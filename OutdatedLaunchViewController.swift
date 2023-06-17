////
////  LaunchViewController.swift
////  DecorateYourRoom
////
////  Created by Nijel Hunt on 5/27/21.
////  Copyright © 2021 Placenote. All rights reserved.
////
//
//import UIKit
//import RealityKit
//import SwiftUI
//import ARKit
//import MultipeerConnectivity
//import Foundation
//import MultipeerHelper
//import FocusEntity
//import FirebaseAuth
//import Combine
//import CoreLocation
//import WebKit
//import FirebaseFirestore
//import ProgressHUD
//import SCLAlertView
//import GeoFire
////import ADAL
//import Photos
//import AzureSpatialAnchors
//
//protocol LaunchViewControllerDelegate {
//    func updateNetworkImg()
//    
//}
//
//private let anchorNamePrefix = "model-"
//
//// Special dictionary key used to track an unsaved anchor
//let unsavedAnchorId = "placeholder-id"
//
//// Colors for the local anchors to indicate status
//let readyColor = UIColor.blue.withAlphaComponent(0.6)           // light blue for a local anchor
//let savedColor = UIColor.green.withAlphaComponent(0.6)          // green when the cloud anchor was saved successfully
//let foundColor = UIColor.yellow.withAlphaComponent(0.6)         // yellow when we successfully located a cloud anchor
//let deletedColor = UIColor.black.withAlphaComponent(0.6)        // grey for a deleted cloud anchor
//let failedColor = UIColor.red.withAlphaComponent(0.6)
//
//class LaunchViewController: UIViewController, ARSessionDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, MultipeerHelperDelegate, UITextFieldDelegate, ASACloudSpatialAnchorSessionDelegate {
//    
//    // Set this string to the account ID provided for the Azure Spatial Anchors account resource.
////    let spatialAnchorsAccountId = "ff7aa5d4-db77-4a8f-ac49-babee66aab5b"
//    let spatialAnchorsAccountId = "b78644ae-c9ae-4cce-9ad5-00570e26de32"
//
//    // Set this string to the account key provided for the Azure Spatial Anchors account resource.
////    let spatialAnchorsAccountKey = "Nu08iRbSKoP/rucUDLVovT2/xm0F9/JL4QQMrtb1pWk="
//    let spatialAnchorsAccountKey = "OGa6xXxPYFrCX0SHVJg+5Z10yG8IbQybTSxHWKVxL5o="
//    
//
//    // Set this string to the account domain provided for the Azure Spatial Anchors account resource.
//    let spatialAnchorsAccountDomain = "eastus.mixedreality.azure.com"
//    
//    var anchorVisuals = [String : AnchorVisual]()
//    var cloudSession: ASACloudSpatialAnchorSession? = nil
//    var cloudAnchor: ASACloudSpatialAnchor? = nil
//    var localAnchor: ARAnchor? = nil
//    
//    var enoughDataForSaving = false     // whether we have enough data to save an anchor
//    var currentlyPlacingAnchor = false  // whether we are currently placing an anchor
//    var ignoreMainButtonTaps = false    // whether we should ignore taps to wait for current demo step finishing
//    var saveCount = 0                   // the number of anchors we have saved to the cloud
//    var step = DemoStep.prepare         // the next step to perform
//    var targetId : String? = nil        // the cloud anchor identifier to locate
//    
//    var locationManager: CLLocationManager?
//    
//    var delegate: LaunchViewControllerDelegate?
//    
//    var sceneManager = SceneManager()
//   
//    @IBOutlet weak var composeImgView: UIImageView!
//    @IBOutlet weak var buttonStackViewBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var anchorInfoStackView: UIStackView!
//    @IBOutlet weak var shareImgView: UIImageView!
//    @IBOutlet weak var anchorCommentsLabel: UILabel!
//    @IBOutlet weak var anchorLikesLabel: UILabel!
//    @IBOutlet weak var commentImg: UIImageView!
//    @IBOutlet weak var heartImg: UIImageView!
//    @IBOutlet weak var anchorUserImg: UIImageView!
//    @IBOutlet weak var profileImgView: UIImageView!
//    @IBOutlet weak var searchImgView: UIImageView!
//    @IBOutlet weak var addImgView: UIImageView!
//    @IBOutlet weak var buttonStackView: UIStackView!
//    @IBOutlet weak var animalsCategoryBtn: UIButton!
//    @IBOutlet weak var categoryStackView: UIStackView!
//    @IBOutlet weak var categoryScrollView: UIScrollView!
//    @IBOutlet weak var sceneInfoButton: UIButton!
//    @IBOutlet weak var searchField: UITextField!
//    @IBOutlet weak var newSearchView: UIView!
//    @IBOutlet weak var objectInfoViewBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var objectInfoViewPrice: UILabel!
//    @IBOutlet weak var objectInfoViewName: UILabel!
//    @IBOutlet weak var objectInfoViewCancelBtn: UIButton!
//    @IBOutlet weak var objectInfoViewImg: UIImageView!
//    @IBOutlet weak var objectInfoView: UIView!
//    @IBOutlet weak var wordsBtnTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var abstractPaintingButton: UIButton!
//    @IBOutlet weak var cancelWalkthroughButton: UIButton!
//    @IBOutlet weak var nftMode: UIButton!
//    @IBOutlet weak var backButton: UIButton!
//    @IBOutlet weak var modelsMode: UIButton!
//    @IBOutlet weak var searchStackView: UIStackView!
//    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var walkthroughViewLabel: UILabel!
//    @IBOutlet weak var walkthroughView: UIView!
//    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var browseTableView: UITableView!
//    @IBOutlet weak var betweenView: UIView!
//    @IBOutlet weak var numberOfEditsImg: UIImageView!
//    @IBOutlet weak var saveButton: UIButton!
//    @IBOutlet weak var previewUnderView: UIView!
//    @IBOutlet weak var editUnderView: UIView!
//    @IBOutlet weak var searchView: SearchView!
//    @IBOutlet weak var profileButton: UIButton!
//    @IBOutlet weak var searchBtn: UIButton!
//    @IBOutlet weak var scanBtn: UIButton!
//    @IBOutlet weak var trashBtn: UIButton!
//    @IBOutlet weak var duplicateBtn: UIButton!
//    @IBOutlet weak var removeBtn: UIButton!
//    @IBOutlet weak var placementStackView: UIStackView!
//    @IBOutlet weak var placementStackBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var confirmBtn: UIButton!
//    @IBOutlet weak var likeBtn: UIButton!
//    @IBOutlet weak var scanModeBtn: UIButton!
//    @IBOutlet weak var designModeBtn: UIButton!
//    @IBOutlet weak var objectModeBtn: UIButton!
//    @IBOutlet weak var modeStackView: UIStackView!
//    
//    @IBOutlet weak var previewButton: UIButton!
//    @IBOutlet weak var sceneView: CustomARView!
//  //  @IBOutlet weak var sceneView1: CustomARView!
//    @IBOutlet weak var shareImg: UIImageView!
//    @IBOutlet weak var connectedNetworkImg: UIImageView!
//    @IBOutlet weak var stackView: UIStackView!
//    @IBOutlet weak var networkBtn: UIButton!
//    @IBOutlet weak var actionBtn: UIButton!
//    @IBOutlet weak var settingsBtn: UIButton!
//    @IBOutlet weak var toggleBtn: UIButton!
//    @IBOutlet weak var networksNearImg: UIImageView!
//    @IBOutlet weak var wordsBtn: UIButton!
//    @IBOutlet weak var videoBtn: UIButton!
//    
//    @IBOutlet weak var editButton: UIButton!
//    @IBOutlet weak var topview: UIView!
//    @IBOutlet weak var searchBar: HomeSearchBar!
//    @StateObject var modelsViewModel = ModelsViewModel()
//    
//    struct GlobalVariable{
//        static var myString = String()
//    }
//    
//    @Published var recentlyPlaced: [Model] = []
//    
//    var defaultConfiguration: ARWorldTrackingConfiguration {
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal, .vertical]
//        config.sceneReconstruction = .meshWithClassification
//        config.isCollaborationEnabled = true
//        config.frameSemantics.insert(.personSegmentationWithDepth)
//        config.environmentTexturing = .automatic
//        return config
//    }
//    
//    var progressView : UIView?
//    var progressBar : UIProgressView?
//    
//    let config = ARWorldTrackingConfiguration()
//
//    let db = Firestore.firestore()
//    
//    var currentLocation: CLLocation?
//    var originalLocation = CLLocation()
//    
//    var arState: ARState?
//    
//    struct ModelAnchor {
//        var model: ModelEntity
//        var anchor: ARAnchor?
//    }
//    
//    var anchorPlaced: ARAnchor?
//    
//    var modelsConfirmedForPlacement: [ModelAnchor] = []
//   
//    
//    var isVideoMode: Bool = false
//    var isTextMode: Bool = false
//    var isObjectMode: Bool? = true
//    var isScanMode: Bool?
//    
//    var trashZone: GradientView!
//    var shadeView: UIView!
//    var resetButton: UIButton!
//    
//    var keyboardHeight: CGFloat!
//    
//    var stickyNotes = [StickyNoteEntity]()
//    
//    var subscription: Cancellable!
//    
//    let defaults = UserDefaults.standard
//    var textNode:SCNNode?
//    var textSize:CGFloat = 5
//    var textDistance:Float = 15
//    let coachingOverlay = ARCoachingOverlayView()
//    
//    var shareRecognizer = UITapGestureRecognizer()
//    var doubleTap = UITapGestureRecognizer()
//    var profileRecognizer = UITapGestureRecognizer()
//    var textSettingsRecognizer = UITapGestureRecognizer()
//    var browseRec = UITapGestureRecognizer()
//    var undoTextRecognizer = UITapGestureRecognizer()
//    var hideMeshRecognizer = UITapGestureRecognizer()
//    
//    // Cache for 3D text geometries representing the classification values.
//    var modelsForClassification: [ARMeshClassification: ModelEntity] = [:]
//    
//    var videoNode: VideoNodeSK?
//    var videoPlayerCreated = false
//    
//    var showFeaturePoints = false
//    var placementType: ARHitTestResult.ResultType = .featurePoint
//    
//    var focusEntity: FocusEntity?
//    private var modelManager: ModelManager = ModelManager()
//    
//    var configuration = ARWorldTrackingConfiguration()
//    
//    var multipeerHelp: MultipeerHelper!
//
//    
//   // private var loadedMetaData: LibPlacenote.MapMetadata = LibPlacenote.MapMetadata()
//      
//    var selectedObject: VirtualObject?
//    static var selectedEntityName = ""
//    static var selectedEntityID = ""
//    var currentConnectedNetwork = "TR5GY49mciaf42wUc8pZ"
//    var selectedEntity: ModelEntity?
//    var selectedAnchor: AnchorEntity?
//    
//      var selectedNode: SCNNode?
//
//      /// The object that is tracked for use by the pan and rotation gestures.
//      var trackedObject: VirtualObject? {
//          didSet {
//              guard trackedObject != nil else { return }
//              selectedObject = trackedObject
//          }
//      }
//    
//    
//    
//    var didTap: Bool?
//    
//    var networkBtnImg = UIImage(named: "network")
//    
//    private var modelCollectionView : UICollectionView!
//    
//    
//    /// Whether the "Access WiFi Information" capability is enabled.
//    /// If available, the MAC address of the connected Wi-Fi access point can be used
//    /// to help find nearby anchors.
//    /// Note: This entitlement requires a paid Apple Developer account.
//    private static let haveAccessWifiInformationEntitlement = false
//
//    /// Whitelist of Bluetooth-LE beacons used to find anchors and improve the locatability
//    /// of existing anchors.
//    /// Add the UUIDs for your own Bluetooth beacons here to use them with Azure Spatial Anchors.
//    public static let knownBluetoothProximityUuids = [
//        "61687109-905f-4436-91f8-e602f514c96d",
//        "e1f54e02-1e23-44e0-9c3d-512eb56adec9",
//        "01234567-8901-2345-6789-012345678903",
//    ]
//
//    var locationProvider: ASAPlatformLocationProvider?
//
//    var nearDeviceWatcher: ASACloudSpatialAnchorWatcher?
//    var numAnchorsFound = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupAudioSession()
//        checkCameraAccess()
//        setupNewUI()
//     //   scanningUI()
//        let defaults = UserDefaults.standard
//        defaults.set(false, forKey: "isCreatingNetwork")
//        defaults.set(false, forKey: "connectToNetwork")
//        defaults.set("", forKey: "modelUid")
//        guard ARWorldTrackingConfiguration.isSupported else {
//            fatalError("""
//                ARKit is not available on this device. For apps that require ARKit
//                for core functionality, use the `arkit` key in the key in the
//                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
//                the app from installing. (If the app can't be installed, this error
//                can't be triggered in a production scenario.)
//                In apps where AR is an additive feature, use `isSupported` to
//                determine whether to show UI for launching AR experiences.
//            """) // For details, see https://developer.apple.com/documentation/arkit
//        }
//        //  multipeerSession = MultipeerSession(receivedDataHandler: receivedData)
//        
//        multipeerSession = MultipeerSession(receivedDataHandler: receivedData, peerJoinedHandler:
//                                                peerJoined, peerLeftHandler: peerLeft, peerDiscoveredHandler: peerDiscovered)
//        
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(down))
//        swipeDown.direction = .down
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(up))
//        swipeUp.direction = .up
//        
//        sceneView.addGestureRecognizer(swipeDown)
//        sceneView.addGestureRecognizer(swipeUp)
//        
//        imagePicker.delegate = self
//        
//        networkBtn.setImage(UIImage(systemName: "network"), for: .normal)
//        profileButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
//        videoBtn.layer.cornerRadius = 22.5
//        //  backImg.layer.borderWidth = 1
//        // backImg.layer.borderColor = UIColor.lightGray.cgColor
//        videoBtn.layer.shadowRadius = 4
//        videoBtn.layer.shadowOpacity = 0.95
//        videoBtn.layer.shadowColor = UIColor.black.cgColor
//        //note.view?.layer.cornerRadius = 5
//        videoBtn.layer.masksToBounds = false
//        videoBtn.layer.shadowOffset = CGSize(width: 0, height: 3.0)
//        
//        //   wordsBtn.layer.cornerRadius = 19
//        //  backImg.layer.borderWidth = 1
//        // backImg.layer.borderColor = UIColor.lightGray.cgColor
//        wordsBtn.layer.shadowRadius = 4
//        wordsBtn.layer.shadowOpacity = 0.95
//        wordsBtn.layer.shadowColor = UIColor.black.cgColor
//        //note.view?.layer.cornerRadius = 5
//        wordsBtn.layer.masksToBounds = false
//        wordsBtn.layer.shadowOffset = CGSize(width: 0, height: 3.0)
//        
//        categoryScrollView.layer.shadowRadius = 1
//        categoryScrollView.layer.shadowOpacity = 0.95
//        categoryScrollView.layer.shadowColor = UIColor.systemGray5.cgColor
//        //note.view?.layer.cornerRadius = 5
//        categoryScrollView.layer.masksToBounds = false
//        categoryScrollView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
//        categoryScrollView.backgroundColor = .white
//        //  categoryScrollView.alpha = 0.90
//        
//        tableViewHeight.constant = (UIScreen.main.bounds.height - 169)
//        
//        animalsCategoryBtn.titleLabel?.text = "Animals & Pets"
//        animalsCategoryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
//        animalsCategoryBtn.contentMode = .center
//        animalsCategoryBtn.imageView?.contentMode = .scaleAspectFit
//        
//        feedbackControl = addFeedbackButton()
//        feedbackControl.backgroundColor = .clear
//        feedbackControl.setTitleColor(.yellow, for: .normal)
//        feedbackControl.contentHorizontalAlignment = .left
//       // feedbackControl.isHidden = true
//        
//        layoutButtons()
//        
//        let objectInfoCancelAction = UITapGestureRecognizer(target: self, action: #selector(objectInfoCancel(_:)))
//        objectInfoViewCancelBtn.titleLabel?.textColor = .darkGray
//        objectInfoViewCancelBtn.addGestureRecognizer(objectInfoCancelAction)
//        
//        let objectInfoViewAction = UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:)))
//        objectInfoView.addGestureRecognizer(objectInfoViewAction)
//        
//        progressView = UIView(frame: CGRect(x: 0, y: 95, width: UIScreen.main.bounds.width, height: 30))
//        progressView?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.90)
//
//        progressBar = UIProgressView(frame: CGRect(x: 20, y: 13, width: UIScreen.main.bounds.width - 40, height: 10))
//     //   progressBar?.heightAnchor = 25
//        progressBar?.progressViewStyle = .default
//        progressBar?.progressTintColor = .systemGreen
//        progressBar?.autoresizesSubviews = true
//        progressBar?.clearsContextBeforeDrawing = true
//        
//        progressView?.addSubview(progressBar!)
//     //   sceneView.addSubview(progressView!)
//        anchorSettingsImg.isHidden = true
//       // self.progressView?.isHidden = true
//        
//        let supportLiDAR = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
//        guard supportLiDAR else {
//            print("LiDAR isn't supported here")
//            setup()
//            browseTableView.delegate = self
//            browseTableView.dataSource = self
//            browseTableView.register(ModelTableViewCell.self, forCellReuseIdentifier: ModelTableViewCell.reuseID)
//            if UITraitCollection.current.userInterfaceStyle == .light {
//                browseTableView.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 244/255, alpha: 1.0)
//                //topview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.90)
//            } else {
//                browseTableView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
//                searchField.overrideUserInterfaceStyle = .light
//            }
//            updateWalkthrough()
//            return
//        }
//        //        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) else {
//        //            fatalError("""
//        //                Scene reconstruction requires a device with a LiDAR Scanner, such as the 4th-Gen iPad Pro.
//        //            """)
//        //        }
//        setupLidar()
//        
//        startSession()
//   //     browseTableView.delegate = self
//    //    browseTableView.dataSource = self
//        if UITraitCollection.current.userInterfaceStyle == .light {
//          //  browseTableView.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 244/255, alpha: 1.0)
//            //topview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.90)
//        } else {
//         //   browseTableView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
//            searchField.overrideUserInterfaceStyle = .light
//            //  searchField.alpha = 1.0
//        }
//      //  browseTableView.register(BrowseTableViewCell.self, forCellReuseIdentifier: "BrowseTableViewCell")
//     //   attachLocationProviderToSession()
//        updateWalkthrough()
//        //   let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchAction(_:)))
//        let searchTap = UITapGestureRecognizer(target: self, action: #selector(editAlert))
//        addButton.layer.cornerRadius = 26
//        let largeConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .bold, scale: .large)
//        //   let largeBoldDoc = UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig)
//        let largeBoldDoc = UIImage(systemName: "plus", withConfiguration: largeConfig)
//        addButton.setImage(largeBoldDoc, for: .normal)
//        addButton.backgroundColor = UIColor.systemBlue
//        addButton.tintColor = .white
//        addButton.layer.shadowRadius = 4
//        addButton.layer.shadowOpacity = 0.95
//        addButton.layer.shadowColor = UIColor.black.cgColor
//        //note.view?.layer.cornerRadius = 5
//        addButton.layer.masksToBounds = false
//        addButton.layer.shadowOffset = CGSize(width: 0, height: 3.3)
//        if Auth.auth().currentUser?.uid != nil {
//            sceneView.addSubview(addButton)
//        }
//        addButton.addGestureRecognizer(searchTap)
//        
//        sceneInfoButton.clipsToBounds = true
//        sceneInfoButton.layer.cornerRadius = 4
//        sceneInfoButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
//        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
//        
//        anchorUserImg.layer.borderColor = UIColor.white.cgColor
//        anchorUserImg.layer.borderWidth = 0.8
//   
//        let likeAction = UITapGestureRecognizer(target: self, action: #selector(like))
//        heartImg.isUserInteractionEnabled = true
//        heartImg.addGestureRecognizer(likeAction)
//        
////        self.db.collection("models").getDocuments { (snapshot, err) in
////            if let err = err {
////                print("Error getting documents: \(err)")
////            } else {
////                for document in snapshot!.documents {
////                    let docId = document.documentID
////                    if document.get("productLink") == nil {
////                        let docRef = self.db.collection("models").document(docId)
////                        docRef.updateData([
////                            "productLink": ""
////                        ])
////
////                    }}}
////        }
//        
//   //     self.lookForAnchorsNearDevice()
//    }
//    
//    let walkthroughLabel = UILabel(frame: CGRect(x: 25, y: 550, width: UIScreen.main.bounds.width - 50, height: 80))
//    let circle =  UIView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 25, y: UIScreen.main.bounds.height - 151, width: 50, height: 50)) // UIView(frame: CGRect(x: 9, y: 45, width: 50, height: 50))
//
//    private func setupAudioSession() {
//            //enable other applications music to play while quizView
//            let options = AVAudioSession.CategoryOptions.mixWithOthers
//            let mode = AVAudioSession.Mode.default
//            let category = AVAudioSession.Category.playback
//            try? AVAudioSession.sharedInstance().setCategory(category, mode: mode, options: options)
//            //---------------------------------------------------------------------------------
//            try? AVAudioSession.sharedInstance().setActive(true)
//        }
//    
//    var continueWalkthroughButton = UIButton()
//    var continueNetworkWalkthroughButton = UIButton()
//    
//    func setupNewUI(){
//     //   //topview.isHidden = true
//        addButton.isHidden = true
//        if defaults.bool(forKey: "finishedWalkthrough") == false{
//            self.buttonStackViewBottomConstraint.constant = -140
//            self.continueWalkthroughButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: 5, width: 110, height: 35))
//            self.continueWalkthroughButton.backgroundColor = .systemBlue// UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
//            self.continueWalkthroughButton.setTitle("Continue", for: .normal)
//            self.continueWalkthroughButton.setTitleColor(.white, for: .normal)
//            self.continueWalkthroughButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//            self.continueWalkthroughButton.layer.cornerRadius = 6
//            self.continueWalkthroughButton.clipsToBounds = true
//            self.continueWalkthroughButton.isUserInteractionEnabled = true
//            self.continueWalkthroughButton.addTarget(self, action: #selector(continueWalkthrough), for: .touchUpInside)
//          //  self.view.addSubview(self.continueWalkthroughButton)
//        }
//        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchUI))
//        searchImgView.addGestureRecognizer(searchTap)
//        
//        let profileTap = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile))
//        profileImgView.addGestureRecognizer(profileTap)
//        
//        let networkTap = UITapGestureRecognizer(target: self, action: #selector(editAlert))
//        addImgView.addGestureRecognizer(networkTap)
//        
//        let createTap = UITapGestureRecognizer(target: self, action: #selector(goToComposeArtwork))
//        composeImgView.addGestureRecognizer(createTap)
//    }
//    
//    
//    
//    func setupCollectionView(){
//        /// collectionView
////        let layout = UICollectionViewFlowLayout()
////        layout.scrollDirection = .horizontal
////        let collectionFrame = CGRect(x: 0, y: 140, width: view.frame.width, height: 375)
////        modelCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
////        modelCollectionView.delegate = self
////        modelCollectionView.dataSource = self
////        modelCollectionView.backgroundColor = .systemBackground
////      //  modelCollectionView.showsHorizontalScrollIndicator = false
////        modelCollectionView.register(ModelCollectionViewCell.self, forCellWithReuseIdentifier: ModelCollectionViewCell.reuseID)
////
////
////        /// addSubviews
////        view.addSubview(modelCollectionView)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        layoutButtons()
//    }
//    
//    @objc func appMovedToBackground() {
//        print("App moved to background!")
//        if Auth.auth().currentUser?.uid != nil {
//            FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
//                if user?.currentConnectedNetworkID != "" || user?.currentConnectedNetworkID != nil {
//                    let docRef = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
//                    docRef.updateData([
//                        "currentConnectedNetworkID": ""
//                    ])
//                }
//            }
//        }
//        for id in currentSessionAnchorIDs {
//            let docRef = self.db.collection("sessionAnchors").document(id)
//            docRef.delete()
//
//        }
//        self.sceneView.scene.anchors.removeAll()
//        if self.videoPlayer != nil && self.videoPlayer.rate != 0 {
//            self.videoPlayer.pause()
//        }
//        
//        self.entityName.removeFromSuperview()
//        self.entityProfileBtn.removeFromSuperview()
//        self.buttonStackView.isHidden = false
//        self.anchorUserImg.isHidden = true
//        self.anchorInfoStackView.isHidden = true
//        self.anchorSettingsImg.isHidden = true
//        self.placementStackView.isHidden = true
//        self.entityName.isHidden = true
//        self.entityProfileBtn.isHidden = true
//        self.wordsBtn.isHidden = false
//        self.videoBtn.isHidden = false
//        self.networkBtn.isHidden = false
//        self.networksNear()
//        self.focusEntity = FocusEntity(on: sceneView, focus: .classic)
//    }
//    
//    func updateWalkthrough(){
//        if defaults.bool(forKey: "finishedWalkthrough") == false {
////            addImgView
////            searchImgView
//            buttonStackView.isUserInteractionEnabled = false
//            videoBtn.isUserInteractionEnabled = false
//            wordsBtn.isUserInteractionEnabled = false
//            networkBtn.isUserInteractionEnabled = false
//            walkthroughView.isHidden = false
//            placementStackBottomConstraint.constant = 55
//            saveButtonBottomConstraint.constant = -5
//            
//            walkthroughLabel.backgroundColor = .systemBlue
//            walkthroughLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//            walkthroughLabel.textColor = .white
//            walkthroughLabel.text = "Scan your surroundings so that the yellow focus square can rest on a horizontal or vertical surface (floor, door, wall, etc.)"
//            walkthroughLabel.numberOfLines = 3
//            walkthroughLabel.clipsToBounds = true
//            walkthroughLabel.textAlignment = .center
//            walkthroughLabel.layer.cornerRadius = 8
//            sceneView.addSubview(walkthroughLabel)
//            
//            circle.backgroundColor = .clear
//            circle.layer.cornerRadius = 25
//            circle.clipsToBounds = true
//            circle.layer.borderColor = UIColor.systemBlue.cgColor
//            circle.layer.borderWidth = 4
//            circle.isUserInteractionEnabled = false
//            circle.alpha = 1.0
//                // sceneView.addSubview(circle)
//            
//            let defaults = UserDefaults.standard
//            defaults.set(true, forKey: "first")
//            
//            let delay = 9
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//               // //self.topView.addSubview(self.circle)
//                self.view.addSubview(self.circle)
//                self.walkthroughView.addSubview(self.continueWalkthroughButton)
////                self.walkthroughViewLabel.text = "2 of 18"
//                self.walkthroughViewLabel.text = "2 of 8"
//                self.walkthroughLabel.frame = CGRect(x: 50, y: 140, width: UIScreen.main.bounds.width - 100, height: 80)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "To find and place digital assets on Blueprint's Marketplace, tap the search icon."
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//
//            }
//
//            
//            if focusEntity?.onPlane == true{
//                print("on plane")
//            }
//        } else {
//            return
//        }
//        
//    }
//    
//    var currentSessionAnchorIDs = [String]()
//    var continueTaps = 0
//    var continueNetworkTaps = 0
//    
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
//                self.walkthroughViewLabel.text = "3 of 8"
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
//                self.walkthroughViewLabel.text = "4 of 8"
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
//                self.walkthroughViewLabel.text = "6 of 8"
//                self.walkthroughLabel.frame = CGRect(x: 60, y: 500, width: UIScreen.main.bounds.width - 120, height: 55)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "To add messages or text to a location, click to ABC button."
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width - 72), y: 125, width: 50, height: 50)
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
//            else if self.continueTaps == 5 {
//                defaults.set(true, forKey: "newSixth")
//                
//                self.walkthroughViewLabel.text = "7 of 8"
//            //    self.continueWalkthroughButton.setTitle("Finish", for: .normal)
//                self.walkthroughLabel.frame = CGRect(x: 60, y: 500, width: UIScreen.main.bounds.width - 120, height: 55)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "To add photos or videos to a location, click to video button."
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
//                self.walkthroughViewLabel.text = "8 of 8"
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
//    
//    @objc func continueNetworkWalkthrough(){
//        continueNetworkTaps += 1
//        let defaults = UserDefaults.standard
//        if defaults.bool(forKey: "finishedNetworkWalkthrough") == false {
//            if self.continueNetworkTaps == 1 {
//                defaults.set(true, forKey: "networkFirst")
//                self.walkthroughViewLabel.text = "2 of 4"
//                self.walkthroughLabel.frame = CGRect(x: 35, y: 365, width: UIScreen.main.bounds.width - 70, height: 85)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "Name the Network, this is what all Blueprint user’s will see when near - this can be changed later."
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 108, y: UIScreen.main.bounds.height - 151, width: 50, height: 50)
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
//
//            }
//            
//            else if self.continueNetworkTaps == 2 {
//                defaults.set(true, forKey: "networkSecond")
//                self.walkthroughViewLabel.text = "3 of 4"
//                self.walkthroughLabel.frame = CGRect(x: 40, y: 300, width: UIScreen.main.bounds.width - 80, height: 90)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "Click the search icon to find any content on Blueprint’s Marketplace you want to place and save to your newly created Network."
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
//            else if self.continueNetworkTaps == 3 {
//                defaults.set(true, forKey: "networkThird")
//                self.walkthroughViewLabel.text = "4 of 4"
//                self.walkthroughLabel.frame = CGRect(x: 35, y: 400, width: UIScreen.main.bounds.width - 70, height: 100)
//                self.walkthroughLabel.numberOfLines = 0
//                self.continueNetworkWalkthroughButton.setTitle("Finish", for: .normal)
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "Once you’ve finished editing your Network - click 'Done' and everything will save in place. Any Blueprint user will be able to expeirence your Network!"
//                circle.frame = CGRect(x: (UIScreen.main.bounds.width - 73), y: 68, width: 50, height: 50)
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
//            else if self.continueNetworkTaps == 4 {
//                defaults.set(true, forKey: "networkFourth")
//                defaults.set(true, forKey: "finishedNetworkWalkthrough") //networkThird
//                self.walkthroughView.removeFromSuperview()
//                self.circle.removeFromSuperview()
//                self.walkthroughLabel.removeFromSuperview()
//                self.buttonStackView.isUserInteractionEnabled = true
//                self.videoBtn.isUserInteractionEnabled = true
//                self.wordsBtn.isUserInteractionEnabled = true
//                self.networkBtn.isUserInteractionEnabled = true
//                self.buttonStackViewBottomConstraint.constant = -87
//            }
//        }
//        
//    }
//    
//    var needLocationView = UIView()
//    
//    func setup(){
//        
//        sceneView.session.delegate = self
//        
//       // sceneView.session.delegate = Coordinator
//        
//        setupCoachingOverlay()
//        
//        focusEntity = FocusEntity(on: sceneView, focus: .classic)
//        
//     //   sceneView.environment.sceneUnderstanding.options = []
//        
//      //  networkBtnImg?.image = UIImage(named: "guitarpbr")
//       // arView.environment.lighting.
//        entityProfileBtn.isUserInteractionEnabled = false
//        entityProfileBtn.isHidden = true
//        // Turn on occlusion from the scene reconstruction's mesh.
//     //   sceneView.environment.sceneUnderstanding.options.insert(.occlusion)
//        
//        // Turn on physics for the scene reconstruction's mesh.
//  //      sceneView.environment.sceneUnderstanding.options.insert(.physics)
//        
//    //    sceneView.environment.sceneUnderstanding.options.insert(.receivesLighting)
//        
//    //    sceneView.environment.sceneUnderstanding.options.insert(.collision)
//
//        // Display a debug visualization of the mesh.
//      //  sceneView.debugOptions.insert(.showSceneUnderstanding)
//       
//        // Manually configure what kind of AR session to run since
//        // ARView on its own does not turn on mesh classification.
//   //     sceneView.automaticallyConfigureSession = false
//        configuration.planeDetection = [.horizontal, .vertical]
//      //  configuration.sceneReconstruction = .mesh
//        configuration.isCollaborationEnabled = true
//      //  configuration.frameSemantics.insert(.personSegmentationWithDepth)
//      //  configuration.environmentTexturing = .automatic
//        sceneView.session.run(configuration)
//        holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
//        holdGesture.delegate = self
//        sceneView.addGestureRecognizer(holdGesture)
//        
//        profileRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:)))
//        profileRecognizer.delegate = self
//    //    entityProfileBtn.addGestureRecognizer(profileRecognizer)
//        
//        shareRecognizer = UITapGestureRecognizer(target: self, action: #selector(share(_:)))
//        shareRecognizer.delegate = self
//        shareImg.addGestureRecognizer(shareRecognizer)
//        // Do any additional setup after loading the view.
//        
//        
//        hideMeshRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideMesh(_:)))
//        hideMeshRecognizer.delegate = self
//        toggleBtn.addGestureRecognizer(hideMeshRecognizer)
//        
////        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(hideUI(_:)))
////        doubleTap.numberOfTapsRequired = 2
////        doubleTap.delegate = self
//     //   sceneView.addGestureRecognizer(doubleTap)
//        if defaults.bool(forKey: "headsUp") == false {
//            needLocationView = UIView(frame: CGRect(x: 58, y: 313, width: 274, height: 194))
//            needLocationView.backgroundColor = .white
//            needLocationView.clipsToBounds = true
//            needLocationView.layer.cornerRadius = 14
//            let titleLabel = UILabel(frame: CGRect(x: 85.67, y: 21, width: 103, height: 28))
//            titleLabel.text = "Heads Up!"
//            titleLabel.textColor = .black
//            titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
//            let titleUnderView = UIView(frame: CGRect(x: 92, y: 59, width: 90, height: 1))
//            titleUnderView.backgroundColor = .systemGray4
//            let messageLabel = UILabel(frame: CGRect(x: 15, y: 68, width: 244, height: 56))
//            messageLabel.numberOfLines = 3
//            messageLabel.textColor = .darkGray
//            messageLabel.textAlignment = .center
//            messageLabel.text = "Blueprint is better with LiDAR! This phone model does not support this feature, but you can still use the app."
//            messageLabel.font = UIFont.systemFont(ofSize: 14)
//            let settingsButton = UIButton(frame: CGRect(x: 57, y: 139, width: 160, height: 40))
//            settingsButton.clipsToBounds = true
//            settingsButton.layer.cornerRadius = 20
//            settingsButton.backgroundColor = UIColor(red: 69/255, green: 65/255, blue: 78/255, alpha: 1.0)
//            settingsButton.setTitle("OK", for: .normal)
//            settingsButton.setTitleColor(.white, for: .normal)
//            settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//            settingsButton.addTarget(self, action: #selector(self.headsUp), for: .touchUpInside)
//            needLocationView.addSubview(titleLabel)
//            needLocationView.addSubview(titleUnderView)
//            needLocationView.addSubview(messageLabel)
//            needLocationView.addSubview(settingsButton)
//            self.view.addSubview(needLocationView)
//            //self.topView.isUserInteractionEnabled = false
//            self.addButton.isUserInteractionEnabled = false
//            self.videoBtn.isUserInteractionEnabled = false
//            self.wordsBtn.isUserInteractionEnabled = false
//            self.walkthroughView.isUserInteractionEnabled = false
//            self.sceneView.isUserInteractionEnabled = false
//            self.buttonStackView.isUserInteractionEnabled = false
//            self.networkBtn.isUserInteractionEnabled = false
//        }
//    }
//    
//    @objc func headsUp(){
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: "headsUp")
//        self.needLocationView.removeFromSuperview()
//        //self.topView.isUserInteractionEnabled = true
//        self.addButton.isUserInteractionEnabled = true
//        self.videoBtn.isUserInteractionEnabled = true
//        self.wordsBtn.isUserInteractionEnabled = true
//        self.walkthroughView.isUserInteractionEnabled = true
//        self.sceneView.isUserInteractionEnabled = true
//        self.buttonStackView.isUserInteractionEnabled = true
//        self.networkBtn.isUserInteractionEnabled = true
//    }
//
//    var holdGesture = UILongPressGestureRecognizer()
//  
//    static private let auth = Auth.auth()
//    
//    func setupLidar(){
//        sceneView.session.delegate = self
//        
//        setupCoachingOverlay()
//        
//        focusEntity = FocusEntity(on: sceneView, focus: .classic)
//        
//        sceneView.environment.sceneUnderstanding.options = []
//        
//      //  networkBtnImg?.image = UIImage(named: "guitarpbr")
//       // arView.environment.lighting.
//        entityProfileBtn.isUserInteractionEnabled = false
//        entityProfileBtn.isHidden = true
//        // Turn on occlusion from the scene reconstruction's mesh.
//        sceneView.environment.sceneUnderstanding.options.insert(.occlusion)
//        
//        // Turn on physics for the scene reconstruction's mesh.
//        sceneView.environment.sceneUnderstanding.options.insert(.physics)
//        
//        sceneView.environment.sceneUnderstanding.options.insert(.receivesLighting)
//        
//        sceneView.environment.sceneUnderstanding.options.insert(.collision)
//
//        // Display a debug visualization of the mesh.
//      //  sceneView.debugOptions.insert(.showSceneUnderstanding)
//       
//        // Manually configure what kind of AR session to run since
//        // ARView on its own does not turn on mesh classification.
//        sceneView.automaticallyConfigureSession = false
//        configuration.planeDetection = [.horizontal, .vertical]
//        configuration.sceneReconstruction = .meshWithClassification
//        configuration.isCollaborationEnabled = true
//        configuration.frameSemantics.insert(.personSegmentationWithDepth)
//        configuration.environmentTexturing = .automatic
//        sceneView.session.run(configuration)
//        
//        // NEW
//        
//        setupMultipeer()
//
//        searchField.delegate = self
//        searchField.tag = 0
//        
//        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
//        UIApplication.shared.isIdleTimerDisabled = true
//        
//        holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
//        holdGesture.delegate = self
//        sceneView.addGestureRecognizer(holdGesture)
//        
//        profileRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:)))
//        profileRecognizer.delegate = self
//    //    entityProfileBtn.addGestureRecognizer(profileRecognizer)
//        
//        shareRecognizer = UITapGestureRecognizer(target: self, action: #selector(share(_:)))
//        shareRecognizer.delegate = self
////        shareImg.addGestureRecognizer(shareRecognizer)
//        // Do any additional setup after loading the view.
//        
//        
//        hideMeshRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideMesh(_:)))
//        hideMeshRecognizer.delegate = self
//        toggleBtn.addGestureRecognizer(hideMeshRecognizer)
//        
//     //   let doubleTap = UITapGestureRecognizer(target: self, action: #selector(connectedNetworkUI(_:)))
//        doubleTap = UITapGestureRecognizer(target: self, action: #selector(removeAllModels(_:)))
//        doubleTap.numberOfTapsRequired = 2
//        doubleTap.delegate = self
//        sceneView.addGestureRecognizer(doubleTap)
//    }
//    
//    private func layoutButtons() {
//      //  layoutButton(mainButton, top: Double(sceneView.bounds.size.height - 80), lines: Double(1.0))
//       // layoutButton(backButton, top: 20, lines: 1)
//        layoutButton(feedbackControl, top: Double(sceneView.bounds.size.height - 45), lines: Double(1.0))
//     //   layoutButton(errorControl, top: Double(sceneView.bounds.size.height - 400), lines: Double(5.0))
//    }
//
//    private func layoutButton(_ button: UIButton, top: Double, lines: Double) {
//        let wideSize = sceneView.bounds.size.width - 20.0
//        button.frame = CGRect(x: 10.0, y: top, width: Double(wideSize), height: lines * 40)
//        if (lines > 1) {
//            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
//        }
//    }
//    
//     func onCloudAnchorCreated() { //override
//        ignoreMainButtonTaps = false
//        step = .lookForNearbyAnchors
//
//        DispatchQueue.main.async {
//       //     self.feedbackControl.isHidden = true
//            print("Tap to start next Session & look for anchors near device")
//        }
//    }
//
//    func onNewAnchorLocated(_ cloudAnchor: ASACloudSpatialAnchor) { //override
//        ignoreMainButtonTaps = false
//        step = .stopWatcher
//
//        DispatchQueue.main.async {
//            self.numAnchorsFound += 1
//       //     self.feedbackControl.isHidden = true
//            print("\(self.numAnchorsFound) anchor(s) found! Tap to stop watcher.")
//        }
//    }
//
////    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) { //override
////        super.renderer(renderer, updateAtTime: time)
////
////        DispatchQueue.main.async {
////            self.sensorStatusView.update()
////        }
////    }
//    
//    @objc func searchForContent() { //override
//        if (ignoreMainButtonTaps) {
//            return
//        }
//
//        switch (step) {
//        case .prepare:
//        print("Tap to start Session")
//            step = .createCloudAnchor
//            createLocationProvider()
//        case .createCloudAnchor:
//            ignoreMainButtonTaps = true
//            currentlyPlacingAnchor = true
//            saveCount = 0
//
//        //    startSession()
//            attachLocationProviderToSession()
//
//            // When you tap on the screen, touchesBegan will call createLocalAnchor and create a local ARAnchor.
//            // We will then put that anchor in the anchorVisuals dictionary with a special key and call CreateCloudAnchor when there is enough data for saving.
//            // CreateCloudAnchor will call onCloudAnchorCreated when its async method returns to move to the next step.
//            print("Tap on the screen to create an Anchor ☝️")
//        case .lookForNearbyAnchors:
//            ignoreMainButtonTaps = true
//       //     stopSession()
//       //     startSession()
//            attachLocationProviderToSession()
//
//            // We will get a call to onLocateAnchorsCompleted which will move to the next step when the locate operation completes.
//            lookForAnchorsNearDevice()
//        case .stopWatcher:
//            step = .stopSession
//            nearDeviceWatcher?.stop()
//            nearDeviceWatcher = nil
//            print("Tap to stop Session and return to the main menu")
//        case .stopSession:
//            stopSession()
//            self.locationProvider = nil
//         //   self.sensorStatusView.setModel(nil)
//       //     moveToMainMenu()
//        default:
//            assertionFailure("Demo has somehow entered an invalid state")
//        }
//    }
//    
//    private func createLocationProvider() {
//        locationProvider = ASAPlatformLocationProvider()
//
//        // Register known Bluetooth beacons
//        locationProvider!.sensors!.knownBeaconProximityUuids =
//            LaunchViewController.knownBluetoothProximityUuids
//
//        // Display the sensor status
//        let sensorStatus = LocationProviderSensorStatus(for: locationProvider)
//      //  sensorStatusView.setModel(sensorStatus)
//
//        enableAllowedSensors()
//    }
//    
//    private func enableAllowedSensors() {
//        if let sensors = locationProvider?.sensors {
//            sensors.bluetoothEnabled = true
//            sensors.wifiEnabled = LaunchViewController.haveAccessWifiInformationEntitlement
//            sensors.geoLocationEnabled = true
//        }
//    }
//
//    private func attachLocationProviderToSession() {
//        cloudSession!.locationProvider = locationProvider
//        print("\(String(describing: locationProvider)) is locationProvider")
//    }
//
//    private func lookForAnchorsNearDevice() {
//        let nearDevice = ASANearDeviceCriteria()!
//        nearDevice.distanceInMeters = 10.0
//        nearDevice.maxResultCount = 12
//        let criteria = ASAAnchorLocateCriteria()!
//        criteria.nearDevice = nearDevice
//       // cloudSession.remov
//        nearDeviceWatcher = cloudSession!.createWatcher(criteria)
//
//        print("Looking for anchors near device...")
//        print("\(String(describing: criteria.identifiers)) is criteria ids")
//       // criteria.identifiers
//    }
//    
//    func startSession() {
//        createLocationProvider()
//        
//        
//        cloudSession = ASACloudSpatialAnchorSession()
//        cloudSession!.session = sceneView.session
//        cloudSession!.logLevel = .information
//        cloudSession!.delegate = self
//        cloudSession!.configuration.accountId = spatialAnchorsAccountId
//        cloudSession!.configuration.accountKey = spatialAnchorsAccountKey
//        cloudSession!.configuration.accountDomain = spatialAnchorsAccountDomain
//        cloudSession!.start()
//        
//        feedbackControl.isHidden = false
//     //   errorControl.isHidden = true
//        enoughDataForSaving = false
//        self.attachLocationProviderToSession()
//    }
//    
//    func createLocalAnchor(anchorLocation: simd_float4x4) { //simd_float4x4
//        if (localAnchor == nil) {
//            localAnchor = ARAnchor(transform: anchorLocation)
//            sceneView.session.add(anchor: localAnchor!)
//            
//            // Put the local anchor in the anchorVisuals dictionary with a special key
//            let visual = AnchorVisual()
//            visual.identifier = unsavedAnchorId
//            visual.localAnchor = localAnchor
//            anchorVisuals[visual.identifier] = visual
//            
//            print("Create Cloud Anchor (once at 100%)")
//        }
//    }
//    
//    func createCloudAnchor() {
//        currentlyPlacingAnchor = false
//        DispatchQueue.main.async {
//            print("Cloud Anchor being saved...")
//        }
//        
//        cloudAnchor = ASACloudSpatialAnchor()
//        cloudAnchor!.localAnchor = localAnchor!
//        // Set modelID within app properties, scale, etc.
//        // instead of getting correct model id, should get anchorId that is produced when creating a session Anchor
//        cloudAnchor!.appProperties = ["modelId" : String(self.currentEntity.id)]
//        // In this sample app we delete the cloud anchor explicitly, but you can also set it to expire automatically
//        let secondsInAMonth = 60 * 60 * 24 * 7 * 4
//        let fourWeeksFromNow = Date(timeIntervalSinceNow: TimeInterval(secondsInAMonth))
//        cloudAnchor!.expiration = fourWeeksFromNow
//        
//        cloudSession!.createAnchor(cloudAnchor, withCompletionHandler: { (error: Error?) in
//            if let error = error {
//                DispatchQueue.main.async {
//                    print("Creation failed")
//                   // self.errorControl.isHidden = false
//                  //  self.errorControl.setTitle(error.localizedDescription, for: .normal)
//                    print("\(error.localizedDescription) failed")
//                }
//    //            self.localAnchorCube?.firstMaterial?.diffuse.contents = failedColor
//            }
//            else {
//              //  self.saveCount += 1
//     //           self.localAnchorCube?.firstMaterial?.diffuse.contents = savedColor
//             //   self.targetId = self.cloudAnchor!.identifier
//                let visual = self.anchorVisuals[unsavedAnchorId]
//                visual?.cloudAnchor = self.cloudAnchor
//                visual?.identifier = self.cloudAnchor!.identifier
//                self.anchorVisuals[visual!.identifier] = visual
//                self.anchorVisuals.removeValue(forKey: unsavedAnchorId)
//                self.localAnchor = nil
//                
//             //   self.onCloudAnchorCreated()
//             //   self.lookForAnchorsNearDevice()
////                self.lookForAnchor()
////
////
////                let docRef = self.db.collection("networks").document(self.currentConnectedNetwork)
////
////                docRef.updateData([
////                    "anchorIDs": FieldValue.arrayUnion(["\(self.cloudAnchor!.identifier ?? "")"])
////                ])
//            }
//            })
//        
//    }
//    
//    var networkCreated = false
//    
//    func stopSession() {
//        if let cloudSession = cloudSession {
//            cloudSession.stop()
//            cloudSession.dispose()
//        }
//        
//        cloudAnchor = nil
//        localAnchor = nil
//        cloudSession = nil
//        
//        for visual in anchorVisuals.values {
//            visual.node!.removeFromParentNode()
//        }
//        
//        anchorVisuals.removeAll()
//    }
//    
//    func connectToNetwork(with networkId: String) {
//        let criteria = ASAAnchorLocateCriteria()!
//        self.progressView?.isHidden = false
//        self.feedbackControl?.isHidden = false
//        // if progressBar?.progress ?? 0.0 >= 0.30 {
//        FirestoreManager.getNetwork(networkId) { network in
//            print("\(String(describing: network?.anchorIDs)) is network anchor iDs")
//            criteria.identifiers = network?.anchorIDs //identifiers in network user just connected to
//            self.cloudSession!.createWatcher(criteria)
//            let networkHost = network?.host
//            self.connectedToNetwork = true
//            print("Locating Anchor ...")
//            
//            // let host = networkId
//            FirestoreManager.getUser(networkHost ?? "") { user in
//                let hostPointsRef = self.db.collection("users").document(networkHost ?? "")
//                hostPointsRef.updateData([
//                    "points": FieldValue.increment(Int64(10))
//                ])
//            } //}
//        }}
//    
//    func lookForAnchor() {
//    //    let ids = [targetId!]
////        let criteria = ASAAnchorLocateCriteria()!
////        criteria.identifiers = ids
////        cloudSession!.createWatcher(criteria)
//        
//        //if you want to look for specific anchors (if anchors are tied to a network) - otherwise just use nearby anchors
//        let criteria = ASAAnchorLocateCriteria()!
//        FirestoreManager.getNetwork(currentConnectedNetwork) { network in
//            print("\(String(describing: network?.anchorIDs)) is network anchor iDs")
//           // let ids =
//            criteria.identifiers = network?.anchorIDs //identifiers in network user just connected to
//            self.cloudSession!.createWatcher(criteria)
//          print("Locating Anchor ...")
//        }
//          
//    }
//    
//    func lookForNearbyAnchors() {
//        let criteria = ASAAnchorLocateCriteria()!
//        let nearCriteria = ASANearAnchorCriteria()!
//        nearCriteria.distanceInMeters = 20
//        nearCriteria.sourceAnchor = anchorVisuals[targetId!]!.cloudAnchor
//        criteria.nearAnchor = nearCriteria
//      //  cloudSession?.watch
//        cloudSession!.createWatcher(criteria)
//        print("Locating nearby Anchors ...")
//    }
//    
//    func deleteFoundAnchors() {
//        if (anchorVisuals.count == 0) {
//            print("Anchor not found yet")
//            return
//        }
//        
//        print("Deleting found Anchor(s) ...")
//
//        for visual in anchorVisuals.values {
//            if let visualCloudAnchor = visual.cloudAnchor {
//                cloudSession!.delete(visualCloudAnchor, withCompletionHandler: { (error: Error?) in
//                    self.ignoreMainButtonTaps = false
//                    self.saveCount -= 1
//                    
//                    if let error = error {
//                        visual.node?.geometry?.firstMaterial?.diffuse.contents = failedColor
//                        DispatchQueue.main.async {
//                          //  self.errorControl.isHidden = false
//                          //  self.errorControl.setTitle(error.localizedDescription, for: .normal)
//                        }
//                    }
//                    else {
//                        visual.node?.geometry?.firstMaterial?.diffuse.contents = deletedColor
//                    }
//                    
//                    if (self.saveCount == 0) {
//                        self.step = .stopSession
//                        DispatchQueue.main.async {
//                            print("Cloud Anchor(s) deleted. Tap to stop Session")
//                        }
//                    }
//                })
//            }
//        }
//    }
//    
//    // MARK: - ASACloudSpatialAnchorSession Delegates
//    
//    internal func onLogDebug(_ cloudSpatialAnchorSession: ASACloudSpatialAnchorSession!, _ args: ASAOnLogDebugEventArgs!) {
//        if let message = args.message {
//            print(message)
//        }
//    }
//    
//    internal func anchorLocated(_ cloudSpatialAnchorSession: ASACloudSpatialAnchorSession!, _ args: ASAAnchorLocatedEventArgs!) {
//        let status = args.status
//        print("\(status) is status")
//        switch (status) {
//        case .alreadyTracked:
//            // Ignore if we were already handling this.
//            break
//        case .located:
//            let anchor = args.anchor!
//            print("Cloud Anchor found! Identifier: \(anchor.identifier ?? ""). Location: \(LaunchViewController.matrixToString(value: anchor.localAnchor.transform))")
//            let visual = AnchorVisual()
//            visual.cloudAnchor = anchor
//            visual.identifier = anchor.identifier
//            visual.localAnchor = anchor.localAnchor
//            anchorVisuals[visual.identifier] = visual
//            cloudSession?.getAnchorProperties(anchor.identifier ?? "", withCompletionHandler: { (anchor: ASACloudSpatialAnchor?, error:Error?) in
//                    if (error != nil) {
//                     //   feedback = "Getting Properties Failed:\(error!.localizedDescription)"
//                        print("Getting Properties Failed:\(error!.localizedDescription)")
//                    }
//                
//                print("\(String(describing: anchor?.appProperties)) is anchor app props")
//                print("\(anchor?.appProperties["modelId"] ?? "") is anchor app props modelid")
//                DispatchQueue.main.async {
//                    let anchorModelID = anchor?.appProperties["modelId"] ?? ""
//                    if anchor?.appProperties["modelId"] != nil && anchor?.appProperties["modelId"] as! String != "" && anchor?.appProperties["modelId"] as! String != " " {
//                        FirestoreManager.getModel(anchorModelID as! String) { model in
//                            let modelName = model?.modelName
//                            print("\(modelName ?? "") is model name")
//                            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")") { localUrl in
//                                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                                    switch loadCompletion {
//                                    case.failure(let error): print("Unable to load modelEntity for \(modelName ?? ""). Error: \(error.localizedDescription)")
//                                        //  handler(false, error)
//                                    case.finished:
//                                        break
//                                    }
//                                }, receiveValue: { modelEntity in
//                                    self.currentEntity.accessibilityDescription = self.modelId1
//                                    //   print("\(self.currentEntity.accessibilityDescription.id) is model")
//                                    //      self.currentEntity.id = modelEntity.id
//                                    
//                                    let box = self.currentEntity.visualBounds(recursive: true, relativeTo: self.currentEntity, excludeInactive: true)
//                                    //sceneView.addSubview(box)
//                                    self.currentEntity.name = "\(model?.name ?? "")"
//                                    print(self.currentEntity)
//                                    self.currentEntity.generateCollisionShapes(recursive: true)
//                                    let physics = PhysicsBodyComponent(massProperties: .default,
//                                                                       material: .default,
//                                                                       mode: .dynamic)
//                                    //   modelEntity.components.set(physics)
//                                    self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//                                    let anchorEntity = AnchorEntity(world: (anchor?.localAnchor.transform)!)  //anchor.localAnchor.transform
//                                    print(anchor?.localAnchor.transform)
//                                    print(anchorEntity as Any)
//                                    // anchorEntity?.visualBounds(relativeTo: s)
//                                    anchorEntity.addChild(self.currentEntity)
//                                    //    anchorEntity?.anchoring = AnchoringComponent(self.anchorPlaced!)
//                                    let scale = model?.scale
//                                    print("\(scale) is scale")
//                                    //    anchorEntity?.anchoring = AnchoringComponent(self.anchorPlaced!)
//                                    self.currentEntity.scale = [Float(scale ?? 0.01), Float(scale ?? 0.01), Float(scale ?? 0.01)]
//                                    self.sceneView.scene.addAnchor(anchorEntity)
//                                    //                                print("modelEntity for \(modelName) has been loaded.")
//                                    //                                ProgressHUD.dismiss()
//                                    //                                self.removeCloseButton()
//                                    //                                // print("modelEntity for \(self.name) has been loaded.")
//                                    //                                self.modelPlacementUI()
//                                })
//                            }}
//                    }}
//                })
//            sceneView.session.add(anchor: anchor.localAnchor)
//            onNewAnchorLocated(anchor)
//        case .notLocatedAnchorDoesNotExist:
//            break
//        case .notLocated:
//            break
//        }
//    }
//    
//    func onLocateAnchorsCompleted() { }
//    
//    internal func locateAnchorsCompleted(_ cloudSpatialAnchorSession: ASACloudSpatialAnchorSession!, _ args: ASALocateAnchorsCompletedEventArgs!) {
//        print("Anchor locate operation completed completed for watcher with identifier: \(args.watcher!.identifier)")
//        onLocateAnchorsCompleted()
//    }
//    
//    var feedbackControl: UIButton!
//    
//    
//    internal func sessionUpdated(_ cloudSpatialAnchorSession: ASACloudSpatialAnchorSession!, _ args: ASASessionUpdatedEventArgs!) {
//        let status = args.status!
//        let message = statusToString(status: status)
//        enoughDataForSaving = status.recommendedForCreateProgress >= 1.0
//        print("\(status.recommendedForCreateProgress) is status.recommendedForCreateProgress")
//        print("\(enoughDataForSaving) is enoughdataforsaving")
//        showLogMessage(text: message, here: feedbackControl)
//        print("\(message) is message")
//     //   self.updateUserLocation()
//    }
//    
//    func addFeedbackButton() -> UIButton {
//        let result = UIButton(type: .system)
//        result.setTitleColor(.black, for: .normal)
//        result.setTitleShadowColor(.white, for: .normal)
//        result.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
//        sceneView.addSubview(result)
//        return result
//    }
//    
//    func showLogMessage(text: String, here: UIView!) {
//        let button = here as? UIButton
//        let textField = here as? UITextField
//        
//        DispatchQueue.main.async {
//            button?.setTitle(text, for: .normal)
//            textField?.text = text
//        }
//    }
//    
//    func scanNetworkUI(){
//        previewButton.isHidden = true
//        progressView?.isHidden = false
//        feedbackControl.isHidden = false
//        //topview.isUserInteractionEnabled = false
//    }
//    
//    internal func error (_ cloudSpatialAnchorSession: ASACloudSpatialAnchorSession!, _ args: ASASessionErrorEventArgs!) {
//        if let errorMessage = args.errorMessage {
//            DispatchQueue.main.async {
//           //     self.errorControl.isHidden = false
//            }
//          //  showLogMessage(text: errorMessage, here: errorControl)
//            print("Error code: \(args.errorCode), message: \(errorMessage)")
//        }
//    }
//    
//    static func matrixToString(value: matrix_float4x4) -> String {
//        return String.init(format: "[[%.3f %.3f %.3f %.3f] [%.3f %.3f %.3f %.3f] [%.3f %.3f %.3f %.3f] [%.3f %.3f %.3f %.3f]]",
//                           value.columns.0[0], value.columns.1[0], value.columns.2[0], value.columns.3[0],
//                           value.columns.0[1], value.columns.1[1], value.columns.2[1], value.columns.3[1],
//                           value.columns.0[2], value.columns.1[2], value.columns.2[2], value.columns.3[2],
//                           value.columns.0[3], value.columns.1[3], value.columns.2[3], value.columns.3[3])
//    }
//    
//    func showProgressView(){
//        progressView?.isHidden = false
//    }
//    
//    func statusToString(status: ASASessionStatus) -> String {
//        let feedback = feedbackToString(userFeedback: status.userFeedback)
//        
//      //  if (step == .createCloudAnchor) {
//            let progress = status.recommendedForCreateProgress
//        if progress * 0.7 <= 1 {
//            
//            progressBar?.progress = progress * 0.7
//            progressView1.progress = progress * 0.7
//            scanProgress = Double(progress * 0.7 * 100).rounded(.down)
//            var scanText = String(format: "%.0f", scanProgress)// "\(scanProgress)%"
//            let scanText1 = "%"
//            scanText.append(scanText1)
//            progressLabel.text = scanText
//        } else {
//            self.progressLabel.text = "100%"
//          //  self.scanningLabel = UILabel(frame: CGRect(x: 76.5, y: 52, width: 70, height: 16))
//            self.scanningLabel.text = "Scanned"
//        }
//        print(String.init(format: "%.0f%% progress. %@", progress * 100 * 0.7, feedback))
//        if progress > 1.2 {
//            feedbackControl.setTitleColor(.systemGreen, for: .normal)
//            UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                self.feedbackControl.alpha = 0.0
//            })
//        }
//        if progress * 0.7 > 1.0 && self.networkCreated == false && defaults.bool(forKey: "isCreatingNetwork") == true {
//            self.uploadNetworkAlert()
//            self.networkCreated = true
//        //    return
//        }
//            return String.init(format: "%.0f%% progress. %@", progress * 100 * 0.7, feedback)
//      //  }
//      //  else {
//       //     return feedback
//      //  }
//    }
//    
//    func uploadNetworkAlert() {
//        let alertController = UIAlertController(title: "Upload Network", message: "Create a name for this Blueprint Network. This can be changed later.", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_) in
//            let nameTextField = alertController.textFields![0]
//            let name = (nameTextField.text ?? "").isEmpty ? "My Room" : nameTextField.text!
//            self.networkName = name
//            if name == "" || name == " " || name == "My Room" {
//                self.uploadNetworkAlert()
//            } else {
//                self.uploadNetwork()
//            }
//
//        })
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
//            //self.showAllUI()
//            self.removeScanUI()
//            self.wordsBtn.isHidden = false
//            self.videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//            self.networkBtn.isHidden = false
//            self.networksNearImg.isHidden = false
//            self.feedbackControl.isHidden = true
//        })
//        alertController.addTextField { (textField) in
//            textField.placeholder = "My Room"
//            textField.autocapitalizationType = .sentences
//            //textField.placeholder = "Network Name"
//        }
//        alertController.addAction(saveAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
//        
//    }
//    
//    
//    
//    func feedbackToString(userFeedback: ASASessionUserFeedback) -> String {
//        if (userFeedback == .notEnoughMotion) {
//            print("Not enough motion.")
//            return ("Not enough motion.")
//        }
//        else if (userFeedback == .motionTooQuick) {
//            print("Motion is too quick.")
//            return ("Motion is too quick.")
//        }
//        else if (userFeedback == .notEnoughFeatures) {
//            print("Not enough features.")
//            return ("Not enough features.")
//        }
//        else {
//            print("Keep moving! 🤳")
//            return "Keep moving! 🤳"
//        }
//    }
//    
//    var touches = 0
//    
//    var hideTaps = 0
//    var multipeerSession: MultipeerSession!
//    
//    var peerSessionIDs = [MCPeerID: String]()
//    
//    var sessionIDObservation: NSKeyValueObservation?
//    
//  //  var searchView : UIView = SearchView()
//
//    
//    @objc func down(sender: UIGestureRecognizer){
//        print("down")
//        UIView.animate(withDuration: 2.0, animations: { () -> Void in
////            self.searchBar.frame = CGRect(x: 20.0, y: 60.0, width: 289, height: 44.0)
////            self.searchBar.delegate = self
//            }, completion: { (Bool) -> Void in
//        })
//    }
//    
//    @objc func up(sender: UIGestureRecognizer){
//        print("up")
//        UIView.animate(withDuration: 2.0, animations: { () -> Void in
////            self.searchBar.frame = CGRect(x: 0.0, y: 0.0, width: 289, height: 44.0)
////            self.searchBar.delegate = self
//        }, completion: { (Bool) -> Void in
//        })
//    }
//    
//    func setupMultipeer() {
//        // MARK: - Setting Up Multipeer Helper -
////        multipeerHelp = MultipeerHelper(
////          serviceName: "blueprint-helper-test",
////          sessionType: .both, //.host
////          delegate: self
////        )
////
////        // MARK: - Setting RealityKit Synchronization
////        guard let syncService = multipeerHelp.syncService else {
////          fatalError("could not create multipeerHelp.syncService")
////        }
////        sceneView.scene.synchronizationService = syncService
//        
//        // Use key-value observation to monitor your ARSession's identifier.
//        // SENSE IF ANY CURRENT SESSIONS NEAR USER
//        sessionIDObservation = observe(\.sceneView.session.identifier, options: [.new]) { object, change in
//            print("SessionID changed to: \(change.newValue!)")
//            // Tell all other peers about your ARSession's changed ID, so
//            // that they can keep track of which ARAnchors are yours.
//            guard let multipeerSession = self.multipeerSession else { return }
//            self.sendARSessionIDTo(peers: multipeerSession.connectedPeers)
//        }
//        
//        // Start looking for other players via MultiPeerConnectivity.
//         multipeerSession = MultipeerSession(receivedDataHandler: receivedData, peerJoinedHandler:
//                                            peerJoined, peerLeftHandler: peerLeft, peerDiscoveredHandler: peerDiscovered)
//      }
//    
//    var undoButton = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 47, y: 120, width: 25, height: 25))
//    
//    
//    
//    @IBAction func profileAction(_ sender: Any) {
//        if LaunchViewController.auth.currentUser?.uid == nil {
//            let storyboard = UIStoryboard(name: "Main ", bundle: nil)
//            var next = storyboard.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountViewController
//           // next.modalPresentationStyle = .fullScreen
//            self.present(next, animated: true, completion: nil)
//        
//        } else {
////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
////            print("\(LaunchViewController.auth.currentUser?.uid) is the current user id")
////            var next = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileViewController
////           // next.modalPresentationStyle = .fullScreen
////            self.present(next, animated: true, completion: nil)
//            
//            
//            
////            var next = UserProfileViewController(Auth.auth().currentUser?.uid ?? "")// ObjectProfileViewController(modelUid: modelUid) //storyboard.instantiateViewController(withIdentifier: "ObjectProfileVC") as! ObjectProfileViewController
////
////            // next.modalPresentationStyle = .fullScreen
////           // self.present(next, animated: true, completion: nil)
////            next.modalPresentationStyle = .fullScreen
////            navigationController!.isNavigationBarHidden = true
////            navigationController!.pushViewController(next, animated: true)
//        }
//    }
//    
//    @objc func goToAnchorSettings(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//      //  print("\(LaunchViewController.auth.currentUser?.uid) is the current user id")
//        var next = storyboard.instantiateViewController(withIdentifier: "AnchorSettingsTableVC") as! AnchorSettingsTableViewController
//       // next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//    }
//    
//    @objc func goToComposeArtwork(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = storyboard.instantiateViewController(withIdentifier: "ComposeArtworkVC") as! ComposeArtworkViewController
//         next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//    }
//    
//    @objc func goToUserProfile(){
//
//        if Auth.auth().currentUser != nil {
//            let user = Auth.auth().currentUser?.uid ?? ""
//            let vc = UserProfileViewController.instantiate(with: user) //(user:user)
//            let navVC = UINavigationController(rootViewController: vc)
//           // var next = UserProfileViewController.instantiate(with: user)
//             navVC.modalPresentationStyle = .fullScreen
//          //  self.navigationController?.pushViewController(next, animated: true)
//            present(navVC, animated: true)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            var next = storyboard.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountViewController
//           // next.modalPresentationStyle = .fullScreen
//            self.present(next, animated: true, completion: nil)
//        }
//    }
//    var scanView = UIView()
//    var progressView1 = UIProgressView()
//    var progressLabel = UILabel()
//    var scanningLabel = UILabel()
//    
//    func scanningUI(){
//        buttonStackView.isHidden = true
//        networkBtn.isHidden = true
//        wordsBtn.isHidden = true
//        videoBtn.isHidden = true
//        networksNearImg.isHidden = true
//        scanView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 95))
//        scanView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
//        
//        progressLabel = UILabel(frame: CGRect(x: 20, y: 45, width: 52.5, height: 23))
//        progressLabel.textColor = .systemGreen
//        progressLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
//       // progressLabel.text = "\(progressView1.progress)%"
//        scanningLabel = UILabel(frame: CGRect(x: 72.5, y: 52, width: 70, height: 16))
//        scanningLabel.textColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1.0)
//        scanningLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
//        scanningLabel.text = "Scanning..."
//        progressView1 = UIProgressView(frame: CGRect(x: 20, y: 75, width: UIScreen.main.bounds.width - 40, height: 16))
//        progressView1.progressTintColor = .systemGreen
//        scanView.addSubview(progressLabel)
//        scanView.addSubview(scanningLabel)
//        scanView.addSubview(progressView1)
//        view.addSubview(scanView)
//    }
//    
//    func removeScanUI(){
//        scanView.removeFromSuperview()
//    }
//    
//    @IBAction func backButtonAction(_ sender: Any) {
//        self.setupBackUI()
////        //topview.isHidden = false
////        self.searchBar.isHidden = true
////        searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchView.isHidden = true
////        self.newSearchView.isHidden = true
////        editButton.isHidden = false
////        previewButton.isHidden = false
////        searchBtn.isHidden = false
////        betweenView.isHidden = false
////        networkBtn.isHidden = false
////        networksNearImg.isHidden = false
////        profileButton.isHidden = false
////        editUnderView.isHidden = false
////        self.categoryScrollView.isHidden = true
////        self.wordsBtn.isHidden = false
////        self.videoBtn.isHidden = false
////
////        browseTableView.isHidden = true
////        view.endEditing(true)
////        if sceneManager.anchorEntities.count == 0 {
////            saveButton.isHidden = true
////            undoButton.isHidden = true
////            numberOfEditsImg.isHidden = true
////            sceneInfoButton.isHidden = true
////        } else {
////            saveButton.isHidden = false
////            undoButton.isHidden = false
////            numberOfEditsImg.isHidden = false
////            sceneInfoButton.isHidden = false
////        }
//    }
//    
//    @IBAction func cancelWalkthroughAction(_ sender: Any) {
//        let defaults = UserDefaults.standard
//        if defaults.bool(forKey: "finishedWalkthrough") == false {
//            let alert = UIAlertController(title: "Skip Tutorial", message: "Skip Blueprint's tutorial? If you already know how to use Blueprint, feel free to skip this part.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Skip", style: .default) { action in
//                
//                defaults.set(true, forKey: "finishedWalkthrough")
//                self.walkthroughView.removeFromSuperview()
//                self.circle.removeFromSuperview()
//                self.walkthroughLabel.removeFromSuperview()
//                self.buttonStackView.isUserInteractionEnabled = true
//                self.videoBtn.isUserInteractionEnabled = true
//                self.wordsBtn.isUserInteractionEnabled = true
//                self.networkBtn.isUserInteractionEnabled = true
//                self.buttonStackViewBottomConstraint.constant = -87
//            })
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
//                //completionHandler(false)
//                return
//            })
//            present(alert, animated: true)
//        } else if defaults.bool(forKey: "finishedWalkthrough") == true {
//            let alert = UIAlertController(title: "Skip Tutorial", message: "Skip Network tutorial? If you already know how to create a Blueprint Network, feel free to skip this part.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Skip", style: .default) { action in
//                defaults.set(true, forKey: "finishedNetworkWalkthrough")
//                self.walkthroughView.removeFromSuperview()
//                self.circle.removeFromSuperview()
//                self.walkthroughLabel.removeFromSuperview()
//                self.buttonStackView.isUserInteractionEnabled = true
//                self.videoBtn.isUserInteractionEnabled = true
//                self.wordsBtn.isUserInteractionEnabled = true
//                self.networkBtn.isUserInteractionEnabled = true
//                self.buttonStackViewBottomConstraint.constant = -87
//                self.buttonStackView.isHidden = false
//            })
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
//                //completionHandler(false)
//                return
//            })
//            present(alert, animated: true)
//        }
//    }
//
//    @objc func hideUI(){
//        //hideTaps += 1
//        
//        //if hideTaps % 2 == 0 {
////            placementStackView.isHidden = true
////
////            shareImg.isHidden = false
////
////            toggleBtn.isHidden = false
////
////            duplicateBtn.isHidden = true
////            entityName.isHidden = true
////            searchBtn.isHidden = false
////            entityProfileBtn.isHidden = true
////            networksNearImg.isHidden = false
//       // } else {
//        //topview.isHidden = true
//        self.searchStackView.isHidden = true
//            placementStackView.isHidden = true
//        //searchStackUnderView.isHidden = true
//      
//            searchBtn.isHidden = false
//           
//            shareImg.isHidden = true
//            
//            toggleBtn.isHidden = true
//            
//            duplicateBtn.isHidden = true
//            entityName.isHidden = true
//            entityProfileBtn.isHidden = true
//            networksNearImg.isHidden = true
//      //  }
//        
//        
//    }
//    
//    @objc func removeModels(_ sender: UITapGestureRecognizer){
//      //  sceneView.scene.rem
//    }
//    
//    @objc func applyFilter(_ sender: UITapGestureRecognizer){
//    }
//    
//    @objc func hideMesh(_ sender: UITapGestureRecognizer){
//        touches += 1
//        if touches % 2 == 0 {
//            sceneView.debugOptions.remove(.showSceneUnderstanding)
//        } else {
//        sceneView.debugOptions.insert(.showSceneUnderstanding) //.insert(.showSceneUnderstanding)
//        }}
//    
//    @objc func textSettings(){
//        
//    }
//    
//    @IBAction func objectModeAction(_ sender: Any) {
//        shareImg.image = UIImage(systemName: "person.2.fill")
//        //networksNearImg.isHidden = true
//        sceneView.removeGestureRecognizer(placeVid)
//        shareImg.removeGestureRecognizer(textSettingsRecognizer)
//        shareImg.addGestureRecognizer(shareRecognizer)
//        toggleBtn.setImage(UIImage(systemName: "rectangle"), for: .normal)
//        toggleBtn.removeGestureRecognizer(undoTextRecognizer)
//        networksNearImg.isHidden = false
//        isObjectMode = true
//        isScanMode = false
//        scanBtn.isHidden = true
//        isVideoMode = false
//        isTextMode = false
//       
//        videoBtn.isHidden = true
//        wordsBtn.isHidden = true
//        
//        UIView.animate(withDuration: 0.9,
//            animations: {
//               // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
//                self.objectModeBtn.setTitleColor(UIColor.systemYellow, for: .normal)
//                self.designModeBtn.setTitleColor(UIColor.white, for: .normal)
//                self.scanModeBtn.setTitleColor(UIColor.white, for: .normal)
//            },
//            completion: { _ in
////                UIView.animate(withDuration: 0.6) {
////                    self.wordsBtn.transform = CGAffineTransform.identity
////                }
//            })
//    }
//    
//    @IBAction func scanModeAction(_ sender: Any) {
//     //   loadMap()
////        shareImg.image = UIImage(systemName: "person.2.fill")
////        //networksNearImg.isHidden = true
////        sceneView.removeGestureRecognizer(placeVid)
////        shareImg.removeGestureRecognizer(textSettingsRecognizer)
////        shareImg.addGestureRecognizer(shareRecognizer)
////        toggleBtn.setImage(UIImage(systemName: "rectangle"), for: .normal)
////        toggleBtn.removeGestureRecognizer(undoTextRecognizer)
////        scanBtn.isHidden = false
////        isObjectMode = false
////        isScanMode = true
////        isVideoMode = false
////        isTextMode = false
////        videoBtn.isHidden = true
////        wordsBtn.isHidden = true
////
////
////        networksNearImg.isHidden = false
////        UIView.animate(withDuration: 0.9,
////            animations: {
////               // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
////                self.scanModeBtn.setTitleColor(UIColor.systemYellow, for: .normal)
////                self.designModeBtn.setTitleColor(UIColor.white, for: .normal)
////                self.objectModeBtn.setTitleColor(UIColor.white, for: .normal)
////            },
////            completion: { _ in
//////                UIView.animate(withDuration: 0.6) {
//////                    self.wordsBtn.transform = CGAffineTransform.identity
//////                }
////            })
//        
//    }
//    
//    
//    
//    @IBAction func designModeAction(_ sender: Any) {
//        isObjectMode = false
//        isScanMode = false
//       // shareImg.image = UIImage(systemName: "gearshape.fill")
//        //networksNearImg.isHidden = true
//        shareImg.removeGestureRecognizer(textSettingsRecognizer)
//        shareImg.addGestureRecognizer(shareRecognizer)
//        
//        scanBtn.isHidden = true
//        toggleBtn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
//        toggleBtn.removeGestureRecognizer(undoTextRecognizer)
//        videoBtn.isHidden = false
//        wordsBtn.isHidden = false
//        
//        UIView.animate(withDuration: 0.9,
//            animations: {
//               // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
//                self.designModeBtn.setTitleColor(UIColor.systemYellow, for: .normal)
//                self.objectModeBtn.setTitleColor(UIColor.white, for: .normal)
//                self.scanModeBtn.setTitleColor(UIColor.white, for: .normal)
//            },
//            completion: { _ in
////                UIView.animate(withDuration: 0.6) {
////                    self.wordsBtn.transform = CGAffineTransform.identity
////                }
//            })
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addPlane(_:)))
//        doubleTap.numberOfTapsRequired = 2
//        doubleTap.delegate = self
//      //  sceneView.addGestureRecognizer(doubleTap)
//    }
//    
//    var wordsTaps = 0
//    
//    @IBAction func wordsAction(_ sender: Any) {
//        self.uploadMessage()
////        wordsTaps += 1
////        videoTaps = 0
////        if wordsTaps % 2 == 1 {
////            isTextMode = true
////            isVideoMode = false
////            isObjectMode = false
////            scanBtn.isHidden = true
////            isScanMode = false
////    //        shareImg.image = UIImage(systemName: "gearshape.fill")
////    //        toggleBtn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
////            shareImg.removeGestureRecognizer(shareRecognizer)
////          //  inputContainerView.isHidden = false
////          //  networksNearImg.isHidden = true
////          //
////    //        textSettingsRecognizer = UITapGestureRecognizer(target: self, action: #selector(textSettings(_:)))
////    //        textSettingsRecognizer.delegate = self
////    //        shareImg.addGestureRecognizer(textSettingsRecognizer)
////    //
////    //        undoTextRecognizer = UITapGestureRecognizer(target: self, action: #selector(undoText(_:)))
////    //        undoTextRecognizer.delegate = self
////    //        toggleBtn.addGestureRecognizer(undoTextRecognizer)
////
////            subscription = sceneView.scene.subscribe(to: SceneEvents.Update.self) { [unowned self] in
////                self.updateSceneView(on: $0)
////            }
////
////            arViewGestureSetup()
////            overlayUISetup()
////
////            let notificationName = UIResponder.keyboardWillShowNotification
////            let selector = #selector(keyboardIsPoppingUp(notification:))
////            NotificationCenter.default.addObserver(self, selector: selector, name: notificationName, object: nil)
////
////            UIView.animate(withDuration: 0.6,
////                animations: {
////                   // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
////                    self.wordsBtn.tintColor = UIColor.systemYellow
////                    self.videoBtn.tintColor = UIColor.white
////                },
////                completion: { _ in
////    //                UIView.animate(withDuration: 0.6) {
////    //                    self.wordsBtn.transform = CGAffineTransform.identity
////    //                }
////                })
////        } else {
////            isTextMode = false
////            isVideoMode = false
////            isObjectMode = false
////            scanBtn.isHidden = true
////            isScanMode = false
////    //        shareImg.image = UIImage(systemName: "gearshape.fill")
////    //        toggleBtn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
////            shareImg.removeGestureRecognizer(shareRecognizer)
////          //  inputContainerView.isHidden = false
////          //  networksNearImg.isHidden = true
////          //
////    //        textSettingsRecognizer = UITapGestureRecognizer(target: self, action: #selector(textSettings(_:)))
////    //        textSettingsRecognizer.delegate = self
////    //        shareImg.addGestureRecognizer(textSettingsRecognizer)
////    //
////    //        undoTextRecognizer = UITapGestureRecognizer(target: self, action: #selector(undoText(_:)))
////    //        undoTextRecognizer.delegate = self
////    //        toggleBtn.addGestureRecognizer(undoTextRecognizer)
////
////            //subscription.cancel()
////            sceneView.removeGestureRecognizer(swipeGesture)
////            sceneView.removeGestureRecognizer(wordsTapGesture)
////
////            UIView.animate(withDuration: 0.6,
////                animations: {
////                   // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
////                    self.wordsBtn.tintColor = UIColor.white
////                    self.videoBtn.tintColor = UIColor.white
////                },
////                completion: { _ in
////                })
////        }
//    }
//    
//    
//    func updateSceneView(on event: SceneEvents.Update) {
//        let notesToUpdate = stickyNotes.compactMap { !$0.isEditing && !$0.isDragging ? $0 : nil }
//        for note in notesToUpdate {
//            // Gets the 2D screen point of the 3D world point.
//            guard let projectedPoint = sceneView.project(note.position) else { return }
//            
//            // Calculates whether the note can be currently visible by the camera.
//            let cameraForward = sceneView.cameraTransform.matrix.columns.2.xyz
//            let cameraToWorldPointDirection = normalize(note.transform.translation - sceneView.cameraTransform.translation)
//            let dotProduct = dot(cameraForward, cameraToWorldPointDirection)
//            let isVisible = dotProduct < 0
//
//            // Updates the screen position of the note based on its visibility
//            note.projection = Projection(projectedPoint: projectedPoint, isVisible: isVisible)
//            note.updateScreenPosition()
//        }
//        
////        if let cloudSession = cloudSession {
////            cloudSession.processFrame(sceneView.session.currentFrame)
////
////            if (currentlyPlacingAnchor && enoughDataForSaving && localAnchor != nil) {
////                createCloudAnchor()
////            }
////        }
//    }
//    
//    func reset() {
//        guard let configuration = sceneView.session.configuration else { return }
//        sceneView.session.run(configuration, options: .removeExistingAnchors)
//        for note in stickyNotes {
//            deleteStickyNote(note)
//        }
//    }
//    
//    private var videoLooper: AVPlayerLooper!
//    private var player: AVQueuePlayer!
//    
//    @IBAction func duplicateAction(_ sender: Any) {
////        print(selectedAnchor)
////        selectedEntity?.clone(recursive: true)
//        showPicker()
//        
//        
//    }
//    
//    
//    func showPicker() {
//        let picker = UIImagePickerController()
//        picker.sourceType = .photoLibrary
//       // picker.mediaTypes = ["public.movie"]
//        picker.delegate = self
//        present(picker, animated: true) {
//            self.didTap = false
//        }
//    }
//    
//    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
//        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))// CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = font
//        label.text = text
//
//        label.sizeToFit()
//        return label.frame.height
//    }
//    
//    var messageText = "Select to Edit"
//    
//    var documentsUrl: URL {
//        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    }
//    
//    private func saveImage(image: UIImage) -> String? {
//        let fileName = "messageView.png"
//        let fileURL = documentsUrl.appendingPathComponent(fileName)
//        if let imageData = image.jpegData(compressionQuality: 1.0) {
//           try? imageData.write(to: fileURL, options: .atomic)
//            print("\(fileURL) is fileURL")
//           return fileName // ----> Save fileName
//        }
//        print("Error saving image")
//        return nil
//    }
//    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    
//    @objc func dismissMessageView(){
//        dismissKeyboard()
//        messageView.animateHide()
//     //   isMessage = false
//    }
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Type message here"
//            textView.textColor = UIColor.lightGray
//        } // disable the post button
//        //messageText = messageTextView.text
//    }
//    
//    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
//        if textView.text == nil || textView.text == "" || textView.text.isEmpty {
//            postMessageButton.backgroundColor = UIColor(red: 66/255, green: 126/255, blue: 251/255, alpha: 0.5)
//            postMessageButton.isUserInteractionEnabled = false
//        } else {
//            postMessageButton.backgroundColor = UIColor(red: 66/255, green: 126/255, blue: 251/255, alpha: 1.0)
//            postMessageButton.isUserInteractionEnabled = true
//        }
//    }
//    
//    var messageViewURL : URL?
//    var messageView = UIView()
//    var messageButtonView = UIView()
//    var messageTextView = UITextView()
//    var postMessageButton = UIButton()
//    
//    func uploadMessage(){
//        let messageButtonUnderline = UIView(frame: CGRect(x: 0, y: 183.5, width: self.view.frame.size.width, height: 0.5))
//        messageButtonUnderline.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)
//        messageButtonView = UIView(frame: CGRect(x: 0, y: 184, width: self.view.frame.size.width, height: 50))
//        messageButtonView.backgroundColor = UIColor.white
//        let audioBtn = UIButton(frame: CGRect(x: 16, y: 11, width: 28, height: 28))
//        audioBtn.tintColor = .link
//        
//       let img1 = UIImage(systemName: "airplayaudio", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
//        audioBtn.setImage(img1, for: .normal) //.imageView?.image =
//        let photoBtn = UIButton(frame: CGRect(x: 70, y: 11, width: 28, height: 28))
//        photoBtn.tintColor = .link
//        let img2 = UIImage(systemName: "photo.fill.on.rectangle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
//        photoBtn.setImage(img2, for: .normal)
//     //   photoBtn.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
//        let addBtn = UIButton(frame: CGRect(x: 342, y: 11, width: 28, height: 28))
//        addBtn.tintColor = .white
//        addBtn.backgroundColor = .link
//        addBtn.layer.cornerRadius = 14
//        let img3 = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
//        addBtn.setImage(img3, for: .normal)
//        //addBtn.setImage(UIImage(systemName: "plus"), for: .normal) //.imageView?.image =
//        messageButtonView.addSubview(audioBtn)
//        messageButtonView.addSubview(photoBtn)
//        messageButtonView.addSubview(addBtn)
//        messageButtonView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
//        messageView = UIView(frame: CGRect(x: 0, y: 274, width: UIScreen.main.bounds.width, height: 500))
//        messageView.backgroundColor = .white
//        messageView.clipsToBounds = true
//        messageView.layer.cornerRadius = 18
//        messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        messageView.addGestureRecognizer(tap)
////        let profilePicImageView = UIImageView(frame: CGRect(x: 20, y: 79, width: 40, height: 40))
////        profilePicImageView.layer.cornerRadius = 20
////        profilePicImageView.clipsToBounds = true
////        StorageManager.getProPic(Auth.auth().currentUser!.uid) { image in
////            profilePicImageView.image = image
////            profilePicImageView.layer.cornerRadius = 20
////        }
//        let cancel = UIButton(frame: CGRect(x: 20, y: 21, width: 63, height: 53))
//        cancel.titleLabel?.textColor = .black
//        cancel.setTitle("Cancel", for: .normal)
//        cancel.setTitleColor(.black, for: .normal)// .titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        cancel.addTarget(self, action: #selector(dismissMessageView), for: .touchUpInside)
//
//        messageTextView = UITextView(frame: CGRect(x: 68, y: 79, width: 302, height: 100))
//        messageTextView.delegate = self //autocorrect
//        messageTextView.text = "Type message here"
//        messageTextView.becomeFirstResponder()
//        messageTextView.textColor = UIColor.lightGray
////        messageTextView.autocorrectionType = .no
////        messageTextView.inputAssistantItem.leadingBarButtonGroups = []
////        messageTextView.inputAssistantItem.trailingBarButtonGroups = []
////        messageTextView.inputAccessoryView = nil
//        messageTextView.font = UIFont.systemFont(ofSize: 18)
//        messageTextView.backgroundColor = .white
//        postMessageButton = UIButton(frame: CGRect(x: 299, y: 25.67, width: 71, height: 32))
//        postMessageButton.backgroundColor = UIColor(red: 66/255, green: 126/255, blue: 251/255, alpha: 0.5)
//        postMessageButton.isUserInteractionEnabled = false
//       // postMessageButton.isEnabled = false
//        postMessageButton.setTitle("Post", for: .normal) //.titleLabel?.text = "Post"
//        postMessageButton.setTitleColor(.white, for: .normal)//.titleLabel?.textColor = .white
//        postMessageButton.layer.cornerRadius = 16
//        postMessageButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//     //   postMessageButton.addTarget(self, action: #selector(postMessage), for: .touchUpInside)
//        
//      //  messageView.addSubview(profilePicImageView)
//        messageView.addSubview(messageTextView)
//        messageView.addSubview(messageButtonUnderline)
//        messageView.addSubview(postMessageButton)
//        messageView.addSubview(cancel)
//        messageView.addSubview(messageButtonView)
//        view.addSubview(messageView)
//        
//        
//        
//        let message = self.messageText
//            let font = UIFont.systemFont(ofSize: 17, weight: .semibold) // UIFont(name: "Helvetica", size: 20.0)
//
//            let height = self.heightForView(text: message, font: font, width: 200.0)
//            print("\(height) is height")
//            let messageLabel = UILabel(frame: CGRect(x: 10, y: 44, width: 200, height: height))
//     //       messageLabel.sizeToFit()
//        messageLabel.textAlignment = .center
//        messageLabel.textColor = .white// .black
//            messageLabel.text = message
//        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//            messageLabel.numberOfLines = 0
//    //        messageLabel.backgroundColor = .white
//            let anchorView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: height + 60))
//        anchorView.backgroundColor = UIColor(red: 21/255, green: 31/255, blue: 43/255, alpha: 0.5) // .systemPink
//        
//        let profilePicImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
//        profilePicImageView.layer.cornerRadius = 15
//        profilePicImageView.clipsToBounds = true
//        let uid = Auth.auth().currentUser?.uid ?? ""
//        if Auth.auth().currentUser != nil {
//           
//            StorageManager.getProPic(uid) { image in
//                // self.anchorUserImg.image = image
//                profilePicImageView.image = image
//            }
//        } else {
//            profilePicImageView.image = UIImage(named: "nouser")
//        }
//        let messageHostNameLabel = UILabel(frame: CGRect(x: 46, y: 11.5, width: 150, height: 14))
//        messageHostNameLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
//        messageHostNameLabel.textColor = .white
//        let messageHostUsernameLabel = UILabel(frame: CGRect(x: 46, y: 25, width: 150, height: 11))
//        messageHostUsernameLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
//        messageHostUsernameLabel.textColor = .lightGray
//        if Auth.auth().currentUser != nil {
//            FirestoreManager.getUser(uid) { user in
//        //            if user?.name != "" {
//        //              //  self.hostName = user?.name ?? ""
//                    messageHostNameLabel.text = user?.name ?? ""
//              //  } else {
//               // self.hostName = user?.username ?? ""
//                    messageHostUsernameLabel.text = "@\(user?.username ?? "[deleted]")"
//
//                }
//            
//        }
//            anchorView.addSubview(messageLabel)
//        anchorView.addSubview(profilePicImageView)
//        anchorView.addSubview(messageHostNameLabel)
//        anchorView.addSubview(messageHostUsernameLabel)
//        
//           // anchorNode.geometry?.firstMaterial?.diffuse.contents = anchorView
//          //  anchorNode.geometry?.firstMaterial?.isDoubleSided = true
//        
//        let imageOfMessage = anchorView.snapshot() //else { return }
//        if let image = imageOfMessage {
//            if let data = image.pngData() {
//                let filename = getDocumentsDirectory().appendingPathComponent("messageView.png")
//                print("\(filename) is filename")
//                self.messageViewURL = filename
//                try? data.write(to: filename)
//            }
//        }
//        let success = saveImage(image: imageOfMessage!)
//        
//        
//        var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//        material.baseColor = try! .texture(.load(contentsOf: (messageViewURL ?? URL(string: "www.google.com"))!)) //img
//        
//        let mesh = MeshResource.generateBox(width: 1.2, height: 0.6, depth: 0.005)   //.generatePlane(width: 2, depth: 1)
//        
//       // let imgPlane = ModelEntity(mesh: mesh, materials: [material])
//      //  mesh.bounds.boundingRadius = 0.3
//       // mesh.contents.
////        material.baseColor = try! .texture(.load(named: "chanceposter"))
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        
//        self.currentEntity = planeModel
//        self.currentEntity.name = "Message by __"
//      //  planeModel.setOrientation(simd_quatf(ix: 0, iy: 0, iz: 90, r: 0), relativeTo: self.currentEntity)
//        print(self.currentEntity)
//        self.currentEntity.generateCollisionShapes(recursive: true)
//        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                    material: .default,
//                                                        mode: .dynamic)
//       // modelEntity.components.set(physics)
//        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//        let anchor = AnchorEntity(world: [0,0.04,-1.2]) // self.focusEntity?.anchor //AnchorEntity(plane: .any)// //
//        print(anchor)
//      //  anchor.setOrientation(simd_quatf(ix: 90, iy: 0, iz: 0, r: 0), relativeTo: self.currentEntity) //setOrientation(simd_quatf(ix: 0, iy: 90, iz: 0, r: 0)
//       // let random = self.generateRandomPhotoID(length: 20)
//       // self.imageAnchorID = random
//    //    self.currentAnchor = anchor!
//       // anchor?.scale = [1.2,1.0,1.0]
//        anchor.addChild(self.currentEntity)
//        self.sceneView.scene.addAnchor(anchor)
//       // self.currentEntity?.scale *= self.scale
//        self.removeCloseButton()
//        ProgressHUD.dismiss()
//       // print("modelEntity for \(self.name) has been loaded.")
//      //  self.modelPlacementUI()
////        if !connectedToNetwork {
////            self.uploadSessionPhotoAnchor()
////            self.currentSessionAnchorIDs.append(self.imageAnchorID)
////        }
//        sceneView.removeGestureRecognizer(placeVideoRecognizer)
//        UIView.animate(withDuration: 0.6,
//            animations: {
//                self.wordsBtn.tintColor = UIColor.white
//                self.videoBtn.tintColor = UIColor.white
//            },
//            completion: { _ in
//            })
//    }
//    
//    @IBAction func removeAction(_ sender: Any) {
//        if selectedAnchor == nil {
//            sceneView.scene.removeAnchor(currentAnchor)
//            
//            currentEntity.removeFromParent()
//            detailAnchor.removeFromParent()
////            let id = String(self.currentAnchor.id)
////            if !connectedToNetwork {
////                let docRef = self.db.collection("sessionAnchors").document(id)
////                docRef.delete()
////            }
//             //.removeLast()
//            if self.selectedAnchorID != "" {
//                let id = self.selectedAnchorID
//                let index = self.currentSessionAnchorIDs.firstIndex(of: self.selectedAnchorID)!
//                self.currentSessionAnchorIDs.removeAll(where: { $0 == id })
//                
//                //HAS PROBLEM AT INDEX: 0
//                
//                self.sceneManager.anchorEntities.remove(at: index)
//            }
//            selectedEntity?.removeFromParent()
//            placementStackView.isHidden = true
//            duplicateBtn.isHidden = true
//            entityName.isHidden = true
//            //sceneManager.anchorEntities.remo
//            searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//            searchBtn.isHidden = false
//            entityProfileBtn.isHidden = true
//            //networksNearImg.isHidden = false
//            self.networksNear()
//            editButton.isHidden = false
//            previewButton.isHidden = false
//            self.buttonStackView.isHidden = false
//            anchorSettingsImg.isHidden = true
//            anchorUserImg.isHidden = true
//            editUnderView.isHidden = false
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            betweenView.isHidden = false
//            profileButton.isHidden = false
//            searchView.isHidden = true
//            self.newSearchView.isHidden = true
//            searchBar.isHidden = true
//            if objectInfoView.isHidden == false {
//                objectInfoView.isHidden = true
//               // objectInfoView.layer.opacity = 0
//            }
////            saveButton.isHidden = true
////            numberOfEditsImg.isHidden = true
//        } else {
//            sceneView.scene.removeAnchor(selectedAnchor!)
//            selectedEntity?.removeFromParent()
//          //  currentEntity.removeFromParent()
//            detailAnchor.removeFromParent()
//            if self.selectedAnchorID != "" {
//                let id = self.selectedAnchorID
//                if self.currentSessionAnchorIDs.count != 0 {
//                  //  let index = self.currentSessionAnchorIDs.firstIndex(of: self.selectedAnchorID)!
//
//                }
//                self.currentSessionAnchorIDs.removeAll(where: { $0 == id })
//                
////                if index == 0 {
////                    self.sceneManager.anchorEntities.removeFirst()
////                } else {
//                //HAS PROBLEM AT INDEX: 0
//                 //   self.sceneManager.anchorEntities.remove(at: index)
//              // }
//            }
//            if !connectedToNetwork && self.currentEntity.name != "" {
//                let id = self.selectedAnchorID// String(self.currentEntity.id)
//                let docRef = self.db.collection("sessionAnchors").document(id)
//                docRef.delete()
//            } else if !connectedToNetwork && currentEntity.name == "" || currentEntity.name == .none  {
//                let id = self.selectedAnchorID// String(self.currentAnchor.id)
//                let docRef = self.db.collection("sessionAnchors").document(id)
//                docRef.delete()
//            }
//            placementStackView.isHidden = true
//            duplicateBtn.isHidden = true
//            entityName.isHidden = true
//            anchorSettingsImg.isHidden = true
//            anchorInfoStackView.isHidden = true
//            anchorUserImg.isHidden = true
//            searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//            searchBtn.isHidden = false
//            entityProfileBtn.isHidden = true
//           // networksNearImg.isHidden = false
//            self.networksNear()
//            editButton.isHidden = false
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//            previewButton.isHidden = false
//            editUnderView.isHidden = false
//            betweenView.isHidden = false
//            profileButton.isHidden = false
//            searchView.isHidden = true
//            self.newSearchView.isHidden = true
//            searchBar.isHidden = true
//            if objectInfoView.isHidden == false {
//                objectInfoView.isHidden = true
//               // objectInfoView.layer.opacity = 0
//            }
//            
//        }
//      //  }
//            
//        placementStackView.isHidden = true
//       //
//       // shareImg.isHidden = false
//        scanBtn.isHidden = true
//        
//     //   toggleBtn.isHidden = false
//        
//      //      //topview.isHidden = false
//            searchBtn.isHidden = false
//           
//            networkBtn.isHidden = false
//       //
//        duplicateBtn.isHidden = true
//        removeBtn.isHidden = true
//        entityName.removeFromSuperview()
////        entityName.text = ""
////        entityName.textColor = .clear
//        entityProfileBtn.isHidden = true
//        entityProfileBtn.removeFromSuperview()
//        
//        if objectInfoView.isHidden == false {
//            objectInfoView.isHidden = true
//           // objectInfoView.layer.opacity = 0
//        }
//        
//        if sceneManager.anchorEntities.count > 0 {
//            sceneManager.anchorEntities.removeLast()
//        }
//        
//        if sceneManager.anchorEntities.count >= 1 {
//            print("\(sceneManager.anchorEntities.count) is the count")
//         //   saveButton.isHidden = false
//            undoButton.isHidden = false
//         //   wordsBtnTopConstraint.constant = 60
//         //   numberOfEditsImg.isHidden = false
//  //          sceneInfoButton.isHidden = false
//        } else {
//            print("\(sceneManager.anchorEntities.count) is the count")
//            saveButton.isHidden = true
//            undoButton.isHidden = true
//            numberOfEditsImg.isHidden = true
//            sceneInfoButton.isHidden = true
//        //    wordsBtnTopConstraint.constant = 11
//        }
//        
//        updateEditCount()
//
//        //sceneView.removeSubview(entityName)
////        entityName.removeFromSuperview()
////        entityProfileBtn.removeFromSuperview()
//        networkBtn.setImage(UIImage(systemName: "network"), for: .normal)
//      //  networksNearImg.isHidden = false
//      //  self.networksNear()
//   // }
//    }
//    
//    var videoPlayer: AVPlayer!
//    
////    var heightInPoints = CGFloat()
////    var widthInPoints = CGFloat()
//    
//    @objc func anchorVideo(_ sender: UITapGestureRecognizer){
//        // pressing button brings up photo library
//        // once selecting photo/video --> thumbnail for selection shows up in bottom right/left
//        // prompt telling user to tap to place content appears
//        // once user taps, then video/photo appears where tapped - if video, starts playing
//        
//        if self.imageAnchorChanged {
//            searchBar.isHidden = true
//            //topview.isHidden = true
//            self.searchStackView.isHidden = true
//            toggleBtn.isHidden = true
//            self.undoButton.isHidden = true
//            self.sceneInfoButton.isHidden = true
//            self.categoryScrollView.isHidden = true
//            //searchStackUnderView.isHidden = true
//            searchBtn.isHidden = false
//            self.newSearchView.isHidden = true
//            dismissKeyboard()
//            ProgressHUD.show("Loading...")
//           
//         //   browseTableView.isHidden = true
//            self.addCloseButton()
//            
//            let img = photoAnchorImageView.image
//            
//            heightInPoints = photoAnchorImageView.image?.size.height ?? 200
//            let heightInPixels = heightInPoints * (photoAnchorImageView.image?.scale ?? 1)
//            widthInPoints = photoAnchorImageView.image?.size.width ?? 200
//            let widthInPixels = widthInPoints * (photoAnchorImageView.image?.scale ?? 1)
//            print("\(heightInPixels) is height in pixels")
//            print("\(widthInPixels) is width in pixels")
//            var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//            material.baseColor = try! .texture(.load(contentsOf: imageAnchorURL!)) //img
//            
//            let mesh = MeshResource.generateBox(width: Float(widthInPixels) / 2000, height: Float((widthInPixels) / 2000) / 50, depth: Float(heightInPixels) / 2000)   //.generatePlane(width: 1.5, depth: 1)
//           // let imgPlane = ModelEntity(mesh: mesh, materials: [material])
//
//    //        material.baseColor = try! .texture(.load(named: "chanceposter"))
//            let planeModel = ModelEntity(mesh: mesh, materials: [material])
//            
//            self.currentEntity = planeModel
//            self.currentEntity.name = "Photo by __"
//            print(self.currentEntity)
//            self.currentEntity.generateCollisionShapes(recursive: true)
//            let physics = PhysicsBodyComponent(massProperties: .default,
//                                                        material: .default,
//                                                            mode: .dynamic)
//           // modelEntity.components.set(physics)
//            self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//            let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//            print(anchor)
//           // anchor?.scale = [1.2,1.0,1.0]
//            anchor?.addChild(self.currentEntity)
//            self.sceneView.scene.addAnchor(anchor!)
//           // self.currentEntity?.scale *= self.scale
//            self.removeCloseButton()
//            ProgressHUD.dismiss()
//           // print("modelEntity for \(self.name) has been loaded.")
//            self.modelPlacementUI()
//            if !connectedToNetwork {
//                self.uploadSessionPhotoAnchor()
//                self.currentSessionAnchorIDs.append(self.imageAnchorID)
//            }
//            sceneView.removeGestureRecognizer(placeVideoRecognizer)
//            UIView.animate(withDuration: 0.6,
//                animations: {
//                    self.wordsBtn.tintColor = UIColor.white
//                    self.videoBtn.tintColor = UIColor.white
//                },
//                completion: { _ in
//                })
//        } else if self.videoAnchorChanged {
//           // guard let path = Bundle.main.path(forResource: "Giannis Highlights", ofType: "mp4") else { return }
//            let videoUrl = self.videoAnchorURL
//            let playerItem = AVPlayerItem(url: self.videoAnchorURL!)
//            
//            let videoPlayer = AVPlayer(playerItem: playerItem)
//            self.videoPlayer = videoPlayer
//
//            let videoMaterial = VideoMaterial(avPlayer: videoPlayer)
//            let mesh = MeshResource.generateBox(width: 1.6, height: 0.2, depth: 1.0)   //.generatePlane(width: 1.5, depth: 1)
//            let videoPlane = ModelEntity(mesh: mesh, materials: [videoMaterial])
//           // videoPlane.name = "Giannis"
//
//            // let anchor = AnchorEntity(anchor: focusEntity?.currentPlaneAnchor as! ARAnchor)
//            let anchor = AnchorEntity(plane: .any) // AnchorEntity(anchor: focusEntity?.currentPlaneAnchor as! ARAnchor) // focusEntity?.currentPlaneAnchor//
//            print(anchor)
//            anchor.addChild(videoPlane)
//            
//            
//            videoPlane.generateCollisionShapes(recursive: true)
//            
//           // videoPlane.
//            //
//            sceneView.installGestures([.translation, .rotation, .scale], for: videoPlane)
//            
//           // sceneView.scene.addAnchor(anchor!)
//            sceneView.scene.anchors.append(anchor)
//            
//            videoPlayer.play()
//            
//            NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
//            sceneView.removeGestureRecognizer(placeVideoRecognizer)
//            UIView.animate(withDuration: 0.6,
//                animations: {
//                    self.wordsBtn.tintColor = UIColor.white
//                    self.videoBtn.tintColor = UIColor.white
//                },
//                completion: { _ in
//                })
//        }
//        
//        
//    }
//    
//    @objc func loopVideo(notification: Notification) {
//            guard let playerItem = notification.object as? AVPlayerItem else { return }
//            playerItem.seek(to: CMTime.zero, completionHandler: nil)
//            videoPlayer.play()
//        }
//    
//    @objc func pauseVideo(_ sender: UITapGestureRecognizer){
//        videoPlayer.pause()
//    }
//    
//    var placeVid = UITapGestureRecognizer()
//    
//    var placeVideoRecognizer = UITapGestureRecognizer()
//    var pauseVideoRecognizer = UITapGestureRecognizer()
//    var wordsTapGesture = UITapGestureRecognizer()
//    var swipeGesture = UISwipeGestureRecognizer()
//    
//    var videoWidth = CGFloat()
//    var videoHeight = CGFloat()
//    
//    func resolutionSizeForLocalVideo(url:NSURL) -> CGSize? {
//        guard let track = AVAsset(url: url as URL).tracks(withMediaType: AVMediaType.video).first else { return nil }
//        let size = track.naturalSize.applying(track.preferredTransform)
//        print("\(CGSize(width: fabs(size.width), height: fabs(size.height))) is video size ")
//        self.videoWidth = fabs(size.width)
//        self.videoHeight = fabs(size.height)
//        return CGSize(width: fabs(size.width), height: fabs(size.height))
//    }
//    
//    @objc func videoAnchorURLChosen(){
//        searchBar.isHidden = true
//        //topview.isHidden = true
//        self.searchStackView.isHidden = true
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.categoryScrollView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchBtn.isHidden = false
//        self.newSearchView.isHidden = true
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//       
//   //     browseTableView.isHidden = true
//        self.addCloseButton()
//        
//        
//        let videoUrl = self.videoAnchorURL
//        let playerItem = AVPlayerItem(url: self.videoAnchorURL!)
//        resolutionSizeForLocalVideo(url: self.videoAnchorURL! as NSURL)
//        let videoPlayer = AVPlayer(playerItem: playerItem)
////        print("\(videoPlayer.accessibilityFrame.height) is playerItem height")
////        print("\(videoPlayer.accessibilityFrame.width) is playerItem width")
//        self.videoPlayer = videoPlayer
//
//        let videoMaterial = VideoMaterial(avPlayer: videoPlayer)
//        let mesh = MeshResource.generateBox(width: Float(videoHeight) / 850, height: 0.025, depth: Float(videoWidth) / 850)   //.generatePlane(width: 1.5, depth: 1)
//        let videoPlane = ModelEntity(mesh: mesh, materials: [videoMaterial])
//        
//        self.currentEntity = videoPlane
//        self.currentEntity.name = "Video by __"
//       
//        print(self.currentEntity)
//        self.currentEntity.generateCollisionShapes(recursive: true)
//        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                    material: .default,
//                                                        mode: .dynamic)
//       // modelEntity.components.set(physics)
//        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//        
//      //  sceneView.installGestures([.translation, .rotation, .scale], for: videoPlane)
//        
//        let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//       // anchor?.orientation = SIMD3(x: 0, y: 90, z: 0)
//        print(anchor)
//        let random = self.generateRandomPhotoID(length: 20)
//        self.videoAnchorID = random
//    //    self.currentAnchor = anchor!
//       // anchor?.scale = [1.2,1.0,1.0]
//        anchor?.addChild(self.currentEntity)
//        self.sceneView.scene.addAnchor(anchor!)
//        
//      //  sceneView.scene.anchors.append(anchor)
//        
//        videoPlayer.play()
//        self.removeCloseButton()
//        ProgressHUD.dismiss()
//       // print("modelEntity for \(self.name) has been loaded.")
//        self.modelPlacementUI()
//        if !connectedToNetwork {
//            self.uploadSessionVideoAnchor()
//            self.currentSessionAnchorIDs.append(self.videoAnchorID)
//        }
//        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
//        sceneView.removeGestureRecognizer(placeVideoRecognizer)
//        UIView.animate(withDuration: 0.6,
//            animations: {
//                self.wordsBtn.tintColor = UIColor.white
//                self.videoBtn.tintColor = UIColor.white
//            },
//            completion: { _ in
//            })
//    
//    }
//    
//    @objc func playerItemDidReachEnd(notification: NSNotification) {
//            if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
//                playerItem.seek(to: CMTime.zero)
//            }
//        }
//    
//    @objc func photoAnchorImageChosen() {
//        // This button will be hidden if n?ot cur?rently tracking, so this can't be nil.
//        
//       print("\(photoAnchorImageView.image?.size.height) is photo anchor image view height")
//        print("\(photoAnchorImageView.image?.size.width) is photo anchor image view width")
//        
//        print("\(photoAnchorImageView.image?.scale) is photo anchor image view scale")
//        
//        
//        heightInPoints = photoAnchorImageView.image?.size.height ?? 200
//        let heightInPixels = heightInPoints * (photoAnchorImageView.image?.scale ?? 1)
//        widthInPoints = photoAnchorImageView.image?.size.width ?? 200
//        let widthInPixels = widthInPoints * (photoAnchorImageView.image?.scale ?? 1)
//        
//        searchBar.isHidden = true
//        //topview.isHidden = true
//        self.searchStackView.isHidden = true
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.categoryScrollView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchBtn.isHidden = false
//        self.newSearchView.isHidden = true
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//       
//   //     browseTableView.isHidden = true
//        self.addCloseButton()
//        
//        let img = photoAnchorImageView.image
//        print("\(heightInPixels) is height in pixels")
//        print("\(widthInPixels) is width in pixels")
//        var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//        material.baseColor = try! .texture(.load(contentsOf: imageAnchorURL!)) //img
//        
//        let mesh = MeshResource.generateBox(width: Float(widthInPixels) / 2000, height: Float((widthInPixels) / 2000) / 50, depth: Float(heightInPixels) / 2000)   //.generatePlane(width: 1.5, depth: 1)
//       // let imgPlane = ModelEntity(mesh: mesh, materials: [material])
//
////        material.baseColor = try! .texture(.load(named: "chanceposter"))
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        
//        self.currentEntity = planeModel
//        self.currentEntity.name = "Photo by __"
//       
//        print(self.currentEntity)
//        self.currentEntity.generateCollisionShapes(recursive: true)
//        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                    material: .default,
//                                                        mode: .dynamic)
//       // modelEntity.components.set(physics)
//        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//        let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//        print(anchor)
//        let random = self.generateRandomPhotoID(length: 20)
//        self.imageAnchorID = random
//    //    self.currentAnchor = anchor!
//       // anchor?.scale = [1.2,1.0,1.0]
//        anchor?.addChild(self.currentEntity)
//        self.sceneView.scene.addAnchor(anchor!)
//       // self.currentEntity?.scale *= self.scale
//        self.removeCloseButton()
//        ProgressHUD.dismiss()
//       // print("modelEntity for \(self.name) has been loaded.")
//        self.modelPlacementUI()
//        if !connectedToNetwork {
//            self.uploadSessionPhotoAnchor()
//            self.currentSessionAnchorIDs.append(self.imageAnchorID)
//        }
//        sceneView.removeGestureRecognizer(placeVideoRecognizer)
//        UIView.animate(withDuration: 0.6,
//            animations: {
//                self.wordsBtn.tintColor = UIColor.white
//                self.videoBtn.tintColor = UIColor.white
//            },
//            completion: { _ in
//            })
//        
//    }
//    
//    private func checkPermissions() {
//        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
//            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in () })
//        }
//        
//        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
//        } else {
//            PHPhotoLibrary.requestAuthorization(requestAuthroizationHandler)
//        }
//    }
//    
//    private func requestAuthroizationHandler(status: PHAuthorizationStatus) {
//        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
//            print("We have access to photos")
//        } else {
//            print("We dont have access to photos")
//        }
//    }
//    
//    @IBAction func videoAction(_ sender: Any) {
//       // videoTaps += 1
//        wordsTaps = 0
//       // if videoTaps % 2 == 1 {
//            isVideoMode = true
//            isTextMode = false
//            isObjectMode = false
//     //       sceneView.addGestureRecognizer(placeVid)
//           // shareImg.image = UIImage(systemName: "gearshape.fill")
//            toggleBtn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
//         //   shareImg.removeGestureRecognizer(shareRecognizer)
//        //    inputContainerView.isHidden = true
//        self.networksNear()
//           
//            textSettingsRecognizer = UITapGestureRecognizer(target: self, action: #selector(textSettings(_:)))
//            textSettingsRecognizer.delegate = self
//            shareImg.addGestureRecognizer(textSettingsRecognizer)
//            
//    //        undoTextRecognizer = UITapGestureRecognizer(target: self, action: #selector(undoText(_:)))
//    //        undoTextRecognizer.delegate = self
//    //        toggleBtn.addGestureRecognizer(undoTextRecognizer)
//            
//            print("place video where focus node is")
//            
//            self.checkPermissions()
//            self.imagePicker.sourceType = .photoLibrary
//            self.imagePicker.mediaTypes = ["public.image", "public.movie"] //maybe just images at first
//            self.imagePicker.videoQuality = .typeHigh
//            self.imagePicker.videoExportPreset = AVAssetExportPresetHEVC1920x1080
//       //     self.imagePicker.allowsEditing = true
//            self.present(self.imagePicker, animated:  true, completion:  nil)
//            
//            placeVideoRecognizer = UITapGestureRecognizer(target: self, action: #selector(anchorVideo(_:)))
//            placeVideoRecognizer.delegate = self
//            placeVid = placeVideoRecognizer
//          //  sceneView.addGestureRecognizer(placeVideoRecognizer)
//            
//            pauseVideoRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseVideo(_:)))
//            pauseVideoRecognizer.numberOfTapsRequired = 2
//            pauseVideoRecognizer.delegate = self
//        //    sceneView.addGestureRecognizer(pauseVideoRecognizer)
//    //
//    //        let scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleVideoPlayer(_:)))
//    //        self.sceneView.addGestureRecognizer(scaleGesture)
//            
//            UIView.animate(withDuration: 0.6,
//                animations: {
//                   // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
//                    self.wordsBtn.tintColor = UIColor.white
//                    self.videoBtn.tintColor = UIColor.systemYellow
//                },
//                completion: { _ in
//    //                UIView.animate(withDuration: 0.6) {
//    //                    self.wordsBtn.transform = CGAffineTransform.identity
//    //                }
//                })
//        }
////        else {
////            isVideoMode = false
////            isTextMode = false
////            isObjectMode = false
////            sceneView.addGestureRecognizer(placeVid)
////           // shareImg.image = UIImage(systemName: "gearshape.fill")
////            toggleBtn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
////         //   shareImg.removeGestureRecognizer(shareRecognizer)
////        //    inputContainerView.isHidden = true
////            networksNearImg.isHidden = false
////
//////            textSettingsRecognizer = UITapGestureRecognizer(target: self, action: #selector(textSettings(_:)))
//////            textSettingsRecognizer.delegate = self
////            shareImg.removeGestureRecognizer(textSettingsRecognizer)
////
////    //        undoTextRecognizer = UITapGestureRecognizer(target: self, action: #selector(undoText(_:)))
////    //        undoTextRecognizer.delegate = self
////    //        toggleBtn.addGestureRecognizer(undoTextRecognizer)
////
////            print("place video where focus node is")
////
//////            placeVideoRecognizer = UITapGestureRecognizer(target: self, action: #selector(anchorVideo(_:)))
//////            placeVideoRecognizer.delegate = self
//////            placeVid = placeVideoRecognizer
////            sceneView.removeGestureRecognizer(placeVideoRecognizer)
////
////            sceneView.removeGestureRecognizer(pauseVideoRecognizer)
////    //
////    //        let scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleVideoPlayer(_:)))
////    //        self.sceneView.addGestureRecognizer(scaleGesture)
////
////            UIView.animate(withDuration: 0.6,
////                animations: {
////                   // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
////                    self.wordsBtn.tintColor = UIColor.white
////                    self.videoBtn.tintColor = UIColor.white
////                },
////                completion: { _ in
////    //                UIView.animate(withDuration: 0.6) {
////    //                    self.wordsBtn.transform = CGAffineTransform.identity
////    //                }
////                })
////        }
//        
//  //  }
//    
//    var likeTaps = 0
//    
//    @IBAction func likeAction(_ sender: Any) {
//        likeTaps += 1
//        if likeTaps % 2 == 0 {
//            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
//           // likeBtn.tintColor = .systemYellow
//        } else {
//            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//    }
//    
//    @objc func removeAllModels(_ sender: UITapGestureRecognizer){
//        if sceneManager.anchorEntities.count != 0{
//            let last = self.sceneManager.anchorEntities.last
//            last?.removeFromParent()
//            sceneManager.anchorEntities.removeLast()
//            let lastID = self.currentSessionAnchorIDs.last
//            print("\(lastID) is last ID")
//            let docRef = self.db.collection("sessionAnchors").document(lastID ?? "")
//            docRef.delete()
//            self.currentSessionAnchorIDs.removeLast()
//            if self.entityName.isHidden == false {
//                self.networkBtn.isHidden = false
//                self.wordsBtn.isHidden = false
//                self.videoBtn.isHidden = false
//                self.buttonStackView.isHidden = false
//               // self.networksNearImg.isHidden = false
//                self.networksNear()
//                self.placementStackView.isHidden = true
//                self.anchorInfoStackView.isHidden = true
//                self.anchorSettingsImg.isHidden = true
//                self.entityName.isHidden = true
//                self.entityProfileBtn.isHidden = true
//                self.anchorUserImg.isHidden = true
//            }
//            updateEditCount()
//        } else {
//            return
//        }
//       
//    }
//    
//    @objc func undoText(_ sender: UITapGestureRecognizer){
////        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) -> Void in
////            node.removeFromParentNode()
////        }
//    }
//    
//    @objc func textSettings(_ sender: UITapGestureRecognizer){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let settingsViewController = storyboard.instantiateViewController(withIdentifier: "TextSettingsViewController") as? TextSettingsViewController else {
//            return
//        }
//        
//        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSettings))
//        settingsViewController.navigationItem.rightBarButtonItem = barButtonItem
//        settingsViewController.title = "Text Settings"
//        
//        let navigationController = UINavigationController(rootViewController: settingsViewController)
//        navigationController.modalPresentationStyle = .popover
//        navigationController.popoverPresentationController?.delegate = self
//        navigationController.preferredContentSize = CGSize(width: sceneView.bounds.size.width - 20, height: sceneView.bounds.size.height - 400)
//        self.present(navigationController, animated: true, completion: nil)
//        
//        navigationController.popoverPresentationController?.sourceView = shareImg
//        navigationController.popoverPresentationController?.sourceRect = shareImg.bounds
//    }
//    
//    @objc func browseVC(_ sender: UITapGestureRecognizer){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let settingsViewController = storyboard.instantiateViewController(withIdentifier: "BrowseVC") as? BrowseViewController else {
//            return
//        }
//        
//        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissBrowse))
//        settingsViewController.navigationItem.rightBarButtonItem = barButtonItem
//        settingsViewController.title = "Browse"
//        
//        let navigationController = UINavigationController(rootViewController: settingsViewController)
//        navigationController.modalPresentationStyle = .popover
//        navigationController.popoverPresentationController?.delegate = self
//        navigationController.preferredContentSize = CGSize(width: sceneView.bounds.size.width - 20, height: sceneView.bounds.size.height - 200)
//        self.present(navigationController, animated: true, completion: nil)
//        
//        navigationController.popoverPresentationController?.sourceView = actionBtn
//        navigationController.popoverPresentationController?.sourceRect = actionBtn.bounds
//    }
//    
//    @objc
//    func dismissSettings() {
//        self.dismiss(animated: true, completion: nil)
//       // updateSettings()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//      //  checkCameraAccess()
//       // networkBtn.setImage(networkBtnImg, for: .normal)// .imageView?.image = networkBtnImg
//        if defaults.bool(forKey: "isCreatingNetwork") == false {
//            
//            progressView?.isHidden = true
//            feedbackControl?.isHidden = true
//            anchorUserImg.isHidden = true
//            anchorInfoStackView.isHidden = true
//   //         anchorSettingsImg.isHidden = true
//            
//        } else {
//            progressView?.isHidden = false
//            feedbackControl?.isHidden = false
//            videoBtn.tintColor = .white
//            scanningUI()
//            if defaults.bool(forKey: "finishedNetworkWalkthrough") == false {
//                self.walkthroughView.isHidden = false
//                self.walkthroughLabel.backgroundColor = .systemBlue
//                self.walkthroughLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//                self.walkthroughLabel.textColor = .white
//                self.walkthroughLabel.numberOfLines = 0
//                self.walkthroughLabel.clipsToBounds = true
//                self.walkthroughLabel.textAlignment = .center
//                self.walkthroughLabel.layer.cornerRadius = 8
//                self.walkthroughViewLabel.text = "1 of 4"
//                self.walkthroughLabel.frame = CGRect(x: 45, y: 540, width: UIScreen.main.bounds.width - 90, height: 70)
//                self.walkthroughLabel.text = "Scan your surroundings to 100% so Blueprint can localize you and remember placement."
//                self.view.addSubview(walkthroughLabel)
//                
//                self.buttonStackViewBottomConstraint.constant = -140
//                self.continueNetworkWalkthroughButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 130, y: 5, width: 110, height: 35))
//                self.continueNetworkWalkthroughButton.backgroundColor = .systemBlue// UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
//                self.continueNetworkWalkthroughButton.setTitle("Continue", for: .normal)
//                self.continueNetworkWalkthroughButton.setTitleColor(.white, for: .normal)
//                self.continueNetworkWalkthroughButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//                self.continueNetworkWalkthroughButton.layer.cornerRadius = 6
//                self.continueNetworkWalkthroughButton.clipsToBounds = true
//                self.continueNetworkWalkthroughButton.isUserInteractionEnabled = true
//                self.continueNetworkWalkthroughButton.addTarget(self, action: #selector(continueNetworkWalkthrough), for: .touchUpInside)
//                self.walkthroughView.addSubview(continueNetworkWalkthroughButton)
//                self.view.addSubview(walkthroughView)
//            }
//        }
//       
//        
//    }
//    
//   
//    
//
//    
//    @objc func dismissBrowse() {
//        self.dismiss(animated: true, completion: nil)
//        networksNearImg.isHidden = true
//        networkBtn.setImage(UIImage(named: "guitarpbr"), for: .normal)
//      //  networkBtn.imageView?.image?. = .as
//        }
//    
//    var currentEntity = ModelEntity()
//    
//    var selectedModel : Model?
//    var currentAnchor = AnchorEntity()
//    
//    func updateEditCount(){
//        if sceneManager.anchorEntities.count == 0{
//           // numberOfEditsImg.image = UIImage(systemName: "1.circle.fill")
//            numberOfEditsImg.isHidden = true
//            saveButton.isHidden = true
//      //      addButton.isHidden = false
//            sceneInfoButton.isHidden = true
//        } else if sceneManager.anchorEntities.count == 1{
//            numberOfEditsImg.image = UIImage(systemName: "1.circle.fill")
//         //   numberOfEditsImg.isHidden = false
//          //  saveButton.isHidden = false
//            addButton.isHidden = true
//    //        sceneInfoButton.isHidden = false
//        } else if sceneManager.anchorEntities.count == 2 {
//            numberOfEditsImg.image = UIImage(systemName: "2.circle.fill")
//        } else if sceneManager.anchorEntities.count == 3 {
//            numberOfEditsImg.image = UIImage(systemName: "3.circle.fill")
//        } else if sceneManager.anchorEntities.count == 4 {
//            numberOfEditsImg.image = UIImage(systemName: "4.circle.fill")
//        } else if sceneManager.anchorEntities.count == 5 {
//            numberOfEditsImg.image = UIImage(systemName: "5.circle.fill")
//        } else if sceneManager.anchorEntities.count == 6 {
//            numberOfEditsImg.image = UIImage(systemName: "6.circle.fill")
//        } else if sceneManager.anchorEntities.count == 7 {
//            numberOfEditsImg.image = UIImage(systemName: "7.circle.fill")
//        } else if sceneManager.anchorEntities.count == 8 {
//            numberOfEditsImg.image = UIImage(systemName: "8.circle.fill")
//        } else if sceneManager.anchorEntities.count == 9 {
//            numberOfEditsImg.image = UIImage(systemName: "9.circle.fill")
//        } else {
//            return
//        }
//    }
//    
//    var connectedToNetwork = false
//    var showedUI = false
//    
//    @objc func connectedNetworkUI(_ sender: UITapGestureRecognizer){
//        connectedNetworkImg.image = UIImage(systemName: "xmark")
//        connectedNetworkImg.isHidden = false
//        connectedNetworkImg.isUserInteractionEnabled = true
//        connectedNetworkImg.alpha = 1
//        numberOfEditsImg.isHidden = true
//        saveButton.isHidden = true
//        undoButton.isHidden = true
//        hideUI()
//        searchBtn.isHidden = true
//        connectedToNetwork = true
//        let hostImg = UIImageView()
//        hostImg.frame = CGRect(x: UIScreen.main.bounds.width - 56, y: 64, width: 36, height: 36)
//        hostImg.clipsToBounds = true
//        hostImg.layer.cornerRadius = 18
//        hostImg.image = UIImage(named: "meandryan")
//        hostImg.contentMode = .scaleAspectFill
//        hostImg.alpha = 1
//        hostImg.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(goToNetworkSettings(_:)))
//        tap.delegate = self
//        hostImg.addGestureRecognizer(tap)
//        sceneView.addSubview(hostImg)
//        if showedUI == false {
//            showLoadingNetwork()
//            showedUI = true
//        }
//        focusEntity?.removeFromParent()
//        let back = UITapGestureRecognizer(target: self, action: #selector(setupBackUI)) //backAction(_:)
//        back.delegate = self
//        connectedNetworkImg.addGestureRecognizer(back)
//
//        let delay = 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//            self.connectedNetworkImg.fadeOut(duration: 4)
//            hostImg.fadeOut(duration: 4)
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.connectedNetworkUI(_:)))
//            tap.numberOfTapsRequired = 1
//            tap.delegate = self
//            self.sceneView.addGestureRecognizer(tap)
//
//        }
//    }
//    
//    func showLoadingNetwork(){
//        ProgressHUD.show("Connecting...") //maybe activity indicator instead of progresshud
//        let delay = 2
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//            ProgressHUD.dismiss()
//        }
//    }
//    
//    func checkScale(){
//        walkthroughLabel.removeFromSuperview()
//        if currentEntity.scale != SIMD3<Float>(0.85,0.75,0.75) {
//            let defaults = UserDefaults.standard
//            defaults.set(true, forKey: "fifth")
//            self.walkthroughLabel.frame = CGRect(x: 45, y: 540, width: UIScreen.main.bounds.width - 90, height: 70)
//            self.walkthroughLabel.text = "Great, now tap and hold on the asset until the asset’s name appears"
//            self.sceneView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "6 of 18"
//            self.currentEntity.generateCollisionShapes(recursive: false)
//         //   self.sceneView.installGestures([.scale], for: self.currentEntity)
//        }
//    }
//    
//    @IBAction func confirmAction(_ sender: Any) {
//        let defaults = UserDefaults.standard
//        
//        if defaults.bool(forKey: "fifth") == false && defaults.bool(forKey: "finishedWalkthrough") == false {
//            defaults.set(true, forKey: "fourth")
//            walkthroughLabel.removeFromSuperview()
//            circle.removeFromSuperview()
//            self.walkthroughLabel.frame = CGRect(x: 25, y: 540, width: UIScreen.main.bounds.width - 50, height: 80)
//            self.walkthroughLabel.text = "Use a 2-finger pinch on the asset to change its size (when selected, you can also change it’s rotation/orientation and location)"
//            self.sceneView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "5 of 18"
//            let delay = 6
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//                self.checkScale()
////                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(2))) {
////                    self.checkScale()
////                }
//            }
//            
//            
//        }
//        if defaults.bool(forKey: "tenth") == false && defaults.bool(forKey: "eighth") == true  && defaults.bool(forKey: "finishedWalkthrough") == false {
//         defaults.set(true, forKey: "ninth")
//            
//             circle.frame = CGRect(x: 9, y: 45, width: 50, height: 50)
//
//             circle.layer.cornerRadius = (circle.frame.height) / 2
//
//          //  circle.frame =   CGRect(x: searchBtn.frame.minX - 5, y: searchBtn.frame.minY - 5, width: 50, height: 50)
//        circle.backgroundColor = .clear
//       // circle.layer.cornerRadius = 25
//        circle.clipsToBounds = true
//        circle.layer.borderColor = UIColor.systemBlue.cgColor
//        circle.layer.borderWidth = 4
//        circle.isUserInteractionEnabled = false
//        circle.alpha = 1.0
//            // sceneView.addSubview(circle)
//            
//        self.walkthroughLabel.frame = CGRect(x: 35, y: 140, width: UIScreen.main.bounds.width - 70, height: 60)
//        self.walkthroughLabel.text = "Now let’s add another asset"
//            self.sceneView.addSubview(self.walkthroughLabel)
//
//        let delay = 1
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//            //self.topView.addSubview(self.circle)
//            self.walkthroughViewLabel.text = "10 of 18"
//           
//            UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                self.circle.alpha = 0.1
//                   })
//        }
//        }
//        
//     //   let defaults = UserDefaults.standard
//        
//        
//        if defaults.bool(forKey: "thirteenth") == false && defaults.bool(forKey: "eleventh") == true && defaults.bool(forKey: "finishedWalkthrough") == false {
//            defaults.set(true, forKey: "twelvth")
//            walkthroughLabel.removeFromSuperview()
//            circle.removeFromSuperview()
//            
//            circle.frame = CGRect(x: 110, y: 47, width: 90, height: 45)
//            circle.backgroundColor = .clear
//            circle.layer.cornerRadius = 22.5
//            circle.clipsToBounds = true
//            circle.layer.borderColor = UIColor.systemBlue.cgColor
//            circle.layer.borderWidth = 4
//            circle.isUserInteractionEnabled = false
//            circle.alpha = 1.0
//
//            self.walkthroughLabel.frame = CGRect(x: 35, y: 120, width: UIScreen.main.bounds.width - 70, height: 60)
//            self.walkthroughLabel.text = "Click Preview to see what your designs look like without UI"
//            self.sceneView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "13 of 18"
//            let delay = 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//                //self.topView.addSubview(self.circle)
//                //self.walkthroughViewLabel.text = "10 of 18"
//               
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                })}
//
//
//        }
//        if anchorSettingsImg.isHidden != false {
//            let anchor = AnchorEntity(plane: .any)// self.focusEntity?.anchor // AnchorEntity(world: [0,-0.2,0])
//            
//            self.currentlyPlacingAnchor = true
//            print(anchor)
//            print("\(anchor.position) is anchor posi")
//            anchor.addChild(currentEntity)
//            
//            print("\(anchor.orientation) is the anchor orientation")
//            print("\(currentEntity.scale) is the entity scale")
//            
//            self.sceneView.scene.addAnchor(anchor)
//            
//            anchor.setOrientation(simd_quatf(ix: 0, iy: 0, iz: 0, r: 0), relativeTo: focusEntity)
//            let anchorLocation = anchor.transform.matrix // anchor.transform // focusEntity?.position
//            self.createLocalAnchor(anchorLocation: anchorLocation)
//            self.sceneManager.anchorEntities.append(anchor)
//            
//            print("\(anchor.orientation) is the new anchor orientation")
//            print("\(currentEntity.scale) is the search entity scale")
//            
//            if (enoughDataForSaving && localAnchor != nil) { //currentlyPlacingAnchor &&
//        //        self.createCloudAnchor()
//            }
//            //  self.createCloudAnchor()
//            let mass = PhysicsMassProperties(mass: 80)
//            
//            let physics = PhysicsBodyComponent(massProperties: mass,
//                                               material: .default,
//                                               mode: .kinematic)
//            currentEntity.components.set(physics)
//            
//            //   currentEntity.components.set(mass)
//            
//            //  currentEntity.physicsBody = physics
//            
//            // let modelAnchor = ModelAnchor(model: selectedModel!, anchor: nil)
//            let modelAnchor = ModelAnchor(model: currentEntity, anchor: nil)
//            
//            self.modelsConfirmedForPlacement.append(modelAnchor)
//            print("\(modelsConfirmedForPlacement.count) is the count of count of models placed")
//            print("\(modelsConfirmedForPlacement.description) is the description of models placed")
//            updateEditCount()
//            undoButton.image = UIImage(systemName: "arrow.counterclockwise")
//            undoButton.isHidden = false
//            undoButton.tintColor = .white
//            //    sceneView.addSubview(undoButton)
//            let id = String(self.currentEntity.id)
//            if !connectedToNetwork {
//                self.uploadSessionModelAnchor()
//                self.currentSessionAnchorIDs.append(id)
//            }
//            
//            if undoButton.isHidden == false {
//                //    wordsBtnTopConstraint.constant = 60
//   //             self.sceneInfoButton.isHidden = false
//            } else {
//                //   wordsBtnTopConstraint.constant = 11
//                self.sceneInfoButton.isHidden = true
//            }
//            
//            if objectInfoView.isHidden == false {
//                objectInfoView.isHidden = true
//                // objectInfoView.layer.opacity = 0
//            }
//            
//            let component = ModelDebugOptionsComponent(visualizationMode: .none)
//            selectedEntity?.modelDebugOptions = component
//            
//            self.updatePersistanceAvailability(for: sceneView)
//            searchBar.isHidden = true
//            entityName.isHidden = true
//            entityProfileBtn.isHidden = true
//            placementStackBottomConstraint.constant = 15
//            //      //topview.isHidden = false
//            searchView.isHidden = true
//            self.newSearchView.isHidden = true
//            networkBtn.isHidden = false
//            profileButton.isHidden = false
//            editUnderView.isHidden = false
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//           // networksNearImg.isHidden = false
//            searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//            betweenView.isHidden = false
//            //   searchBar.isHidden = false
//            editUnderView.isHidden = false
//            //
//            //
//            networkBtn.isHidden = false
//            profileButton.isHidden = false
//            editUnderView.isHidden = false
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//           // networksNearImg.isHidden = false
//            self.networksNear()
//            editButton.isHidden = false
//            previewButton.isHidden = false
//            duplicateBtn.isHidden = true
//            //  shareImg.isHidden = false
//            placementStackView.isHidden = true
//            //  searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//            //  toggleBtn.isHidden = false
//            searchBtn.isHidden = false
//            //networkBtn.setImage(UIImage(systemName: "icloud.and.arrow.up.fill"), for: .normal)
//            // networksNearImg.isHidden = false
//            // networksNearImg.tintColor = .systemYellow
//            //      numberOfEditsImg.isHidden = false
//            //     saveButton.isHidden  = false
//            self.sceneView.addGestureRecognizer(doubleTap)
//            self.sceneView.addGestureRecognizer(holdGesture)
//        } else {
//            networkBtn.isHidden = false
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//         //   networksNearImg.isHidden = false
//            self.networksNear()
//            placementStackView.isHidden = true
//            anchorInfoStackView.isHidden = true
//            anchorSettingsImg.isHidden = true
//            entityName.isHidden = true
//            entityProfileBtn.isHidden = true
//            anchorUserImg.isHidden = true
//            self.sceneView.addGestureRecognizer(doubleTap)
//            self.sceneView.addGestureRecognizer(holdGesture)
//        }
//        }
//    
//    
//    @IBAction func cancelAction(_ sender: Any) {
//        placementStackView.isHidden = true
//        
//       
//        shareImg.isHidden = false
//        toggleBtn.isHidden = false
//    }
//    
//    @objc func objectInfoCancel(_ sender: UITapGestureRecognizer){
//        placementStackView.isHidden = true
//        placementStackBottomConstraint.constant = 15
//        objectInfoView.isHidden = true
//        entityName.isHidden = true
//        entityProfileBtn.isHidden = true
//     //   //topview.isHidden = false
//        self.searchBar.isHidden = true
//        searchStackView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchView.isHidden = true
//        self.newSearchView.isHidden = true
//        editButton.isHidden = false
//        previewButton.isHidden = false
//        searchBtn.isHidden = false
//        betweenView.isHidden = false
//        networkBtn.isHidden = false
//        networksNearImg.isHidden = false
//        profileButton.isHidden = false
//        editUnderView.isHidden = false
//        self.wordsBtn.isHidden = false
//        self.videoBtn.isHidden = false
//      //  saveButton.isHidden = false
//        undoButton.isHidden = false
//      //  numberOfEditsImg.isHidden = false
//        
//    }
//    
//    @objc func setupBackUI(){
//        if connectedToNetwork {
//            let alert = UIAlertController(title: "Disconnect from Network?", message: "Are you sure you want to disconnect from the current Blueprint Network?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
//                self.connectedToNetwork = false
//          //      //self.topView.isHidden = false
//                self.searchView.isHidden = true
//                self.newSearchView.isHidden = true
//                self.networksNearImg.isHidden = false
//                self.networkBtn.isHidden = false
//                self.editButton.isHidden = false
//                self.previewButton.isHidden = false
//                self.editUnderView.isHidden = false
//                self.wordsBtn.isHidden = false
//                self.videoBtn.isHidden = false
//                self.previewUnderView.isHidden = true
//                self.connectedNetworkImg.isHidden = true
//              //  sceneView.addSubview(focusEntity!)
//                self.focusEntity = FocusEntity(on: self.sceneView, focus: .classic)
//                if self.sceneManager.anchorEntities.count > 0 {
//            //        self.saveButton.isHidden = false
//                    self.undoButton.isHidden = false
//           //         self.numberOfEditsImg.isHidden = false
// //                   self.sceneInfoButton.isHidden = false
//                } else {
//                    self.saveButton.isHidden = true
//                    self.undoButton.isHidden = true
//                    self.numberOfEditsImg.isHidden = true
//                    self.sceneInfoButton.isHidden = true
//                }
//            })
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
//                //completionHandler(false)
//                self.wordsBtn.isHidden = false
//                self.videoBtn.isHidden = false
//                self.buttonStackView.isHidden = false
//                self.networkBtn.isHidden = false
//                self.networksNearImg.isHidden = false
//                return
//            })
//            present(alert, animated: true)
//        } else {
//            recordView.isHidden = true
//            recordAroundView.isHidden = true
//            cameraImg.isHidden = true
//            //topview.isHidden = true
//            self.categoryScrollView.isHidden = true
//            searchView.isHidden = true
//            self.newSearchView.isHidden = true
//           // networksNearImg.isHidden = false
//            self.networkBtn.isHidden = false
//            editButton.isHidden = true
//            addButton.isHidden = true
//            self.dismissKeyboard()
//  //          self.browseTableView.isHidden = true
//            self.buttonStackView.isHidden = false
//            previewButton.isHidden = true
//            editUnderView.isHidden = true
//            self.wordsBtn.isHidden = false
//            self.videoBtn.isHidden = false
//            previewUnderView.isHidden = true
//            connectedNetworkImg.isHidden = true
//            self.networksNear()
//            self.focusEntity = FocusEntity(on: self.sceneView, focus: .classic)
//            if self.sceneManager.anchorEntities.count > 0 {
//          //      saveButton.isHidden = false
//                undoButton.isHidden = false
//   //             addButton.isHidden = true
//           //     numberOfEditsImg.isHidden = false
//  //              sceneInfoButton.isHidden = false
//            } else {
//                saveButton.isHidden = true
//    //            addButton.isHidden = false
//                undoButton.isHidden = true
//                numberOfEditsImg.isHidden = true
//                sceneInfoButton.isHidden = true
//            }
//            }
//    }
//    
//    @objc func backAction(_ sender: UITapGestureRecognizer){
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: "fourteenth")
//        walkthroughLabel.removeFromSuperview()
//        circle.removeFromSuperview()
//        if defaults.bool(forKey: "fifteenth") == false && defaults.bool(forKey: "finishedWalkthrough") == false {
//            circle.frame = CGRect(x: 30, y: 683, width: 70, height: 70)
//            circle.backgroundColor = .clear
//            circle.layer.cornerRadius = 35
//            circle.clipsToBounds = true
//            circle.layer.borderColor = UIColor.systemBlue.cgColor
//            circle.layer.borderWidth = 4
//            circle.isUserInteractionEnabled = false
//            circle.alpha = 1.0
//                // sceneView.addSubview(circle)
//            self.walkthroughLabel.frame = CGRect(x: 30, y: 590, width: UIScreen.main.bounds.width - 60, height: 60)
//            self.walkthroughLabel.text = "Now you can save the Network by tapping the Save button in the bottom left corner"
//            self.sceneView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "15 of 18"
//            
//            let delay = 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//                self.sceneView.addSubview(self.circle)
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//
//            }
//        }
//        
//        if connectedToNetwork {
//            let alert = UIAlertController(title: "Disconnect from Network?", message: "Are you sure you want to disconnect from the current Blueprint Network?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
//                self.connectedToNetwork = false
//     //           //self.topView.isHidden = false
//                self.searchView.isHidden = true
//                self.newSearchView.isHidden = true
//                self.networksNearImg.isHidden = false
//                self.editButton.isHidden = false
//                self.previewButton.isHidden = false
//                self.editUnderView.isHidden = false
//                self.wordsBtn.isHidden = false
//                self.videoBtn.isHidden = false
//                self.previewUnderView.isHidden = true
//                self.connectedNetworkImg.isHidden = true
//              //  sceneView.addSubview(focusEntity!)
//                self.focusEntity = FocusEntity(on: self.sceneView, focus: .classic)
//                if self.sceneManager.anchorEntities.count > 0 {
//               //     self.saveButton.isHidden = false
//                    self.undoButton.isHidden = false
//                //    self.numberOfEditsImg.isHidden = false
//   //                 self.sceneInfoButton.isHidden = false
//                } else {
//                    self.saveButton.isHidden = true
//                    self.undoButton.isHidden = true
//                    self.numberOfEditsImg.isHidden = true
//                    self.sceneInfoButton.isHidden = true
//                }
//            })
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
//                //completionHandler(false)
//                self.wordsBtn.isHidden = false
//                self.videoBtn.isHidden = false
//                self.buttonStackView.isHidden = false
//                self.networkBtn.isHidden = false
//                self.networksNearImg.isHidden = false
//                return
//            })
//            present(alert, animated: true)
//        } else {
//            recordView.isHidden = true
//            recordAroundView.isHidden = true
//            cameraImg.isHidden = true
//       //     //topview.isHidden = false
//            self.categoryScrollView.isHidden = true
//            searchView.isHidden = true
//            self.newSearchView.isHidden = true
//            networksNearImg.isHidden = false
//            editButton.isHidden = false
//      //      addButton.isHidden = false
//            previewButton.isHidden = false
//            editUnderView.isHidden = false
//            self.wordsBtn.isHidden = false
//            self.videoBtn.isHidden = false
//            previewUnderView.isHidden = true
//            connectedNetworkImg.isHidden = true
//            self.focusEntity = FocusEntity(on: self.sceneView, focus: .classic)
//            if self.sceneManager.anchorEntities.count > 0 {
//             //   saveButton.isHidden = false
//                undoButton.isHidden = false
//                addButton.isHidden = true
//          //      numberOfEditsImg.isHidden = false
// //               sceneInfoButton.isHidden = false
//            } else {
//                saveButton.isHidden = true
//      //          addButton.isHidden = false
//                undoButton.isHidden = true
//                numberOfEditsImg.isHidden = true
//                sceneInfoButton.isHidden = true
//            }
//            }
//    }
//    
//    func updateNetworkImg() {
//        networkBtn.setImage(networkBtnImg, for: .normal)
//    }
//    
//    @objc func viewNetworks(){
//        let storyboard = UIStoryboard(name: "Networks", bundle: nil)
//        var next = storyboard.instantiateViewController(withIdentifier: "NetworksNearVC") as! NetworksNearTableViewController
//       // next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        var next = storyboard.instantiateViewController(withIdentifier: "NewUIVC") as! NewUIViewController
////        next.modalPresentationStyle = .fullScreen
////        self.present(next, animated: true, completion: nil)
//    }
//    
//    @IBAction func networkAction(_ sender: Any) {
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: "finishedWalkthrough")
//        walkthroughLabel.removeFromSuperview()
//        circle.removeFromSuperview()
//        walkthroughView.isHidden = true
//        walkthroughViewLabel.isHidden = true
//        UIView.animate(withDuration: 0.6,
//            animations: {
//               // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
//                self.wordsBtn.tintColor = UIColor.white
//                self.videoBtn.tintColor = UIColor.white
//            },
//            completion: { _ in
//                self.isTextMode = false
//                self.isVideoMode = false
//                self.isObjectMode = false
//            })
//        viewNetworks()
//        
//        }
//    
//    
//    let cameraImg = UIImageView(frame: CGRect(x: 280, y: 738, width: 50, height: 50))
//    let recordView = UIView(frame: CGRect(x: (UIScreen.main.bounds.width * 0.5) - 40, y: 723, width: 80, height: 80))
//    let recordAroundView = UIView(frame: CGRect(x: (UIScreen.main.bounds.width * 0.5) - 46, y: 717, width: 92, height: 92))
//    
//    @IBAction func previewAction(_ sender: Any) {
////        sceneManager.shouldLoadSceneToSystem = true
////        self.updatePersistanceAvailability(for: sceneView)
////        self.handlePersistence(for: sceneView)
////        print("\(sceneManager.persistenceURL) is persist url")
////        print("\(String(describing: sceneManager.scenePersistenceData)) is persist data")
//
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: "thirteenth")
//        walkthroughLabel.removeFromSuperview()
//        circle.removeFromSuperview()
//        if defaults.bool(forKey: "fourteenth") == false && defaults.bool(forKey: "finishedWalkthrough") == false {
//            circle.frame = CGRect(x: 12.5, y: 60, width: 45, height: 45)
//            circle.backgroundColor = .clear
//            circle.layer.cornerRadius = 22.5
//            circle.clipsToBounds = true
//            circle.layer.borderColor = UIColor.systemBlue.cgColor
//            circle.layer.borderWidth = 4
//            circle.isUserInteractionEnabled = false
//            circle.alpha = 1.0
//                // sceneView.addSubview(circle)
//            self.walkthroughLabel.frame = CGRect(x: 30, y: 120, width: UIScreen.main.bounds.width - 60, height: 60)
//            self.walkthroughLabel.text = "Now, click the back button so we can save this Blueprint Network"
//            self.sceneView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "14 of 18"
//
//            let delay = 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//                self.sceneView.addSubview(self.circle)
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//
//            }
//        }
//
//        previewUnderView.isHidden = false
//        editUnderView.isHidden = true
//        self.wordsBtn.isHidden = true
//            //        self.categoryScrollView.isHidden = true
//        self.videoBtn.isHidden = true
//        addButton.isHidden = true
//        sceneInfoButton.isHidden = true
//        hideUI()
//        focusEntity?.removeFromParent()
//        saveButton.isHidden = true
//        self.progressView?.isHidden = true
//        undoButton.isHidden = true
//        numberOfEditsImg.isHidden = true
//        connectedNetworkImg.image = UIImage(systemName: "arrow.left")
//        connectedNetworkImg.isHidden = false
//        let back = UITapGestureRecognizer(target: self, action: #selector(setupBackUI)) //backAction(_:)
//        back.delegate = self
//        connectedNetworkImg.addGestureRecognizer(back)
//
//        cameraImg.image = UIImage(systemName: "camera.circle.fill")
//        cameraImg.tintColor = .white
//        cameraImg.isUserInteractionEnabled = true
//       // cameraImg.backgroundColor = .def
//        cameraImg.layer.cornerRadius = 25
//        cameraImg.clipsToBounds = true
//
//        recordView.layer.cornerRadius = 40
//        recordView.backgroundColor = .red
//
//       // recordAroundView.backgroundColor = .white
//        recordAroundView.layer.borderColor = UIColor.white.cgColor
//        recordAroundView.layer.borderWidth = 4
//        recordAroundView.layer.cornerRadius = 46
////        recordAroundView.translatesAutoresizingMaskIntoConstraints = false
////        recordAroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(takePhoto(_:)))
//        cameraImg.addGestureRecognizer(cameraTap)
//
//        cameraImg.isHidden = false
//        recordView.isHidden = false
//        recordAroundView.isHidden = false
//        sceneView.addSubview(cameraImg)
//        sceneView.addSubview(recordView)
//        sceneView.addSubview(recordAroundView)
//    }
//    
//    
//    
//    @objc func takePhoto(_ sender: UITapGestureRecognizer){
//        sceneView.snapshot(saveToHDR: false) { (image) in
//          
//          // Compress the image
//          let compressedImage = UIImage(data: (image?.pngData())!)
//          // Save in the photo album
//          UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
//        }}
//    
//    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//
//        if let error = error {
//            print("Error Saving ARKit Scene \(error)")
//        } else {
//            print("ARKit Scene Successfully Saved")
//        }
//    }
//    
//    @IBAction func editAction(_ sender: Any) {
//        previewUnderView.isHidden = true
//        editUnderView.isHidden = false
//    }
//    
//    @IBAction func action(_ sender: Any) {
//        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrowseVC") as! BrowseViewController
//      //  vc.view.backgroundColor = .clear
//        vc.modalPresentationStyle = .popover
//        
//
//        self.present(vc, animated: true, completion: nil)
//    }
//    
//    
//    @IBAction func settingsAction(_ sender: Any) {
//        
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = storyboard.instantiateViewController(withIdentifier: "HomeTableVC") as! HomeTableViewController
//        // next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        // "pvQWkfc9iOOuJ6pKNXiM"
//    }
//    
//    var creatorUid = ""
//    
//    @objc func anchorUserProfile(){
//        let user = self.creatorUid
//        
//        let vc = UserProfileViewController.instantiate(with: user) //(user:user)
//        let navVC = UINavigationController(rootViewController: vc)
//       // var next = UserProfileViewController.instantiate(with: user)
//       //  navVC.modalPresentationStyle = .fullScreen
//      //  self.navigationController?.pushViewController(next, animated: true)
//        present(navVC, animated: true)
//    }
//    
//    @objc func goToProfile(_ sender: UITapGestureRecognizer){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//      //  let modelUid = "6CwMVBiRJob46q4gR5VV" // modelId1
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//   //     self.navigationController?.pushViewController(ObjectProfileViewController.instantiate(with: modelUid), animated: true)
//        self.present(next, animated: true, completion: nil)
////        next.modalPresentationStyle = .fullScreen
////        navigationController!.isNavigationBarHidden = true
////        navigationController!.pushViewController(next, animated: true)
//        
////        let defaults = UserDefaults.standard
////        defaults.set(true, forKey: "seventh")
////        walkthroughLabel.removeFromSuperview()
////        circle.removeFromSuperview()
////
////        circle.frame = CGRect(x: 10, y: 72, width: 45, height: 45)
////        circle.backgroundColor = .clear
////        circle.layer.cornerRadius = 22.5
////        circle.clipsToBounds = true
////        circle.layer.borderColor = UIColor.systemBlue.cgColor
////        circle.layer.borderWidth = 5
////        circle.isUserInteractionEnabled = false
////        circle.alpha = 1.0
////        if defaults.bool(forKey: "eighth") == false && defaults.bool(forKey: "finishedWalkthrough") == false {
////            self.walkthroughLabel.frame = CGRect(x: 25, y: 540, width: UIScreen.main.bounds.width - 50, height: 90)
////            self.walkthroughLabel.numberOfLines = 4
////            self.walkthroughLabel.text = "Here you can see more information on an asset, including the description, cost, and who created it. Tap the back arrow to go back"
////            view.addSubview(self.walkthroughLabel)
////            self.walkthroughViewLabel.text = "8 of 18"
////            let delay = 1
////            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
////                self.view.addSubview(self.circle)
////                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
////                    self.circle.alpha = 0.1
////                       })
////            }
////        }
////
////        //let defaults1 = UserDefaults.standard
////
////        walkthroughLabel.removeFromSuperview()
////        circle.removeFromSuperview()
////
////        circle.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 37, y: 690, width: 74, height: 74)
////        circle.backgroundColor = .clear
////        circle.layer.cornerRadius = 37
////        circle.clipsToBounds = true
////        circle.layer.borderColor = UIColor.systemBlue.cgColor
////        circle.layer.borderWidth = 4
////        circle.isUserInteractionEnabled = false
////        circle.alpha = 1.0
////        if defaults.bool(forKey: "ninth") == false && defaults.bool(forKey: "seventh") == true && defaults.bool(forKey: "finishedWalkthrough") == false {
////            defaults.set(true, forKey: "eighth")
////            self.walkthroughLabel.frame = CGRect(x: 45, y: 590, width: UIScreen.main.bounds.width - 90, height: 60)
////            self.walkthroughLabel.numberOfLines = 3
////            self.walkthroughLabel.text = "Tap the checkmark button to confirm placement"
////            self.placementStackBottomConstraint.constant = 55
////            view.addSubview(self.walkthroughLabel)
////            self.walkthroughViewLabel.text = "9 of 18"
////            let delay = 1
////            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
////                self.view.addSubview(self.circle)
////                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
////                    self.circle.alpha = 0.1
////                       })
////            }
////        }
//        
//    }
//    
//    var mapProvider: MCPeerID?
//    var scanProgress = 0.0
//    
//    @objc func share(_ sender: UITapGestureRecognizer){
////        let storyboard = UIStoryboard(name: "Networks", bundle: nil)
////        var next = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareViewController
////        // next.modalPresentationStyle = .fullScreen
////        self.present(next, animated: true, completion: nil)
//        
//        sceneView.session.getCurrentWorldMap { worldMap, error in
//            guard let map = worldMap
//                else { print("Error: \(error!.localizedDescription)"); return }
//            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
//                else { fatalError("can't encode map") }
//          //  let dataIsCritical = data.priority == .critical
//            //self.multipeerSession.sendToAllPeers(data)
//           // self.multipeerSession.sendToAllPeers(data, reliably: dataIsCritical)
//        }
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
//        UIApplication.shared.isIdleTimerDisabled = true
//        locationManager = CLLocationManager()
//        // This will cause either |locationManager:didChangeAuthorizationStatus:| or
//        // |locationManagerDidChangeAuthorization:| (depending on iOS version) to be called asynchronously
//        // on the main thread. After obtaining location permission, we will set up the ARCore session.
//        locationManager?.delegate = self
//        // locationManager?.distanceFilter = 20
//        locationManager?.allowsBackgroundLocationUpdates = true
//        locationManager?.startUpdatingLocation()
//       // checkCameraAccess()
//        
//        if (self.isMovingToParent || self.isBeingPresented){
//                // Controller is being pushed on or presented.
//            }
//            else{
//                // Controller is being shown as result of pop/dismiss/unwind.
//                let defaults = UserDefaults.standard
//                self.modelUid = defaults.value(forKey: "modelUid") as! String
//                
//                if defaults.bool(forKey: "downloadContent") == true{
//                    if self.modelUid != "" {
//                        self.downloadContentFromMarketplace()
//                        defaults.set(false, forKey: "downloadContent")
//                    }
//                }
//            }
//    }
//    
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return true
//    }
//    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//    
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
//    
//    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
//        
//    }
//
//    
//    
//    /// Adds The Video Labels To The VideoNodeSK
//    func addDataToVideoNode(){
////
////        videoNode?.addVideoDataLabels()
////        videoPlayerCreated = true
//    }
//    
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        guard error is ARError else { return }
//        let errorWithInfo = error as NSError
//        let messages = [
//            errorWithInfo.localizedDescription,
//            errorWithInfo.localizedFailureReason,
//            errorWithInfo.localizedRecoverySuggestion
//        ]
//        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
//        DispatchQueue.main.async {
//            // Present an alert informing about the error that has occurred.
//            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
//            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
//                alertController.dismiss(animated: true, completion: nil)
//                //self.resetButtonPressed(self)
//            }
//            alertController.addAction(restartAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        
//        
//    }
//    
//    
//    
//    func placeModel(_ modelEntity: ModelEntity, in arView: ARView){
//        
//        
//        let clonedEntity = modelEntity.clone(recursive: true)
//        clonedEntity.generateCollisionShapes(recursive: true)
//        arView.installGestures([.translation, .rotation, .scale], for: clonedEntity)
//        
//    
//        let anchorEntity = AnchorEntity(plane: .any)
//        anchorEntity.addChild(clonedEntity)
//        sceneView.scene.addAnchor(anchorEntity)
//        
//    }
//        
//    func model(for classification: ARMeshClassification) -> ModelEntity {
//        // Return cached model if available
//        if let model = modelsForClassification[classification] {
//            model.transform = .identity
//            return model.clone(recursive: true)
//        }
//        
//        // Generate 3D text for the classification
//        let lineHeight: CGFloat = 0.05
//        let font = MeshResource.Font.systemFont(ofSize: lineHeight)
//        let textMesh = MeshResource.generateText(classification.description, extrusionDepth: Float(lineHeight * 0.1), font: font)
//        let textMaterial = SimpleMaterial(color: classification.color, isMetallic: true)
//        let model = ModelEntity(mesh: textMesh, materials: [textMaterial])
//        // Move text geometry to the left so that its local origin is in the center
//        model.position.x -= model.visualBounds(relativeTo: nil).extents.x / 2
//        // Add model to cache
//        modelsForClassification[classification] = model
//        return model
//    }
//    
//    func sphere(radius: Float, color: UIColor) -> ModelEntity {
//        let sphere = ModelEntity(mesh: .generateSphere(radius: radius), materials: [SimpleMaterial(color: color, isMetallic: false)])
//        // Move sphere up by half its diameter so that it does not intersect with the mesh
//        sphere.position.y = radius
//        return sphere
//    }
//    
//    @IBAction func saveAction(_ sender: Any) {
//        //saveAlert()
//        self.updatePersistanceAvailability(for: sceneView)
//        self.handlePersistence(for: sceneView)
//        
//        if sceneManager.isPersistenceAvailable {
//            sceneManager.shouldSaveSceneToSystem = true
//            print("should save scene to system is true")
//            print("\(sceneManager.persistenceURL) is persist url")
//            print("\(String(describing: sceneManager.scenePersistenceData)) is persist data")
//        }
//        
//    }
//    
//    
//    @objc func saveAlert(){
//        let defaults = UserDefaults.standard
//       
//        if defaults.bool(forKey: "sixteenth") == false && defaults.bool(forKey: "finishedWalkthrough") == false {
//                // sceneView.addSubview(circle)
//            defaults.set(true, forKey: "fifteenth")
//            walkthroughLabel.removeFromSuperview()
//            circle.removeFromSuperview()
//            self.walkthroughLabel.frame = CGRect(x: 35, y: 380, width: UIScreen.main.bounds.width - 70, height: 60)
//            self.walkthroughLabel.text = "Name the Network and click Save"
//            self.sceneView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "16 of 18"
//        }
//        
//        let alertController = UIAlertController(title: "Save Network", message: "Create a name for this Blueprint Network.", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_) in
//            let nameTextField = alertController.textFields![0]
//            let name = (nameTextField.text ?? "").isEmpty ? "My Room" : nameTextField.text!
//            if name == "" || name == " " || name == "My Room" {
//                return
//            } else {
//                self.saveMap()
//            }
//            
//        })
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
//            self.wordsBtn.isHidden = false
//            self.videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//            self.networkBtn.isHidden = false
//            self.networksNearImg.isHidden = false
//            //self.showAllUI()
//        })
//        alertController.addTextField { (textField) in
//            textField.placeholder = "My Room"
//            textField.autocapitalizationType = .sentences
//            //textField.placeholder = "Network Name"
//        }
//        alertController.addAction(saveAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
//    
//   // var planeMat : Material?
//    
//    var planesPlaced = 0
//    
//    @objc func addPlane(_ sender: UITapGestureRecognizer){
//        //if want to add to touchlocation instead of plane LOOK AT INSERTNEWSTICKY (VC+Gestures)
//        
//        planesPlaced += 1
//        
//        if planesPlaced == 1 {
//            let mesh = MeshResource.generatePlane(width: 1, height: 0.6)    // 16:9 video
//            var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//            material.baseColor = try! .texture(.load(named: "targetred"))
//            let planeModel = ModelEntity(mesh: mesh, materials: [material])
//            
//          //  let model = ModelEntity(mesh: .generatePlane(width: 2, height: 1.2))
//          
//    //
//    //        var simpleMaterial = SimpleMaterial()
//    //
//    //        simpleMaterial.baseColor = try! MaterialColorParameter.texture(
//    //                                                  TextureResource.load(named: "img.jpg"))
//            
//        
//            
//           // planeModel.scale *= -1
//          //  planeModel.name = "planeModel"
//            let anchor = AnchorEntity(world: [0,0.8,-0.5])// AnchorEntity(plane: .any)// self.focusEntity?.anchor //
//            anchor.addChild(planeModel)
//            anchor.name = "planeModel"
//            pickedImageView.image = nil
//          //  planeModel.generateCollisionShapes(recursive: true)
//
//            sceneView.installGestures([.translation, .rotation, .scale], for: planeModel)
//
//            
//           // planeModel.model?.materials.first = pickedImageView.image as! Material
//            self.sceneView.scene.addAnchor(anchor)
//        } else if planesPlaced == 2 {
//            
//            let mesh = MeshResource.generatePlane(width: 1, height: 0.6)    // 16:9 video
//            var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//            material.baseColor = try! .texture(.load(named: "tennisball"))
//            let planeModel = ModelEntity(mesh: mesh, materials: [material])
//            
//          //  let model = ModelEntity(mesh: .generatePlane(width: 2, height: 1.2))
//          
//    //
//    //        var simpleMaterial = SimpleMaterial()
//    //
//    //        simpleMaterial.baseColor = try! MaterialColorParameter.texture(
//    //                                                  TextureResource.load(named: "img.jpg"))
//            
//        
//            
//           // planeModel.scale *= -1
//          //  planeModel.name = "planeModel"
//            let anchor = AnchorEntity(world: [0.0,0.3,-1.8])// AnchorEntity(plane: .any)// self.focusEntity?.anchor //
//            anchor.addChild(planeModel)
//            anchor.name = "planeModel1"
//            pickedImageView.image = nil
//        //    planeModel.generateCollisionShapes(recursive: true)
//
//            sceneView.installGestures([.translation, .rotation, .scale], for: planeModel)
//
//            
//           // planeModel.model?.materials.first = pickedImageView.image as! Material
//            self.sceneView.scene.addAnchor(anchor)
//        }
//      
//        
//       
//        
//        let addImageButton = UIButton(frame: CGRect(x: 15, y: 550, width: 120, height: 120))
//        addImageButton.layer.cornerRadius = 5
//        addImageButton.setImage(UIImage(systemName: "photo.fill"), for: .normal)
//        addImageButton.tintColor = .white
//        addImageButton.isUserInteractionEnabled = true
//        
////        let addImageTap = UITapGestureRecognizer(target: self, action: #selector(imagePicker(_:)))
////        addImageTap.delegate = self
////        addImageButton.addGestureRecognizer(addImageTap)
////        sceneView.addSubview(addImageButton)
//    }
//    
//    var pickedImageView = UIImageView()
//    
//    private func getTransformForPlacement(in arView: CustomARView) -> simd_float4x4? {
//        guard let query = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .any) else {
//            return nil
//        }
//        
//        guard let raycastResult = arView.session.raycast(query).first else {return nil}
//        
//        return raycastResult.worldTransform
//    }
//    
//    var searchTaps = 0
//    
//    private var allModels       = [Model]()
//    private var searchedModels  = [Model]()
//
//    let addButton = UIButton(frame: CGRect(x: 38, y: 728, width: 52, height: 52))
//  
//    
//    @objc func editAlert(){
//        if let viewController = self.storyboard?.instantiateViewController(
//            withIdentifier: "OnboardingViewController") {
//            viewController.modalPresentationStyle = .fullScreen
//            self.present(viewController, animated: true)
//        }
////        let alert = UIAlertController(title: "Edit your surroundings or Create a Network?", message: "Skip Blueprint's tutorial? If you already know how to use Blueprint, feel free to skip this part.", preferredStyle: .alert)
////        alert.addAction(UIAlertAction(title: "Edit", style: .default) { action in
////            self.searchAction(self)
////        })
////        alert.addAction(UIAlertAction(title: "Create Network", style: .default) { action in
//////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//////           // print("\(LaunchViewController.auth.currentUser?.uid) is the current user id")
//////
//////            var next = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileViewController
//////           // next.modalPresentationStyle = .fullScreen
//////            self.present(next, animated: true, completion: nil)
////
////            if let viewController = self.storyboard?.instantiateViewController(
////                withIdentifier: "RoomCaptureViewNavigationController") {
////                viewController.modalPresentationStyle = .fullScreen
////                self.present(viewController, animated: true)
////            }
////        })
////        present(alert, animated: true)
//    }
//    
//    @objc func searchUI(){
//    let defaults = UserDefaults.standard
//    
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
////
//    if searchBtn.currentImage == UIImage(systemName: "xmark") {
//        currentEntity.removeFromParent()
//        placementStackView.isHidden = true
//       
//        shareImg.isHidden = false
//        
//        toggleBtn.isHidden = false
//        
//        duplicateBtn.isHidden = true
//        entityName.isHidden = true
//        searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//        searchBtn.isHidden = false
//        entityProfileBtn.isHidden = true
//        networksNearImg.isHidden = false
//        }
//    else {
//       // searchTaps += 1
//        isVideoMode = false
//        isTextMode = false
//        isObjectMode = false
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//       // print("\(LaunchViewController.auth.currentUser?.uid) is the current user id")
//        
//        var next = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
//       // let navVC = UINavigationController(rootViewController: next)
//       // var next = UserProfileViewController.instantiate(with: user)
//      
//        next.modalPresentationStyle = .fullScreen
//        present(next, animated: true, completion: nil)
//        
//        
////        searchView.isHidden = false
////        self.newSearchView.isHidden = false
////        searchBar.isHidden = false
////        searchBar.autocapitalizationType = .none
////        //searchBar.becomeFirstResponder()
////        if newSearchView.isHidden == false {
////         //   searchField.becomeFirstResponder()
////        }
////        categoryScrollView.isHidden = false
////        modelModeAction((Any).self)
////       // searchStackView.isHidden = false
////        //searchStackUnderView.isHidden = false
////        searchBtn.isHidden = true
////        networksNearImg.isHidden = true
////        previewButton.isHidden = true
////        buttonStackView.isHidden = true
////        editButton.isHidden = true
////        networkBtn.isHidden = true
////        profileButton.isHidden = true
////        editUnderView.isHidden = true
////        self.wordsBtn.isHidden = true
////        self.videoBtn.isHidden = true
////        networksNearImg.isHidden = true
////        betweenView.isHidden = true
////        previewUnderView.isHidden = true
////        shareImg.isHidden = true
////        toggleBtn.isHidden = true
////        print("\(currentEntity.scale) is the search entity scale")
////        searchBar.placeholder = "Search Blueprint"
////        searchBar.delegate = self
////        searchBar.autocapitalizationType = .none
////        printModels()
////        newSearchView.topAnchor.constraint(equalTo: self.view.topAnchor)
////        newSearchView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
////        newSearchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
////        searchView.isHidden = true
////        //topview.isHidden = true
////        newSearchView.isHidden = false
////        searchField.layer.shadowRadius = 3
////        searchField.layer.shadowOpacity = 0.95
////       // thirdField.layer.cornerRadius = 32
////        searchField.layer.shadowColor = UIColor.systemGray3.cgColor
////          //note.view?.layer.cornerRadius = 5
////        searchField.layer.masksToBounds = false
////        searchField.layer.shadowOffset = CGSize(width: 0, height: 1.5)
////        searchField.setLeftView1(image: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))!)
////        searchField.tintColor = .darkGray
////        sceneView.removeGestureRecognizer(placeVideoRecognizer)
////    //    sceneView.removeGestureRecognizer(wordstapGesture)
////        let delay = 0.5
////        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
////            self.browseTableView.isHidden = false
////        }
//        
//        UIView.animate(withDuration: 0.6,
//            animations: {
//               // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
//                self.wordsBtn.tintColor = UIColor.white
//                self.videoBtn.tintColor = UIColor.white
//            },
//            completion: { _ in
////                UIView.animate(withDuration: 0.6) {
////                    self.wordsBtn.transform = CGAffineTransform.identity
////                }
//            })
//
//    }
//    }
//    
//    @IBAction func searchAction(_ sender: Any) {
//      //  searchMode = false
//        
//        let defaults = UserDefaults.standard
//        
//        if defaults.bool(forKey: "third") == false && defaults.bool(forKey: "finishedWalkthrough") == false {
//            defaults.set(true, forKey: "second")
//            walkthroughLabel.removeFromSuperview()
//            circle.removeFromSuperview()
//            circle.frame = CGRect(x: 8, y: 10, width: 183, height: 183)
//            circle.backgroundColor = .clear
//            circle.layer.cornerRadius = 91
//            circle.clipsToBounds = true
//            circle.layer.borderColor = UIColor.systemBlue.cgColor
//            circle.layer.borderWidth = 5
//            circle.isUserInteractionEnabled = false
//            circle.alpha = 1.0
//                // sceneView.addSubview(circle)
//            self.walkthroughLabel.frame = CGRect(x: 20, y: 275, width: UIScreen.main.bounds.width - 40, height: 80)
//            self.walkthroughLabel.text = "Soon, you’ll be able to search for any type of digital asset, but in the meantime select the Abstract Painting in the top left corner"
//    //        self.browseTableView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "3 of 18"
//            
//            let delay = 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//     //           self.browseTableView.addSubview(self.circle)
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//
//            }
//        }
//        
//        //let defaults = UserDefaults.standard
//        
//       
//        if defaults.bool(forKey: "eleventh") == false && defaults.bool(forKey: "ninth") == true {
//            walkthroughLabel.removeFromSuperview()
//            circle.removeFromSuperview()
//            defaults.set(true, forKey: "tenth")
//            circle.frame = CGRect(x: 199, y: 10, width: 183, height: 183)
//            circle.backgroundColor = .clear
//            circle.layer.cornerRadius = 91
//            circle.clipsToBounds = true
//            circle.layer.borderColor = UIColor.systemBlue.cgColor
//            circle.layer.borderWidth = 5
//            circle.isUserInteractionEnabled = false
//            circle.alpha = 1.0
//                // sceneView.addSubview(circle)
//            self.walkthroughLabel.frame = CGRect(x: 30, y: 275, width: UIScreen.main.bounds.width - 60, height: 70)
//            self.walkthroughLabel.text = "Select the wooden chair to the right of the abstract painting"
//      //      self.browseTableView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "11 of 18"
//
//            let delay = 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//      //          self.browseTableView.addSubview(self.circle)
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                       })
//
//            }}
////
//    if searchBtn.currentImage == UIImage(systemName: "xmark") {
//        currentEntity.removeFromParent()
//        placementStackView.isHidden = true
//       
//        shareImg.isHidden = false
//        
//        toggleBtn.isHidden = false
//        
//        duplicateBtn.isHidden = true
//        entityName.isHidden = true
//        searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//        searchBtn.isHidden = false
//        entityProfileBtn.isHidden = true
//        networksNearImg.isHidden = false
//        }
//    else {
//       // searchTaps += 1
//        isVideoMode = false
//        isTextMode = false
//        isObjectMode = false
//        searchView.isHidden = false
//        self.newSearchView.isHidden = false
//        searchBar.isHidden = false
//        searchBar.autocapitalizationType = .none
//        //searchBar.becomeFirstResponder()
//        if newSearchView.isHidden == false {
//         //   searchField.becomeFirstResponder()
//        }
//        categoryScrollView.isHidden = false
//        modelModeAction((Any).self)
//       // searchStackView.isHidden = false
//        //searchStackUnderView.isHidden = false
//        searchBtn.isHidden = true
//        previewButton.isHidden = true
//        editButton.isHidden = true
//        networkBtn.isHidden = true
//        profileButton.isHidden = true
//        editUnderView.isHidden = true
//        self.wordsBtn.isHidden = true
//        self.videoBtn.isHidden = true
//        networksNearImg.isHidden = true
//        betweenView.isHidden = true
//        previewUnderView.isHidden = true
//        shareImg.isHidden = true
//        toggleBtn.isHidden = true
//        print("\(currentEntity.scale) is the search entity scale")
//        searchBar.placeholder = "Search Blueprint"
//        searchBar.delegate = self
//        searchBar.autocapitalizationType = .none
//        printModels()
//        newSearchView.topAnchor.constraint(equalTo: self.view.topAnchor)
//        newSearchView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
//        newSearchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
//        searchView.isHidden = true
//        //topview.isHidden = true
//        newSearchView.isHidden = false
//        searchField.layer.shadowRadius = 3
//        searchField.layer.shadowOpacity = 0.95
//       // thirdField.layer.cornerRadius = 32
//        searchField.layer.shadowColor = UIColor.systemGray3.cgColor
//          //note.view?.layer.cornerRadius = 5
//        searchField.layer.masksToBounds = false
//        searchField.layer.shadowOffset = CGSize(width: 0, height: 1.5)
//        searchField.setLeftView1(image: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold))!)
//        searchField.tintColor = .darkGray
//        sceneView.removeGestureRecognizer(placeVideoRecognizer)
//    //    sceneView.removeGestureRecognizer(wordstapGesture)
//        let delay = 0.5
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//            self.browseTableView.isHidden = false
//        }
//        
//        UIView.animate(withDuration: 0.6,
//            animations: {
//               // self.wordsBtn.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
//                self.wordsBtn.tintColor = UIColor.white
//                self.videoBtn.tintColor = UIColor.white
//            },
//            completion: { _ in
////                UIView.animate(withDuration: 0.6) {
////                    self.wordsBtn.transform = CGAffineTransform.identity
////                }
//            })
//
//    }
//    }
//    
//    let storedData = UserDefaults.standard
//    let mapKey = "ar.worldmap"
//    var heightInPoints = CGFloat()
//    var widthInPoints = CGFloat()
//    var imageAnchorURL : URL?
//    var videoAnchorURL : URL?
//    private var imageAnchorChanged = false
//    private var videoAnchorChanged = false
//    private let imagePicker        = UIImagePickerController()
//    var photoAnchorImageView = UIImageView()
//    
//    lazy var worldMapData: Data? = {
//        storedData.data(forKey: mapKey)
//    }()
//    
//    @objc func saveMap(){
//        let defaults = UserDefaults.standard
//        
//        if defaults.bool(forKey: "finishedWalkthrough") == false {
//            defaults.set(true, forKey: "sixteenth")
//            walkthroughLabel.removeFromSuperview()
//            circle.removeFromSuperview()
//            
//            circle.frame = CGRect(x: 294, y: 50, width: 40, height: 40)
//            circle.backgroundColor = .clear
//            circle.layer.cornerRadius = 20
//            circle.clipsToBounds = true
//            circle.layer.borderColor = UIColor.systemBlue.cgColor
//            circle.layer.borderWidth = 4
//            circle.isUserInteractionEnabled = false
//            circle.alpha = 1.0
//                // sceneView.addSubview(circle)
//            self.walkthroughLabel.numberOfLines = 6
//            self.walkthroughLabel.frame = CGRect(x: 20, y: 530, width: UIScreen.main.bounds.width - 40, height: 130)
//            self.walkthroughLabel.text = "Great! You’ve created your first Blueprint Network. Now you can connect to that Network any time you are back at this location by clicking the Network button and selecting your Network. This will download all digital assets back into place of where you saved them."
//            self.sceneView.addSubview(self.walkthroughLabel)
//            self.walkthroughViewLabel.text = "17 of 18"
//            
//            let delay = 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//                //self.topView.addSubview(self.circle)
//                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                    self.circle.alpha = 0.1
//                    defaults.set(true, forKey: "seventeenth")
//                       })
//
//            }
//        }
//        
//      
//        sceneView.session.getCurrentWorldMap { (worldMap, _) in
//               
//               if let map: ARWorldMap = worldMap {
//                   
//                   let data = try! NSKeyedArchiver.archivedData(withRootObject: map,
//                                                         requiringSecureCoding: true)
//                   
//                   let savedMap = UserDefaults.standard
//                   savedMap.set(data, forKey: "WorldMap")
//                   //worldMap?.anchors
//                   savedMap.synchronize()
//                   print("world map saved")
//                   ProgressHUD.show("Saving Network")
//                   let delay = 1.5
//                   DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
//                       ProgressHUD.dismiss()
//                       SCLAlertView().showSuccess("Network Saved", subTitle: "Users can now connect to your Blueprint Network")
//                       self.saveButton.isHidden = true
//                       self.undoButton.isHidden = true
//                       self.numberOfEditsImg.isHidden = true
//                   }
//               }
//           }
//    }
//    
//    @objc func dismissKeyboard() {
//        searchBar.isHidden = true
//        view.endEditing(true)
//    }
//    
//    let browseView = BrowseSearchView()
//    
//   // var searchResults : [Model] = []
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        searchedModels = (searchText == "") ? allModels : allModels.filter({ (model: Model) -> Bool in
//            print("\(model.name.localizedCaseInsensitiveContains(searchText)) is the model names from search")
//            return model.name.localizedCaseInsensitiveContains(searchText)
//            //might want to get the thumbnails, not necesarrily the name
//        })
//
//      //  browseTableView.reloadData()
//    }
//    
////    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
////      // return true
////    }
//    
//
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        view.endEditing(true)
//        if searchBar.text == "" || searchBar.text == " " {
//            searchMode = false
//            nftView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 375)
//            tableViewHeight.constant = 375
//           // browseTableView.isHidden = true
//            
//            //topview.isHidden = false
//     //       self.searchBar.isHidden = true
//            searchStackView.isHidden = true
//            //searchStackUnderView.isHidden = true
//            searchView.isHidden = true
//            newSearchView.isHidden = true
//            editButton.isHidden = false
//            previewButton.isHidden = false
//            searchBtn.isHidden = false
//            betweenView.isHidden = false
//            networkBtn.isHidden = false
//            //categoryScrollView.isHidden = true
//            networksNearImg.isHidden = false
//            profileButton.isHidden = false
//            editUnderView.isHidden = false
//            self.wordsBtn.isHidden = false
//            self.videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//            browseTableView.isHidden = true
//            let segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: 95, width: UIScreen.main.bounds.width, height: 40))
//            segmentedControl.selectedSegmentTintColor = .blue
//            segmentedControl.insertSegment(withTitle: "Marketplace", at: 0, animated: false)
//            segmentedControl.insertSegment(withTitle: "NFT", at: 1, animated: false)
//            segmentedControl.selectedSegmentIndex = 0
////            if segmentedControl.selectedSegmentIndex == 0 {
////                segmentedControl.se
////            }
//            segmentedControl.backgroundColor = .white
//          //  sceneView.addSubview(segmentedControl)
//            if sceneManager.anchorEntities.count == 0 {
//                saveButton.isHidden = true
//                undoButton.isHidden = true
//                numberOfEditsImg.isHidden = true
//                sceneInfoButton.isHidden = true
//            } else {
//            //    saveButton.isHidden = false
//                undoButton.isHidden = false
//             //   numberOfEditsImg.isHidden = false
//    //            sceneInfoButton.isHidden = false
//            }
//        } else if searchBar.text?.count ?? 0 > 1 { //== "couch" || searchBar.text == "Couch"
//            searchMode = true
//            browseTableView.isHidden = false
//            print("\(searchBar.text) is search bar text")
//            tableViewHeight.constant = UIScreen.main.bounds.height - 140
//            nftView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
//            let db = Firestore.firestore()
//            let docRef = db.collection("models").document("8EaV7rkVJCjn7iyzWUkR")
//
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    
//                    let documentName = document.get("name")
//                    let documentModel = document.get("modelName")
//                    let documentThumbnail = document.get("thumbnail")
//                    print("\(documentName ?? "") is the document name")
//                    print("\(documentModel ?? "") is the document model")
//                //    print("\(documentScale) is the document scale")
//                    print("\(documentThumbnail ?? "") is the document thumbnail")
//                    self.searchBar.isHidden = true
//                    //self.topView.isHidden = true
//                    self.searchStackView.isHidden = true
//                 //   self.searchStackUnderView.isHidden = true
//                    self.searchBtn.isHidden = false
//                    self.toggleBtn.isHidden = true
//                    self.undoButton.isHidden = true
//                    self.sceneInfoButton.isHidden = true
//                    self.categoryScrollView.isHidden = true
//                    self.newSearchView.isHidden = true
//                    self.dismissKeyboard()
//                    ProgressHUD.show("Loading...")
//                    self.browseTableView.isHidden = true
//                    FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(documentModel ?? "")") { localUrl in
//                        self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                            switch loadCompletion {
//                            case.failure(let error): print("Unable to load model for \(documentName). Error: \(error.localizedDescription)")
//                            case.finished:
//                                break
//                            }
//                        }, receiveValue: { modelEntity in
//                            self.currentEntity = modelEntity
//                            self.currentEntity.name = "\(documentName ?? ""))"
//                            if let documentScale = document.get("scale") as? NSNumber {
//                                let floatScale = documentScale.floatValue
//                                self.currentEntity.scale = [floatScale, floatScale, floatScale]
//                            }
//                            self.downloadModel()
//                        })
//                    }
//                } else {
//                    print("Document does not exist")
//                }
//            }
//            
//        }  else {
//     //   hideUI()
//       // placementStackView.isHidden = false
//        saveButton.isHidden = true
//            undoButton.isHidden = true
//        numberOfEditsImg.isHidden = true
//           
//            browseTableView.isHidden = true
//        }}
//    
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        browseTableView.isHidden = false
//        
//    }
//    
////    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
////        searchUserTableView.isHidden = true
////        reloadSearchLabel()
////    }
//    
//    //MARK: --- Public Functions ---
//    public func reloadData() {
//        
//        /// reset
//        allModels = [Model]()
//        searchedModels = [Model]()
//
//        /// Suggested Users
//        FirestoreManager.getAllModels { [self] models in
//            allModels = models.shuffled()
//            searchedModels = models.shuffled()
//            updateUI()
//        }}
//
//        //MARK: --- MainFunctions ---
//        private func updateUI() {
//            browseTableView.reloadData()
//        }
//
//    func printModels(){
//        FirestoreManager.getAllModels { [self] models in
//            allModels = models.shuffled()
//            // searchedModels = models.shuffled()
//            //updateUI()
//            print("\(allModels.count) is the all models count")
//            print("\(allModels.capacity) is the all models capacity")
//        }//}
//        
//    }
//    
//    var networkName = ""
//    var networkModel = "" //maybe modelEntity or something else?
//  //  var photoAnchorImageView = UIImageView()
//    
//    func uploadNetwork(){
//        let lat = self.currentLocation?.coordinate.latitude
//        let long = self.currentLocation?.coordinate.longitude
//        self.db.collection("networks").addDocument(data: [
//            "latitude" : NSNumber(value: lat!),
//            "longitude" : NSNumber(value: long!),
//            "host" : Auth.auth().currentUser?.uid,
//            "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
//         //   "hostUsername" : Auth.auth().currentUser?.uid,
//            "rating" : "",
//            "likes" : 0,
//            "comments" : 0,
//            "name" : self.networkName,
//            "dislikes" : 0,
//            "contentType" : "network",
//            "id" : "",
//            "isPublic" : true,
//            "password" : "",
//            "timeStamp" : Date(),
//            "placeId" : "",
//            "interactionCount" : 0,
//            "amountEarned" : 0,
//            "description" : "",
//            "anchorIDs" : [""],
//            "historyUsers" : [""],
//            "currentUsers" : [""],
//            "size" : 0,
//            ], completion: { err in
//            if let err = err {
//                print("Error adding document for loser notification: \(err)")
//            } else {
//                print("added anchor to firestore")
//             //   self.addPoints()
//                let host = Auth.auth().currentUser?.uid ?? ""
//                FirestoreManager.getUser(host) { user in
//                    let hostPointsRef = self.db.collection("users").document(host)
//                    hostPointsRef.updateData([
//                         "points": FieldValue.increment(Int64(20))
//                        ])
//            }
//        }
//            })
//        
//    }
//    
//    var imageAnchorID = ""
//    
//    var videoAnchorID = ""
//    
//    func uploadSessionPhotoAnchor(){
//        let lat = self.currentLocation?.coordinate.latitude
//        let long = self.currentLocation?.coordinate.longitude
//        print("\(self.currentEntity.id) is current entity id")
//        print("\(self.currentEntity.scale.x) is current entity scale")
//        let id = self.imageAnchorID //NSUUID().uuidString //uuid
//        var userName = ""
////        if Auth.auth().currentUser?.uid ?? "" != nil {
////            let host = Auth.auth().currentUser?.uid ?? ""
////            FirestoreManager.getUser(host) { user in
////                if user?.name != nil && user?.name != ""{
////                    userName = user?.name ?? ""
////                } else {
////                    userName = user?.username ?? ""
////                }
////            }
////        }
//        self.db.collection("sessionAnchors").document(id).setData([
//            "latitude" : NSNumber(value: lat!),
//            "longitude" : NSNumber(value: long!),
//            "host" : Auth.auth().currentUser?.uid ?? "",
//            "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
//         //   "hostUsername" : Auth.auth().currentUser?.uid,
//            "likes" : 0,
//            "comments" : 0,
//            "name" : "Photo by \(Auth.auth().currentUser?.uid ?? "")", //"Photo by \(userName)",
//            "dislikes" : 0,
//            "contentType" : "sessionPhotoAnchor",
//            "id" : id,
//            "isPublic" : true,
//            "timeStamp" : Date(),
//            "placeId" : "",
//            "interactionCount" : 0,
//            "scale" : 1,
//            "description" : "",
//            "size" : 0,
//        ])
////        self.db.collection("sessionAnchors").addDocument(data: [
////            "latitude" : NSNumber(value: lat!),
////            "longitude" : NSNumber(value: long!),
////            "host" : Auth.auth().currentUser?.uid,
////            "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
////         //   "hostUsername" : Auth.auth().currentUser?.uid,
////            "likes" : 0,
////            "comments" : 0,
////            "name" : self.currentEntity.name,
////            "dislikes" : 0,
////            "contentType" : "sessionAnchor",
////            "id" : self.currentEntity.id,
////            "modelId" : "",
////            "isPublic" : true,
////            "timeStamp" : Date(),
////            "placeId" : "",
////            "interactionCount" : 0,
////            "scale" : self.currentEntity.scale.x,
////            "description" : "",
////            "size" : 0,
////            ], completion: { err in
////            if let err = err {
////                print("Error adding document for loser notification: \(err)")
////            } else {
////                print("added anchor to firestore")
////             //   self.addPoints()
////            }
////        })
//    }
//    
//    func uploadSessionVideoAnchor(){
//        let lat = self.currentLocation?.coordinate.latitude
//        let long = self.currentLocation?.coordinate.longitude
//        print("\(self.currentEntity.id) is current entity id")
//        print("\(self.currentEntity.scale.x) is current entity scale")
//        let id = self.videoAnchorID //NSUUID().uuidString //uuid
//        var userName = ""
////        if Auth.auth().currentUser?.uid ?? "" != nil {
////            let host = Auth.auth().currentUser?.uid ?? ""
////            FirestoreManager.getUser(host) { user in
////                if user?.name != nil && user?.name != ""{
////                    userName = user?.name ?? ""
////                } else {
////                    userName = user?.username ?? ""
////                }
////            }
////        }
//        self.db.collection("sessionAnchors").document(id).setData([
//            "latitude" : NSNumber(value: lat!),
//            "longitude" : NSNumber(value: long!),
//            "host" : Auth.auth().currentUser?.uid ?? "",
//            "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
//         //   "hostUsername" : Auth.auth().currentUser?.uid,
//            "likes" : 0,
//            "comments" : 0,
//            "name" : "Photo by \(Auth.auth().currentUser?.uid ?? "")", //"Photo by \(userName)",
//            "dislikes" : 0,
//            "contentType" : "sessionVideoAnchor",
//            "id" : id,
//            "isPublic" : true,
//            "timeStamp" : Date(),
//            "placeId" : "",
//            "interactionCount" : 0,
//            "scale" : 1,
//            "description" : "",
//            "size" : 0,
//        ])
//    }
//    
//    func uploadSessionModelAnchor(){
//        let lat = self.currentLocation?.coordinate.latitude
//        let long = self.currentLocation?.coordinate.longitude
//        print("\(self.currentEntity.id) is current entity id")
//        print("\(self.currentEntity.scale.x) is current entity scale")
//        let id = String(self.currentEntity.id)
//        self.db.collection("sessionAnchors").document(id).setData([
//            "latitude" : NSNumber(value: lat!),
//            "longitude" : NSNumber(value: long!),
//            "host" : Auth.auth().currentUser?.uid ?? "",
//            "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
//         //   "hostUsername" : Auth.auth().currentUser?.uid,
//            "likes" : 0,
//            "comments" : 0,
//            "name" : self.currentEntity.name,
//            "dislikes" : 0,
//            "contentType" : "sessionModelAnchor",
//            "id" : id,
//            "modelId" : self.modelUid,
//            "isPublic" : true,
//            "timeStamp" : Date(),
//            "placeId" : "",
//            "interactionCount" : 0,
//            "scale" : self.currentEntity.scale.x,
//            "description" : "",
//            "size" : 0,
//        ])
////        self.db.collection("sessionAnchors").addDocument(data: [
////            "latitude" : NSNumber(value: lat!),
////            "longitude" : NSNumber(value: long!),
////            "host" : Auth.auth().currentUser?.uid,
////            "geohash" : GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: lat!, longitude: long!)),
////         //   "hostUsername" : Auth.auth().currentUser?.uid,
////            "likes" : 0,
////            "comments" : 0,
////            "name" : self.currentEntity.name,
////            "dislikes" : 0,
////            "contentType" : "sessionAnchor",
////            "id" : self.currentEntity.id,
////            "modelId" : "",
////            "isPublic" : true,
////            "timeStamp" : Date(),
////            "placeId" : "",
////            "interactionCount" : 0,
////            "scale" : self.currentEntity.scale.x,
////            "description" : "",
////            "size" : 0,
////            ], completion: { err in
////            if let err = err {
////                print("Error adding document for loser notification: \(err)")
////            } else {
////                print("added anchor to firestore")
////             //   self.addPoints()
////            }
////        })
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return 12
//       // return searchedModels.count
//        }
//    var gotRandomModelID = false
//    
//    var searchMode = false
//    
//    func getRandomModelID(completion: @escaping (_ success: Bool) -> Void){
//       // DispatchQueue.main.async {
//            
//        
//            let postsRef = self.db.collection("models")
//            let random = self.generateRandomModelID(length: 20)
//            print("\(random) is random")
//            let queryRef = postsRef.whereField("id", isGreaterThanOrEqualTo: random).order(by: "id").limit(to: 2)
//            let docId = postsRef.document().documentID // document.documentID
//            queryRef.getDocuments { (snapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in snapshot!.documents {
//                        let docId = document.documentID
//                        print("\(docId) is doc id")
//                        let first = snapshot!.documents[0]
//                        print("\(first) is first")
//                        self.modelId1 = first.documentID
//                        print("\(self.modelId1) is modelId1")
//                        
//                        let second = snapshot!.documents[1]
//                        print("\(first) is first")
//                        self.modelId2 = second.documentID
//                        print("\(self.modelId2) is modelId2")
//                        self.gotRandomModelID = true
//                        completion(true)
//                    }
//              //  }
//            }
//        }
//        
//    }
//    
//    func generateRandomModelID(length: Int) -> String {
//        let letters = "abcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        return String((0..<length).map{ _ in letters.randomElement()! })
//    }
//    
//    func generateRandomPhotoID(length: Int) -> String {
//        let letters = "0123456789"
//        return String((0..<length).map{ _ in letters.randomElement()! })
//    }
//    
//    var loadedTableView = false
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = ModelTableViewCell()
////        cell.setContent(searchedModels[indexPath.row])
////        return cell
//        let defaults = UserDefaults.standard
//            if indexPath.row == 0 {
//           //     if defaults.bool(forKey: "finishedWalkthrough") == false {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "new", for: indexPath)
//                    tableView.rowHeight = 280
//                    if UITraitCollection.current.userInterfaceStyle == .light {
//                        cell.textLabel?.textColor = UIColor.yellow
//                    } else {
//                        cell.textLabel?.textColor = UIColor.green
//                    }
//                    return cell
//              //  }
//           /*     guard let cell = tableView.dequeueReusableCell(withIdentifier: BrowseTableViewCell.identifier, for: indexPath) as? BrowseTableViewCell else {
//                    return UITableViewCell()
//                }
//                if self.loadedTableView == false{
//                    self.getRandomModelID { (success) -> Void in
//                        if success {
//                            // do second task if success
//                            
//                            cell.configure(with: self.modelId1)
//                            cell.configure2(with: self.modelId2)
//                            
//                        }
//                    }
//                    let tap = UITapGestureRecognizer(target: self, action: #selector(addItem))
//                    cell.itemView1.addGestureRecognizer(tap)
//                    let tap2 = UITapGestureRecognizer(target: self, action: #selector(addItem2))
//                    cell.itemView2.addGestureRecognizer(tap2)
//                    tableView.rowHeight = 280
//                    self.loadedTableView = true
//                    return cell
//                } else {
//                    cell.configure(with: self.modelId1)
//                    cell.configure2(with: self.modelId2)
//                    return cell
//                }*/
//              }
//              if indexPath.row == 1 {
//                  let cell = tableView.dequeueReusableCell(withIdentifier: "newSecond", for: indexPath)
//                  tableView.rowHeight = 270
//                //  print("most popular cell returned")
//                  return cell
//              }
//               if indexPath.row == 2 {
//                   let cell = tableView.dequeueReusableCell(withIdentifier: "newThird", for: indexPath)
//                   tableView.rowHeight = 270
//                   return cell
//               }
//            if indexPath.row == 3 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "newFourth", for: indexPath)
//                tableView.rowHeight = 270
//                return cell
//            }
//            if indexPath.row == 4 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "newFifth", for: indexPath)
//                tableView.rowHeight = 270
//                return cell
//            }
//            if indexPath.row == 5 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "newSixth", for: indexPath)
//                tableView.rowHeight = 270
//                return cell
//            }
//            if indexPath.row == 6 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "newSeventh", for: indexPath)
//                tableView.rowHeight = 270
//                return cell
//            }
//            if indexPath.row == 7 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "newEighth", for: indexPath)
//                tableView.rowHeight = 270
//                return cell
//            }
//            if indexPath.row == 8 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "newNinth", for: indexPath)
//                tableView.rowHeight = 270
//                return cell
//            }
//        if indexPath.row == 9 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "newTenth", for: indexPath)
//            tableView.rowHeight = 270
//            return cell
//        }
//        if indexPath.row == 10 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "newEleventh", for: indexPath)
//            tableView.rowHeight = 270
//            return cell
//        }
//    if indexPath.row == 11 {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "newTwelfth", for: indexPath)
//        tableView.rowHeight = 270
//        return cell
//    }
//
//             return UITableViewCell()
//    }
//    
//
//    
//    @objc func loadMap(){
//        let storedData = UserDefaults.standard
//
//            if let data = storedData.data(forKey: "WorldMap") {
//
//                if let unarchiver = try? NSKeyedUnarchiver.unarchivedObject(
//                                       ofClasses: [ARWorldMap.classForKeyedUnarchiver()],
//                                            from: data),
//                   let worldMap = unarchiver as? ARWorldMap {
//
//                        config.initialWorldMap = worldMap
//                        sceneView.session.run(config)
//                    print("world map loaded")
//                }
//            }
//    }
//    
//    
//    @IBAction func addCeilingFilter(_ sender: Any) {
//        browseTableView.isHidden = true
//     //   //topview.isHidden = false
//        self.searchStackView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchBtn.isHidden = false
//        searchView.isHidden = true
//        newSearchView.isHidden = true
//        searchBar.isHidden = true
//        betweenView.isHidden = false
//        editUnderView.isHidden = false
//        previewButton.isHidden = false
//        self.wordsBtn.isHidden = false
//        self.videoBtn.isHidden = false
//        editButton.isHidden = false
//        profileButton.isHidden = false
//        networkBtn.isHidden = false
//        networksNearImg.isHidden = false
//        view.endEditing(true)
//        let mesh = MeshResource.generatePlane(width: 1.5, depth: 1)
//        var material = SimpleMaterial()
//        material.baseColor = try! .texture(.load(named: "sistineimg"))
//
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        let anchor = AnchorEntity(plane: .any)
//        anchor.addChild(planeModel)
//        anchor.name = "planeModelSunset"
//        planeModel.name = "Sunset Filter"
//        pickedImageView.image = nil
//        planeModel.generateCollisionShapes(recursive: true)
//
//        sceneView.installGestures([.translation, .rotation, .scale], for: planeModel)
//        self.sceneView.scene.addAnchor(anchor)
//    }
//    
//    @IBAction func addWall1Filter(_ sender: Any) {
//        browseTableView.isHidden = true
//      //  //topview.isHidden = false
//        self.searchStackView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchBtn.isHidden = false
//        searchView.isHidden = true
//        newSearchView.isHidden = true
//        searchBar.isHidden = true
//        betweenView.isHidden = false
//        editUnderView.isHidden = false
//        previewButton.isHidden = false
//        self.wordsBtn.isHidden = false
//        self.videoBtn.isHidden = false
//        editButton.isHidden = false
//        profileButton.isHidden = false
//        networkBtn.isHidden = false
//        networksNearImg.isHidden = false
//        view.endEditing(true)
//        let mesh = MeshResource.generatePlane(width: 1.5, depth: 1)
//        var material = SimpleMaterial()
//        material.baseColor = try! .texture(.load(named: "beachbirdsdepth"))
//
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        let anchor = AnchorEntity(plane: .any)
//        anchor.addChild(planeModel)
//        anchor.name = "planeModelBeach"
//        planeModel.name = "Beach Filter"
//        pickedImageView.image = nil
//        planeModel.generateCollisionShapes(recursive: true)
//
//        sceneView.installGestures([.translation, .rotation, .scale], for: planeModel)
//        self.sceneView.scene.addAnchor(anchor)
//    }
//    
//    @IBAction func addWall2Filter(_ sender: Any) {
//        browseTableView.isHidden = true
//      //  //topview.isHidden = false
//        self.searchStackView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchBtn.isHidden = false
//        searchView.isHidden = true
//        newSearchView.isHidden = true
//        searchBar.isHidden = true
//        betweenView.isHidden = false
//        editUnderView.isHidden = false
//        previewButton.isHidden = false
//        self.wordsBtn.isHidden = false
//        self.videoBtn.isHidden = false
//        editButton.isHidden = false
//        profileButton.isHidden = false
//        networkBtn.isHidden = false
//        networksNearImg.isHidden = false
//        view.endEditing(true)
//        let mesh = MeshResource.generatePlane(width: 1.5, depth: 1)
//        var material = SimpleMaterial()
//        material.baseColor = try! .texture(.load(named: "dawndepth"))
//
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        let anchor = AnchorEntity(plane: .any)
//        anchor.addChild(planeModel)
//        anchor.name = "planeModelDawn"
//        planeModel.name = "Dawn Filter"
//        pickedImageView.image = nil
//        planeModel.generateCollisionShapes(recursive: true)
//
//        sceneView.installGestures([.translation, .rotation, .scale], for: planeModel)
//        self.sceneView.scene.addAnchor(anchor)
//    }
//    
//    
//    @IBAction func addChess(_ sender: Any) {
//        self.modelUid = "dFCqM6TklPuh0g3v1crC"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        toggleBtn.isHidden = true
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Chess.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Chess Set. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Chess Set"
////                self.modelUid = "dFCqM6TklPuh0g3v1crC"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////                //modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.65,0.65,0.65]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Chess Set has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addRedPainting(_ sender: Any) {
//        self.modelUid = "4rIGwSVijh77o4qj1uRt"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        toggleBtn.isHidden = true
////        searchBtn.isHidden = false
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
//////        guard let fileUrl = Bundle.main.url(forResource: "Blank_Canvas", withExtension: "usdz"),
//////        let entity = try? ModelEntity.loadModel(contentsOf: fileUrl) else {
//////                 fatalError("could not load entity")
//////             }
//////
//////        self.currentEntity = entity
//////        self.currentEntity.name = "Blank Canvas"
//////        print(self.currentEntity)
//////        self.currentEntity.generateCollisionShapes(recursive: true)
//////        self.sceneView.installGestures([.rotation, .scale, .translation], for: self.currentEntity) //.translation
//////        let anchor =  self.focusEntity?.anchor
//////        print(anchor)
//////        anchor?.addChild(self.currentEntity)
//////        self.currentEntity.scale = [0.013,0.013,0.013]
//////        self.sceneView.scene.addAnchor(anchor!)
//////        print("modelEntity for Blank Canvas has been loaded.")
//////        self.removeCloseButton()
//////        ProgressHUD.dismiss()
//////        self.modelPlacementUI()
////
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/splatterpainting.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Red Painting. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Red Painting"
////                self.modelUid = "4rIGwSVijh77o4qj1uRt"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [1.1,1,1]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Red Painting has been loaded.")
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    @IBAction func addChairGubi(_ sender: Any) {
//        self.modelUid = "5LWeAjR4wERzIR6HCCqc"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        toggleBtn.isHidden = true
////        self.undoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.newSearchView.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Chair_Gubi.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Chair Gubi. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Chair Gubi"
////                self.modelUid = "5LWeAjR4wERzIR6HCCqc"
////                print(self.currentEntity)
////                let physics = PhysicsBodyComponent(massProperties: .init(mass: 13),
////                                                            material: .default,
////                                                                mode: .kinematic)
////              //  modelEntity.components.set(physics)
////
////                modelEntity.physicsBody = physics
////
////                self.currentEntity.generateCollisionShapes(recursive: true)
////
////                self.sceneView.installGestures([.translation, .rotation], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.32,0.32,0.32]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Chair Gubi has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    @IBAction func addFlatscreen(_ sender: Any) {
//        self.modelUid = "MbfjeiKYGfOFTw74eb33"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        toggleBtn.isHidden = true
////        self.undoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/2018_Flat_screen_TV.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for 2018 Sony Flatscreen TV. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "2018 Sony Flatscreen TV"
////                self.modelUid = "MbfjeiKYGfOFTw74eb33"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////               // modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.7,0.7,0.7]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for 2018 Sony Flatscreen TV has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    @IBAction func addLShapeCouch(_ sender: Any) {
//        self.modelUid = "CYizrDMSTDonvpxwCxIN"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        toggleBtn.isHidden = true
////        searchBtn.isHidden = false
////        self.undoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Gray_L-Shaped_Couch.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Gray_L-Shaped_Couch. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Gray L-Shaped Couch"
////                self.modelUid = "CYizrDMSTDonvpxwCxIN"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////               // modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [1.1,1.1,1.1]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Gray L-Shaped Couch has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addDanceFrames(_ sender: Any) {
//        self.modelUid = "HM7RhXgvplpG5S9gAZnn"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        self.sceneInfoButton.isHidden = true
////        self.undoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        toggleBtn.isHidden = true
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
//////        guard let fileUrl = Bundle.main.url(forResource: "1980", withExtension: "usdz"),
//////        let entity = try? ModelEntity.loadModel(contentsOf: fileUrl) else {
//////                 fatalError("could not load entity")
//////             }
////
//////        self.currentEntity = entity
//////        self.currentEntity.name = "Greek Snake Statue"
//////        print(self.currentEntity)
//////        self.currentEntity.generateCollisionShapes(recursive: true)
//////        self.sceneView.installGestures([.rotation, .scale, .translation], for: self.currentEntity) //.translation
//////        let anchor =  self.focusEntity?.anchor
//////        print(anchor)
//////        anchor?.addChild(self.currentEntity)
//////        self.currentEntity.scale = [0.00738,0.00738,0.00738]
//////        self.sceneView.scene.addAnchor(anchor!)
//////        print("modelEntity for Snake Statue has been loaded.")
//////        self.removeCloseButton()
//////        ProgressHUD.dismiss()
//////        self.modelPlacementUI()
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        self.categoryScrollView.isHidden = true
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Dance Frames.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Dance Frames. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Dance Frames"
////                self.modelUid = "HM7RhXgvplpG5S9gAZnn"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.2,0.2,0.2]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Dance Frames has been loaded.")
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    var tvStand : ModelEntity?
//    
//    @IBAction func addTVStand(_ sender: Any) {
//        self.modelUid = "kUCg8YOdf4buiXMwmxm7"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        toggleBtn.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        self.undoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Reclaimed_TV_Stand.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Reclaimed TV Stand. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.tvStand = modelEntity
////                self.currentEntity.name = "Reclaimed TV Stand"
////                self.modelUid = "kUCg8YOdf4buiXMwmxm7"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .kinematic)
////                modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [1.05,1.05,1.05]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Reclaimed TV Stand has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addWoodenPiano(_ sender: Any) {
//        self.modelUid = "5YCiyJ4bMMThRkYG9sQn"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        self.undoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        toggleBtn.isHidden = true
////        self.newSearchView.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Old_Wooden_Grand_Piano.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Old Wooden Grand Piano. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Old Wooden Grand Piano"
////                self.modelUid = "5YCiyJ4bMMThRkYG9sQn"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////               // modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.35,0.35,0.35]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Old Wooden Grand Piano has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addSamsungTV(_ sender: Any) {
//        self.modelUid = "z44i1R3BuOw2iPi7dV79"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        toggleBtn.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.undoButton.isHidden = true
////        self.newSearchView.isHidden = true
////        searchBtn.isHidden = false
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Samsung_Curved_TV.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Samsung 65' QLED 4K Curved Smart TV. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Samsung 65' QLED 4K Curved Smart TV"
////                self.modelUid = "z44i1R3BuOw2iPi7dV79"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////             //   modelEntity.components.set(physics)
////                if self.tvStand == nil {
////                    self.currentEntity = modelEntity
////                    self.currentEntity.name = "Samsung 65' QLED 4K Curved Smart TV"
////                    self.modelUid = "z44i1R3BuOw2iPi7dV79"
////                    print(self.currentEntity)
////                    self.currentEntity.generateCollisionShapes(recursive: true)
////                    let physics = PhysicsBodyComponent(massProperties: .default,
////                                                                material: .default,
////                                                                    mode: .dynamic)
////                   // modelEntity.components.set(physics)
////                    self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                    let anchor =  self.focusEntity?.anchor
////                    print(anchor)
////                    anchor?.addChild(self.currentEntity)
////                    self.currentEntity.scale = [0.35,0.35,0.35]
////                    self.sceneView.scene.addAnchor(anchor!)
////                    print("modelEntity for Samsung 65' QLED 4K Curved Smart TV has been loaded.")
////                    self.removeCloseButton()
////                    ProgressHUD.dismiss()
////                    self.modelPlacementUI()
////                } else {
////                    self.currentEntity = modelEntity
////                    self.currentEntity.name = "Samsung 65' QLED 4K Curved Smart TV"
////                    self.modelUid = "z44i1R3BuOw2iPi7dV79"
////                    print(self.currentEntity)
////                    self.currentEntity.generateCollisionShapes(recursive: true)
////                    let physics = PhysicsBodyComponent(massProperties: .default,
////                                                                material: .default,
////                                                                    mode: .dynamic)
////                   // modelEntity.components.set(physics)
////                    self.sceneView.installGestures([.rotation, .scale], for: self.currentEntity) //.translation
////                    let anchor =  self.focusEntity?.anchor
////                    print(anchor)
////                    anchor?.addChild(self.currentEntity)
////                    self.currentEntity.scale = [0.35,0.35,0.35]
////                    //create variable specifically for tvStand
////                    self.tvStand?.addChild(modelEntity) // .addAnchor(anchor!) //maybe currentEntity, not anchor
////                    modelEntity.setPosition(SIMD3(0.0, 0.78, 0.0), relativeTo: self.tvStand)
////                   // self.sceneView.scene.addAnchor(anchor!)
////                    print("modelEntity for Samsung 65' QLED 4K Curved Smart TV has been loaded.")
////                    self.removeCloseButton()
////                    ProgressHUD.dismiss()
////
////                    //self.modelPlacementUI()
////          //          //self.topView.isHidden = false
////                    self.searchBar.isHidden = true
////                    self.searchView.isHidden = true
////                    self.newSearchView.isHidden = true
////                   // self.searchStackView.isHidden = true
////                   // //searchStackUnderView.isHidden = true
////                    self.editButton.isHidden = false
////                    self.previewButton.isHidden = false
////                    self.profileButton.isHidden = false
////                    self.networkBtn.isHidden = false
////                    self.networksNearImg.isHidden = false
////                    self.betweenView.isHidden = false
////                    self.editUnderView.isHidden = false
////                    self.wordsBtn.isHidden = false
////                    self.videoBtn.isHidden = false
////                    self.searchBtn.isHidden = false
////                }
////            })
////        }
////
//        
//    }
//    
//    @IBAction func addPlant(_ sender: Any) {
//        self.modelUid = "7LQYGxvKqTiCvL13pHhl"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        toggleBtn.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.undoButton.isHidden = true
////        self.newSearchView.isHidden = true
////        searchBtn.isHidden = false
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Peace_Lily.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Peace Lily. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Peace Lily"
////                self.modelUid = "7LQYGxvKqTiCvL13pHhl"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////               // modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//////                let pinch = EntityScaleGestureRecognizer()
//////                self.currentEntity.ges
//////                sceneView.installGestures(.all, for: clonedEntity).forEach { entityGesture in
//////                    entityGesture.addTarget(self, action: #selector(handleEntityGesture(_:)))
//////                }
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.22,0.22,0.22]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Peace Lily has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func add3Frames(_ sender: Any) {
//        self.modelUid = "SqXjbhl1T0XbAeNw19en"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        toggleBtn.isHidden = true
////        //searchStackUnderView.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.undoButton.isHidden = true
////        self.newSearchView.isHidden = true
////        searchBtn.isHidden = false
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Frames_Version_03.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Picture Frames. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Picture Frames"
////                self.modelUid = "SqXjbhl1T0XbAeNw19en"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.7,0.7,0.7]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Picture Frames has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    
//    @IBAction func addJordans(_ sender: Any) {
//        self.modelUid = "T8fZY0CksR9nd9lO1m6e"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        toggleBtn.isHidden = true
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        browseTableView.isHidden = true
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////
////        ProgressHUD.show("Loading...")
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Cave_Painting.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Air Jordan 1s. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////               // self.currentEntity.name = "Air Jordan 1s"
////                self.currentEntity.name = "Wilson Basketball"
////                self.modelUid = "T8fZY0CksR9nd9lO1m6e"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////                modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////             //   self.currentEntity.scale = [0.08,0.08,0.08]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for Air Jordan 1s has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addCar(_ sender: Any) {
//        self.modelUid = "Kv1OErYZ5Jwl4RkBmTSn"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        toggleBtn.isHidden = true
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        if tvStand != nil {
////            guard let fileUrl = Bundle.main.url(forResource: "MacBook_Pro_2021", withExtension: "usdz"),
////            let entity = try? ModelEntity.loadModel(contentsOf: fileUrl) else {
////                     fatalError("could not load entity")
////                 }
////
////            self.currentEntity = entity
////            self.currentEntity.name = "2021 Macbook Pro"
////            print(self.currentEntity)
////            self.currentEntity.generateCollisionShapes(recursive: true)
////            let physics = PhysicsBodyComponent(massProperties: .init(mass: 1.6),
////                                                        material: .default,
////                                                            mode: .dynamic)
////            entity.components.set(physics)
////            self.sceneView.installGestures([.rotation, .scale], for: self.currentEntity) //.translation
////            let anchor =  self.focusEntity?.anchor
////            print(anchor)
////            anchor?.addChild(self.currentEntity)
////            self.currentEntity.scale = [0.12,0.12,0.12]
////            //create variable specifically for tvStand
////            self.tvStand?.addChild(entity) // .addAnchor(anchor!) //maybe currentEntity, not anchor
////            entity.setPosition(SIMD3(0.0, 0.78, 0.0), relativeTo: self.tvStand)
////            ProgressHUD.dismiss()
////          //  //self.topView.isHidden = false
////            self.searchBar.isHidden = true
////            self.searchView.isHidden = true
////            self.newSearchView.isHidden = true
////           // self.searchStackView.isHidden = true
////           // //searchStackUnderView.isHidden = true
////            self.editButton.isHidden = false
////            self.previewButton.isHidden = false
////            self.profileButton.isHidden = false
////            self.networkBtn.isHidden = false
////            self.networksNearImg.isHidden = false
////            self.betweenView.isHidden = false
////            self.editUnderView.isHidden = false
////            self.wordsBtn.isHidden = false
////            self.videoBtn.isHidden = false
////            self.searchBtn.isHidden = false
////        } else {
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/1975_Porsche_911_930_Turbo.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for 1975 Porsche 911 Turbo. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "1975 Porsche 911 Turbo"
////                self.modelUid = "Kv1OErYZ5Jwl4RkBmTSn"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////               // modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.2,0.2,0.2]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for 1975 Porsche 911 Turbo has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//        }//}
//    
//    @IBAction func addMonkeys(_ sender: Any) {
//        self.modelUid = "KiwSj0FAbpn5BVc0ulEd"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        toggleBtn.isHidden = true
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Monkeys_figure.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Monkeys figure. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "3 Monkey Statue"
////                self.modelUid = "KiwSj0FAbpn5BVc0ulEd"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor
////                print(anchor)
////                anchor?.addChild(self.currentEntity)
////                self.currentEntity.scale = [0.0025,0.0025,0.0025]
////                self.sceneView.scene.addAnchor(anchor!)
////                print("modelEntity for 3 Monkey Statue has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addFlowerBoy(_ sender: Any) {
//        searchBar.isHidden = true
//        //topview.isHidden = true
//        self.searchStackView.isHidden = true
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.categoryScrollView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchBtn.isHidden = false
//        self.newSearchView.isHidden = true
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//       
//        browseTableView.isHidden = true
//        self.addCloseButton()
//      //  view.endEditing(true)
//        let mesh = MeshResource.generatePlane(width: 1.05, depth: 1.5)// .generatePlane(width: 1.5, height: 0.9)    // 16:9 video
//
//        var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//        material.baseColor = try! .texture(.load(named: "flowerboy"))
//
////        material.baseColor = try! .texture(.load(named: "chanceposter"))
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        
//        self.currentEntity = planeModel
//        self.currentEntity.name = "Flower Boy Poster"
//        print(self.currentEntity)
//        self.currentEntity.generateCollisionShapes(recursive: true)
//        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                    material: .default,
//                                                        mode: .dynamic)
//       // modelEntity.components.set(physics)
//        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//        let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//        print(anchor)
//       // anchor?.scale = [1.2,1.0,1.0]
//        anchor?.addChild(self.currentEntity)
//        self.sceneView.scene.addAnchor(anchor!)
//       // self.currentEntity?.scale *= self.scale
//        self.removeCloseButton()
//        ProgressHUD.dismiss()
//       // print("modelEntity for \(self.name) has been loaded.")
//        self.modelPlacementUI()
//    }
//    
//    @IBAction func addAsapPoster(_ sender: Any) {
//        searchBar.isHidden = true
//        //topview.isHidden = true
//        self.searchStackView.isHidden = true
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.categoryScrollView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchBtn.isHidden = false
//        self.newSearchView.isHidden = true
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//       
//        browseTableView.isHidden = true
//        self.addCloseButton()
//      //  view.endEditing(true)
//        let mesh = MeshResource.generatePlane(width: 0.88, depth: 1.33)// .generatePlane(width: 1.5, height: 0.9)    // 16:9 video
//
//        var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//        material.baseColor = try! .texture(.load(named: "asapasap"))
//
////        material.baseColor = try! .texture(.load(named: "chanceposter"))
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        
//        self.currentEntity = planeModel
//        self.currentEntity.name = "A$AP Dior Poster"
//        print(self.currentEntity)
//        self.currentEntity.generateCollisionShapes(recursive: true)
//        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                    material: .default,
//                                                        mode: .dynamic)
//       // modelEntity.components.set(physics)
//        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//        let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//        print(anchor)
//       // anchor?.scale = [1.2,1.0,1.0]
//        anchor?.addChild(self.currentEntity)
//        self.sceneView.scene.addAnchor(anchor!)
//       // self.currentEntity?.scale *= self.scale
//        self.removeCloseButton()
//        ProgressHUD.dismiss()
//       // print("modelEntity for \(self.name) has been loaded.")
//        self.modelPlacementUI()
//    }
//    
//    @IBAction func addChancePoster(_ sender: Any) {
//        
//        searchBar.isHidden = true
//        //topview.isHidden = true
//        self.searchStackView.isHidden = true
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.categoryScrollView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        searchBtn.isHidden = false
//        self.newSearchView.isHidden = true
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//       
//        browseTableView.isHidden = true
//        self.addCloseButton()
//      //  view.endEditing(true)
//        let mesh = MeshResource.generatePlane(width: 1.5, depth: 1)// .generatePlane(width: 1.5, height: 0.9)    // 16:9 video
//
//        var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//        material.baseColor = try! .texture(.load(named: "chanceposter"))
//
////        material.baseColor = try! .texture(.load(named: "chanceposter"))
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        
//        self.currentEntity = planeModel
//        self.currentEntity.name = "Chance the Rapper Poster"
//        print(self.currentEntity)
//        self.currentEntity.generateCollisionShapes(recursive: true)
//        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                    material: .default,
//                                                        mode: .dynamic)
//       // modelEntity.components.set(physics)
//        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//        let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//        print(anchor)
//       // anchor?.scale = [1.2,1.0,1.0]
//        anchor?.addChild(self.currentEntity)
//        self.sceneView.scene.addAnchor(anchor!)
//       // self.currentEntity?.scale *= self.scale
//        self.removeCloseButton()
//        ProgressHUD.dismiss()
//       // print("modelEntity for \(self.name) has been loaded.")
//        self.modelPlacementUI()
//        
//    }
//    
//    @IBAction func addVintageDesk(_ sender: Any) {
//        self.modelUid = "uz9qRIM24cMmYXXte0CV"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        toggleBtn.isHidden = true
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        searchBtn.isHidden = false
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Vintage_Table_Desk.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Vintage Table Desk. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Vintage Table Desk"
////                self.modelUid = "uz9qRIM24cMmYXXte0CV"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////               // modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
////                print(anchor)
////               // anchor?.scale = [1.2,1.0,1.0]
////                anchor?.addChild(self.currentEntity)
////                //self.currentEntity = currentEntity
////                self.currentEntity.scale = [0.5,0.5,0.5]
////                self.sceneView.scene.addAnchor(anchor!)
////               // self.currentEntity?.scale *= self.scale
////                print("modelEntity for Vintage Table Desk has been loaded.")
////                self.removeCloseButton()
////                ProgressHUD.dismiss()
////               // print("modelEntity for \(self.name) has been loaded.")
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addFlowerVase(_ sender: Any) {
//        self.modelUid = "r9vrD5hp7KcgnoHRPlJl"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        toggleBtn.isHidden = true
////        searchBtn.isHidden = false
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Flower Vase.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Flower Vase. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Flower Vase"
////                self.modelUid = "r9vrD5hp7KcgnoHRPlJl"
////                self.currentEntity.scale = [0.0033,0.0033,0.0033]
////                self.downloadModel()
////            })
////        }
//    }
//    
//    @objc func downloadModel(){
//        print(self.currentEntity)
//        self.currentEntity.generateCollisionShapes(recursive: true)
//        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                    material: .default,
//                                                        mode: .dynamic)
//      //  modelEntity.components.set(physics)
//        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//        let anchor =  self.focusEntity?.anchor
//        print(anchor)
//        anchor?.addChild(self.currentEntity)
//        //self.currentEntity.scale = [0.0033,0.0033,0.0033]
//        self.sceneView.scene.addAnchor(anchor!)
//        print("modelEntity for Flower Vase has been loaded.")
//        ProgressHUD.dismiss()
//        self.modelPlacementUI()
//    }
//    
//    @IBAction func addWoodenTable(_ sender: Any) {
//        self.modelUid = "xbWdRPZeD3nQB4TozEXR"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        toggleBtn.isHidden = true
////        searchBtn.isHidden = false
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Wooden_Table.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Wooden_Table. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Wooden Table"
////                self.modelUid = "xbWdRPZeD3nQB4TozEXR"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////              //  modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
////                print(anchor)
////               // anchor?.scale = [1.2,1.0,1.0]
////                anchor?.addChild(self.currentEntity)
////                //self.currentEntity = currentEntity
////                self.currentEntity.scale = [2,2,2]
////                self.sceneView.scene.addAnchor(anchor!)
////               // self.currentEntity?.scale *= self.scale
////                print("modelEntity for Wooden_Table has been loaded.")
////                ProgressHUD.dismiss()
////                self.removeCloseButton()
////               // print("modelEntity for \(self.name) has been loaded.")
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addRusticChair(_ sender: Any) {
//        
//        self.modelUid = "e4aE8GPAZ0D3UcD9wMPo"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        let defaults = UserDefaults.standard
////        defaults.set(true, forKey: "eleventh")
////        walkthroughLabel.removeFromSuperview()
////        circle.removeFromSuperview()
////        if defaults.bool(forKey: "twelvth") == false && defaults.bool(forKey: "finishedWalkthrough") == false {
////            circle.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 37, y: 690, width: 74, height: 74)
////            circle.backgroundColor = .clear
////            circle.layer.cornerRadius = 37
////            circle.clipsToBounds = true
////            circle.layer.borderColor = UIColor.systemBlue.cgColor
////            circle.layer.borderWidth = 4
////            circle.isUserInteractionEnabled = false
////            circle.alpha = 1.0
////            self.placementStackBottomConstraint.constant = 55
////                // sceneView.addSubview(circle)
////            self.walkthroughLabel.frame = CGRect(x: 35, y: 590, width: UIScreen.main.bounds.width - 70, height: 60)
////            self.walkthroughLabel.text = "Place it on a horizontal surface and tap the checkmark button"
////            self.sceneView.addSubview(self.walkthroughLabel)
////            self.walkthroughViewLabel.text = "12 of 18"
////
////            let delay = 1
////            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
////                self.sceneView.addSubview(self.circle)
////                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
////                    self.circle.alpha = 0.1
////                       })
////
////            }
////        }
////
////
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        self.undoButton.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        toggleBtn.isHidden = true
////        searchBtn.isHidden = false
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Rustic_chair.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Rustic Chair. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Rustic Chair"
////                self.modelUid = "e4aE8GPAZ0D3UcD9wMPo"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////               // modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
////                print(anchor)
////               // anchor?.scale = [1.2,1.0,1.0]
////                anchor?.addChild(self.currentEntity)
////                //self.currentEntity = currentEntity
////                self.currentEntity.scale = [1,1,1]
////                self.sceneView.scene.addAnchor(anchor!)
////               // self.currentEntity?.scale *= self.scale
////                print("modelEntity for Rustic Chair has been loaded.")
////                ProgressHUD.dismiss()
////                self.removeCloseButton()
////               // print("modelEntity for \(self.name) has been loaded.")
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    @IBAction func addJunji(_ sender: Any) {
//        self.modelUid = "bDohDSgk5IlFTkd5ODSx"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        toggleBtn.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.undoButton.isHidden = true
////        self.newSearchView.isHidden = true
////        searchBtn.isHidden = false
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Junji_Ito_-_Tomie_Kawakami.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Tomie Kawakami by Junji Ito. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Tomie Kawakami by Junji Ito"
////                self.modelUid = "bDohDSgk5IlFTkd5ODSx"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
////                print(anchor)
////               // anchor?.scale = [1.2,1.0,1.0]
////                anchor?.addChild(self.currentEntity)
////                //self.currentEntity = currentEntity
////                self.currentEntity.scale = [1,1,1]
////                self.sceneView.scene.addAnchor(anchor!)
////               // self.currentEntity?.scale *= self.scale
////                print("modelEntity for Tomie Kawakami by Junji Ito has been loaded.")
////                ProgressHUD.dismiss()
////                self.removeCloseButton()
////               // print("modelEntity for \(self.name) has been loaded.")
////                self.modelPlacementUI()
////            })
////            }
//    }
//    
//    @IBAction func addSailingShip(_ sender: Any) {
//        self.modelUid = "pAmBHFgojiOHjthpAEKY"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        self.searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        toggleBtn.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.undoButton.isHidden = true
////        searchBtn.isHidden = false
////        self.newSearchView.isHidden = true
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Sailing_Ship_Model.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Mayflower Ship Model. Error: \(error.localizedDescription)")
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
//////                self.sceneView.removeGestureRecognizer(holdGesture)
////                self.currentEntity = modelEntity
////                self.currentEntity.name = "Mayflower Ship Model"
////                self.modelUid = "pAmBHFgojiOHjthpAEKY"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////                // modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
////                print(anchor)
////               // anchor?.scale = [1.2,1.0,1.0]
////                anchor?.addChild(self.currentEntity)
////                //self.currentEntity = currentEntity
////                self.currentEntity.scale = [0.2,0.2,0.2]
////                self.sceneView.scene.addAnchor(anchor!)
////               // self.currentEntity?.scale *= self.scale
////                print("modelEntity for Mayflower Ship Model has been loaded.")
////                ProgressHUD.dismiss()
////                self.removeCloseButton()
////               // print("modelEntity for \(self.name) has been loaded.")
////                self.modelPlacementUI()
////            })
////
//     //   }
//      //  modelPlacementUI()
//    }
//    
//    var modelName = ""
//    
//    func downloadContentFromMarketplace(){
//        searchBar.isHidden = true
//            //topview.isHidden = true
//            self.searchStackView.isHidden = true
//            //searchStackUnderView.isHidden = true
//            toggleBtn.isHidden = true
//            self.sceneInfoButton.isHidden = true
//            self.categoryScrollView.isHidden = true
//            self.undoButton.isHidden = true
//            searchBtn.isHidden = false
//            self.newSearchView.isHidden = true
//            dismissKeyboard()
//            ProgressHUD.show("Loading...")
//
//            browseTableView.isHidden = true
//            self.addCloseButton()
//        print("\(self.modelName) is modelName")
//        FirestoreManager.getModel(self.modelUid) { model in
//            let modelName = model?.modelName
//            print("\(modelName ?? "") is model name")
//            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")")  { localUrl in
//                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                    switch loadCompletion {
//                    case.failure(let error): print("Unable to load modelEntity for Mayflower Ship Model. Error: \(error.localizedDescription)")
//                        ProgressHUD.dismiss()
//                    case.finished:
//                        break
//                    }
//                }, receiveValue: { modelEntity in
//    //                self.sceneView.removeGestureRecognizer(holdGesture)
//                    self.currentEntity = modelEntity
//                   // FirestoreManager.getModel(self.modelUid) { model in
//                        self.currentEntity.name = model?.name ?? ""
//                     //   self.modelUid =
//                        print(self.currentEntity)
//                        self.currentEntity.generateCollisionShapes(recursive: true)
//                        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                                    material: .default,
//                                                                        mode: .dynamic)
//                        // modelEntity.components.set(physics)
//                        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//                        let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//                        print(anchor)
//                       // anchor?.scale = [1.2,1.0,1.0]
//                        anchor?.addChild(self.currentEntity)
//                        let scale = model?.scale
//                        print("\(scale) is scale")
//                        self.currentEntity.scale = [Float(scale ?? 0.01), Float(scale ?? 0.01), Float(scale ?? 0.01)]
//                        self.sceneView.scene.addAnchor(anchor!)
//                       // self.currentEntity?.scale *= self.scale
//                        print("modelEntity for Mayflower Ship Model has been loaded.")
//                        ProgressHUD.dismiss()
//                        self.removeCloseButton()
//                       // print("modelEntity for \(self.name) has been loaded.")
//                        self.modelPlacementUI()
//                    })
//                    
//                }
//
//
//            }
//    }
//    
//    var modelId1 = ""
//    var modelId2 = ""
//    
//    @objc func addItem(){
////        attachLocationProviderToSession()
//        isPlacingModel = true
//        searchBar.isHidden = true
//        //topview.isHidden = true
//        newSearchView.isHidden = true
//        searchStackView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        toggleBtn.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.undoButton.isHidden = true
//        self.categoryScrollView.isHidden = true
//        self.newSearchView.isHidden = true
//        searchBtn.isHidden = false
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//       
//        browseTableView.isHidden = true
//        self.addCloseButton()
//        
//        FirestoreManager.getModel(modelId1) { model in
//            let modelName = model?.modelName
//            print("\(modelName ?? "") is model name")
//            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")") { localUrl in
//                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                    switch loadCompletion {
//                    case.failure(let error): print("Unable to load modelEntity for \(modelName ?? ""). Error: \(error.localizedDescription)")
//                        //  handler(false, error)
//                    case.finished:
//                        break
//                    }
//                }, receiveValue: { modelEntity in
//                    self.currentEntity.accessibilityDescription = self.modelId1
//                 //   print("\(self.currentEntity.accessibilityDescription.id) is model")
//              //      self.currentEntity.id = modelEntity.id
//                     
//                    let box = self.currentEntity.visualBounds(recursive: true, relativeTo: self.currentEntity, excludeInactive: true)
//                    //sceneView.addSubview(box)
//                    self.currentEntity.name = "\(model?.name ?? "")"
//                    print(self.currentEntity)
//                    self.currentEntity.generateCollisionShapes(recursive: true)
//                    let physics = PhysicsBodyComponent(massProperties: .default,
//                                                       material: .default,
//                                                       mode: .dynamic)
//                    //   modelEntity.components.set(physics)
//                    self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//                    let anchorEntity =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//                    print(anchorEntity as Any)
//                    // anchorEntity?.visualBounds(relativeTo: s)
//                    anchorEntity?.addChild(self.currentEntity)
//                    //    anchorEntity?.anchoring = AnchoringComponent(self.anchorPlaced!)
//                    let scale = model?.scale
//                    print("\(scale) is scale")
//                    //    anchorEntity?.anchoring = AnchoringComponent(self.anchorPlaced!)
//                    self.currentEntity.scale = [Float(scale ?? 0.01), Float(scale ?? 0.01), Float(scale ?? 0.01)]
//                    self.sceneView.scene.addAnchor(anchorEntity!)
//                    print("modelEntity for \(modelName) has been loaded.")
//                    ProgressHUD.dismiss()
//                    self.isPlacingModel = false
//                    self.removeCloseButton()
//                    // print("modelEntity for \(self.name) has been loaded.")
//                    self.modelPlacementUI()
//                })
//            }}
//        
//        //add model to network if connected to Network and owner
//            //get modelId, AzureCloudAnchorId, Scale, Date()
//        //also if connected to network and not owner - then remove UI
//        
//    }
//    
//    
//    @objc func addItem2(){
//        isPlacingModel = true
//        searchBar.isHidden = true
//        //topview.isHidden = true
//        newSearchView.isHidden = true
//        searchStackView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        toggleBtn.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.undoButton.isHidden = true
//        self.categoryScrollView.isHidden = true
//        self.newSearchView.isHidden = true
//        searchBtn.isHidden = false
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//       
//        browseTableView.isHidden = true
//        self.addCloseButton()
//        
//        FirestoreManager.getModel(modelId2) { model in
//            let modelName = model?.modelName
//            print("\(modelName ?? "") is model name")
//            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")") { localUrl in
//                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                    switch loadCompletion {
//                    case.failure(let error): print("Unable to load modelEntity for \(modelName ?? ""). Error: \(error.localizedDescription)")
//                        //  handler(false, error)
//                    case.finished:
//                        break
//                    }
//                }, receiveValue: { modelEntity in
//                    self.currentEntity = modelEntity
//                  //  modelEntity.id = modelId2
//                 //   self.currentEntity.id = modelEntity.id
//                    
//                    let box = self.currentEntity.visualBounds(recursive: true, relativeTo: self.currentEntity, excludeInactive: true)
//                    //sceneView.addSubview(box)
//                    self.currentEntity.name = "\(model?.name ?? "")"
//                    print(self.currentEntity)
//                    self.currentEntity.generateCollisionShapes(recursive: true)
//                    let physics = PhysicsBodyComponent(massProperties: .default,
//                                                       material: .default,
//                                                       mode: .dynamic)
//                    //   modelEntity.components.set(physics)
//                    self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//                    let anchorEntity =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//                    print(anchorEntity as Any)
//                    // anchorEntity?.visualBounds(relativeTo: s)
//                    anchorEntity?.addChild(self.currentEntity)
//                    let scale = model?.scale
//                    print("\(scale) is scale")
//                    //    anchorEntity?.anchoring = AnchoringComponent(self.anchorPlaced!)
//                    self.currentEntity.scale = [Float(scale ?? 0.01), Float(scale ?? 0.01), Float(scale ?? 0.01)] // [0.85,0.75,0.75]
//                    self.sceneView.scene.addAnchor(anchorEntity!)
//                    print("modelEntity for \(modelName) has been loaded.")
//                    ProgressHUD.dismiss()
//                    self.isPlacingModel = false
//                    self.removeCloseButton()
//                    // print("modelEntity for \(self.name) has been loaded.")
//                    self.modelPlacementUI()
//                })
//            }}
//    }
//    
//    public var modelUid = ""
//    
//    @IBAction func addAbstractPainting(_ sender: Any) { //(handler: @escaping (_ completed: Bool, _ error: Error?) -> Void)
//        self.modelUid = "2mG9Q1zMR6Avye5JZHFX"
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var next = ObjectProfileViewController.instantiate(with: modelUid)
//        next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//        
////        let defaults = UserDefaults.standard
////        defaults.set(true, forKey: "third")
////        walkthroughLabel.removeFromSuperview()
////        circle.removeFromSuperview()
////        if defaults.bool(forKey: "fourth") == false && defaults.bool(forKey: "finishedWalkthrough") == false {
////            circle.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 37, y: 690, width: 74, height: 74)
////            circle.backgroundColor = .clear
////            circle.layer.cornerRadius = 37
////            circle.clipsToBounds = true
////            circle.layer.borderColor = UIColor.systemBlue.cgColor
////            circle.layer.borderWidth = 4
////            circle.isUserInteractionEnabled = false
////            circle.alpha = 1.0
////                // sceneView.addSubview(circle)
////            self.walkthroughLabel.frame = CGRect(x: 20, y: 590, width: UIScreen.main.bounds.width - 40, height: 80)
////            self.walkthroughLabel.text = "Move the painting to a location where you desire it to be on a vertical surface, then tap the checkmark to place the asset."
////            self.sceneView.addSubview(self.walkthroughLabel)
////            self.walkthroughViewLabel.text = "4 of 18"
////
////            let delay = 1
////            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(delay))) {
////                self.sceneView.addSubview(self.circle)
////                UIView.animate(withDuration: 0.85, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
////                    self.circle.alpha = 0.1
////                       })
////
////            }
////        }
////
////
////        searchBar.isHidden = true
////        //topview.isHidden = true
////        newSearchView.isHidden = true
////        searchStackView.isHidden = true
////        //searchStackUnderView.isHidden = true
////        toggleBtn.isHidden = true
////        self.sceneInfoButton.isHidden = true
////        self.undoButton.isHidden = true
////        self.categoryScrollView.isHidden = true
////        self.newSearchView.isHidden = true
////        searchBtn.isHidden = false
////        dismissKeyboard()
////        ProgressHUD.show("Loading...")
////
////        browseTableView.isHidden = true
////        self.addCloseButton()
////        FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/Abstract Painting.usdz") { localUrl in
////            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
////                switch loadCompletion {
////                case.failure(let error): print("Unable to load modelEntity for Abstract Painting. Error: \(error.localizedDescription)")
////                  //  handler(false, error)
////                case.finished:
////                    break
////                }
////            }, receiveValue: { modelEntity in
////                self.currentEntity = modelEntity
////                self.modelUid = "2mG9Q1zMR6Avye5JZHFX"
////                let box = self.currentEntity.visualBounds(recursive: true, relativeTo: self.currentEntity, excludeInactive: true)
////                //sceneView.addSubview(box)
////                self.currentEntity.name = "Abstract Painting"
////                print(self.currentEntity)
////                self.currentEntity.generateCollisionShapes(recursive: true)
////                let physics = PhysicsBodyComponent(massProperties: .default,
////                                                            material: .default,
////                                                                mode: .dynamic)
////             //   modelEntity.components.set(physics)
////                self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
////                let anchorEntity =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
////                print(anchorEntity as Any)
////               // anchorEntity?.visualBounds(relativeTo: s)
////                anchorEntity?.addChild(self.currentEntity)
////            //    anchorEntity?.anchoring = AnchoringComponent(self.anchorPlaced!)
////                self.currentEntity.scale = [0.85,0.75,0.75]
////                self.sceneView.scene.addAnchor(anchorEntity!)
////                print("modelEntity for Abstract Painting has been loaded.")
////                ProgressHUD.dismiss()
////                self.removeCloseButton()
////               // print("modelEntity for \(self.name) has been loaded.")
////                self.modelPlacementUI()
////            })
////        }
//    }
//    
//    private var cancellable: AnyCancellable?
//    
//    let nftView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 375))
//    let searchStackUnderView = UIView(frame: CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width / 2, height: 2))
//    
//    
//    @IBAction func modelModeAction(_ sender: Any) {
//        nftMode.setTitleColor(.darkGray, for: .normal)
//        //searchStackUnderView.removeFromSuperview()
//        if #available(iOS 15.0, *) {
//            modelsMode.setTitleColor(.tintColor, for: .normal)
//            //searchStackUnderView.backgroundColor = .tintColor // setTitleColor(.tintColor, for: .normal)
//        } else {
//            modelsMode.setTitleColor(.link, for: .normal)
//            //searchStackUnderView.backgroundColor = .link
//        }
//        //searchStackUnderView.bottomAnchor.constraint(equalTo: //topview.bottomAnchor)
//        //searchStackUnderView.frame.origin.x = 0
//   //     print("\( //searchStackUnderView.frame.origin.x) is //searchStackUnderView x")
//    //    searchStackView.addSubview(//searchStackUnderView)
//    //    browseTableView.isScrollEnabled = true
//    //    nftView.removeFromSuperview()
//    }
//    
//    @IBAction func nftModeAction(_ sender: Any) {
////        nftMode.tintColor = .link
//        //searchStackUnderView.removeFromSuperview()
//        if #available(iOS 15.0, *) {
//            nftMode.setTitleColor(.tintColor, for: .normal)
//            //searchStackUnderView.backgroundColor = .tintColor
//        } else {
//            nftMode.setTitleColor(.link, for: .normal)
//            //searchStackUnderView.backgroundColor = .link
//        }
//        modelsMode.setTitleColor(.darkGray, for: .normal)
////        //searchStackUnderView.frame.origin.x = UIScreen.main.bounds.width / 2
////        print("\( //searchStackUnderView.frame.origin.x) is //searchStackUnderView x")
//        
//        //searchStackUnderView.bottomAnchor.constraint(equalTo: //topview.bottomAnchor)
//        //searchStackUnderView.frame.origin.x = UIScreen.main.bounds.width / 2
//    //    print("\( //searchStackUnderView.frame.origin.x) is //searchStackUnderView x")
//  //      searchStackView.addSubview(//searchStackUnderView)
//        
//   //     nftView.backgroundColor = .white
//        
//        let nftViewHeader = UILabel(frame: CGRect(x: 22, y: 13, width: 346, height: 73))
//        nftViewHeader.numberOfLines = 2
//        nftViewHeader.text = "Blueprint NFT Marketplace is coming soon!"
//        nftViewHeader.textColor = .black
//        nftViewHeader.textAlignment = .center
//        nftViewHeader.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
//        let nftViewLabel = UILabel(frame: CGRect(x: 8, y: 94, width: 374, height: 97))
//        nftViewLabel.numberOfLines = 4
//        nftViewLabel.text = "Blueprint NFTs will be a peer-to-peer AR NFT Marketplace where creators can monetize their art/talents in a new way."
//        nftViewLabel.textColor = .darkGray
//        nftViewLabel.textAlignment = .center
//        nftViewLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
//        let nftViewSublabel = UILabel(frame: CGRect(x: 8, y: 215, width: 374, height: 153))
////        let attributedString = NSMutableAttributedString.init(string: "www.blueprint.com/nft/announce")
////
////             // Add Underline Style Attribute.
////             attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
////                 NSRange.init(location: 0, length: attributedString.length));
//        
//        nftViewSublabel.numberOfLines = 5
//        nftViewSublabel.text = "Sign up for early access and regular updates today by visiting www.blueprint.com/nft/announce. We’ve got a lot more exciting news to come that you won’t want to miss."
//        nftViewSublabel.textColor = .darkGray
//        nftViewSublabel.textAlignment = .center
//        nftViewSublabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//    }
//    
//    func networksNear(){
//        print("\(self.currentLocation?.coordinate.latitude) is lat")
//        print("\(self.currentLocation?.coordinate.longitude) is long")
//        print("\(self.originalLocation.coordinate.latitude) is orig lat")
//        print("\(self.originalLocation.coordinate.longitude) is orig long")
////        FirestoreManager.getNetworksInRange(centerCoord: CLLocationCoordinate2D(latitude: (self.currentLocation?.coordinate.latitude)!, longitude: (self.currentLocation?.coordinate.longitude)!), withRadius: 40) { Network in
//        FirestoreManager.getNetworksInRange(centerCoord: CLLocationCoordinate2D(latitude: (self.originalLocation.coordinate.latitude), longitude: (self.originalLocation.coordinate.longitude)), withRadius: 40) { Network in
//            
//            let num = Network.count
//            if num == 0 {
//                self.networksNearImg.isHidden = true
//            } else if self.browseTableView.isHidden == true || self.isPlacingModel == true {
//                self.networksNearImg.image = UIImage(systemName: "\(num).circle.fill")
//                self.networksNearImg.isHidden = false
//            }
//        }}
//    
//    var isPlacingModel = false
//    
//    @objc func modelPlacementUI(){
//        self.sceneView.removeGestureRecognizer(holdGesture)
//        self.isPlacingModel = true
//        self.networksNearImg.isHidden = true
//        self.placementStackView.isHidden = false
//        //self.topView.isHidden = true
//        self.searchStackView.isHidden = true
//        //searchStackUnderView.isHidden = true
//        self.networkBtn.isHidden = true
//        self.networksNearImg.isHidden = true
//        self.wordsBtn.isHidden = true
//        self.videoBtn.isHidden = true
//        self.buttonStackView.isHidden = true
////        searchBtn.isHidden = true
//        addButton.isHidden = true
//        shareImg.isHidden = true
//        self.progressView?.isHidden = true
//        toggleBtn.isHidden = true
//        searchBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
//        self.sceneView.removeGestureRecognizer(doubleTap)
//        if currentEntity.name == "Blank Canvas"{
//            duplicateBtn.isHidden = false
//        } else {
//            duplicateBtn.isHidden = true
//
//        }
//        saveButton.isHidden = true
//        undoButton.isHidden = true
//        numberOfEditsImg.isHidden = true
//     //   entityName = UILabel(frame: CGRect(x: 20, y: 140, width: 300, height: 30))
//        entityName = UILabel(frame: CGRect(x: 35, y: 87, width: 340, height: 30))
////        entityName.trailingAnchor.constraint(equalTo: sceneView.trailingAnchor, constant: 45).isActive = true
//        entityName.text = currentEntity.name
//        entityName.textColor = .white
//        entityName.font = UIFont(name: "Noto Sans Kannada Bold", size: 22) //UIFont.systemFont(ofSize: 22, weight: .bold)
////        entityProfileBtn = UIButton(frame: CGRect(x: 12, y: 173, width: 100, height: 20))
//        entityName.textAlignment = .right
//        entityProfileBtn = UIButton(frame: CGRect(x: 285, y: 120, width: 100, height: 20))
//        
//        
//        entityProfileBtn.titleLabel?.font = UIFont(name: "Noto Sans Kannada", size: 15) //.systemFont(ofSize: 15)
//        entityProfileBtn.setTitle("View Profile", for: .normal)
//      //  entityProfileBtn.color = .red
//        entityProfileBtn.setTitleColor(.systemYellow, for: .normal)// = .blue
//        entityProfileBtn.isUserInteractionEnabled = true
//      //  entityProfileBtn.addGestureRecognizer(profileRecognizer)
//        
//        entityName.isHidden = false
//        entityProfileBtn.isHidden = false
//        
//        sceneView.addSubview(entityName)
//        if entityName.text == "" || entityName.text == .none || ((entityName.text?.contains("Photo by")) == true){
//            //self.selectedAnchorID = String(currentAnchor.id)
//        } else {
//            sceneView.addSubview(entityProfileBtn)
//        }
//        
//        networksNearImg.isHidden = true
//     //     networkBtn.setImage(UIImage(systemName: "icloud.and.arrow.up.fill"), for: .normal)
//        
//        self.view.isUserInteractionEnabled = true
//        self.sceneView.isUserInteractionEnabled = true
//    }
//    
//    var likeTouches = 0
//    
//            
//    @objc func like(){
//        if Auth.auth().currentUser != nil {
//            
//            likeTouches += 1
//            var likeID = ""
//            if currentEntity.name == "" || currentEntity.name == .none {
//                likeID = String(self.currentAnchor.id)
//                //            FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
//                //                if ((user?.likedAnchorIDs.contains(likeID)) == true) {
//                //                    self.likeTouches += 1
//                //                }
//                //            }
//            } else {
//                likeID = String(self.currentEntity.id)
//                //            FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
//                //                if ((user?.likedAnchorIDs.contains(likeID)) == true) {
//                //                    self.likeTouches += 1
//                //                }
//                //            }
//            }
//            
//            if likeTouches % 2 == 0 {
//                heartImg.tintColor = .white
//                heartImg.alpha = 0.70
//                
//                FirestoreManager.getSessionAnchor(likeID) { anchor in
//                    //   let ID = self.selectedNodeAnchorID
//                    
//                    let docRef = self.db.collection("sessionAnchors").document(anchor?.id ?? "")
//                    docRef.updateData([
//                        "likes": FieldValue.increment(Int64(-1))
//                    ])
//                    
//                    let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
//                    docRef2.updateData([
//                        "likedAnchorIDs": FieldValue.arrayRemove(["\(likeID)"])
//                    ])
//                    
//                    self.anchorLikesLabel.text = "\(self.originalAnchorLikes)"
//                    
//                    let host = anchor?.host
//                    FirestoreManager.getUser(host!) { user in
//                        let hostPointsRef = self.db.collection("users").document(host!)
//                        hostPointsRef.updateData([
//                            "points": FieldValue.increment(Int64(-3))
//                        ])
//                    }
//                }} else {
//                    heartImg.tintColor = .systemRed
//                    heartImg.alpha = 0.95
//                    FirestoreManager.getSessionAnchor(likeID) { anchor in
//                        //  let ID = self.selectedNodeAnchorID
//                        
//                        let docRef = self.db.collection("sessionAnchors").document(anchor?.id ?? "")
//                        docRef.updateData([
//                            "likes": FieldValue.increment(Int64(1))
//                        ])
//                        
//                        let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
//                        docRef2.updateData([
//                            "likedAnchorIDs": FieldValue.arrayUnion(["\(likeID)"])
//                        ])
//                        
//                        self.anchorLikesLabel.text = "\(self.originalAnchorLikes + 1)"
//                        let host = anchor?.host
//                        FirestoreManager.getUser(host!) { user in
//                            let hostPointsRef = self.db.collection("users").document(host!)
//                            hostPointsRef.updateData([
//                                "points": FieldValue.increment(Int64(3))
//                            ])
//                        }
//                    }
//                }
//        } else {
//            let alert = UIAlertController(title: "Create Account", message: "When you create an account on Blueprint, you can interact with content.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Sign Up", style: .default) { action in
//                
//                self.goToSignUp()
//            })
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
//                //completionHandler(false)
//                return
//            })
//            present(alert, animated: true)
//        }
//    }
//    
//    @objc func goToSignUp(){
//        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
//        var next = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
//         next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//    }
//    
//    func updateUserLocation() {
//        if self.currentLocation?.distance(from: self.originalLocation) ?? 0 >= 7 && self.currentLocation?.distance(from: self.originalLocation) ?? 0 < 200 {
// //           self.lookForAnchorsNearDevice()
//         //   self.anchorsNear()
//            print("updated anchor near")
//            self.originalLocation = CLLocation(latitude: currentLocation?.coordinate.latitude ?? 42.3421531456477, longitude: currentLocation?.coordinate.longitude ?? -71.08596376738004)
//            print("\(originalLocation) is og location")
//        }
//    }
//    
//    var closeButton = UIButton()
//    
//    
//    
//    func addCloseButton(){
////        closeButton = UIButton(frame: CGRect(x: 33, y: 55, width: 35, height: 35))
////        closeButton.tintColor = .white
////        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
////        let img = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
////        closeButton.setTitleColor(UIColor.white, for: .normal)
////        closeButton.setImage(img, for: .normal)
////        closeButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
////        sceneView.addSubview(closeButton)
//    }
//    
//    func removeCloseButton(){
//        closeButton.removeFromSuperview()
//    }
//    
//    @objc func exit(){
//        ProgressHUD.dismiss()
//        self.updatePersistanceAvailability(for: sceneView)
//            searchBar.isHidden = true
//        entityName.isHidden = true
//        entityProfileBtn.isHidden = true
//        placementStackBottomConstraint.constant = 15
//          //  //topview.isHidden = false
//            searchView.isHidden = true
//        self.newSearchView.isHidden = true
//            networkBtn.isHidden = false
//            profileButton.isHidden = false
//            editUnderView.isHidden = false
//        wordsBtn.isHidden = false
//        videoBtn.isHidden = false
//            networksNearImg.isHidden = false
//            searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//            betweenView.isHidden = false
//         //   searchBar.isHidden = false
//            editUnderView.isHidden = false
//       //
//       //
//        placementStackView.isHidden = true
//            editButton.isHidden = false
//            previewButton.isHidden = false
//        duplicateBtn.isHidden = true
//      //  shareImg.isHidden = false
//        
//      //  searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//      //  toggleBtn.isHidden = false
//        searchBtn.isHidden = false
//        //networkBtn.setImage(UIImage(systemName: "icloud.and.arrow.up.fill"), for: .normal)
//       // networksNearImg.isHidden = false
//       // networksNearImg.tintColor = .systemYellow
//          //  numberOfEditsImg.isHidden = false
//         //   saveButton.isHidden  = true
//        return
//    }
//    
//    func noLidarModelPlacementUI(){
//        
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
////        //1. Get The Current Touch Location
////        guard let touchLocation = touches.first?.location(in: self.sceneView),
////
////            //2. Perform An SCNHitTest To See If We Have Touch A Control Button
////            let hitTest = self.sceneView.hitTest(touchLocation, options: nil).first,
////
////            //3. Check The Parent Node Is Our VideoNodeSK
////            let videoNode = hitTest.node.parent as? VideoNodeSK,
////
////            //4. Check We Have Hit A Control Button
////            let functionName = hitTest.node.name else { return }
////
////        //5. Perform The Video Playback Function
////        switch functionName {
////        case "Play":
////            videoNode.playVideo()
////        case "Stop":
////            videoNode.stopVideo()
////        case "Loop":
////            videoNode.loopVideo()
////        case "Mute":
////            videoNode.muteVideo()
////        case "Forwards", "Backwards":
////            videoNode.changeVideoItem(functionName)
////        default:
////            return
////        }
//
//    }
//    
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        switch frame.worldMappingStatus {
//        case .notAvailable, .limited:
//            shareImg.isUserInteractionEnabled = false
//        case .extending:
//            shareImg.isUserInteractionEnabled = !multipeerSession.connectedPeers.isEmpty
//        case .mapped:
//            shareImg.isUserInteractionEnabled = !multipeerSession.connectedPeers.isEmpty
//        @unknown default:
//            shareImg.isUserInteractionEnabled = false
//        }
//        
//        if let cloudSession = cloudSession {
//            cloudSession.processFrame(sceneView.session.currentFrame)
//            
////            if (currentlyPlacingAnchor && enoughDataForSaving && localAnchor != nil) {
////                createCloudAnchor()
////            }
//        }
//     //   print(frame.worldMappingStatus.description)
//     //   print(frame.camera.trackingState)
//        //updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
//        
//        //if defaults.bool(forKey: "lookForAnchorsNear") == true {
//            self.updateUserLocation()
//       // }
//    }
//    
//    /// - Tag: DidOutputCollaborationData
//    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
//        guard let multipeerSession = multipeerSession else { return }
//        if !multipeerSession.connectedPeers.isEmpty {
//            guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
//            else { fatalError("Unexpectedly failed to encode collaboration data.") }
//            // Use reliable mode if the data is critical, and unreliable mode if the data is optional.
//            let dataIsCritical = data.priority == .critical
//            multipeerSession.sendToAllPeers(encodedData, reliably: dataIsCritical)
//        } else {
//          //  print("Deferred sending collaboration to later because there are no peers.")
//        }
//    }
//
//    func receivedData(_ data: Data, from peer: MCPeerID) {
//        if let collaborationData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARSession.CollaborationData.self, from: data) {
//            sceneView.session.update(with: collaborationData)
//            return
//        }
//        // ...
//        let sessionIDCommandString = "SessionID:"
//        if let commandString = String(data: data, encoding: .utf8), commandString.starts(with: sessionIDCommandString) {
//            let newSessionID = String(commandString[commandString.index(commandString.startIndex,
//                                                                     offsetBy: sessionIDCommandString.count)...])
//            // If this peer was using a different session ID before, remove all its associated anchors.
//            // This will remove the old participant anchor and its geometry from the scene.
//            if let oldSessionID = peerSessionIDs[peer] {
//                removeAllAnchorsOriginatingFromARSessionWithID(oldSessionID)
//            }
//            
//            peerSessionIDs[peer] = newSessionID
//        }
//    }
//    
//    func peerDiscovered(_ peer: MCPeerID) -> Bool {
//        guard let multipeerSession = multipeerSession else { return false }
//        
//        if multipeerSession.connectedPeers.count > 3 {
//            // Do not accept more than four users in the experience.
//            print("A fifth peer wants to join the experience.\nThis app is limited to four users.")
//          //  messageLabel.displayMessage("A fifth peer wants to join the experience.\nThis app is limited to four users.", duration: 6.0)
//            return false
//        } else {
//            return true
//        }
//    }
//    /// - Tag: PeerJoined
//    func peerJoined(_ peer: MCPeerID) {
//        print("""
//            A peer wants to join the experience.
//            Hold the phones next to each other.
//            """)
//            /* messageLabel.displayMessage("""
//            A peer wants to join the experience.
//            Hold the phones next to each other.
//            """, duration: 6.0)*/
//        // Provide your session ID to the new user so they can keep track of your anchors.
//        sendARSessionIDTo(peers: [peer])
//    }
//        
//    func peerLeft(_ peer: MCPeerID) {
//        print("A peer has left the shared experience.")
//       // messageLabel.displayMessage("A peer has left the shared experience.")
//        
//        // Remove all ARAnchors associated with the peer that just left the experience.
//        if let sessionID = peerSessionIDs[peer] {
//            removeAllAnchorsOriginatingFromARSessionWithID(sessionID)
//            peerSessionIDs.removeValue(forKey: peer)
//        }
//    }
//    
//    private func removeAllAnchorsOriginatingFromARSessionWithID(_ identifier: String) {
//        guard let frame = sceneView.session.currentFrame else { return }
//        for anchor in frame.anchors {
//            guard let anchorSessionID = anchor.sessionIdentifier else { continue }
//            if anchorSessionID.uuidString == identifier {
//                sceneView.session.remove(anchor: anchor)
//            }
//        }
//    }
//    
//    private func sendARSessionIDTo(peers: [MCPeerID]) {
//        guard let multipeerSession = multipeerSession else { return }
//        let idString = sceneView.session.identifier.uuidString
//        let command = "SessionID:" + idString
//        if let commandData = command.data(using: .utf8) {
//            multipeerSession.sendToPeers(commandData, reliably: true, peers: peers)
//        }
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
////        searchField.layer.borderColor = UIColor.systemBlue.cgColor
////        searchField.layer.borderWidth = 2
////        searchField.tintColor = .systemBlue
////        searchField.layer.cornerRadius = 10
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        view.endEditing(true)
//        if searchField.text == "" || searchField.text == " " {
//           // searchfie
//            view.endEditing(true)
////            searchMode = false
////            nftView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 375)
////          //  tableViewHeight.constant = 375
////           // browseTableView.isHidden = true
////            newSearchView.isHidden = true
////        //    //topview.isHidden = false
////            self.searchBar.isHidden = true
////            searchStackView.isHidden = true
////            //searchStackUnderView.isHidden = true
////            searchView.isHidden = true
////            editButton.isHidden = false
////            previewButton.isHidden = false
////            categoryScrollView.isHidden = true
////            searchBtn.isHidden = false
////            betweenView.isHidden = false
////            networkBtn.isHidden = false
////            networksNearImg.isHidden = false
////            profileButton.isHidden = false
////            editUnderView.isHidden = false
////            self.wordsBtn.isHidden = false
////            self.videoBtn.isHidden = false
////            self.buttonStackView.isHidden = false
////            browseTableView.isHidden = true
////
////          //  sceneView.addSubview(segmentedControl)
////            if sceneManager.anchorEntities.count == 0 {
////                saveButton.isHidden = true
////                undoButton.isHidden = true
////                numberOfEditsImg.isHidden = true
////                sceneInfoButton.isHidden = true
////            } else {
////             //   saveButton.isHidden = false
////                undoButton.isHidden = false
////             //   numberOfEditsImg.isHidden = false
////     //           sceneInfoButton.isHidden = false
////            }
//        } else if searchBar.text?.count ?? 0 > 1 { //== "couch" || searchBar.text == "Couch"
//            searchMode = true
//            browseTableView.isHidden = false
//            print("\(searchBar.text) is search bar text")
//            searchField.layer.borderWidth = 0
//            searchField.tintColor = .lightGray
//            tableViewHeight.constant = UIScreen.main.bounds.height - 140
//            nftView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 140)
//            let db = Firestore.firestore()
//            let docRef = db.collection("models").document("8EaV7rkVJCjn7iyzWUkR")
//
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    
//                    let documentName = document.get("name")
//                    let documentModel = document.get("modelName")
//                    let documentThumbnail = document.get("thumbnail")
//                    print("\(documentName ?? "") is the document name")
//                    print("\(documentModel ?? "") is the document model")
//                //    print("\(documentScale) is the document scale")
//                    print("\(documentThumbnail ?? "") is the document thumbnail")
//                    self.searchBar.isHidden = true
//                    //self.topView.isHidden = true
//                    self.searchStackView.isHidden = true
//              //      self.//searchStackUnderView.isHidden = true
//                    self.searchBtn.isHidden = false
//                    self.toggleBtn.isHidden = true
//                    self.undoButton.isHidden = true
//                    self.sceneInfoButton.isHidden = true
//                    self.categoryScrollView.isHidden = true
//                    self.dismissKeyboard()
//                    self.newSearchView.isHidden = true
//                    ProgressHUD.show("Loading...")
//                    self.browseTableView.isHidden = true
//                    FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(documentModel ?? "")") { localUrl in
//                        self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                            switch loadCompletion {
//                            case.failure(let error): print("Unable to load model for \(documentName). Error: \(error.localizedDescription)")
//                            case.finished:
//                                break
//                            }
//                        }, receiveValue: { modelEntity in
//                            self.currentEntity = modelEntity
//                            self.currentEntity.name = "\(documentName ?? ""))"
//                            if let documentScale = document.get("scale") as? NSNumber {
//                                let floatScale = documentScale.floatValue
//                                self.currentEntity.scale = [floatScale, floatScale, floatScale]
//                            }
//                            self.downloadModel()
//                        })
//                    }
//                } else {
//                    print("Document does not exist")
//                }
//            }
//            
//        }  else {
////     //   hideUI()
////       // placementStackView.isHidden = false
////        saveButton.isHidden = true
////            undoButton.isHidden = true
////        numberOfEditsImg.isHidden = true
////
////            browseTableView.isHidden = true
//            searchMode = false
//            nftView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 375)
//          //  tableViewHeight.constant = 375
//           // browseTableView.isHidden = true
//            newSearchView.isHidden = true
//        //    //topview.isHidden = false
//            self.searchBar.isHidden = true
//            searchStackView.isHidden = true
//            //searchStackUnderView.isHidden = true
//            searchView.isHidden = true
//            editButton.isHidden = false
//            previewButton.isHidden = false
//            categoryScrollView.isHidden = true
//            searchBtn.isHidden = false
//            betweenView.isHidden = false
//            networkBtn.isHidden = false
//            networksNearImg.isHidden = false
//            profileButton.isHidden = false
//            editUnderView.isHidden = false
//            self.wordsBtn.isHidden = false
//            self.videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//            browseTableView.isHidden = true
//           
//          //  sceneView.addSubview(segmentedControl)
//            if sceneManager.anchorEntities.count == 0 {
//                saveButton.isHidden = true
//                undoButton.isHidden = true
//                numberOfEditsImg.isHidden = true
//                sceneInfoButton.isHidden = true
//            } else {
//             //   saveButton.isHidden = false
//                undoButton.isHidden = false
//             //   numberOfEditsImg.isHidden = false
//     //           sceneInfoButton.isHidden = false
//            }
//        }
//        return false
//    }
//    
////    func receivedData(_ data: Data, from peer: MCPeerID) {
////
////        do {
////            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
////                // Run the session with the received world map.
////                let configuration = ARWorldTrackingConfiguration()
////                configuration.planeDetection = .horizontal
////                configuration.initialWorldMap = worldMap
////                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
////
////                // Remember who provided the map for showing UI feedback.
////                mapProvider = peer
////            }
////            else
////            if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
////                // Add anchor to the session, ARSCNView delegate adds visible content.
////                sceneView.session.add(anchor: anchor)
////            }
////            else {
////                print("unknown data recieved from \(peer)")
////            }
////        } catch {
////            print("can't decode data recieved from \(peer)")
////        }
////    }
//    var anchorHostID = ""
//    var entityName = UILabel()
//    var entityDetailsView = UIView()
//    var entityProfileBtn = UIButton()
//    var image: UIImage? = nil
//    var detailAnchor = AnchorEntity()
//    
//    @objc func goToNetworkSettings(_ sender: UITapGestureRecognizer){
//        let storyboard = UIStoryboard(name: "Networks", bundle: nil)
//        var next = storyboard.instantiateViewController(withIdentifier: "NetworkSettingsVC") as! NetworkSettingsTableViewController
//        //next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//    }
//    
//    @IBAction func sceneInfoAction(_ sender: Any) {
//        self.updatePersistanceAvailability(for: sceneView)
//        self.handlePersistence(for: sceneView)
//        print("\(sceneManager.persistenceURL) is persist url")
//        print("\(sceneManager.scenePersistenceData) is persist data")
//    }
//    
//    func checkCameraAccess() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .denied:
//            
//                AVCaptureDevice.requestAccess(for: .video) { success in
//                    if success {
//                        print("Permission granted, proceed")
//                    } else {
//                        DispatchQueue.main.async {
//                        print("Denied, request permission from settings")
//                        let needLocationView = UIView(frame: CGRect(x: 58, y: 313, width: 274, height: 194))
//                        needLocationView.backgroundColor = .white
//                        needLocationView.clipsToBounds = true
//                        needLocationView.layer.cornerRadius = 14
//                        let titleLabel = UILabel(frame: CGRect(x: 105.67, y: 21, width: 63, height: 28))
//                        titleLabel.text = "Oops!"
//                        titleLabel.textColor = .black
//                        titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
//                        let titleUnderView = UIView(frame: CGRect(x: 92, y: 59, width: 90, height: 1))
//                        titleUnderView.backgroundColor = .systemGray6
//                        let messageLabel = UILabel(frame: CGRect(x: 15, y: 68, width: 244, height: 56))
//                        messageLabel.numberOfLines = 3
//                        messageLabel.textColor = .darkGray
//                        messageLabel.textAlignment = .center
//                        messageLabel.text = "Blueprint is a camera app! To continue, you'll need to allow Camera access in Settings."
//                        messageLabel.font = UIFont.systemFont(ofSize: 14)
//                        let settingsButton = UIButton(frame: CGRect(x: 57, y: 139, width: 160, height: 40))
//                        settingsButton.clipsToBounds = true
//                        settingsButton.layer.cornerRadius = 20
//                        settingsButton.backgroundColor = UIColor(red: 69/255, green: 65/255, blue: 78/255, alpha: 1.0)
//                        settingsButton.setTitle("Settings", for: .normal)
//                        settingsButton.setTitleColor(.white, for: .normal)
//                        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//                        settingsButton.addTarget(self, action: #selector(self.goToSettings), for: .touchUpInside)
//                        needLocationView.addSubview(titleLabel)
//                        needLocationView.addSubview(titleUnderView)
//                        needLocationView.addSubview(messageLabel)
//                        needLocationView.addSubview(settingsButton)
//                        self.view.addSubview(needLocationView)
//                        //self.topView.isUserInteractionEnabled = false
//                        self.addButton.isUserInteractionEnabled = false
//                        self.videoBtn.isUserInteractionEnabled = false
//                        self.wordsBtn.isUserInteractionEnabled = false
//                        self.walkthroughView.isUserInteractionEnabled = false
//                        self.sceneView.isUserInteractionEnabled = false
//                    }}}
//        case .restricted:
//            print("Restricted, device owner must approve")
//        case .authorized:
//            print("Authorized, proceed")
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { success in
//                if success {
//                    print("Permission granted, proceed")
//                } else {
//                    print("Permission denied")
//                    let needLocationView = UIView(frame: CGRect(x: 58, y: 313, width: 274, height: 194))
//                    needLocationView.backgroundColor = .white
//                    needLocationView.clipsToBounds = true
//                    needLocationView.layer.cornerRadius = 14
//                    let titleLabel = UILabel(frame: CGRect(x: 105.67, y: 21, width: 63, height: 28))
//                    titleLabel.text = "Oops!"
//                    titleLabel.textColor = .black
//                    titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
//                    let titleUnderView = UIView(frame: CGRect(x: 92, y: 59, width: 90, height: 1))
//                    titleUnderView.backgroundColor = .systemGray6
//                    let messageLabel = UILabel(frame: CGRect(x: 15, y: 68, width: 244, height: 56))
//                    messageLabel.numberOfLines = 3
//                    messageLabel.textColor = .darkGray
//                    messageLabel.textAlignment = .center
//                    messageLabel.text = "Blueprint is a camera app! To continue, you'll need to allow Camera access in Settings."
//                    messageLabel.font = UIFont.systemFont(ofSize: 14)
//                    let settingsButton = UIButton(frame: CGRect(x: 57, y: 139, width: 160, height: 40))
//                    settingsButton.clipsToBounds = true
//                    settingsButton.layer.cornerRadius = 20
//                    settingsButton.backgroundColor = UIColor(red: 69/255, green: 65/255, blue: 78/255, alpha: 1.0)
//                    settingsButton.setTitle("Settings", for: .normal)
//                    settingsButton.setTitleColor(.white, for: .normal)
//                    settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//                    settingsButton.addTarget(self, action: #selector(self.goToSettings), for: .touchUpInside)
//                    needLocationView.addSubview(titleLabel)
//                    needLocationView.addSubview(titleUnderView)
//                    needLocationView.addSubview(messageLabel)
//                    needLocationView.addSubview(settingsButton)
//                    self.view.addSubview(needLocationView)
//                    //self.topView.isUserInteractionEnabled = false
//                    self.addButton.isUserInteractionEnabled = false
//                    self.videoBtn.isUserInteractionEnabled = false
//                    self.wordsBtn.isUserInteractionEnabled = false
//                    self.walkthroughView.isUserInteractionEnabled = false
//                    self.sceneView.isUserInteractionEnabled = false
//                    self.buttonStackView.isUserInteractionEnabled = false
//                    self.networkBtn.isUserInteractionEnabled = false
//                }
//            }
//        }
//    }
//    
//    var originalAnchorLikes = Int()
//    
//    func checkLocationPermission() {
//        var authorizationStatus: CLAuthorizationStatus?
//
//        if #available(iOS 14.0, *) {
//            authorizationStatus = self.locationManager?.authorizationStatus // CLAuthorizationStatus(rawValue: locationManager?.authorizationStatus().rawValue)
//        } else {
//            authorizationStatus = CLLocationManager.authorizationStatus()
//        }
//        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
//            if #available(iOS 14.0, *) {
//                if locationManager?.accuracyAuthorization != .fullAccuracy {
//                  //  self.statusLabel?.text = "Location permission not granted with full accuracy."
//                   // self.addAnchorButton?.isHidden = true
//                   // self.networkView.isHidden = true
//                   // self.deleteAnchorButton?.isHidden = true
//                    return
//                }
//            }
//        } else if authorizationStatus == .notDetermined {
//            locationManager?.requestWhenInUseAuthorization()
//        } else {
//            let needLocationView = UIView(frame: CGRect(x: 58, y: 313, width: 274, height: 194))
//            needLocationView.backgroundColor = .white
//            needLocationView.clipsToBounds = true
//            needLocationView.layer.cornerRadius = 14
//            let titleLabel = UILabel(frame: CGRect(x: 105.67, y: 21, width: 63, height: 28))
//            titleLabel.text = "Oops!"
//            titleLabel.textColor = .black
//            titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
//            let titleUnderView = UIView(frame: CGRect(x: 92, y: 59, width: 90, height: 1))
//            titleUnderView.backgroundColor = .systemGray6
//            let messageLabel = UILabel(frame: CGRect(x: 15, y: 68, width: 244, height: 56))
//            messageLabel.numberOfLines = 3
//            messageLabel.textColor = .darkGray
//            messageLabel.textAlignment = .center
//            messageLabel.text = "Blueprint is a location-based app! To continue, you'll need to allow Location access in Settings."
//            messageLabel.font = UIFont.systemFont(ofSize: 14)
//            let settingsButton = UIButton(frame: CGRect(x: 57, y: 139, width: 160, height: 40))
//            settingsButton.clipsToBounds = true
//            settingsButton.layer.cornerRadius = 20
//            settingsButton.backgroundColor = UIColor(red: 69/255, green: 65/255, blue: 78/255, alpha: 1.0)
//            settingsButton.setTitle("Settings", for: .normal)
//            settingsButton.setTitleColor(.white, for: .normal)
//            settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//            settingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
//            needLocationView.addSubview(titleLabel)
//            needLocationView.addSubview(titleUnderView)
//            needLocationView.addSubview(messageLabel)
//            needLocationView.addSubview(settingsButton)
//            view.addSubview(needLocationView)
//            //topview.isUserInteractionEnabled = false
//            addButton.isUserInteractionEnabled = false
//            videoBtn.isUserInteractionEnabled = false
//            wordsBtn.isUserInteractionEnabled = false
//            walkthroughView.isUserInteractionEnabled = false
//            sceneView.isUserInteractionEnabled = false
//            buttonStackView.isUserInteractionEnabled = false
//            networkBtn.isUserInteractionEnabled = false
//           // self.statusLabel?.text = "Location permission denied or restricted."
//           // self.addAnchorButton?.isHidden = true
//            //self.networkView.isHidden = true
//           // self.deleteAnchorButton?.isHidden = true
//        }}
//    
//    @objc func goToSettings(){
//        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                    return
//                }
//
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                        print("Settings opened: \(success)") // Prints true
//                    })
//                }
//    }
//
//  //  var webScreenshot = UIImage?
//    var videoTaps = 0
//    var anchorSettingsImg = UIImageView()
//    var selectedAnchorID = ""
//    
//    @objc func handleEntityGesture(_ sender: UIGestureRecognizer) {
////        // Scale
////        if let scaleGesture = sender as? EntityScaleGestureRecognizer {
////            switch scaleGesture.state {
////            case .began:
////                // Handle things that happen when gesture begins
////            case .changed:
////                // Handle things during the gesture
////            case .ended:
////                // Handle things when the gesture has ended
////            default:
////                return
////            }
////        }
//    }
//    
//    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) { //UILongPress
//        if gesture.state == UIGestureRecognizer.State.began {
//            //virtualTaps = 0
//            let touchLocation = gesture.location(in: sceneView)
//            let hits = self.sceneView.hitTest(touchLocation) //.hitTest(touchLocation, options: nil)
//            
//            
//
//            if let tappedEntity = hits.first?.entity  { //sceneView.virtualObject(at: touchLocation)
////                if entityName.isHidden == false {
////                    return
////                }
////                else {
//            
//                print("\(tappedEntity.name) is the name of the tapped enitity")
//                print("\(tappedEntity.position(relativeTo: currentEntity)) is the position relative to the current entity")
//                print("\(tappedEntity.position.y)) is the top y point of the tapped entity")
//                print("\(tappedEntity.anchor?.position.y ?? 0)) is the top y point of the tapped entity's anchor")
//          //      print("\(tappedEntity.size ?? 0)) is the tapped entity's size")
//                print("\(tappedEntity.scale) is the tapped entity's scale")
//                
//                let tappedName = tappedEntity.name
//                if tappedName.contains("Mesh Entity") {
//                    return
//                } else if tappedName == self.entityName.text && self.entityName.isHidden == false{
//                    return
//                } else {
//                    self.entityName.removeFromSuperview()
//                    self.entityProfileBtn.removeFromSuperview()
//                    self.anchorSettingsImg.removeFromSuperview()
//                }
//                
//                selectedEntity = tappedEntity as? ModelEntity
//                selectedAnchor = selectedEntity?.anchor as? AnchorEntity
////                    if selectedEntity?.name == "" || selectedEntity?.name == .none {
////                        return
////                    }
//                let component = ModelDebugOptionsComponent(visualizationMode: .baseColor)
//               // selectedEntity?.modelDebugOptions = component
//                
//                let physics = PhysicsBodyComponent(massProperties: .init(mass: 10),
//                                                                material: .default,
//                                                                    mode: .kinematic)
//                if selectedEntity?.name == "" || selectedEntity?.name == .none {
//                    self.selectedAnchorID = String(currentAnchor.id)
//                } else {
//                    self.selectedAnchorID = String(tappedEntity.id)
//                }
//                    
//                print("\(tappedEntity.id) is tapped entity id")
//                print("\(currentAnchor.id) is current anchor id")
//                    let defaults = UserDefaults.standard
//                    defaults.set(self.selectedAnchorID, forKey: "selectedAnchorID")
//               // selectedEntity?.physicsBody = physics
//                //topview.isHidden = true
//                    addButton.isHidden = true
//                    self.progressView?.isHidden = true
//                    sceneInfoButton.isHidden = true
//                self.searchStackView.isHidden = true
//                //searchStackUnderView.isHidden = true
//                searchBtn.isHidden = true
//                    self.buttonStackView.isHidden = true
//                saveButton.isHidden = true
//                    undoButton.isHidden = true
//                    print("\(currentEntity.physicsBody?.massProperties.mass)")
//                numberOfEditsImg.isHidden = true
//                networkBtn.isHidden = true
//                    wordsBtn.isHidden = true
//                    videoBtn.isHidden = true
//                print(tappedEntity.name)
//                print("is tapped entity name")
//                placementStackView.isHidden = false
//               
//                    searchBtn.isHidden = true
//                shareImg.isHidden = true
//                    addButton.isHidden = true
//                    self.progressView?.isHidden = true
//                toggleBtn.isHidden = true
//                    networksNearImg.isHidden = true
//                    self.buttonStackView.isHidden = true
//                entityDetailsView = UIView(frame: CGRect(x: 0, y: 675, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 675))
//                    entityDetailsView.backgroundColor = .black
//                    entityDetailsView.alpha = 0.75
//                    
//                let entityPrice = UILabel(frame: CGRect(x: 20, y: 25, width: 150, height: 40))
//                    entityPrice.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
//                    entityPrice.text = "$299.49"
//                    entityPrice.textColor = .white
//                    
//                    anchorSettingsImg = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width - 61, y: 81, width: 30, height: 30))
//                    anchorSettingsImg.image = UIImage(systemName: "gearshape.fill")
//                    anchorSettingsImg.tintColor = .white
//                    anchorSettingsImg.contentMode = .scaleAspectFill
//                    anchorSettingsImg.isUserInteractionEnabled = true
//                    let tap = UITapGestureRecognizer(target: self, action: #selector(goToAnchorSettings))
//                    anchorSettingsImg.addGestureRecognizer(tap)
//                    view.addSubview(anchorSettingsImg)
//                    
//                entityName = UILabel(frame: CGRect(x: 20, y: 80, width: UIScreen.main.bounds.width - 85, height: 30))
////                entityName.text = selectedEntity?.name
//                entityName.textColor = .white
//                entityName.font = UIFont(name: "Noto Sans Kannada Bold", size: 22) //UIFont.systemFont(ofSize: 22, weight: .bold)
//              //  entityName.adjustsFontSizeToFitWidth = true
//                entityProfileBtn = UIButton(frame: CGRect(x: 12, y: 113, width: 100, height: 20))
//                entityProfileBtn.titleLabel?.font = UIFont(name: "Noto Sans Kannada", size: 15) //.systemFont(ofSize: 15)
//                entityProfileBtn.setTitle("View Profile", for: .normal)
//              //  entityProfileBtn.color = .red
//                entityProfileBtn.setTitleColor(.systemYellow, for: .normal)// = .blue
//                entityProfileBtn.isUserInteractionEnabled = true
//               
//                entityProfileBtn.addGestureRecognizer(profileRecognizer)
////                if tappedName.contains("Photo by") {
////                    self.entityProfileBtn.removeFromSuperview()
////                }
//                likeTouches = 0
//                heartImg.tintColor = .white
//                heartImg.alpha = 0.70
//                
//                    var anchorUserHostID = ""
//                    
//                    FirestoreManager.getSessionAnchor(self.selectedAnchorID) { anchor in
//                        self.entityName.text = anchor?.name
//                        if self.entityName.text == "Chance the Rapper Poster" || self.entityName.text == "A$AP Dior Poster" || self.entityName.text == "Flower Boy Poster" {
//                            self.entityProfileBtn.removeFromSuperview()// nremoveFromSuperview()
//                        }
//                        let likes = anchor?.likes
//                        self.modelUid = anchor?.modelId ?? ""
//                        print("\(self.modelUid)is model ID")
//                        self.originalAnchorLikes = likes ?? 123456
//                        let comments = anchor?.comments
//                        self.anchorLikesLabel.text = "\(likes ?? 123456)"
//                        self.anchorCommentsLabel.text = "\(comments ?? 123456)"
//                      //  self.anchorDescription = anchor?.description ?? ""
//                        anchorUserHostID = anchor?.host as? String ?? "eUWpeKULDhN1gZEyaeKvzPNkMEk1"
//                      //  anchorHostID = uid
//                        print("\(anchorUserHostID) is host")
//                        self.anchorSettingsImg.isHidden = false
//                        self.anchorSettingsImg.isHidden = false
//                        self.anchorInfoStackView.isHidden = false
//                      //  anchorUserImg.isHidden = true
//                       // FirestoreManager.getUser(anchorUserHostID) { user in
//                           // let randUsername = self.randomString(length: 12)
//                            let uid = anchorUserHostID
//                        self.anchorHostID = uid
//                        self.creatorUid = uid
//                            StorageManager.getProPic(uid) { image in
//                                self.anchorUserImg.isHidden = false
//                                self.anchorUserImg.image = image
//                                self.anchorUserImg.isUserInteractionEnabled = true
//                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.anchorUserProfile))
//                                self.anchorUserImg.addGestureRecognizer(tap)
//                                if self.anchorUserImg.image == UIImage(named: "nouser") {
//                                    self.anchorUserImg.isUserInteractionEnabled = false
//                                }
//                            }
//                        
//                        
//                    }
//                    
////                    if selectedEntity?.name == "Wilson Basketball" {
////                        return
////                    } else {
//                
//                sceneView.addSubview(entityName)
//                    print("added object here")
//                    
//                
//                    entityDetailsView.addSubview(entityPrice)
//               // sceneView.addSubview(entityDetailsView)
//                if selectedEntity?.name == "" || selectedEntity?.name == .none || tappedName.contains("Photo by"){
//                    //self.selectedAnchorID = String(currentAnchor.id)
//                } else {
//                    sceneView.addSubview(entityProfileBtn)
//                }
//                
//
//               
//            }
//                }//}
//       
//       }
//    
//    func locationManager(_ locationManager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLocationPermission()
//    }
//
//    /// Authorization callback for iOS 14.
//    @available(iOS 14.0, *)
//    func locationManagerDidChangeAuthorization(_ locationManager: CLLocationManager) {
//        checkLocationPermission()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if self.currentLocation == nil {
//            if let location = locations.first {
//                //MAYBE LOCATIONMANAGER.COORDINATE.LAT
//                let latitude = location.coordinate.latitude
//                let longitude = location.coordinate.longitude
//                self.originalLocation = CLLocation(latitude: latitude, longitude: longitude)
//                self.networksNear()
//  //              self.lookForAnchorsNearDevice()
//                if Auth.auth().currentUser != nil {
//                    let docRef = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
//                    docRef.updateData([
//                        "latitude": latitude,
//                        "longitude": longitude
//                    ])
//                }}
//        }
//        if let location = locations.last {
//            //MAYBE LOCATIONMANAGER.COORDINATE.LAT
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//            // Handle location update
//            self.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
//            print("\(currentLocation?.verticalAccuracy ?? 0) is vert accuracy")
//            if (currentLocation?.horizontalAccuracy ?? 0 < 0){
//               // No Signal
//                print("NO SIGNAL")
//                //INSIDE --> SHOW GRAPHIC
//           }
//            else if (currentLocation?.horizontalAccuracy ?? 0 > 163){
//               // Poor Signal
//               print("POOR SIGNAL")
//               //INSIDE --> SHOW GRAPHIC
//           }
//            else if (currentLocation?.horizontalAccuracy ?? 0 > 48){
//               // Average Signal
//               print("AVERAGE SIGNAL")
//                
//               //UNSURE --> SHOW UNSURE GRAPHIC
//           }
//           else{
//               // Full Signal
//               print("FULL SIGNAL")
//               //OUTSIDE
//           }
//          //  let currentDistance = self.currentLocation?.distance(from: self.originalLocation)
//            print("\(String(describing: currentLocation)) is current location updated")
////            self.networksNear()
//            if defaults.bool(forKey: "connectToNetwork") == false {
//
//            } else {
//                FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
//                    self.currentConnectedNetwork = user?.currentConnectedNetworkID ?? ""
//                    self.connectToNetwork(with: self.currentConnectedNetwork)
//                    let defaults = UserDefaults.standard
//                    defaults.set(false, forKey: "connectToNetwork")
//
//                }}
//          //  print("\(originalLocation) is current original location")
//           
//        }
//        
//        
//    }
//
//
//}
//
//extension LaunchViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imageAnchorChanged = true
//           // profileImageView.image = image
//            photoAnchorImageView.image = image //do same for video
//            //call function that displays image in front of user
//            
//            
//            imageAnchorURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
//            imagePicker.dismiss(animated: true, completion: nil)
//            self.networkBtn.isHidden = true
//            
//            self.wordsBtn.isHidden = true
//            self.videoBtn.isHidden = true
//            self.buttonStackView.isHidden = true
//            photoAnchorImageChosen()
//            }
//        
////        guard let movieUrl = info[.mediaURL] as? URL else { return }
//        
//        if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//            videoAnchorChanged = true
//           // profileImageView.image = image
//            videoAnchorURL = video //do same for video
//            //call function that displays image in front of user
//            imagePicker.dismiss(animated: true, completion: nil)
//            videoAnchorURLChosen()
//
//        }
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
//
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
//
//extension LaunchViewController{
//    
//     func handlePersistence(for arView: CustomARView) {
//        if sceneManager.shouldSaveSceneToSystem {
//            ScenePersistenceHelper.saveScene(for: arView, at: sceneManager.persistenceURL)
//            sceneManager.shouldSaveSceneToSystem = false
//        } else if sceneManager.shouldLoadSceneToSystem {
//            guard let scenePersistenceData = sceneManager.scenePersistenceData else {
//                print("DEBUG: No persistence data found")
//                sceneManager.shouldLoadSceneToSystem = false
//                return
//            }
//          //  viewModel.clearModelEntitiesFromMemory()
//            sceneManager.anchorEntities.removeAll(keepingCapacity: true)
//            ScenePersistenceHelper.loadScene(for: arView, on: scenePersistenceData)
//            sceneManager.shouldLoadSceneToSystem = false
//        }
//    }
//    
//     func updatePersistanceAvailability(for arView: CustomARView) {
//        guard let currentFrame = arView.session.currentFrame else {
//            print("DEBUG: Persistence for ARView isnt available rn")
//            return
//        }
//        switch currentFrame.worldMappingStatus {
//        case .extending, .mapped:
//            self.sceneManager.isPersistenceAvailable = !self.sceneManager.anchorEntities.isEmpty
//        default:
//            self.sceneManager.isPersistenceAvailable = false
//        }
//    }
//    
//    private func saveCurrentWorldMap(for arView: CustomARView) {
//        
//    }
//}
//
//extension LaunchViewController {
//    class Coordinator: NSObject, ARSessionDelegate {
//        var parent : LaunchViewController
//        
//        init(_ parent: LaunchViewController) {
//            self.parent = parent
//        }
//        
////        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
////            for anchor in anchors {
////                if let anchorName = anchor.name, anchorName.hasPrefix(anchorNamePrefix) {
////                    let modelName = anchorName.dropFirst(anchorNamePrefix.count)
////
////                    print("ARSession: didAdd anchor for modelName: \(modelName)")
////
////                    guard let model = self.parent.modelsViewModel.models.first(where: { $0.name == modelName}) else {
////                        print("Unable to retrieve model from modelsViewModel")
////                        return
////                    }
////
////                    model.asyncLoadModelEntity { completed, error in
////                        if completed {
////                            let modelAnchor = ModelAnchor(model: model, anchor: anchor)
////                            self.parent.modelsConfirmedForPlacement.append(modelAnchor)
////                            print("adding modelAnchor with name: \(model.name)")
////                        }
////                    }
////                }
////            }
////        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//}
//
//extension UIButton {
//    
//    func centerVertically(padding: CGFloat = 6.0) {
//        guard
//            let imageViewSize = self.imageView?.frame.size,
//            let titleLabelSize = self.titleLabel?.frame.size else {
//            return
//        }
//        
//        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
//        
//        self.imageEdgeInsets = UIEdgeInsets(
//            top: -(totalHeight - imageViewSize.height),
//            left: 0.0,
//            bottom: 0.0,
//            right: -titleLabelSize.width
//        )
//        
//        self.titleEdgeInsets = UIEdgeInsets(
//            top: 0.0,
//            left: -imageViewSize.width,
//            bottom: -(totalHeight - titleLabelSize.height),
//            right: 0.0
//        )
//        
//        self.contentEdgeInsets = UIEdgeInsets(
//            top: 0.0,
//            left: 0.0,
//            bottom: titleLabelSize.height,
//            right: 0.0
//        )
//    }
//    
//}
//
//extension UITextField {
//  func setLeftView1(image: UIImage) {
//      let iconView = UIImageView(frame: CGRect(x: 15, y: 6, width: 20, height: 20)) // set your Own size
//    iconView.image = image
//      iconView.contentMode = .scaleAspectFill
//      
//    let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//    iconContainerView.addSubview(iconView)
//    leftView = iconContainerView
//    leftViewMode = .always
//    self.tintColor = .lightGray
//  }
//}
//
////extension LaunchViewController: MultipeerHelperDelegate {
////  func shouldSendJoinRequest(
////    _ peer: MCPeerID,
////    with discoveryInfo: [String: String]?
////  ) -> Bool {
////    self.checkPeerToken(with: discoveryInfo)
////  }
////}
//
//extension UIView {
//    func snapshot() -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
//        self.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return img
//    }
//    
//    func animateHide(){
//        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveLinear],
//                       animations: {
//                        self.center.y += self.bounds.height
//                        self.layoutIfNeeded()
//
//        },  completion: {(_ completed: Bool) -> Void in
//        self.isHidden = true
//            })
//    }
//}
