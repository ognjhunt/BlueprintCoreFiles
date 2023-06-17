//
//  LaunchViewController.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 5/27/21.
//  Copyright © 2021 Placenote. All rights reserved.
//

import UIKit
import RealityKit
import SwiftUI
import ARKit
import Foundation
import FocusEntity
import RoomPlan
import FirebaseAuth
import Combine
import CoreLocation
//import WebKit
import FirebaseFirestore
import ProgressHUD
import SCLAlertView
import GeoFire
//import AzureSpatialAnchors
import FirebaseStorage


class LaunchViewController: UIViewController, ARSessionDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    var locationManager: CLLocationManager?
        
    var sceneManager = SceneManager()
   
    @IBOutlet weak var buttonStackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var userGuideBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeUserGuideImgView: UIImageView!
    @IBOutlet weak var userGuideBtn: UIButton!
    @IBOutlet weak var styleTableView: UITableView!
    @IBOutlet weak var scanImgView: UIImageView!
   
    @IBOutlet weak var composeImgView: UIImageView!
   
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var searchImgView: UIImageView!
    @IBOutlet weak var addImgView: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
   
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var trashBtn: UIButton!
    @IBOutlet weak var sceneView: CustomARView!
    @IBOutlet weak var networkBtn: UIButton!
   
    @IBOutlet weak var networksNearImg: UIImageView!
    
    @StateObject var modelsViewModel = ModelsViewModel()
    
    struct GlobalVariable{
        static var myString = String()
    }
    
    @Published var recentlyPlaced: [Model] = []
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
      //  config.geometryQuality = .high
        config.sceneReconstruction = .meshWithClassification
        config.isCollaborationEnabled = true
        
        config.frameSemantics.insert(.personSegmentationWithDepth)
        config.environmentTexturing = .automatic
        return config
    }
    
    var progressView : UIView?
    var progressBar : UIProgressView?
    
    let config = ARWorldTrackingConfiguration()

    let db = Firestore.firestore()
    
    var currentLocation: CLLocation?
    var originalLocation = CLLocation()
    
    var arState: ARState?
    
    struct ModelAnchor {
        var model: ModelEntity
        var anchor: ARAnchor?
    }
    
    var anchorPlaced: ARAnchor?
    
    var modelsConfirmedForPlacement: [ModelAnchor] = []
   
    
    var isVideoMode: Bool = false
    var isTextMode: Bool = false
    var isObjectMode: Bool? = true
    var isScanMode: Bool?
    
    var trashZone: GradientView!
    var shadeView: UIView!
    var resetButton: UIButton!
    
    var keyboardHeight: CGFloat!
    
    var stickyNotes = [StickyNoteEntity]()
    
    var subscription: Cancellable!
    
    let defaults = UserDefaults.standard
    var textNode:SCNNode?
    var textSize:CGFloat = 5
    var textDistance:Float = 15
    let coachingOverlay = ARCoachingOverlayView()
    
    var shareRecognizer = UITapGestureRecognizer()
    var doubleTap = UITapGestureRecognizer()
    var profileRecognizer = UITapGestureRecognizer()
    var textSettingsRecognizer = UITapGestureRecognizer()
    var browseRec = UITapGestureRecognizer()
    var undoTextRecognizer = UITapGestureRecognizer()
    var hideMeshRecognizer = UITapGestureRecognizer()
    
    // Cache for 3D text geometries representing the classification values.
    var modelsForClassification: [ARMeshClassification: ModelEntity] = [:]
    
    var videoNode: VideoNodeSK?
    var videoPlayerCreated = false
    
    var showFeaturePoints = false
    var placementType: ARHitTestResult.ResultType = .featurePoint
    
    var focusEntity: FocusEntity?
    private var modelManager: ModelManager = ModelManager()
    
    var configuration = ARWorldTrackingConfiguration()
    
    var multipeerHelp: MultipeerHelper!

    
   // private var loadedMetaData: LibPlacenote.MapMetadata = LibPlacenote.MapMetadata()
      
    var selectedObject: VirtualObject?
    static var selectedEntityName = ""
    static var selectedEntityID = ""
    var currentConnectedNetwork = "TR5GY49mciaf42wUc8pZ"
    var selectedEntity: ModelEntity?
    var selectedAnchor: AnchorEntity?
    
      var selectedNode: SCNNode?

      /// The object that is tracked for use by the pan and rotation gestures.
      var trackedObject: VirtualObject? {
          didSet {
              guard trackedObject != nil else { return }
              selectedObject = trackedObject
          }
      }
    private var cancellable: AnyCancellable?

    var selectedModelURL: URL?
    
    var didTap: Bool?
    
    var networkBtnImg = UIImage(named: "network")
    
    private var modelCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioSession()
        checkCameraAccess()
        setupNewUI()
     //   scanningUI()
        
        styleTableView.delegate = self
        styleTableView.dataSource = self
        styleTableView.register(StyleTableViewCell.self, forCellReuseIdentifier: "StyleTableViewCell")

        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isCreatingNetwork")
        defaults.set(false, forKey: "connectToNetwork")
        defaults.set(false, forKey: "createBlueprint")
        defaults.set("", forKey: "modelUid")
        defaults.set("", forKey: "blueprintId")
        defaults.set(true, forKey: "findNetworksOn")
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
       
      
        
        networkBtn.setImage(UIImage(systemName: "network"), for: .normal)
     
        
        progressView = UIView(frame: CGRect(x: 0, y: 95, width: UIScreen.main.bounds.width, height: 30))
        progressView?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.90)

        progressBar = UIProgressView(frame: CGRect(x: 20, y: 13, width: UIScreen.main.bounds.width - 40, height: 10))
     //   progressBar?.heightAnchor = 25
        progressBar?.progressViewStyle = .default
        progressBar?.progressTintColor = .systemGreen
        progressBar?.autoresizesSubviews = true
        progressBar?.clearsContextBeforeDrawing = true
        
        progressView?.addSubview(progressBar!)
     //   sceneView.addSubview(progressView!)
        anchorSettingsImg.isHidden = true
       // self.progressView?.isHidden = true
        
        let supportLiDAR = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        guard supportLiDAR else {
            print("LiDAR isn't supported here")
            setup()
//            if UITraitCollection.current.userInterfaceStyle == .light {
//                browseTableView.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 244/255, alpha: 1.0)
//                //topview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.90)
//            } else {
//                browseTableView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
//                searchField.overrideUserInterfaceStyle = .light
//            }
            //checkWalkthrough()
            return
        }
        setupLidar()
        
       // startSession()
     //   checkWalkthrough()
        //   let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchAction(_:)))
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(editAlert))
        addButton.layer.cornerRadius = 26
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .bold, scale: .large)
        //   let largeBoldDoc = UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig)
        let largeBoldDoc = UIImage(systemName: "plus", withConfiguration: largeConfig)
        addButton.setImage(largeBoldDoc, for: .normal)
        addButton.backgroundColor = UIColor.systemBlue
        addButton.tintColor = .white
        addButton.layer.shadowRadius = 4
        addButton.layer.shadowOpacity = 0.95
        addButton.layer.shadowColor = UIColor.black.cgColor
        //note.view?.layer.cornerRadius = 5
        addButton.layer.masksToBounds = false
        addButton.layer.shadowOffset = CGSize(width: 0, height: 3.3)
        if Auth.auth().currentUser?.uid != nil {
            sceneView.addSubview(addButton)
        }
        addButton.addGestureRecognizer(searchTap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
   
        
        
        let connectAction = UITapGestureRecognizer(target: self, action: #selector(selectStyle))
        styleTableView.isUserInteractionEnabled = true
      //  styleTableView.addGestureRecognizer(connectAction)
        
        let cancelAction = UITapGestureRecognizer(target: self, action: #selector(cancelUserGuideAction))
        closeUserGuideImgView.isUserInteractionEnabled = true
        closeUserGuideImgView.addGestureRecognizer(cancelAction)
    }
    
    let walkthroughLabel = UILabel(frame: CGRect(x: 25, y: 550, width: UIScreen.main.bounds.width - 50, height: 80))
    var circle =  UIView() // UIView(frame: CGRect(x: 9, y: 45, width: 50, height: 50))

    private func setupAudioSession() {
            //enable other applications music to play while quizView
            let options = AVAudioSession.CategoryOptions.mixWithOthers
            let mode = AVAudioSession.Mode.default
            let category = AVAudioSession.Category.playback
            try? AVAudioSession.sharedInstance().setCategory(category, mode: mode, options: options)
            //---------------------------------------------------------------------------------
            try? AVAudioSession.sharedInstance().setActive(true)
        }
    
    
    
    var continueWalkthroughButton = UIButton()
    var continueNetworkWalkthroughButton = UIButton()
    
    func setupNewUI(){
     //   //topview.isHidden = true
        addButton.isHidden = true
        if defaults.bool(forKey: "finishedCreateWalkthrough") == false{
            self.continueWalkthroughButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: 5, width: 110, height: 35))
            self.continueWalkthroughButton.backgroundColor = .systemBlue// UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
            self.continueWalkthroughButton.setTitle("Continue", for: .normal)
            self.continueWalkthroughButton.setTitleColor(.white, for: .normal)
            self.continueWalkthroughButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            self.continueWalkthroughButton.layer.cornerRadius = 6
            self.continueWalkthroughButton.clipsToBounds = true
            self.continueWalkthroughButton.isUserInteractionEnabled = true
         //   self.continueWalkthroughButton.addTarget(self, action: #selector(continueWalkthrough), for: .touchUpInside)
          //  self.view.addSubview(self.continueWalkthroughButton)
        }
        let scanTap = UITapGestureRecognizer(target: self, action: #selector(editAlert)) //editAlert
        scanImgView.addGestureRecognizer(scanTap)
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchUI))
        searchImgView.addGestureRecognizer(searchTap)
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile))
        profileImgView.addGestureRecognizer(profileTap)
        
        let networkTap = UITapGestureRecognizer(target: self, action: #selector(editAlert))
        addImgView.addGestureRecognizer(networkTap)
        
        let createTap = UITapGestureRecognizer(target: self, action: #selector(showStyles))//goToCapturedRoom
        composeImgView.addGestureRecognizer(createTap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("Received memory warning.")

        // Release any unneeded memory here
        // For example, you can release large images or other data that's not currently in use
 //       heavyImage = nil

        // You can also release any objects that have been retained by properties in the class
        // For example, if you have a reference to an observer, you should remove it
  //      NotificationCenter.default.removeObserver(observer)
    }
    
    @objc func shareFile(fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    var modelUid = ""
    var blueprintId = ""
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  layoutButtons()
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        if Auth.auth().currentUser?.uid != nil {
            FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
                if user?.currentConnectedNetworkID != "" || user?.currentConnectedNetworkID != nil {
                    let docRef = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    docRef.updateData([
                        "currentConnectedNetworkID": ""
                    ])
                }
            }
        }
        for id in currentSessionAnchorIDs {
            let docRef = self.db.collection("sessionAnchors").document(id)
            docRef.delete()

        }
        self.sceneView.scene.anchors.removeAll()
        
        self.entityName.removeFromSuperview()
        self.entityProfileBtn.removeFromSuperview()
        self.buttonStackView.isHidden = false
        self.anchorSettingsImg.isHidden = true
        self.entityName.isHidden = true
        self.entityProfileBtn.isHidden = true
//        self.checkCameraAccess()
//        self.chec
        self.networksNear()
    //    self.focusEntity = FocusEntity(on: sceneView, focus: .classic)
    }
    
    func checkWalkthrough(){
        if defaults.bool(forKey: "finishedCreateWalkthrough") == false {
//            addImgView
//            searchImgView
            self.userGuideBtn.setTitle("HOW TO: CREATE A BLUEPRINT", for: .normal)
            self.userGuideBtn.isHidden = false
            self.closeUserGuideImgView.isHidden = false
            self.networkBtn.isHidden = true
            self.networksNearImg.isHidden = true
            return
//        }
//        else if defaults.bool(forKey: "finishedConnectWalkthrough") == false  { //&& self.num >= 1
//            self.userGuideBtn.setTitle("CONNECT TO NEARBY BLUEPRINT", for: .normal)
//            self.userGuideBtn.isHidden = false
//            self.userGuideBtnTopConstraint.constant = -170
//            self.closeUserGuideImgView.isHidden = false
//            self.networkBtn.isHidden = false
//            self.networksNearImg.isHidden = false
//            placementStackBottomConstraint.constant = 55
//            saveButtonBottomConstraint.constant = -5
//            self.editInstructions = UILabel(frame: CGRect(x: 15, y: 180, width: UIScreen.main.bounds.width - 30, height: 50))
//            self.view.addSubview(self.editInstructions)
//               
//            return
        } else if defaults.bool(forKey: "finishedDesignWalkthrough") == false && self.connectedToNetwork {
            self.userGuideBtn.setTitle("HOW TO: DESIGN A BLUEPRINT", for: .normal)
            self.userGuideBtn.isHidden = false
            self.closeUserGuideImgView.isHidden = false
            self.networkBtn.isHidden = true
            self.networksNearImg.isHidden = true
            return
        }
        
        else {
            self.userGuideBtn.isHidden = true
            self.closeUserGuideImgView.isHidden = true
            self.networkBtn.isHidden = false
            self.networksNearImg.isHidden = false
            return
        }

    }
    
    var currentSessionAnchorIDs = [String]()
    var continueTaps = 0
    var continueNetworkTaps = 0
    
    @objc func cancelUserGuideAction(){
        let defaults = UserDefaults.standard
        if userGuideBtn.titleLabel?.text == "HOW TO: CREATE A BLUEPRINT" {
            let alertController = UIAlertController(title: "Skip Walkthrough?", message: "Feel free to skip this if you already know how to create a Blueprint. All user guides are also located within your Settings.", preferredStyle: .alert)
            
            // action to dismiss the view controller and lose the generated art
            let purchaseAction = UIAlertAction(title: "Skip", style: .default, handler: { (_) in
                defaults.set(true, forKey: "finishedCreateWalkthrough")
                defaults.set(false, forKey: "createBlueprint")
                self.userGuideBtn.isHidden = true
                self.closeUserGuideImgView.isHidden = true
                self.editInstructions.removeFromSuperview()
                self.circle.removeFromSuperview()
                self.networkBtn.isHidden = false
                self.networksNearImg.isHidden = false
                self.networkBtn.isUserInteractionEnabled = true
                self.composeImgView.isUserInteractionEnabled = true
                self.profileImgView.isUserInteractionEnabled = true
                if self.num >= 1 {
                    self.editInstructions = UILabel(frame: CGRect(x: 15, y: 135, width: UIScreen.main.bounds.width - 30, height: 50))
                    self.editInstructions.textAlignment = .center
                    self.editInstructions.text = "There is a Blueprint near your location. Explore and connect with it!" // "There is a Blueprint near your location. Do you want to connect?"
                    self.editInstructions.backgroundColor = .white
                    self.editInstructions.textColor = .black
                    self.editInstructions.clipsToBounds = true
                    self.editInstructions.layer.cornerRadius = 12
                   // self.editInstructions.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                    self.editInstructions.numberOfLines = 2
                    self.editInstructions.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                  //  self.view.addSubview(self.editInstructions)
                    self.showNearbyBlueprintAlert()
                }
            })
            
            // action to cancel and stay on the current view controller
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            })
           
            // add the actions to the alert controller
            alertController.addAction(purchaseAction)
            alertController.addAction(cancelAction)
            
            // present the alert to the user
            self.present(alertController, animated: true, completion: nil)
        } else if userGuideBtn.titleLabel?.text == "HOW TO: DESIGN A BLUEPRINT" {
            defaults.set(true, forKey: "finishedDesignWalkthrough")
        } else if userGuideBtn.titleLabel?.text == "CONNECT TO NEARBY BLUEPRINT" {
            
            let alertController = UIAlertController(title: "Skip Walkthrough?", message: "Feel free to skip this if you already know how to connect to nearby Blueprints. All user guides are also located within your Settings.", preferredStyle: .alert)
            
            // action to dismiss the view controller and lose the generated art
            let purchaseAction = UIAlertAction(title: "Skip", style: .default, handler: { (_) in
                defaults.set(true, forKey: "finishedConnectWalkthrough")

                self.userGuideBtn.isHidden = true
                self.closeUserGuideImgView.isHidden = true
                self.editInstructions.removeFromSuperview()
                self.circle.removeFromSuperview()
                self.networkBtn.isHidden = false
                self.networksNearImg.isHidden = false
                self.scanImgView.isUserInteractionEnabled = true
                self.composeImgView.isUserInteractionEnabled = true
                self.profileImgView.isUserInteractionEnabled = true
                if self.num >= 1 {
                    self.editInstructions = UILabel(frame: CGRect(x: 15, y: 135, width: UIScreen.main.bounds.width - 30, height: 50))
                    self.editInstructions.textAlignment = .center
                    self.editInstructions.text = "There is a Blueprint near your location. Explore and connect with it!" // "There is a Blueprint near your location. Do you want to connect?"
                    self.editInstructions.backgroundColor = .white
                    self.editInstructions.textColor = .black
                    self.editInstructions.clipsToBounds = true
                    self.editInstructions.layer.cornerRadius = 12
                   // self.editInstructions.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                    self.editInstructions.numberOfLines = 2
                    self.editInstructions.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                    self.view.addSubview(self.editInstructions)
                }
            })
            
            // action to cancel and stay on the current view controller
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            })
           
            // add the actions to the alert controller
            alertController.addAction(purchaseAction)
            alertController.addAction(cancelAction)
            
            // present the alert to the user
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func goToUserProfile(){

        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser?.uid ?? ""
            let vc = UserProfileViewController.instantiate(with: user) //(user:user)
            let navVC = UINavigationController(rootViewController: vc)
           // var next = UserProfileViewController.instantiate(with: user)
             navVC.modalPresentationStyle = .fullScreen
          //  self.navigationController?.pushViewController(next, animated: true)
            present(navVC, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var next = storyboard.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountViewController
           // next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        }
    }
    
    @IBAction func userGuideAction(_ sender: Any) {
        if userGuideBtn.titleLabel?.text == "HOW TO: CREATE A BLUEPRINT" {
            circle.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 40, y: scanImgView.frame.minY - 7.5, width: 80, height: 80)
            circle.backgroundColor = .clear
            circle.layer.cornerRadius = 40
            circle.clipsToBounds = true
            circle.layer.borderColor = UIColor.systemBlue.cgColor
            circle.layer.borderWidth = 4
            circle.isUserInteractionEnabled = false
            circle.alpha = 1.0
            sceneView.addSubview(circle)
            
            UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
                self.circle.alpha = 0.1
            })
            self.editInstructions.removeFromSuperview()
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "createBlueprint")
            self.networkBtn.isUserInteractionEnabled = false
            self.composeImgView.isUserInteractionEnabled = false
            self.profileImgView.isUserInteractionEnabled = false
            self.editInstructions = UILabel(frame: CGRect(x: 15, y: scanImgView.frame.minY - 120, width: UIScreen.main.bounds.width - 30, height: 75))
            self.editInstructions.textAlignment = .center
            self.editInstructions.text = "Click on this button to create a new Blueprint at your location. There are no limits to the amount of Blueprints you can create!" // "There is a Blueprint near your location. Do you want to connect?"
            self.editInstructions.backgroundColor = .white
            self.editInstructions.textColor = .black
            self.editInstructions.clipsToBounds = true
            self.editInstructions.layer.cornerRadius = 12
            // self.editInstructions.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            self.editInstructions.numberOfLines = 3
            self.editInstructions.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            self.view.addSubview(self.editInstructions)
        } else if userGuideBtn.titleLabel?.text == "HOW TO: DESIGN A BLUEPRINT" {
            circle.frame = CGRect(x: buttonStackView.frame.minX - 13.5, y: buttonStackView.frame.minY - 13.5, width: 55, height: 55)
            circle.backgroundColor = .clear
            circle.layer.cornerRadius = 27.5
            circle.clipsToBounds = true
            circle.layer.borderColor = UIColor.systemBlue.cgColor
            circle.layer.borderWidth = 4
            circle.isUserInteractionEnabled = false
            circle.alpha = 1.0
            sceneView.addSubview(circle)
            
            UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
                self.circle.alpha = 0.1
            })
            self.editInstructions.removeFromSuperview()
            
            self.editInstructions = UILabel(frame: CGRect(x: 15, y: scanImgView.frame.minY - 120, width: UIScreen.main.bounds.width - 30, height: 75))
            self.editInstructions.textAlignment = .center
            self.editInstructions.text = "Choose a style to use AI to design your created Blueprint. Afterwards, you can further manually design your space with 3D content on our Marketplace!" // "There is a Blueprint near your location. Do you want to connect?"
            self.editInstructions.backgroundColor = .white
            self.editInstructions.textColor = .black
            self.editInstructions.clipsToBounds = true
            self.editInstructions.layer.cornerRadius = 12
            // self.editInstructions.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            self.editInstructions.numberOfLines = 3
            self.editInstructions.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            self.view.addSubview(self.editInstructions)
        }
        else if userGuideBtn.titleLabel?.text == "CONNECT TO NEARBY BLUEPRINT" {
            circle.frame = CGRect(x: networkBtn.frame.minX - 7.5, y: networkBtn.frame.minY - 6, width: 60, height: 60)
            circle.backgroundColor = .clear
            circle.layer.cornerRadius = 30
            circle.clipsToBounds = true
            circle.layer.borderColor = UIColor.systemBlue.cgColor
            circle.layer.borderWidth = 4
            circle.isUserInteractionEnabled = false
            circle.alpha = 1.0
            sceneView.addSubview(circle)
            
            UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
                self.circle.alpha = 0.1
            })
            self.editInstructions.removeFromSuperview()
            self.scanImgView.isUserInteractionEnabled = false
            self.composeImgView.isUserInteractionEnabled = false
            self.profileImgView.isUserInteractionEnabled = false
            self.editInstructions = UILabel(frame: CGRect(x: 15, y: 200, width: UIScreen.main.bounds.width - 30, height: 50))
            self.editInstructions.textAlignment = .center
            self.editInstructions.text = "Click on this button to find and connect to nearby user-created Blueprints." // "There is a Blueprint near your location. Do you want to connect?"
            self.editInstructions.backgroundColor = .white
            self.editInstructions.textColor = .black
            self.editInstructions.clipsToBounds = true
            self.editInstructions.layer.cornerRadius = 12
            // self.editInstructions.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            self.editInstructions.numberOfLines = 2
            self.editInstructions.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            self.view.addSubview(self.editInstructions)
        }
    }
    //    @objc func continueWalkthrough(){
//        continueTaps += 1
//        let defaults = UserDefaults.standard
//        if defaults.bool(forKey: "finishedWalkthrough") == false {
////            if self.continueTaps == 1 {
////                defaults.set(true, forKey: "newSecond")
////                self.walkthroughViewLabel.text = "3 of 8"
////                self.walkthroughLabel.frame = CGRect(x: 35, y: 300, width: UIScreen.main.bounds.width - 70, height: 100)
////                self.walkthroughLabel.numberOfLines = 0
//////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
////                self.walkthroughLabel.text = "To create a Blueprint Network click the left plus button. This makes it so you can save digital content in place at any indoor location."
////                circle.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 108, y: UIScreen.main.bounds.height - 151, width: 50, height: 50)
////
////                circle.layer.cornerRadius = (circle.frame.height) / 2
////
////             //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
////           circle.backgroundColor = .clear
////          // circle.layer.cornerRadius = 25
////           circle.clipsToBounds = true
////           circle.layer.borderColor = UIColor.systemBlue.cgColor
////           circle.layer.borderWidth = 4
////           circle.isUserInteractionEnabled = false
////           circle.alpha = 1.0
////                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
////                    self.circle.alpha = 0.1
////                       })
////
////            }
//
//            if self.continueTaps == 1 {
//                defaults.set(true, forKey: "newSecond")
//                self.walkthroughViewLabel.text = "3 of 9"
//                self.walkthroughLabel.frame = CGRect(x: 50, y: 360, width: UIScreen.main.bounds.width - 100, height: 65)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "Click Create to use AI to generate your own images and 3D models."
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 107.5, y: UIScreen.main.bounds.height - 151, width: 50, height: 50)
//
//                circle.layer.cornerRadius = (circle.frame.height) / 2
//
//             //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
//           circle.backgroundColor = .clear
//          // circle.layer.cornerRadius = 25
//           circle.clipsToBounds = true
//           circle.layer.borderColor = UIColor.systemBlue.cgColor
//           circle.layer.borderWidth = 4
//           circle.isUserInteractionEnabled = false
//           circle.alpha = 1.0
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//            }
//
//            else if self.continueTaps == 2 {
//                defaults.set(true, forKey: "newThird")
//                self.walkthroughViewLabel.text = "4 of 9"
//                self.walkthroughLabel.frame = CGRect(x: 50, y: 300, width: UIScreen.main.bounds.width - 100, height: 65)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "Click Profile to view your profile or to create your Blueprint account."
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width / 2) + 58, y: UIScreen.main.bounds.height - 151, width: 50, height: 50)
//
//                circle.layer.cornerRadius = (circle.frame.height) / 2
//
//             //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
//           circle.backgroundColor = .clear
//          // circle.layer.cornerRadius = 25
//           circle.clipsToBounds = true
//           circle.layer.borderColor = UIColor.systemBlue.cgColor
//           circle.layer.borderWidth = 4
//           circle.isUserInteractionEnabled = false
//           circle.alpha = 1.0
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//            }
//
//            else if self.continueTaps == 3 {
//                defaults.set(true, forKey: "newFourth")
//                self.walkthroughViewLabel.text = "5 of 9"
//                self.walkthroughLabel.frame = CGRect(x: 32.5, y: 400, width: UIScreen.main.bounds.width - 65, height: 110)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "The network icon will show how many networks are within range. Very similar to a Wi-Fi network, you’ll be able to connect to any Network and experience the digital content within them."
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width - 73), y: 71, width: 50, height: 50)
//
//                circle.layer.cornerRadius = (circle.frame.height) / 2
//
//             //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
//           circle.backgroundColor = .clear
//          // circle.layer.cornerRadius = 25
//           circle.clipsToBounds = true
//           circle.layer.borderColor = UIColor.systemBlue.cgColor
//           circle.layer.borderWidth = 4
//           circle.isUserInteractionEnabled = false
//           circle.alpha = 1.0
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//            }
//            else if self.continueTaps == 4 {
//                defaults.set(true, forKey: "newFifth")
//                self.walkthroughViewLabel.text = "6 of 9"
//                self.walkthroughLabel.frame = CGRect(x: 35, y: 500, width: UIScreen.main.bounds.width - 120, height: 68)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "To browse content you've creations and collected, click the library button."
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width - 72), y: 130, width: 50, height: 50)
//
//                circle.layer.cornerRadius = (circle.frame.height) / 2
//
//             //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
//           circle.backgroundColor = .clear
//          // circle.layer.cornerRadius = 25
//           circle.clipsToBounds = true
//           circle.layer.borderColor = UIColor.systemBlue.cgColor
//           circle.layer.borderWidth = 4
//           circle.isUserInteractionEnabled = false
//           circle.alpha = 1.0
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//            }
//            else if self.continueTaps == 5 {
//                defaults.set(true, forKey: "newSixth")
//                self.walkthroughViewLabel.text = "7 of 9"
//                self.walkthroughLabel.frame = CGRect(x: 60, y: 500, width: UIScreen.main.bounds.width - 120, height: 55)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "To add messages or text to a location, click to ABC button."
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width - 73), y: 184.5, width: 50, height: 50)
//
//                circle.layer.cornerRadius = (circle.frame.height) / 2
//
//             //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
//           circle.backgroundColor = .clear
//          // circle.layer.cornerRadius = 25
//           circle.clipsToBounds = true
//           circle.layer.borderColor = UIColor.systemBlue.cgColor
//           circle.layer.borderWidth = 4
//           circle.isUserInteractionEnabled = false
//           circle.alpha = 1.0
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//            }
//
//            else if self.continueTaps == 6 {
//                defaults.set(true, forKey: "newSeventh")
//
//                self.walkthroughViewLabel.text = "8 of 9"
//            //    self.continueWalkthroughButton.setTitle("Finish", for: .normal)
//                self.walkthroughLabel.frame = CGRect(x: 60, y: 500, width: UIScreen.main.bounds.width - 120, height: 55)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "To add photos or videos to a location, click to video button."
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width - 73), y: 244.5, width: 50, height: 50)
//
//                circle.layer.cornerRadius = (circle.frame.height) / 2
//
//             //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
//           circle.backgroundColor = .clear
//          // circle.layer.cornerRadius = 25
//           circle.clipsToBounds = true
//           circle.layer.borderColor = UIColor.systemBlue.cgColor
//           circle.layer.borderWidth = 4
//           circle.isUserInteractionEnabled = false
//           circle.alpha = 1.0
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//            }
//
//            else if self.continueTaps == 7 {
//                defaults.set(true, forKey: "newSeventh")
//
//                self.walkthroughViewLabel.text = "9 of 9"
//                self.continueWalkthroughButton.removeFromSuperview()// .setTitle("Finish", for: .normal)
//                self.walkthroughLabel.frame = CGRect(x: 60, y: 500, width: UIScreen.main.bounds.width - 120, height: 75)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "Now tap the search icon and add your first piece of digital content to the world!"
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 25, y: UIScreen.main.bounds.height - 151, width: 50, height: 50)
//
//                circle.layer.cornerRadius = (circle.frame.height) / 2
//
//             //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
//           circle.backgroundColor = .clear
//          // circle.layer.cornerRadius = 25
//           circle.clipsToBounds = true
//           circle.layer.borderColor = UIColor.systemBlue.cgColor
//           circle.layer.borderWidth = 4
//           circle.isUserInteractionEnabled = false
//           circle.alpha = 1.0
//                self.buttonStackView.isUserInteractionEnabled = true
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//            }
////            else if self.continueTaps == 7 {
////                defaults.set(true, forKey: "finishedWalkthrough")
////                self.walkthroughView.removeFromSuperview()
////                self.circle.removeFromSuperview()
////                self.walkthroughLabel.removeFromSuperview()
////                self.buttonStackView.isUserInteractionEnabled = true
////                self.videoBtn.isUserInteractionEnabled = true
////                self.wordsBtn.isUserInteractionEnabled = true
////                self.networkBtn.isUserInteractionEnabled = true
////                self.buttonStackViewBottomConstraint.constant = -87
////            }
//        }
//
//    }
    
    
    var needLocationView = UIView()
    
    func setup(){
        
        sceneView.session.delegate = self
        
       // sceneView.session.delegate = Coordinator
        
        setupCoachingOverlay()
        
    //    focusEntity = FocusEntity(on: sceneView, focus: .classic)
        
     //   sceneView.environment.sceneUnderstanding.options = []
        
      //  networkBtnImg?.image = UIImage(named: "guitarpbr")
       // arView.environment.lighting.
        entityProfileBtn.isUserInteractionEnabled = false
        entityProfileBtn.isHidden = true
        // Turn on occlusion from the scene reconstruction's mesh.
     //   sceneView.environment.sceneUnderstanding.options.insert(.occlusion)
        
        // Turn on physics for the scene reconstruction's mesh.
  //      sceneView.environment.sceneUnderstanding.options.insert(.physics)
        
    //    sceneView.environment.sceneUnderstanding.options.insert(.receivesLighting)
        
    //    sceneView.environment.sceneUnderstanding.options.insert(.collision)

        // Display a debug visualization of the mesh.
      //  sceneView.debugOptions.insert(.showSceneUnderstanding)
       
        // Manually configure what kind of AR session to run since
        // ARView on its own does not turn on mesh classification.
   //     sceneView.automaticallyConfigureSession = false
        configuration.planeDetection = [.horizontal, .vertical]
      //  configuration.sceneReconstruction = .mesh
        configuration.isCollaborationEnabled = true
      //  configuration.frameSemantics.insert(.personSegmentationWithDepth)
      //  configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration)
       
        if defaults.bool(forKey: "headsUp") == false {
            needLocationView = UIView(frame: CGRect(x: 58, y: 313, width: 274, height: 194))
            needLocationView.backgroundColor = .white
            needLocationView.clipsToBounds = true
            needLocationView.layer.cornerRadius = 14
            let titleLabel = UILabel(frame: CGRect(x: 85.67, y: 21, width: 103, height: 28))
            titleLabel.text = "Heads Up!"
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
            let titleUnderView = UIView(frame: CGRect(x: 92, y: 59, width: 90, height: 1))
            titleUnderView.backgroundColor = .systemGray4
            let messageLabel = UILabel(frame: CGRect(x: 15, y: 68, width: 244, height: 56))
            messageLabel.numberOfLines = 3
            messageLabel.textColor = .darkGray
            messageLabel.textAlignment = .center
            messageLabel.text = "Blueprint is better with LiDAR! This phone model does not support this feature, but you can still use the app."
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            let settingsButton = UIButton(frame: CGRect(x: 57, y: 139, width: 160, height: 40))
            settingsButton.clipsToBounds = true
            settingsButton.layer.cornerRadius = 20
            settingsButton.backgroundColor = UIColor(red: 69/255, green: 65/255, blue: 78/255, alpha: 1.0)
            settingsButton.setTitle("OK", for: .normal)
            settingsButton.setTitleColor(.white, for: .normal)
            settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            settingsButton.addTarget(self, action: #selector(self.headsUp), for: .touchUpInside)
            needLocationView.addSubview(titleLabel)
            needLocationView.addSubview(titleUnderView)
            needLocationView.addSubview(messageLabel)
            needLocationView.addSubview(settingsButton)
            self.view.addSubview(needLocationView)
            //self.topView.isUserInteractionEnabled = false
            self.addButton.isUserInteractionEnabled = false
            self.sceneView.isUserInteractionEnabled = false
            self.buttonStackView.isUserInteractionEnabled = false
            self.networkBtn.isUserInteractionEnabled = false
        }
    }
    
    @objc func headsUp(){
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "headsUp")
        self.needLocationView.removeFromSuperview()
        //self.topView.isUserInteractionEnabled = true
        self.addButton.isUserInteractionEnabled = true
        self.sceneView.isUserInteractionEnabled = true
        self.buttonStackView.isUserInteractionEnabled = true
        self.networkBtn.isUserInteractionEnabled = true
    }

    var holdGesture = UILongPressGestureRecognizer()
  
    static private let auth = Auth.auth()
    
    func setupLidar(){
        sceneView.session.delegate = self
       // sceneView.debugOptions.insert(.showStatistics)
        setupCoachingOverlay()
      //  sceneView.sess
 //       focusEntity = FocusEntity(on: sceneView, focus: .classic)
        
        sceneView.environment.sceneUnderstanding.options = []
        
      //  networkBtnImg?.image = UIImage(named: "guitarpbr")
       // arView.environment.lighting.
        entityProfileBtn.isUserInteractionEnabled = false
        entityProfileBtn.isHidden = true
        // Turn on occlusion from the scene reconstruction's mesh.
        sceneView.environment.sceneUnderstanding.options.insert(.occlusion)
        
        // Turn on physics for the scene reconstruction's mesh.
      //  sceneView.environment.sceneUnderstanding.options.insert(.physics)
        
        sceneView.environment.sceneUnderstanding.options.insert(.receivesLighting)
        
       // sceneView.environment.sceneUnderstanding.options.insert(.collision)
        sceneView.renderOptions = [
                    .disableHDR,
                    .disableDepthOfField,
                    .disableMotionBlur,
                    .disableFaceMesh,
                    .disablePersonOcclusion,
                    .disableCameraGrain
                ]
        // Display a debug visualization of the mesh.
      //  sceneView.debugOptions.insert(.showSceneUnderstanding)
        if !connectedToNetwork {
        //    self.copilotBtn.isHidden = true
            self.networksNearImg.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            // make the button grow to twice its original size
            self.networkBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        // Manually configure what kind of AR session to run since
        // ARView on its own does not turn on mesh classification.
        sceneView.automaticallyConfigureSession = false
        configuration.planeDetection = [.horizontal, .vertical]
     //   configuration.sceneReconstruction = .meshWithClassification
     //   configuration.isCollaborationEnabled = true
      //  configuration.frameSemantics.insert(.personSegmentationWithDepth)
      //  configuration.environmentTexturing = .automatic
        if #available(iOS 16.0, *) {
            if let hiResFormat = ARWorldTrackingConfiguration.recommendedVideoFormatFor4KResolution {
                configuration.videoFormat = hiResFormat
            }
        } else {
            // Fallback on earlier versions
        }
        sceneView.session.run(configuration)
        
        // NEW
        
        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        
    }
    
    let blueprintName = "F26B869C-3942-4D91-BA3A-081A1B0F7186-Mes.usdz"
    
    var modelVertices: [SIMD3<Float>] = []
    
    @objc func selectStyle(){
        if !connectedToNetwork {
            let alertController = UIAlertController(title: "Connect or Create a Blueprint", message: "To design your space, connect to an existing Blueprint or create a new one for your desired space.", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Create", style: .default, handler: { (_) in
                self.cancelAIAction()
                self.editAlert()
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.cancelAIAction()
            })
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func downloadBlueprint(){
        var blueprintResult: ModelEntity?
        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "blueprints/\(blueprintName ?? "")") { localUrl in
            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error):
                    print("Unable to load modelEntity for asdlsdd. Error: \(error.localizedDescription)")

                case .finished:
                    break
                }
            }, receiveValue: { roomEntity in
                // Set result to the loaded model entity
                blueprintResult = roomEntity

              //  self.currentEntity = modelEntity
                
                self.getVerticesOfRoom(entity: roomEntity, roomEntity.transform.matrix)

                    // Get the min and max X, Y and Z positions of the room
                    var minVertex = SIMD3<Float>(Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude)
                    var maxVertex = SIMD3<Float>(-Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude)
                for vertex in self.modelVertices {
                     if vertex.x < minVertex.x { minVertex.x = vertex.x }
                     if vertex.y < minVertex.y { minVertex.y = vertex.y }
                     if vertex.z < minVertex.z { minVertex.z = vertex.z }
                     if vertex.x > maxVertex.x { maxVertex.x = vertex.x }
                     if vertex.y > maxVertex.y { maxVertex.y = vertex.y }
                     if vertex.z > maxVertex.z { maxVertex.z = vertex.z }
                    }

                    // Compose the corners of the floor
                    let upperLeftCorner: SIMD3<Float> = SIMD3<Float>(minVertex.x, minVertex.y, minVertex.z)
                    let lowerLeftCorner: SIMD3<Float> = SIMD3<Float>(minVertex.x, minVertex.y, maxVertex.z)
                    let lowerRightCorner: SIMD3<Float> = SIMD3<Float>(maxVertex.x, minVertex.y, maxVertex.z)
                    let upperRightCorner: SIMD3<Float> = SIMD3<Float>(maxVertex.x, minVertex.y, minVertex.z)

                    // Create the floor's ModelEntity
                    let floorPositions: [SIMD3<Float>] = [upperLeftCorner, lowerLeftCorner, lowerRightCorner, upperRightCorner]
                    var floorMeshDescriptor = MeshDescriptor(name: "floor")
                    floorMeshDescriptor.positions = MeshBuffers.Positions(floorPositions)
                    // Positions should be specified in CCWISE order
                    floorMeshDescriptor.primitives = .triangles([0, 1, 2, 2, 3, 0])
                    let simpleMaterial = SimpleMaterial(color: .gray, isMetallic: false)
                    let floorModelEntity = ModelEntity(mesh: try! .generate(from: [floorMeshDescriptor]), materials: [simpleMaterial])
                 //   guard let floorModelEntity = floorModelEntity else {
                 //    return
                 //   }

                
                    // Add the floor as a child of the room
                roomEntity.addChild(floorModelEntity)
                self.currentEntity = roomEntity
                let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
                print(anchor)
                // anchor?.scale = [1.2,1.0,1.0]
                anchor?.addChild(self.currentEntity)
                self.sceneView.scene.addAnchor(anchor!)
/*
                //self.placeEntity(model: self.currentEntity)
                let entityBounds = self.currentEntity.visualBounds(relativeTo: nil) // Get the bounds of the RoomPlan scan Entity.
                let width = entityBounds.extents.x + 0.025 // Slightly extend the width of the "floor" past the model, adjust to your preference.
                let height = Float(0.002) // Set the "height" of the floor, or its thickness, to your preference.
                let depth = entityBounds.extents.z + 0.0125 // Set the length/depth of the floor slightly past the model, adjust to your preference.

                let boxResource = MeshResource.generateBox(size: SIMD3<Float>(width, height, depth))
                let material = SimpleMaterial(color: .white, roughness: 0, isMetallic: true)
                let floorEntity = ModelEntity(mesh: boxResource, materials: [material])

                let yCenter = (entityBounds.center.y * 100) - 1.0 // Set the offset of the floor slightly from the mode, adjust to your preference.
                floorEntity.scale = [100.0, 100.0, 100.0] // Scale the model by a factor of 100, as noted in the [release notes](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-16-release-notes) for working with RoomPlan entities.
                floorEntity.position = [entityBounds.center.x * 100, yCenter, entityBounds.center.z * 100]
                self.currentEntity.addChild(floorEntity)
                self.currentEntity.generateCollisionShapes(recursive: true)
                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
                let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
                print(anchor)
                // anchor?.scale = [1.2,1.0,1.0]
                anchor?.addChild(self.currentEntity)
//                let scale = model?.scale
//                print("\(scale) is scale")
                self.currentEntity.scale = [Float(0.2), Float(0.2), Float(0.2)]
                self.sceneView.scene.addAnchor(anchor!)
                self.modelPlacementUI()*/
            })
        }
        
        
    }
    
    var alertView = UIView()
    var xImageView = UIImageView()
    
    func showNearbyBlueprintAlert(){
        alertView = UIView(frame: CGRect(x: 20, y: 130, width: UIScreen.main.bounds.width - 40, height: 120))
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 12
       // alertView.backgroundColor = .lightGray
        
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height))
        backgroundImage.image = UIImage(named: "greygradient")
        backgroundImage.contentMode = .scaleAspectFill
        alertView.addSubview(backgroundImage)
        
        let imageView = UIImageView(frame: CGRect(x: 12, y: 12, width: 25, height: 25))
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .small)
        //   let largeBoldDoc = UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig)
        let largeBoldDoc = UIImage(systemName: "network", withConfiguration: largeConfig)
        imageView.image = largeBoldDoc
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .center
        imageView.tintColor = .white
        imageView.layer.cornerRadius = 5
        alertView.addSubview(imageView)
        
        let blueprintLabel = UILabel(frame: CGRect(x: 45, y: 15, width: 70, height: 20))
        blueprintLabel.text = "Blueprint"
        blueprintLabel.textColor = .darkGray
        blueprintLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        alertView.addSubview(blueprintLabel)
        
        let nowLabel = UILabel(frame: CGRect(x: alertView.frame.maxX - 62, y: 15.5, width: 30, height: 16))
        nowLabel.text = "now"
        nowLabel.textColor = .darkGray
        nowLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        alertView.addSubview(nowLabel)
        
        let titleLabel = UILabel(frame: CGRect(x: 12, y: 46, width: 170, height: 18))
        titleLabel.text = "Available Blueprint"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        alertView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel(frame: CGRect(x: 12, y: 66, width: alertView.frame.width - 30, height: 43))
        subtitleLabel.text = "'\(self.nearbyBlueprintName)' is an available Blueprint nearby."
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textColor = .black
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        alertView.addSubview(subtitleLabel)
        
        xImageView = UIImageView(frame: CGRect(x: alertView.frame.minX - 10, y: alertView.frame.minY - 12.5, width: 30, height: 30))
        xImageView.layer.cornerRadius = 15
        xImageView.image = UIImage(systemName: "xmark.circle.fill")
        xImageView.contentMode = .scaleAspectFit
        xImageView.tintColor = .systemGray2
        xImageView.backgroundColor = .darkGray
        xImageView.isUserInteractionEnabled = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewNetworks))
        alertView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(closeNearbyBlueprintAlert))
        xImageView.addGestureRecognizer(tap1)
        
        view.addSubview(alertView)
        view.addSubview(xImageView)
        
//        alertView.animate(withDuration: 0.7, delay: 0, options: [.curveLinear],
//                       animations: {
//                        self.center.y += self.bounds.height
//                        self.layoutIfNeeded()
//
//        },  completion: {(_ completed: Bool) -> Void in
//        self.isHidden = true
//            })
    }
    
    func getVerticesOfRoom(entity: Entity, _ transformChain: simd_float4x4) {
      let modelEntity = entity as? ModelEntity
      guard let modelEntity = modelEntity else {
       // If the Entity isn't a ModelEntity, skip it and check if we can get the vertices of its children
       let updatedTransformChain = entity.transform.matrix * transformChain
       for currEntity in entity.children {
        getVerticesOfRoom(entity: currEntity, updatedTransformChain)
       }
       return
      }

      // Below we get the vertices of the ModelEntity
      let updatedTransformChain = modelEntity.transform.matrix * transformChain

      // Iterate over all instances
      var instancesIterator = modelEntity.model?.mesh.contents.instances.makeIterator()
      while let currInstance = instancesIterator?.next() {
       // Get the model of the current instance
       let currModel = modelEntity.model?.mesh.contents.models[currInstance.model]

       // Iterate over the parts of the model
       var partsIterator = currModel?.parts.makeIterator()
       while let currPart = partsIterator?.next() {
        // Iterate over the positions of the part
        var positionsIterator = currPart.positions.makeIterator()
        while let currPosition = positionsIterator.next() {
         // Transform the position and store it
         let transformedPosition = updatedTransformChain * SIMD4<Float>(currPosition.x, currPosition.y, currPosition.z, 1.0)
         modelVertices.append(SIMD3<Float>(transformedPosition.x, transformedPosition.y, transformedPosition.z))
        }
       }
      }

      // Check if we can get the vertices of the children of the ModelEntity
      for currEntity in modelEntity.children {
       getVerticesOfRoom(entity: currEntity, updatedTransformChain)
      }
     }
  

//    private func layoutButton(_ button: UIButton, top: Double, lines: Double) {
//        let wideSize = sceneView.bounds.size.width - 20.0
//        button.frame = CGRect(x: 10.0, y: top, width: Double(wideSize), height: lines * 40)
//        if (lines > 1) {
//            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
//        }
//    }
//

    private func distance(_ a: [NSNumber], _ b: [NSNumber]) -> Float {
        if a.count != 3 || b.count != 3 {
            return 0
        }
        let dx = a[0].floatValue - b[0].floatValue
        let dy = a[1].floatValue - b[1].floatValue
        let dz = a[2].floatValue - b[2].floatValue
        return sqrt(dx * dx + dy * dy + dz * dz)
    }
        var promptLabel = UILabel()
    var cancelImg = UIImageView()
    
    @objc func closeNearbyBlueprintAlert(){
        self.alertView.removeFromSuperview()
        self.xImageView.removeFromSuperview()
    }
    
    @objc func cancelAIAction(){
        networkBtn.isHidden = false
        self.networksNear()
       // libraryImageView.isHidden = false
      //  wordsBtn.isHidden = false
       // videoBtn.isHidden = false
      //  copilotBtn.isHidden = false
        buttonStackView.isHidden = false
        self.styleTableView.isHidden = true
        self.overView.isHidden = true
        self.scanImgView.isHidden = false
        self.editInstructions.isHidden = true
        promptLabel.isHidden = true
        cancelImg.isHidden = true
        
        
        self.networkBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.networksNearImg.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
    }
    
   
    
    func searchEntity(query: String, completion: @escaping (String?) -> Void) {
        let capQuery = query.capitalized
        FirestoreManager.searchModels(queryStr: capQuery) { searchedModels in
            if let firstModel = searchedModels.first {
                // Set result to the id of the first model in the searchedModels array
                let result = firstModel.id
                self.modelUid = result
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    
    
    // Modify your downloadEntity function to return a ModelEntity value
    func downloadEntity(modelID: String) -> ModelEntity? {
        var result: ModelEntity?
        FirestoreManager.getModel(modelID) { model in
            let modelName = model?.modelName
            print("\(modelName ?? "") is model name")

            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")") { localUrl in
                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
                    switch loadCompletion {
                    case .failure(let error):
                        print("Unable to load modelEntity for \(modelName). Error: \(error.localizedDescription)")

                    case .finished:
                        break
                    }
                }, receiveValue: { modelEntity in
                    // Set result to the loaded model entity
                    result = modelEntity

                    self.currentEntity = modelEntity

                   // self.placeEntity(model: self.currentEntity)
                })
            }
        }
        //need completion handler - result is returning before asyncDownload is finished
        return result
    }

    
   
    override func viewWillAppear(_ animated: Bool) {
      //  checkCameraAccess()
       // networkBtn.setImage(networkBtnImg, for: .normal)// .imageView?.image = networkBtnImg
        if defaults.bool(forKey: "isCreatingNetwork") == false {
            
            progressView?.isHidden = true
           // feedbackControl?.isHidden = true
   //         anchorSettingsImg.isHidden = true
            
        } else {
            progressView?.isHidden = false
          //  scanningUI()
            
        }
       
        if (self.isMovingToParent || self.isBeingPresented){
                // Controller is being pushed on or presented.
            }
            else{
                // Controller is being shown as result of pop/dismiss/unwind.
                let defaults = UserDefaults.standard
                self.modelUid = defaults.value(forKey: "modelUid") as! String
                self.blueprintId = defaults.value(forKey: "blueprintId") as! String
                if defaults.bool(forKey: "createBlueprint") == true {
                    self.userGuideAction((Any).self)
                  //  defaults.set(false, forKey: "createBlueprint")
                } else if defaults.bool(forKey: "connectToBlueprint") == true {
                    if self.blueprintId != "" {
                        self.connectToBlueprint()
                        defaults.set(false, forKey: "connectToBlueprint")
                    }
                } else if defaults.bool(forKey: "goToCreateBlueprint") == true {
                    self.editAlert()
                    defaults.set(false, forKey: "goToCreateBlueprint")
                    print("\(String(describing: defaults.value(forKey: "goToCreateBlueprint"))) is the value for gotocreateblueprint")
                }
                print("\(String(describing: defaults.value(forKey: "goToCreateBlueprint"))) is the value for gotocreateblueprint")

            }
        
    }
    
    
    var currentEntity = ModelEntity()
    
    var selectedModel : Model?
    var currentAnchor = AnchorEntity()
    
   
    
    var connectedToNetwork = false
    var showedUI = false
    
    var changedOptions = false
    
   
    
    @objc func connectToBlueprint(){
        ProgressHUD.show("Loading...")
        view.isUserInteractionEnabled = false
        
        let group = DispatchGroup()

        // Enter the dispatch group before starting the first async task
        group.enter()
        FirestoreManager.getBlueprint(self.blueprintId) { blueprint in
            let modelName = blueprint?.storagePath
            print("\(modelName ?? "") is blueprint name")
            // Enter the dispatch group before starting the second async task
            group.enter()
            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "blueprints/\(modelName ?? "")")  { localUrl in
                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
                    switch loadCompletion {
                    case.failure(let error): print("Unable to load modelEntity for Mayflower Ship Model. Error: \(error.localizedDescription)")
                        ProgressHUD.dismiss()
                    case.finished:
                        break
                    }
                    // Leave the dispatch group after finishing the second async task
                    group.leave()
                }, receiveValue: { modelEntity in
                    self.currentEntity = modelEntity
                
                    self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
                    let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
                    print(anchor)
                    // anchor?.scale = [1.2,1.0,1.0]
                    anchor?.addChild(self.currentEntity)
//                    let scale = model?.scale
//                    print("\(scale) is scale")
//                    self.currentEntity.scale = [Float(scale ?? 0.01), Float(scale ?? 0.01), Float(scale ?? 0.01)]
                    self.sceneView.scene.addAnchor(anchor!)
                    // self.currentEntity?.scale *= self.scale
                    print("modelEntity for Mayflower Ship Model has been loaded.")
                    ProgressHUD.dismiss()
                    self.removeCloseButton()
                    // print("modelEntity for \(self.name) has been loaded.")
                 //   self.modelPlacementUI()
                })
                    // Leave the dispatch group after finishing the first async task
                    group.leave()
                }
            }
        
        // Wait for all async tasks to finish and call the completion closure
        group.notify(queue: .main) {
            // Do something after all async tasks are finished
            self.view.isUserInteractionEnabled = true
        }

    }
    
    func loadCapturedRoom() -> CapturedRoom? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("capturedRoom").appendingPathExtension("plist")

        guard let data = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(CapturedRoom.self, from: data)
    }
    
    var capturedRoom: CapturedRoom?
    
    // Load the destinationURL from UserDefaults
    func loadDestinationURL() -> URL? {
        if let url = UserDefaults.standard.url(forKey: "capturedRoomDestinationURL") {
            return url
        }
        return nil
    }
    
    
    @objc func goToCapturedRoom(){
        let vc = ARRoomModelView(nibName: "ARRoomModelView", bundle: nil)
        vc.capturedRoom = loadCapturedRoom()
        vc.modelURL = loadDestinationURL()
        vc.modalPresentationStyle = .fullScreen
   //     self.navigationController?.pushViewController(ObjectProfileViewController.instantiate(with: modelUid), animated: true)
        self.present(vc, animated: true, completion: nil)
    }
   
    
    func updateNetworkImg() {
        networkBtn.setImage(networkBtnImg, for: .normal)
    }
    
    @objc func viewNetworks(){
        let storyboard = UIStoryboard(name: "Networks", bundle: nil)
        var next = storyboard.instantiateViewController(withIdentifier: "NetworksNearVC") as! NetworksNearTableViewController
       // next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = storyboard.instantiateViewController(withIdentifier: "NewUIVC") as! NewUIViewController
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func networkAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "finishedWalkthrough")
        walkthroughLabel.removeFromSuperview()
        circle.removeFromSuperview()
        viewNetworks()
        
        }
    
    var overView = UIView()
    
    var editInstructions = UILabel()
    
    //  private var searchedModels  = [Model]()
    var stylesArray = ["Minimalist Haven", "Modern Fusion", "Japanese Zen", "Art Deco Glamour", "Bohemian Oasis", "Coastal Breeze", "Scandinavian Sanctuary", "Cyberpunk", "French Countryside"]
      private var styles        = [Style]()
      private var styleImages = [String: UIImage?]()
      private var fetchingImages = false
   
    @objc func showStyles(){
     
        self.overView = UIView(frame: CGRect(x: 0, y: styleTableView.frame.minY - 20, width: UIScreen.main.bounds.width, height: 20))
        
        self.overView.clipsToBounds = true
        self.overView.layer.cornerRadius = 12
        self.networkBtn.isHidden = true
        self.networksNearImg.isHidden = true
        self.alertView.isHidden = true
        self.xImageView.isHidden = true
        self.overView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.networkBtn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.networksNearImg.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        styleTableView.isHidden = false
        scanImgView.isHidden = true
        buttonStackView.isHidden = true
        promptLabel = UILabel(frame: CGRect(x: (view.frame.width - 250) / 2, y: 70, width: 250, height: 80))
        promptLabel.numberOfLines = 2
        promptLabel.textColor = .white
        promptLabel.tintColor = .white
        promptLabel.text = "Choose a style to design your space"
        promptLabel.textAlignment = .center
        promptLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        view.addSubview(promptLabel)

        cancelImg = UIImageView(frame: CGRect(x: 22, y: 58, width: 22, height: 22))
        cancelImg.tintColor = .white
        cancelImg.isUserInteractionEnabled = true
        cancelImg.clipsToBounds = true
        cancelImg.contentMode = .scaleAspectFit
        let smallConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold, scale: .medium)
        let smallBoldDoc = UIImage(systemName: "xmark", withConfiguration: smallConfig)
        cancelImg.image = smallBoldDoc
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelAIAction))
        cancelImg.addGestureRecognizer(tap)
        view.addSubview(cancelImg)
        overView.backgroundColor = .white
        view.addSubview(overView)
        
        
        self.editInstructions.removeFromSuperview()
        
        self.editInstructions = UILabel(frame: CGRect(x: 15, y: overView.frame.minY - 67, width: UIScreen.main.bounds.width - 30, height: 63))
        self.editInstructions.text = "Think of each style as a starting template. You can further design your space using Blueprint's library of 3D content after choosing the style of your choice."
        self.editInstructions.textColor = .white
        self.editInstructions.numberOfLines = 3
        self.editInstructions.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        view.addSubview(editInstructions)
    }
    
    var styleName = ""
    
    var selectedIndexPath: IndexPath?

    
    @objc func useStyleAlert(){
//        let alertController = UIAlertController(title: "\(self.styleName)", message: "Use the \(self.styleName) style to design your space?", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Design", style: .default, handler: { (_) in
//            //change textures/colors of walls, floor and ceiling planes
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            var next = storyboard.instantiateViewController(withIdentifier: "BlueprintVC") as! BlueprintViewController
//             next.modalPresentationStyle = .fullScreen
//            self.present(next, animated: true, completion: nil)
//
//        })
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
//
//        })
//
//        alertController.addAction(saveAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)\
        if isLocked == true {
            let alertController = UIAlertController(title: "Create Account", message: "To use locked AI-Powered design styles, create a Blueprint account.", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Sign Up", style: .default, handler: { (_) in
                self.goToSignUp()
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
             //   self.cancelAIAction()
            })
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: "Connect or Create a Blueprint", message: "To use our AI-Powered design tools, connect to an existing Blueprint or create a new one for your desired space.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Create", style: .default, handler: { (_) in
            self.cancelAIAction()
            self.editAlert()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
         //   self.cancelAIAction()
        })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var isLocked = false
    
    @objc func styleImageTapped(_ gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView,
              let cell = imageView.superview?.superview as? StyleTableViewCell,
              let tableView = cell.superview as? UITableView,
              let indexPath = tableView.indexPath(for: cell) else { return }

        // Remove border from all image views in the table view
        for case let visibleCell as StyleTableViewCell in tableView.visibleCells {
            for subview in visibleCell.contentView.subviews {
                if let imageView = subview as? UIImageView {
                    imageView.layer.borderWidth = 0
                }
            }
        }

        // Add border to the tapped image view
        imageView.layer.borderColor = UIColor.systemYellow.cgColor
        imageView.layer.borderWidth = 3.5

        // Get the selected style name
        if let selectedStyleName = getSelectedStyleName(for: indexPath, tag: imageView.tag) {
            print("\(selectedStyleName) is the selected style")
            self.styleName = selectedStyleName
            self.useStyleAlert()
        }
    }

    func getSelectedStyleName(for indexPath: IndexPath, tag: Int) -> String? {
        let index = indexPath.row * 3 + tag
        guard index < stylesArray.count else { return nil }

        let selectedStyle = stylesArray[index]
        
        let isFirstFiveUnlocked = index < 5 // Adjust the condition based on the desired range of unlocked styles
        let isStyleLocked = !isFirstFiveUnlocked && Auth.auth().currentUser == nil
            
            if isStyleLocked {
                print("Selected style is locked.")
                // Perform any additional actions for locked styles, such as showing an alert
                isLocked = true
            } else {
                print("Selected style is unlocked.")
                // Perform any additional actions for unlocked styles
                isLocked = false
            }
        
        return selectedStyle
    }

    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: StyleTableViewCell.identifier, for: indexPath) as! StyleTableViewCell
//
//        tableView.rowHeight = 130
//
//        // Determine the index in the styles array based on the row
//        let index = indexPath.row * 3
//
//        // Configure the cell with the corresponding styles
//        cell.configure(with: stylesArray[index])
//
//        cell.configure2(with: stylesArray[index + 1])
//        cell.configure3(with: stylesArray[index + 2])
//
//        // Add a tap gesture recognizer to each image view
//        cell.styleImageView1.tag = 0
//        cell.styleImageView1.isUserInteractionEnabled = true
//        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(styleImageTapped(_:)))
//        cell.styleImageView1.addGestureRecognizer(tapGesture1)
//
//        cell.styleImageView2.tag = 1
//        cell.styleImageView2.isUserInteractionEnabled = true
//        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(styleImageTapped(_:)))
//        cell.styleImageView2.addGestureRecognizer(tapGesture2)
//
//        cell.styleImageView3.tag = 2
//        cell.styleImageView3.isUserInteractionEnabled = true
//        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(styleImageTapped(_:)))
//        cell.styleImageView3.addGestureRecognizer(tapGesture3)
//
//        // Set the initial state of the lockImageViews based on user authentication
//            if let currentUser = Auth.auth().currentUser {
//                cell.lockImageView1.isHidden = true
//                cell.lockImageView2.isHidden = true
//                cell.lockImageView3.isHidden = true
//            } else {
//                cell.lockImageView1.isHidden = false
//                cell.lockImageView2.isHidden = false
//                cell.lockImageView3.isHidden = false
//            }
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StyleTableViewCell.identifier, for: indexPath) as! StyleTableViewCell
        
        tableView.rowHeight = 130
        
        let index = indexPath.row * 3
            
            let isFirstFiveUnlocked = index < 5
            
            cell.configure(with: stylesArray[index], isFirstFiveUnlocked: isFirstFiveUnlocked)
            cell.configure2(with: stylesArray[index + 1], isFirstFiveUnlocked: isFirstFiveUnlocked)
            cell.configure3(with: stylesArray[index + 2], isFirstFiveUnlocked: isFirstFiveUnlocked)
            
            cell.styleImageView1.tag = 0
            cell.styleImageView1.isUserInteractionEnabled = true
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(styleImageTapped(_:)))
            cell.styleImageView1.addGestureRecognizer(tapGesture1)

            cell.styleImageView2.tag = 1
            cell.styleImageView2.isUserInteractionEnabled = true
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(styleImageTapped(_:)))
            cell.styleImageView2.addGestureRecognizer(tapGesture2)

            cell.styleImageView3.tag = 2
            cell.styleImageView3.isUserInteractionEnabled = true
            let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(styleImageTapped(_:)))
            cell.styleImageView3.addGestureRecognizer(tapGesture3)
            
            return cell
    }


//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stylesArray.count / 3
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        locationManager = CLLocationManager()
        // This will cause either |locationManager:didChangeAuthorizationStatus:| or
        // |locationManagerDidChangeAuthorization:| (depending on iOS version) to be called asynchronously
        // on the main thread. After obtaining location permission, we will set up the ARCore session.
        locationManager?.delegate = self
        // locationManager?.distanceFilter = 20
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startUpdatingLocation()
       // checkCameraAccess()
//        self.checkWalkthrough()

    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                //self.resetButtonPressed(self)
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
    var searchTaps = 0
    
    private var allModels       = [Model]()
    private var searchedModels  = [Model]()

    let addButton = UIButton(frame: CGRect(x: 38, y: 728, width: 52, height: 52))
  
    
    @objc func editAlert(){
        if let viewController = self.storyboard?.instantiateViewController(
            withIdentifier: "OnboardingViewController") {
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        var next = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
//       // next.modalPresentationStyle = .fullScreen
//        present(next, animated: true, completion: nil)
    }
    
    @objc func searchUI(){
    let defaults = UserDefaults.standard
    
//    if defaults.bool(forKey: "finishedWalkthrough") == false {
//        defaults.set(true, forKey: "finishedWalkthrough")
//        self.walkthroughView.removeFromSuperview()
//        self.circle.removeFromSuperview()
//        self.walkthroughLabel.removeFromSuperview()
//        self.buttonStackView.isUserInteractionEnabled = true
//        self.videoBtn.isUserInteractionEnabled = true
//        self.wordsBtn.isUserInteractionEnabled = true
//        self.networkBtn.isUserInteractionEnabled = true
//        self.buttonStackViewBottomConstraint.constant = -87
//    }
       // searchTaps += 1
        isVideoMode = false
        isTextMode = false
        isObjectMode = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       // print("\(LaunchViewController.auth.currentUser?.uid) is the current user id")
        
        var next = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
       // let navVC = UINavigationController(rootViewController: next)
       // var next = UserProfileViewController.instantiate(with: user)
      
        next.modalPresentationStyle = .fullScreen
        present(next, animated: true, completion: nil)
        

    }
    
    
   
    
    let storedData = UserDefaults.standard
    let mapKey = "ar.worldmap"
    var heightInPoints = CGFloat()
    var widthInPoints = CGFloat()
    var imageAnchorURL : URL?
    var videoAnchorURL : URL?
    private var imageAnchorChanged = false
    private var videoAnchorChanged = false
    private let imagePicker        = UIImagePickerController()
    var photoAnchorImageView = UIImageView()
  
    var num = 0
    
    var nearbyBlueprintName = ""
    
    func networksNear(){
        print("\(self.currentLocation?.coordinate.latitude) is lat")
        print("\(self.currentLocation?.coordinate.longitude) is long")
        print("\(self.originalLocation.coordinate.latitude) is orig lat")
        print("\(self.originalLocation.coordinate.longitude) is orig long")
        FirestoreManager.getBlueprintsInRange(centerCoord: CLLocationCoordinate2D(latitude: (self.originalLocation.coordinate.latitude), longitude: (self.originalLocation.coordinate.longitude)), withRadius: 20) { (blueprints) in
            
            self.num = blueprints.count
           
            if self.num == 0 {
                self.networksNearImg.isHidden = true
            } else if self.num >= 1 {
                let blueprint = blueprints[0]
                self.networksNearImg.image = UIImage(systemName: "\(self.num).circle.fill")
                self.networksNearImg.isHidden = false
                 
//                self.editInstructions = UILabel(frame: CGRect(x: 15, y: 135, width: UIScreen.main.bounds.width - 30, height: 50))
//
//
//                self.editInstructions.textAlignment = .center
//                self.editInstructions.text = "There is a Blueprint near your location. Explore and connect with it!" // "There is a Blueprint near your location. Do you want to connect?"
//                self.editInstructions.backgroundColor = .white
//                self.editInstructions.textColor = .black
//                self.editInstructions.clipsToBounds = true
//                self.editInstructions.layer.cornerRadius = 12
//               // self.editInstructions.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//                self.editInstructions.numberOfLines = 2
//                self.editInstructions.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                self.checkWalkthrough()
                let blueprintId = blueprint.id
                FirestoreManager.getBlueprint(blueprintId) { (foundBlueprint) in
                    if let blueprint = foundBlueprint {
                        self.nearbyBlueprintName = blueprint.name
                        if self.userGuideBtn.isHidden == true {
                            self.showNearbyBlueprintAlert()
                        }}
                }
              //  self.showNearbyBlueprintAlert()
            }
        }}
    
    var isPlacingModel = false
    
     
     func goToSignUp(){
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        var next = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
         next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    func updateUserLocation() {
        if self.currentLocation?.distance(from: self.originalLocation) ?? 0 >= 7 && self.currentLocation?.distance(from: self.originalLocation) ?? 0 < 200 {
          //  self.lookForAnchorsNearDevice()
         //   self.anchorsNear()
            print("updated anchor near")
            self.originalLocation = CLLocation(latitude: currentLocation?.coordinate.latitude ?? 42.3421531456477, longitude: currentLocation?.coordinate.longitude ?? -71.08596376738004)
            print("\(originalLocation) is og location")
        }
    }
    
    var closeButton = UIButton()
    
    
    func removeCloseButton(){
        closeButton.removeFromSuperview()
    }
    
     func exit(){
        ProgressHUD.dismiss()
    //    self.updatePersistanceAvailability(for: sceneView)
        entityName.isHidden = true
        entityProfileBtn.isHidden = true
            networkBtn.isHidden = false
            networksNearImg.isHidden = false
        return
    }
    var currentPlaneAnchor: ARPlaneAnchor?
    private var planeAnchors: [ARPlaneAnchor] = []
    // MARK: - ARSessionDelegate

    
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        switch frame.worldMappingStatus {
//        case .notAvailable, .limited:
//            saveButton.isUserInteractionEnabled = false
//        case .extending:
//            saveButton.isUserInteractionEnabled = false// = !multipeerSession.connectedPeers.isEmpty
//        case .mapped:
//            saveButton.isUserInteractionEnabled = false// = !multipeerSession.connectedPeers.isEmpty
//        @unknown default:
//            saveButton.isUserInteractionEnabled = false
//        }
//            self.updateUserLocation()
//    }
   
    var anchorHostID = ""
    var entityName = UILabel()
    var entityDetailsView = UIView()
    var entityProfileBtn = UIButton()
    var image: UIImage? = nil
    var detailAnchor = AnchorEntity()
    
    func goToNetworkSettings(_ sender: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Networks", bundle: nil)
        var next = storyboard.instantiateViewController(withIdentifier: "NetworkSettingsVC") as! NetworkSettingsTableViewController
        //next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        print("Permission granted, proceed")
                    } else {
                        DispatchQueue.main.async {
                        print("Denied, request permission from settings")
                        let needLocationView = UIView(frame: CGRect(x: 58, y: 313, width: 274, height: 194))
                        needLocationView.backgroundColor = .white
                        needLocationView.clipsToBounds = true
                        needLocationView.layer.cornerRadius = 14
                        let titleLabel = UILabel(frame: CGRect(x: 105.67, y: 21, width: 63, height: 28))
                        titleLabel.text = "Oops!"
                        titleLabel.textColor = .black
                        titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
                        let titleUnderView = UIView(frame: CGRect(x: 92, y: 59, width: 90, height: 1))
                        titleUnderView.backgroundColor = .systemGray6
                        let messageLabel = UILabel(frame: CGRect(x: 15, y: 68, width: 244, height: 56))
                        messageLabel.numberOfLines = 3
                        messageLabel.textColor = .darkGray
                        messageLabel.textAlignment = .center
                        messageLabel.text = "Blueprint is a camera app! To continue, you'll need to allow Camera access in Settings."
                        messageLabel.font = UIFont.systemFont(ofSize: 14)
                        let settingsButton = UIButton(frame: CGRect(x: 57, y: 139, width: 160, height: 40))
                        settingsButton.clipsToBounds = true
                        settingsButton.layer.cornerRadius = 20
                        settingsButton.backgroundColor = UIColor(red: 69/255, green: 65/255, blue: 78/255, alpha: 1.0)
                        settingsButton.setTitle("Settings", for: .normal)
                        settingsButton.setTitleColor(.white, for: .normal)
                        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                        settingsButton.addTarget(self, action: #selector(self.goToSettings), for: .touchUpInside)
                        needLocationView.addSubview(titleLabel)
                        needLocationView.addSubview(titleUnderView)
                        needLocationView.addSubview(messageLabel)
                        needLocationView.addSubview(settingsButton)
                        self.view.addSubview(needLocationView)
                        //self.topView.isUserInteractionEnabled = false
                        self.addButton.isUserInteractionEnabled = false
                        self.sceneView.isUserInteractionEnabled = false
                    }}}
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                    let needLocationView = UIView(frame: CGRect(x: 58, y: 313, width: 274, height: 194))
                    needLocationView.backgroundColor = .white
                    needLocationView.clipsToBounds = true
                    needLocationView.layer.cornerRadius = 14
                    let titleLabel = UILabel(frame: CGRect(x: 105.67, y: 21, width: 63, height: 28))
                    titleLabel.text = "Oops!"
                    titleLabel.textColor = .black
                    titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
                    let titleUnderView = UIView(frame: CGRect(x: 92, y: 59, width: 90, height: 1))
                    titleUnderView.backgroundColor = .systemGray6
                    let messageLabel = UILabel(frame: CGRect(x: 15, y: 68, width: 244, height: 56))
                    messageLabel.numberOfLines = 3
                    messageLabel.textColor = .darkGray
                    messageLabel.textAlignment = .center
                    messageLabel.text = "Blueprint is a camera app! To continue, you'll need to allow Camera access in Settings."
                    messageLabel.font = UIFont.systemFont(ofSize: 14)
                    let settingsButton = UIButton(frame: CGRect(x: 57, y: 139, width: 160, height: 40))
                    settingsButton.clipsToBounds = true
                    settingsButton.layer.cornerRadius = 20
                    settingsButton.backgroundColor = UIColor(red: 69/255, green: 65/255, blue: 78/255, alpha: 1.0)
                    settingsButton.setTitle("Settings", for: .normal)
                    settingsButton.setTitleColor(.white, for: .normal)
                    settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                    settingsButton.addTarget(self, action: #selector(self.goToSettings), for: .touchUpInside)
                    needLocationView.addSubview(titleLabel)
                    needLocationView.addSubview(titleUnderView)
                    needLocationView.addSubview(messageLabel)
                    needLocationView.addSubview(settingsButton)
                    self.view.addSubview(needLocationView)
                    //self.topView.isUserInteractionEnabled = false
                    self.addButton.isUserInteractionEnabled = false
                  
                    self.sceneView.isUserInteractionEnabled = false
                    self.buttonStackView.isUserInteractionEnabled = false
                    self.networkBtn.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    var originalAnchorLikes = Int()
    
    func checkLocationPermission() {
        var authorizationStatus: CLAuthorizationStatus?

        if #available(iOS 14.0, *) {
            authorizationStatus = self.locationManager?.authorizationStatus // CLAuthorizationStatus(rawValue: locationManager?.authorizationStatus().rawValue)
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            if #available(iOS 14.0, *) {
                if locationManager?.accuracyAuthorization != .fullAccuracy {
                  //  self.statusLabel?.text = "Location permission not granted with full accuracy."
                   // self.addAnchorButton?.isHidden = true
                   // self.networkView.isHidden = true
                   // self.deleteAnchorButton?.isHidden = true
                    return
                }
            }
        } else if authorizationStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            let needLocationView = UIView(frame: CGRect(x: 58, y: 313, width: 274, height: 194))
            needLocationView.backgroundColor = .white
            needLocationView.clipsToBounds = true
            needLocationView.layer.cornerRadius = 14
            let titleLabel = UILabel(frame: CGRect(x: 105.67, y: 21, width: 63, height: 28))
            titleLabel.text = "Oops!"
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
            let titleUnderView = UIView(frame: CGRect(x: 92, y: 59, width: 90, height: 1))
            titleUnderView.backgroundColor = .systemGray6
            let messageLabel = UILabel(frame: CGRect(x: 15, y: 68, width: 244, height: 56))
            messageLabel.numberOfLines = 3
            messageLabel.textColor = .darkGray
            messageLabel.textAlignment = .center
            messageLabel.text = "Blueprint is a location-based app! To continue, you'll need to allow Location access in Settings."
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            let settingsButton = UIButton(frame: CGRect(x: 57, y: 139, width: 160, height: 40))
            settingsButton.clipsToBounds = true
            settingsButton.layer.cornerRadius = 20
            settingsButton.backgroundColor = UIColor(red: 69/255, green: 65/255, blue: 78/255, alpha: 1.0)
            settingsButton.setTitle("Settings", for: .normal)
            settingsButton.setTitleColor(.white, for: .normal)
            settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            settingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
            needLocationView.addSubview(titleLabel)
            needLocationView.addSubview(titleUnderView)
            needLocationView.addSubview(messageLabel)
            needLocationView.addSubview(settingsButton)
            view.addSubview(needLocationView)
            //topview.isUserInteractionEnabled = false
            addButton.isUserInteractionEnabled = false
            sceneView.isUserInteractionEnabled = false
            buttonStackView.isUserInteractionEnabled = false
            networkBtn.isUserInteractionEnabled = false
            scanImgView.isUserInteractionEnabled = false
           // self.statusLabel?.text = "Location permission denied or restricted."
           // self.addAnchorButton?.isHidden = true
            //self.networkView.isHidden = true
           // self.deleteAnchorButton?.isHidden = true
        }}
    
    @objc func goToSettings(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
    }

  //  var webScreenshot = UIImage?
    var videoTaps = 0
    var anchorSettingsImg = UIImageView()
    var selectedAnchorID = ""
    
    
    
    func locationManager(_ locationManager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }

    /// Authorization callback for iOS 14.
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ locationManager: CLLocationManager) {
        checkLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
        // You can also display an alert to the user or show a message on the screen to inform them that there was an error getting their location.
    }
    
    private let locationUpdateThreshold: CLLocationDistance = 50
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentLocation == nil {
            if let location = locations.first {
                //MAYBE LOCATIONMANAGER.COORDINATE.LAT
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                self.originalLocation = CLLocation(latitude: latitude, longitude: longitude)
                self.networksNear()
               // self.lookForAnchorsNearDevice()
        //        self.checkWalkthrough()

                if Auth.auth().currentUser != nil {
                    let docRef = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    docRef.updateData([
                        "latitude": latitude,
                        "longitude": longitude,
                        "numSessions" : FieldValue.increment(Int64(1))
                    ]) { (error) in
                        if let error = error {
                            print("Error updating location: \(error.localizedDescription)")
                        } else {
                            print("Location updated successfully!")
                        }
                    }
                }
            }
        }
        if let location = locations.last {
            //MAYBE LOCATIONMANAGER.COORDINATE.LAT
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
            self.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
            print("\(currentLocation?.verticalAccuracy ?? 0) is vert accuracy")
            if (currentLocation?.horizontalAccuracy ?? 0 < 0){
               // No Signal
                print("NO SIGNAL")
                //INSIDE --> SHOW GRAPHIC
           }
            else if (currentLocation?.horizontalAccuracy ?? 0 > 163){
               // Poor Signal
               print("POOR SIGNAL")
               //INSIDE --> SHOW GRAPHIC
           }
            else if (currentLocation?.horizontalAccuracy ?? 0 > 48){
               // Average Signal
               print("AVERAGE SIGNAL")
                
               //UNSURE --> SHOW UNSURE GRAPHIC
           }
           else{
               // Full Signal
               print("FULL SIGNAL")
               //OUTSIDE
           }
          //  let currentDistance = self.currentLocation?.distance(from: self.originalLocation)
            print("\(String(describing: currentLocation)) is current location updated")
//            self.networksNear()
            if defaults.bool(forKey: "connectToNetwork") == false {

            } else {
                FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
                    self.currentConnectedNetwork = user?.currentConnectedNetworkID ?? ""
             //       self.connectToNetwork(with: self.currentConnectedNetwork)
                    let defaults = UserDefaults.standard
                    defaults.set(false, forKey: "connectToNetwork")

                }}
          //  print("\(originalLocation) is current original location")
           
        }
        
        
    }
    
    private func updateUserLocationInDatabase(_ location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        docRef.updateData([
            "latitude": latitude,
            "longitude": longitude
        ]) { (error) in
            if let error = error {
                print("Error updating location: \(error.localizedDescription)")
            } else {
                print("Location updated successfully!")
            }
        }
    }


}



//class SceneManager: ObservableObject {
//        @Published var isPersistenceAvailable: Bool = false
//        @Published var anchorEntities: [AnchorEntity] = []
//
//        var shouldSaveSceneToSystem: Bool = false
//        var shouldLoadSceneToSystem: Bool = false
//
//        lazy var persistenceURL: URL = {
//            do {
//                return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("blueprint.persistence")
//            } catch {
//                fatalError("Unable to get persistence url: \(error.localizedDescription)")
//            }
//        }()
//
//        var scenePersistenceData: Data? {
//            return try? Data(contentsOf: persistenceURL)
//        }
//    }

extension LaunchViewController {
    class Coordinator: NSObject, ARSessionDelegate {
        var parent : LaunchViewController
        
        init(_ parent: LaunchViewController) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

//#Preview{
//    var controller = LaunchViewController()
//    return controller
//}
