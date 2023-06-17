/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller that manages the scanning process.
*/

import UIKit
import RoomPlan
import GeoFire
import FirebaseAuth
import CoreLocation
import FirebaseFirestore
import RealityKit
import ARKit

@available(iOS 16.0, *)
@available(iOS 16.0, *)
@available(iOS 16.0, *)
@available(iOS 16.0, *)
class RoomCaptureViewController: UIViewController, CLLocationManagerDelegate, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {
    
    @IBOutlet var exportButton: UIButton?
    
    @IBOutlet var doneButton: UIBarButtonItem?
    @IBOutlet var cancelButton: UIBarButtonItem?
    
    private var isScanning: Bool = false
    var currentLocation: CLLocation?
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfig: RoomCaptureSession.Configuration = RoomCaptureSession.Configuration()
    var locationManager: CLLocationManager?
    private var finalResults: CapturedRoom?
    
    let db = Firestore.firestore()
    
    var blueprintName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up after loading the view.
        setupRoomCaptureView()
    }
    
    private func setupRoomCaptureView() {
        roomCaptureView = RoomCaptureView(frame: view.bounds)
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        self.exportButton?.setTitle("Upload", for: .normal)
        view.insertSubview(roomCaptureView, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
       
    }
    
    override func viewWillDisappear(_ flag: Bool) {
        super.viewWillDisappear(flag)
        stopSession()
    }
    
    private func startSession() {
        isScanning = true
        roomCaptureView?.captureSession.run(configuration: roomCaptureSessionConfig)
        locationManager = CLLocationManager()
        // This will cause either |locationManager:didChangeAuthorizationStatus:| or
        // |locationManagerDidChangeAuthorization:| (depending on iOS version) to be called asynchronously
        // on the main thread. After obtaining location permission, we will set up the ARCore session.
        locationManager?.delegate = self
       // locationManager?.distanceFilter = 20
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startUpdatingLocation()
        setActiveNavBar()
    }
    
    private func stopSession() {
        isScanning = false
        roomCaptureView?.captureSession.stop()
        
        setCompleteNavBar()
    }
    
    // Decide to post-process and show the final results.
    @available(iOS 16.0, *)
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }
    
    // Access the final post-processed results.
    @available(iOS 16.0, *)
    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResults = processedResult
    }
    
    @IBAction func doneScanning(_ sender: UIBarButtonItem) {
        if isScanning { stopSession() } else { cancelScanning(sender) }
    }

    @IBAction func cancelScanning(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Stop Scanning?", message: "This will end the scanning process here, meaning the Blueprint will not be created. If you are done scanning, click 'Finish'.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default) { action in
            return
        })
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel) { action in
            self.navigationController?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    // Export the USDZ output by specifying the `.parametric` export option.
    // Alternatively, `.mesh` exports a nonparametric file and `.all`
    // exports both in a single USDZ.
    @IBAction func exportResults(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Upload Blueprint", message: "Create a name for this Blueprint. This can be changed later.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            let nameTextField = alertController.textFields![0]
            let name = (nameTextField.text ?? "").isEmpty ? "My Room" : nameTextField.text!
            self.blueprintName = name
            
            let id = FirebaseAuthHelper.getCurrentUserUid()
            
            let destinationURL =  FileManager.default.temporaryDirectory.appending(path: "\(StorageManager.blueprintID)-\(name).usdz")
            
            
            do {
                try self.finalResults?.export(to: destinationURL, exportOptions: .parametric)
                self.uploadBlueprint(fileUrl: destinationURL)
                // Redirect to AR Model
                let defaults = UserDefaults.standard

                defaults.set(false, forKey: "createBlueprint")
                let vc = ARRoomModelView(nibName: "ARRoomModelView", bundle: nil)
                //save in userdefaults for later use?
                vc.capturedRoom = self.finalResults
//                let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: self.finalResults, requiringSecureCoding: false)
//                defaults.set(encodedData, forKey: "capturedRoom")
                vc.modelURL = destinationURL
              //  defaults.set(destinationURL, forKey: "destinationURL")
                self.navigationController?.pushViewController(vc, animated: true)
                
            } catch {
                print("Error = \(error)")
            }

        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            //self.showAllUI()
        })
        alertController.addTextField { (textField) in
            textField.placeholder = "'My Room' or 'Apartment #3'"
            textField.autocapitalizationType = .sentences
            //textField.placeholder = "Network Name"
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
   
    }
    
    func uploadBlueprint(fileUrl: URL) {
        do {
            let data = try Data(contentsOf: fileUrl)
            let name = self.blueprintName
            StorageManager.uploadBlueprint(withData: data, name: name) { success in
                if success == nil {
                    print("We're sorry, your image cannot be uploaded at this time. Please try again")
                    return
                }
                
                let lat = self.currentLocation?.coordinate.latitude
                let long = self.currentLocation?.coordinate.longitude
                
                let blueprintCollection = Firestore.firestore().collection("blueprints")
                let userDefaults = UserDefaults.standard
                
                // Step 1: Generate a unique identifier for the device/user if it doesn't exist
                if let uniqueIdentifier = userDefaults.string(forKey: "UniqueIdentifier") {
                    // Unique identifier exists, user has already created blueprints on this device
                    // Retrieve the blueprints associated with the unique identifier and update them
                    var blueprintData: [String: Any] = [
                        "latitude" : NSNumber(value: lat!),
                        "longitude" : NSNumber(value: long!),
                        "creatorId" : Auth.auth().currentUser?.uid ?? "",
                        "uniqueIdentifier": uniqueIdentifier,
                        "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
                        "name" : self.blueprintName,
                        "contentType" : "blueprint",
                        "roomType" : "",
                        "id" : "",
                        "password" : "",
                        "visibility" : "public",
                        "date" : Date(),
                        "description" : "",
                        "storagePath" : StorageManager.blueprintID,
                        "size" : 0
                    ]
                    
                    let docRef = blueprintCollection.document()
                    let id = docRef.documentID
                    blueprintData["id"] = id
                    
                    blueprintCollection.document(id).setData(blueprintData) { error in
                        if let error = error {
                            print("Error adding blueprint: \(error.localizedDescription)")
                        } else {
                            print("Blueprint added with unique identifier: \(uniqueIdentifier)")
                        }
                    }
                    
                    
                    
                } else {
                    // Unique identifier doesn't exist, create a new one and store it locally
                    let uniqueIdentifier = UUID().uuidString
                    userDefaults.set(uniqueIdentifier, forKey: "UniqueIdentifier")
                    
                    
                    var blueprintData: [String: Any] = [
                        "latitude" : NSNumber(value: lat!),
                        "longitude" : NSNumber(value: long!),
                        "creatorId" : Auth.auth().currentUser?.uid ?? "",
                        "uniqueIdentifier": uniqueIdentifier,
                        "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
                        "name" : self.blueprintName,
                        "contentType" : "blueprint",
                        "roomType" : "",
                        "id" : "",
                        "password" : "",
                        "visibility" : "public",
                        "date" : Date(),
                        "description" : "",
                        "storagePath" : StorageManager.blueprintID,
                        "size" : 0
                    ]
                    
                    let docRef = blueprintCollection.document()
                    let id = docRef.documentID
                    blueprintData["id"] = id
                    
                    blueprintCollection.document(id).setData(blueprintData) { error in
                        if let error = error {
                            print("Error adding blueprint: \(error.localizedDescription)")
                        } else {
                            print("Blueprint added with unique identifier: \(uniqueIdentifier)")
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }

    
//
//    func uploadBlueprint(fileUrl: URL){
//
//        do {
//
//            let data = try Data(contentsOf: fileUrl)
//            let name = self.blueprintName
//            StorageManager.uploadBlueprint(withData: data, name: name) { success in
//                if (success == nil) {
//                    print("We're sorry, your image cannot be uploaded at this time. Please try again")
//                    return //self.alertAndDismiss("We're sorry, your image cannot be uploaded at this time. Please try again")
//                }
//
//                let lat = self.currentLocation?.coordinate.latitude
//                let long = self.currentLocation?.coordinate.longitude
//
//                var blueprintData: [String: Any] = [
//                    "latitude" : NSNumber(value: lat!),
//                    "longitude" : NSNumber(value: long!),
//                    "creatorId" : Auth.auth().currentUser?.uid ?? "",
//                    "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
//                    "name" : self.blueprintName,
//                    "contentType" : "blueprint",
//                    "roomType" : "",
//                    "id" : "",
//                    "password" : "",
//                    "visibility" : "public",
//                    "date" : Date(),
//                    "description" : "",
//                    "storagePath" : StorageManager.blueprintID,
//                    "size" : 0
//                ]
//
//                let docRef = Firestore.firestore().collection("blueprints").document()
//                let id = docRef.documentID
//                blueprintData["id"] = id
//
//                self.db.collection("blueprints").document(id).setData(blueprintData) { err in
//                    if let err = err {
//                        print("Error adding document for loser notification: \(err)")
//                    } else {
//                        print("Added anchor to Firestore with ID: \(id)")
//                        // Perform any additional operations with the generated ID
//                    }
//                }
//            }
//        } catch {
//            print(error)
//        }
//
//    }
    
    private func setActiveNavBar() {
        UIView.animate(withDuration: 1.0, animations: {
            self.cancelButton?.tintColor = .white
            self.doneButton?.tintColor = .white
            self.exportButton?.alpha = 0.0
        }, completion: { complete in
            self.exportButton?.isHidden = true
        })
    }
    
    private func setCompleteNavBar() {
        self.exportButton?.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.cancelButton?.tintColor = .systemBlue
            self.doneButton?.tintColor = .systemBlue
            self.exportButton?.alpha = 1.0
           // self.exportButton?.setTitle("Upload", for: .normal)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if let location = locations.last {
            //MAYBE LOCATIONMANAGER.COORDINATE.LAT
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
            self.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
          //  let currentDistance = self.currentLocation?.distance(from: self.originalLocation)
            print("\(String(describing: currentLocation)) is current location updated")
           // self.networksNear()
          //  print("\(originalLocation) is current original location")
        }
    }
}

