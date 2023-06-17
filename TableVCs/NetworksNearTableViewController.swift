//
//  SharingSettingsTableViewController.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 11/28/20.
//  Copyright © 2020 Placenote. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ProgressHUD
import GeoFire
import FirebaseFirestore
import CoreLocation
//import PlacenoteSDK
import FirebaseAuth


protocol HomeProtocol{
    func changeNetworks()
}

class NetworksNearTableViewController: UITableViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var cfaActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cfaCheckmarkImg: UIImageView!
    @IBOutlet weak var checkmarkImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectionSwitch: UISwitch!
    @IBOutlet weak var infoBtn: UIBarButtonItem!
    @IBOutlet weak var kitchenInfoImg: UIImageView!
    
    let homeVC = LaunchViewController()
    
    var delegate = HomeProtocol.self
    var locationManager: CLLocationManager?
    var networkIDList = [String]()
    let db = Firestore.firestore()
    
    var currentLocation: CLLocation?
    var originalLocation = CLLocation()
    var networkID = ""
    var isConnected : Bool?
    var sectionNumber: Int?
    var isCurrentlyConnected : Bool?
    var currentConnectedNetwork = ""
    
    var connectedNetworks = [String]()
    var myNetworks = [String]()
    var otherNetworks = [String]()
    
    var networkUidSettings = "networkID"
    
//    init(sectionNumber: Int) {
//            self.sectionNumber = sectionNumber
//        }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NetworkTableViewCell.self, forCellReuseIdentifier: "NetworkTableViewCell")
        tableView.register(NetworkConnectionTableViewCell.self, forCellReuseIdentifier: "NetworkConnectionTableViewCell")
        tableView.register(CreatePersonalNetworkTableViewCell.self, forCellReuseIdentifier: "CreatePersonalNetworkTableViewCell")
        tableView.register(AskToJoinTableViewCell.self, forCellReuseIdentifier: "AskToJoinTableViewCell")
//        let kitchenTap = UITapGestureRecognizer(target: self, action: #selector(kitchenTapAction))
//        kitchenInfoImg.addGestureRecognizer(kitchenTap)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
       // locationManager?.distanceFilter = 20
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startUpdatingLocation()
        if networkID != "" {
            connectedNetworks.append(networkID)
        }
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "findNetworksOn") == false {
            self.isConnected = true
            //self.taps = 1
        } else {
            self.isConnected = true
        }
    }
    
    var isDataRetrieved = false

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    var loadedTableView = false

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isConnected == false {
          //  isConnected = true
            return 1
        } else {
          //  isConnected = false
            return 5
        }
    }
    
    var numNetworkCount = 0
    
    @objc func goToAskToJoin(){
        var next = self.storyboard?.instantiateViewController(withIdentifier: "AskToJoinNetworksTableVC") as! AskToJoinNetworksTableViewController
        //next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    func findNetworks(completion: @escaping () -> Void){ //(completion: @escaping (_ success: Bool) -> Void)
//        FirestoreManager.getNetworksInRange(centerCoord: CLLocationCoordinate2D(latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!), withRadius: 40) { Network in
        FirestoreManager.getBlueprintsInRange(centerCoord: CLLocationCoordinate2D(latitude: (self.originalLocation.coordinate.latitude), longitude: (self.originalLocation.coordinate.longitude)), withRadius: 40) { Blueprint in
            for network in Blueprint {
                let id = network.id
                if id != "" {
                    self.networkIDList.append(id)
                    if Auth.auth().currentUser?.uid != nil {
                        FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
                            
                            if id != self.connectedNetworks.first && id != "" && !(user?.historyNetworkIDs.contains(id) ?? false) &&  !(user?.createdNetworkIDs.contains(id) ?? false) {
                                self.otherNetworks.append(id)
                            } else if id != self.connectedNetworks.first && id != "" && ((user?.historyNetworkIDs.contains(id)) == true) || (user?.createdNetworkIDs.contains(id) ?? false) {
                                self.myNetworks.append(id)
                            }
                            if self.myNetworks.count > 0 {
                                self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                            }
                            if self.otherNetworks.count > 0 {
                                self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
                                
                            }
                            
                        }
                    } else {
                        self.otherNetworks.append(id)
                        if self.otherNetworks.count > 0 {
                            self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
                            
                        }
                    }
                }
            }
            self.numNetworkCount = Blueprint.count
        //    completion(true)
            // Update the isDataRetrieved flag to true
            self.isDataRetrieved = true
            
            // Call the completion handler to indicate that the data retrieval is complete
            completion()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isDataRetrieved {
                return 0
            }
        switch section {
        case 0:
            return 1 + connectedNetworks.count
        case 1:
            return myNetworks.isEmpty ? 0 : myNetworks.count
        case 2:
            return otherNetworks.isEmpty ? 0 : otherNetworks.count
        case 3, 4:
            return 1
        default:
            return 0
        }
    }
        
    
    @objc func kitchenTapAction(){
//        var next = NetworkSettingsTableViewController(self.connectedNetworks.first ?? "") //self.storyboard?.instantiateViewController(withIdentifier: "NetworkSettingsVC") as! NetworkSettingsTableViewController
//        //next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addNetworkAction(_ sender: Any) {
    }
    
    
    @objc func goToNetworkSettings(sender: UITapGestureRecognizer) {
        guard let cell = sender.view?.superview?.superview as? NetworkTableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                return
        }
        
        var blueprintId: String?
        
        if indexPath.section == 1 && indexPath.row < myNetworks.count {
            blueprintId = myNetworks[indexPath.row]
        } else if indexPath.section == 2 && indexPath.row < otherNetworks.count {
            blueprintId = otherNetworks[indexPath.row]
        }
        
        if let blueprintId = blueprintId {
            let storyboard = UIStoryboard(name: "Networks", bundle: nil)
            let next = NetworkSettingsTableViewController.instantiate(with: blueprintId)
            self.present(next, animated: true, completion: nil)
        }
    }

    
    @objc func goToEnterPassword(){
        let storyboard = UIStoryboard(name: "Networks", bundle: nil)
        var next = storyboard.instantiateViewController(withIdentifier: "EnterPasswordVC") as! EnterPasswordViewController
        //next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    let destinationURL = URL(string: "www.google.com")
    
    @objc func connectToNetwork(){
      //  self.networkID = id
        print("\(self.networkID) is network ID")
        if Auth.auth().currentUser?.uid != nil {
            let docRef = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
            docRef.updateData([
                "currentConnectedNetworkID": self.networkID
            ])
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "connectToBlueprint")
            self.dismiss(animated: true)
        } else {
            let defaults = UserDefaults.standard

            defaults.set("\(self.networkID)", forKey: "blueprintId")
            defaults.set(true, forKey: "connectToBlueprint")
            self.dismiss(animated: true)
//            let vc = ARRoomModelView(nibName: "ARRoomModelView", bundle: nil)
//            vc.capturedRoom = self.finalResults
//            vc.modelURL = destinationURL
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func infoAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Sharing", message: "Sharing enables users to share their experience with other people in their vicinity. When clicking the 'Share' button, COMPANY will ______ and you will be able to choose with whom to share your world with. Once you've shared, other users will be able to see everything that you see within the COMPANY app.", preferredStyle: .actionSheet)
                      
              let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                  print("You've pressed default");
              }
        

              alertController.addAction(action1)
              self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func connectionSwitchAction(_ sender: Any) {
        if connectionSwitch.isOn {
            isConnected = true
            tableView.reloadData()
        } else {
            isConnected = false
            tableView.reloadData()
        }
    }
    var taps = 0
    
    @objc func goToCreateBlueprint(){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "goToCreateBlueprint")
        print("\(String(describing: defaults.value(forKey: "goToCreateBlueprint"))) is the value for gotocreateblueprint")
        self.dismiss(animated: true)
    }
    
    @objc func changeConnection(){
        taps += 1
        let defaults = UserDefaults.standard
        if taps % 2 == 0 {
            self.isConnected = true
            defaults.set(true, forKey: "findNetworksOn")
            tableView.reloadData()
        } else {
            self.isConnected = false
            if Auth.auth().currentUser?.uid ?? "" != "" {
                FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
                    if user?.currentConnectedNetworkID != "" {
                        let docRef = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                                docRef.updateData([
                                    "currentConnectedNetworkID": ""
                                ])
                    }
                }
                
            }
            defaults.set(false, forKey: "findNetworksOn")
            self.tableView.reloadData()
        }
    }
    
    var dismiss = false
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isDataRetrieved {
                // Return a loading cell or an empty cell while data is being retrieved
                return UITableViewCell()
            }
        switch indexPath.section {
        case 0:
            // Connection section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NetworkConnectionTableViewCell.identifier, for: indexPath) as? NetworkConnectionTableViewCell else {
                return UITableViewCell()
            }
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: "findNetworksOn") == false {
                cell.connectionSwitch.isOn = false
            } else {
                cell.connectionSwitch.isOn = true
            }
            cell.connectionSwitch.addTarget(self, action: #selector(changeConnection), for: .valueChanged)
            tableView.rowHeight = 55
            return cell
        case 1:
            // My networks section
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: NetworkTableViewCell.identifier, for: indexPath) as? NetworkTableViewCell else {
                        return UITableViewCell()
                    }

                    if indexPath.row < myNetworks.count {
                        let network = myNetworks[indexPath.row]
                        // Configure the cell with the network data
                        cell.configure(with: network)

                        let tap = UITapGestureRecognizer(target: self, action: #selector(goToNetworkSettings))
                        tap.delegate = self
                        cell.infoImageView.addGestureRecognizer(tap)
                        
                        let connectTap = UITapGestureRecognizer(target: self, action: #selector(connectToNetwork))
                        connectTap.delegate = self
                        cell.addGestureRecognizer(connectTap)
                    } else {
                        // Return a default or placeholder cell
                        cell.textLabel?.text = "No networks found"
                    }

                    tableView.rowHeight = 55
                    return cell
        case 2:
            // Other networks section
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: NetworkTableViewCell.identifier, for: indexPath) as? NetworkTableViewCell else {
                       return UITableViewCell()
                   }
                   
                   var network: String?
                   
                   if indexPath.row < otherNetworks.count {
                       network = otherNetworks[indexPath.row]
                   }
                   
                   // Configure the cell with the network data
                   if let network = network {
                       cell.configure(with: network)
                       let tap = UITapGestureRecognizer(target: self, action: #selector(goToNetworkSettings))
                       tap.delegate = self
                       cell.infoImageView.addGestureRecognizer(tap)
                       
                       let connectTap = UITapGestureRecognizer(target: self, action: #selector(connectToNetwork))
                       connectTap.delegate = self
                       cell.addGestureRecognizer(connectTap)
                   } else {
                       // Return a default or placeholder cell
                       cell.configure(with: "No networks found")
                       cell.infoImageView.gestureRecognizers = nil
                   }
                   
                   tableView.rowHeight = 55
                   return cell
        case 3:
            // Create personal network section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreatePersonalNetworkTableViewCell.identifier, for: indexPath) as? CreatePersonalNetworkTableViewCell else {
                return UITableViewCell()
            }
            // Configure the cell
            // ...
            let createTap = UITapGestureRecognizer(target: self, action: #selector(goToCreateBlueprint))
            createTap.delegate = self
            cell.addGestureRecognizer(createTap)
            tableView.rowHeight = 55
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AskToJoinTableViewCell.identifier, for: indexPath) as? AskToJoinTableViewCell else {
                return UITableViewCell()
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(goToAskToJoin))
            tap.delegate = self
            cell.contentView.addGestureRecognizer(tap)
            tableView.rowHeight = 50
            return cell
        default:
            return UITableViewCell()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentLocation == nil {
            if let location = locations.first {
                //MAYBE LOCATIONMANAGER.COORDINATE.LAT
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                self.originalLocation = CLLocation(latitude: latitude, longitude: longitude)
                if self.isConnected! {
                    findNetworks { [weak self] in
                        // Check if data retrieval is complete
                        guard let self = self else { return }
                        if self.isDataRetrieved {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                print("\(String(describing: originalLocation)) is current original location")
              //  print("\(originalLocation) is current original location")
            }
        }
        if let location = locations.last {
            //MAYBE LOCATIONMANAGER.COORDINATE.LAT
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
            self.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
           
          //  self.networksNear()
        }
    }
}

extension Array {
    func arrayWithoutFirstElement() -> Array {
        if count != 0 { // Check if Array is empty to prevent crash
            var newArray = Array(self)
            newArray.removeFirst()
            return newArray
        }
        return []
    }
}
