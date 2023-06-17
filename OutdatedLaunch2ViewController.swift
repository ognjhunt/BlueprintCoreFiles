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
////import WebKit
//import FirebaseFirestore
//import ProgressHUD
//import SCLAlertView
//import GeoFire
//import Photos
////import AzureSpatialAnchors
//import FirebaseStorage
//import Alamofire
//import Speech
//import AVKit
//import JavaScriptCore
//import ChatGPTSwift
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
//class LaunchViewController: UIViewController, ARSessionDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, MultipeerHelperDelegate {
//
//    
//    var locationManager: CLLocationManager?
//    
//    var delegate: LaunchViewControllerDelegate?
//    
//    var sceneManager = SceneManager()
//   
//    @IBOutlet weak var recordSpeechUnderView: UIView!
//    @IBOutlet weak var changeInputMethodLabel: UILabel!
//    @IBOutlet weak var copilotBtn: UIButton!
//    @IBOutlet weak var libraryImageView: UIImageView!
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
//    @IBOutlet weak var sceneInfoButton: UIButton!
//    @IBOutlet weak var wordsBtnTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var cancelWalkthroughButton: UIButton!
//    @IBOutlet weak var walkthroughViewLabel: UILabel!
//    @IBOutlet weak var walkthroughView: UIView!
//    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var numberOfEditsImg: UIImageView!
//    @IBOutlet weak var saveButton: UIButton!
//    @IBOutlet weak var scanBtn: UIButton!
//    @IBOutlet weak var trashBtn: UIButton!
//    @IBOutlet weak var duplicateBtn: UIButton!
//    @IBOutlet weak var removeBtn: UIButton!
//    @IBOutlet weak var placementStackView: UIStackView!
//    @IBOutlet weak var placementStackBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var confirmBtn: UIButton!
//    @IBOutlet weak var likeBtn: UIButton!
//    @IBOutlet weak var sceneView: CustomARView!
//    @IBOutlet weak var networkBtn: UIButton!
//    @IBOutlet weak var toggleBtn: UIButton!
//    @IBOutlet weak var networksNearImg: UIImageView!
//    @IBOutlet weak var wordsBtn: UIButton!
//    @IBOutlet weak var recordAudioImgView: UIImageView!
//    @IBOutlet weak var recordedSpeechLabel: UILabel!
//    @IBOutlet weak var recordedSpeechTextView: UITextView!
//    @IBOutlet weak var videoBtn: UIButton!
//    
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
//      //  config.geometryQuality = .high
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
//    var selectedModelURL: URL?
//    
//    var didTap: Bool?
//    
//    var networkBtnImg = UIImage(named: "network")
//    
//    private var modelCollectionView : UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupAudioSession()
//        checkCameraAccess()
//        setupNewUI()
//        setupJavaScriptEnvironment()
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
////
////        feedbackControl = addFeedbackButton()
////        feedbackControl.backgroundColor = .clear
////        feedbackControl.setTitleColor(.yellow, for: .normal)
////        feedbackControl.contentHorizontalAlignment = .left
//       // feedbackControl.isHidden = true
//        
//     //   layoutButtons()
//        
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
////            if UITraitCollection.current.userInterfaceStyle == .light {
////                browseTableView.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 244/255, alpha: 1.0)
////                //topview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.90)
////            } else {
////                browseTableView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
////                searchField.overrideUserInterfaceStyle = .light
////            }
//            updateWalkthrough()
//            return
//        }
//        setupLidar()
//        
//       // startSession()
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
//        
//        let libraryAction = UITapGestureRecognizer(target: self, action: #selector(goToLibrary))
//        libraryImageView.isUserInteractionEnabled = true
//        libraryImageView.addGestureRecognizer(libraryAction)
//        
//        let recordAction = UITapGestureRecognizer(target: self, action: #selector(recordAudio))
//        recordAudioImgView.isUserInteractionEnabled = true
//        recordAudioImgView.addGestureRecognizer(recordAction)
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
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//        print("Received memory warning.")
//
//        // Release any unneeded memory here
//        // For example, you can release large images or other data that's not currently in use
// //       heavyImage = nil
//
//        // You can also release any objects that have been retained by properties in the class
//        // For example, if you have a reference to an observer, you should remove it
//  //      NotificationCenter.default.removeObserver(observer)
//    }
//    
//    @objc func shareFile(fileURL: URL) {
//        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
//        present(activityViewController, animated: true, completion: nil)
//    }
//    
//    var modelUid = ""
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//      //  layoutButtons()
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
//        self.libraryImageView.isHidden = false
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
//                self.walkthroughViewLabel.text = "2 of 9"
//                self.walkthroughLabel.frame = CGRect(x: 50, y: 140, width: UIScreen.main.bounds.width - 100, height: 140)
//                self.walkthroughLabel.numberOfLines = 0
////                self.walkthroughLabel.text = "Tap the search button in the top left corner to search for digital assets"
//                self.walkthroughLabel.text = "To find and place digital assets on Blueprint's Marketplace, tap the search icon. \n\n Click 'Continue' in the bottom right to continue the walkthrough."
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
//        if #available(iOS 16.0, *) {
//            if let hiResFormat = ARWorldTrackingConfiguration.recommendedVideoFormatFor4KResolution {
//                configuration.videoFormat = hiResFormat
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//        sceneView.session.run(configuration)
//        
//        // NEW
//        
//        setupMultipeer()
//
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
//
//    private func layoutButton(_ button: UIButton, top: Double, lines: Double) {
//        let wideSize = sceneView.bounds.size.width - 20.0
//        button.frame = CGRect(x: 10.0, y: top, width: Double(wideSize), height: lines * 40)
//        if (lines > 1) {
//            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
//        }
//    }
//    
//
//    private func distance(_ a: [NSNumber], _ b: [NSNumber]) -> Float {
//        if a.count != 3 || b.count != 3 {
//            return 0
//        }
//        let dx = a[0].floatValue - b[0].floatValue
//        let dy = a[1].floatValue - b[1].floatValue
//        let dz = a[2].floatValue - b[2].floatValue
//        return sqrt(dx * dx + dy * dy + dz * dz)
//    }
//    
//    private let _jsContext = JSContext()!
//    
//    // MARK: - JavaScript
//
//    private func setupJavaScriptEnvironment() {
//        // Define print() function for logging
//        let printFn: @convention(block) (String) -> Void = { message in print(message) }
//        _jsContext.setObject(printFn, forKeyedSubscript: "print" as NSString)
//
//
////        // Define function to search for entities
////        let searchEntityFn: @convention(block) (String) -> JSValue = { type in return self.searchEntity(text: type) }
////        _jsContext.setObject(searchEntityFn, forKeyedSubscript: "searchEntity" as NSString)
//
//        // Define function to download entities
//        let downloadEntityFn: @convention(block) (String) -> JSValue = { modelID in return self.downloadEntity(modelID: modelID) }
//        _jsContext.setObject(downloadEntityFn, forKeyedSubscript: "downloadEntity" as NSString)
//        
//        // Define function to place entities in correct locations/planes
//        // based on prompt place object on correct plane (if object belongs on ceiling, table, floor - then horizontal, if belongs on wall - vertical, etc.
//        let placeEntityFn: @convention(block) (String) -> JSValue = { modelId in return self.placeEntity(modelId: modelId) }
//        _jsContext.setObject(placeEntityFn, forKeyedSubscript: "olaceEntity" as NSString)
//
//
//        // ChatGPT often insists on using a distance() function even when we tell it not to
//        let distanceFn: @convention(block) ([NSNumber], [NSNumber]) -> Float = { return self.distance($0, $1) }
//        _jsContext.setObject(distanceFn, forKeyedSubscript: "distance" as NSString)
//    }
//    
//    /// Wraps the user prompt in more context about the system to help ChatGPT generate usable code. - will need to change based off functions and needs of Blueprint
//    public func augmentPrompt(prompt: String) -> String {
//        return """
//
//    Assume:
//    - A function searchEntity() exists that takes only a string describing the object (for example, 'TV', 'carpet', or 'chair'). The return value is the first object's ID in the results array that it returns from our database.
//    - Objects returned by downloadEntity() have only three properties, each of them an array of length 3: 'position' (the position), 'scale' (the scale), and 'euler' (rotation specified as Euler angles in degrees).
//    - Objects returned by downloadEntity() must have their properties initialized after the object is created.
//    - The function scaleEntity() scales the downloaded entity to the correct dimensions. If no scale is mentioned, the size stays the same.
//    - The function rotateEntity() rotates the downloaded entity to the correct angle. If no rotation is mentioned, nothing happens.
//    - Each plane has two properties: 'center', the center position of the plane, and 'size', the size of the plane in each dimension. Each of these is an array of numbers of length 3.
//    - A global variable 'cameraPosition' containing the camera position, which is the user position, as a 3-element float array.
//    - The function placeEntity() places the downloaded object on the plane that makes the most sense for the description of the object. For example - a mounted TV will be placed on a vertical wall.
//
//    Write Javascript code for the user that:
//
//    \(prompt)
//
//    The code must obey the following constraints:
//    - Is wrapped in an anonymous function that is then executed.
//    - Does not define any new functions.
//    - Defines all variables and constants used.
//    - Does not call any functions besides those given above and those defined by the base language spec.
//    """
//    }
//    
//    private var _cameraTransform: simd_float4x4?
//
//    public func runCode(code: String) {
//        _jsContext.evaluateScript(code)
//    }
//
//    private func updateGlobalVariables(frame: ARFrame) {
//        _cameraTransform = frame.camera.transform
//        let cameraPosition = frame.camera.transform.position
//        _jsContext.setObject([ cameraPosition.x, cameraPosition.y, cameraPosition.z ], forKeyedSubscript: "cameraPosition" as NSString)
//    }
//    
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
//            textView.text = "Type anything"
//            textView.textColor = UIColor.lightGray
//        } else {
//            
//        }
//    
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        let count = textView.text.count
//      //  textCountRemainingLabel.text = String(400 - count)
//
//    }
//    
//    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////        if (text == "\n") {
////             textView.resignFirstResponder()
////             return false
////         }
////         return true
//        if(text == "\n"){
//                textView.resignFirstResponder()
//                return false
//            }
//            else {
//                return textView.text.count + (text.count - range.length) <= 400
//            }
//        
//        
//    }
//    
//    func transcribeSpeechData(_ data: Data, completion: @escaping (Result<String, Error>) -> Void) {
//        let apiKey = "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"
//        //Error Here - need correct URL
//        let url = "https://api.openai.com/v1/audio/transcriptions"
//        let headers: HTTPHeaders = [
//            "Content-Type": "audio/wav",
//            "Authorization": "Bearer \(apiKey)"
//        ]
//        
//        AF.upload(data, to: url, headers: headers)
//            .validate()
//            .responseDecodable(of: TranscriptionResponse.self) { response in
//                switch response.result {
//                case .success(let transcriptionResponse):
//                    completion(.success(transcriptionResponse.transcription))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//
//    struct TranscriptionResponse: Decodable {
//        let transcription: String
//    }
//    
//    let speechRecorder = SpeechRecorder()
//
//    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
//
//    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
//    var recognitionTask         : SFSpeechRecognitionTask?
//    let audioEngine             = AVAudioEngine()
//    
//    var promptLabel = UILabel()
//    var cancelImg = UIImageView()
//    
//    @objc func cancelAIAction(){
//        networkBtn.isHidden = false
//        libraryImageView.isHidden = false
//        wordsBtn.isHidden = false
//        videoBtn.isHidden = false
//        recordAudioImgView.isHidden = true
//        recordSpeechUnderView.isHidden = true
//        recordedSpeechLabel.isHidden = true
//        changeInputMethodLabel.isHidden = true
//        copilotBtn.isHidden = false
//        buttonStackView.isHidden = false
//        
//        promptLabel.isHidden = true
//        cancelImg.isHidden = true
//    }
//    
//    @IBAction func copilotAction(_ sender: Any) {
//        self.setupSpeech()
//        networkBtn.isHidden = true
//        libraryImageView.isHidden = true
//        wordsBtn.isHidden = true
//        videoBtn.isHidden = true
//        recordAudioImgView.isHidden = false
//        recordAudioImgView.tintColor = UIColor(red: 216/255, green: 71/255, blue: 56/255, alpha: 1.0)
//        recordSpeechUnderView.isHidden = false
//        recordedSpeechLabel.isHidden = false
//        recordedSpeechLabel.text = "Hold to Speak"
//        recordedSpeechLabel.backgroundColor = .clear
//        recordedSpeechLabel.textColor = .white
//        changeInputMethodLabel.isHidden = false
//        copilotBtn.isHidden = true
//        buttonStackView.isHidden = true
//       
//        
//        promptLabel = UILabel(frame: CGRect(x: (view.frame.width - 250) / 2, y: 70, width: 250, height: 80))
//        promptLabel.numberOfLines = 2
//        promptLabel.textColor = .white
//        promptLabel.tintColor = .white
//        promptLabel.text = "How would you like to design your space?"
//        promptLabel.textAlignment = .center
//        promptLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
//        view.addSubview(promptLabel)
//        
//        cancelImg = UIImageView(frame: CGRect(x: 22, y: 58, width: 22, height: 22))
//        cancelImg.tintColor = .white
//        cancelImg.isUserInteractionEnabled = true
//        cancelImg.clipsToBounds = true
//        cancelImg.contentMode = .scaleAspectFit
//        let smallConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold, scale: .medium)
//        let smallBoldDoc = UIImage(systemName: "xmark", withConfiguration: smallConfig)
//        cancelImg.image = smallBoldDoc
//        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelAIAction))
//        cancelImg.addGestureRecognizer(tap)
//        view.addSubview(cancelImg)
//    }
//    
//    @objc func recordAudio(){
//        if audioEngine.isRunning {
//            self.audioEngine.stop()
//            self.recognitionRequest?.endAudio()
//            self.searchImgView.isUserInteractionEnabled = false
//           // self.btnStart.setTitle("Start Recording", for: .normal)
//        } else {
//            self.startRecording()
//            UIView.animate(withDuration: 0.2) {
//                self.recordSpeechUnderView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//                self.recordAudioImgView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//                        }
//           // self.btnStart.setTitle("Stop Recording", for: .normal)
//        }
//    }
//    
// //   private var _engine: Engine?
//    
////    func searchEntity(text: String) -> JSValue {
//////        var result: [String: Any]? = nil
//////
//////        let group = DispatchGroup()
//////        group.enter()
//////
//////        FirestoreManager.searchModels(queryStr: text) { searchedModels in
//////            if let firstModel = searchedModels.first {
//////                result = ["id": firstModel.id]
//////            }
//////
//////            group.leave()
//////        }
//////
//////        group.wait()
//////
//////        guard let unwrappedResult = result else { return JSValue(nullIn: _jsContext) }
//////        let jsValue = JSValue(dictionary: unwrappedResult, in: _jsContext)!
//////
//////        return jsValue
////    }
//
//    
//
//
//    
////    //Search database to see whether or not we can find the objects necessary (images/3D) to fulfill the user's prompt.
////    func searchEntity() { //prompt: String
////
////        // search through database --> get first modelId result from search array (if have the credits)
////        // downloadModel
////        FirestoreManager.searchModels(queryStr: "TV") { searchedModels in
////            self.searchedModels = searchedModels\
////        }
////        // after finding each object, it will have to be sized & placed at correct location
////        // placeEntity func
////
////        // if cannot find an object, then if image --> generateImage, if 3D model, then alert user that we cannot ____, either they can search for it manually, or try another option.
////    }
//    
//    func downloadEntity(modelID: String) -> JSValue {
//        let group = DispatchGroup()
//        var value: JSValue?
//        
//        // Enter the dispatch group before starting the first async task
//        group.enter()
//        
//        FirestoreManager.getModel(self.modelUid) { model in
//            let modelName = model?.modelName
//            print("\(modelName ?? "") is model name")
//            
//            // Enter the dispatch group before starting the second async task
//            group.enter()
//            
//            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")") { localUrl in
//                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                    switch loadCompletion {
//                    case .failure(let error):
//                        print("Unable to load modelEntity for Mayflower Ship Model. Error: \(error.localizedDescription)")
//                        ProgressHUD.dismiss()
//                    case .finished:
//                        break
//                    }
//                    // Leave the dispatch group after finishing the second async task
//                    group.leave()
//                }, receiveValue: { modelEntity in
//                    self.currentEntity = modelEntity
//                    
//                    self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//                    
//                    print("modelEntity for Mayflower Ship Model has been loaded.")
//                    ProgressHUD.dismiss()
//                    
//                    // print("modelEntity for \(self.name) has been loaded.")
//                    self.placeEntity(modelId: self.modelUid)
//                })
//                
//                // Leave the dispatch group after finishing the first async task
//                group.leave()
//            }
//        }
//        
//        // Wait for all async tasks to finish and call the completion closure
//        group.notify(queue: .main) {
//            // Do something after all async tasks are finished
//            self.view.isUserInteractionEnabled = true
//            
//            // create JSValue with currentEntity
//            value = JSValue(object: self.currentEntity, in: self._jsContext)
//        }
//        
//        return value ?? JSValue(nullIn: _jsContext)
//    }
//
//    
//    //Anything we dont have in our database - if ChatGPT cant find it, from artwork to textures for flooring - will be created using this function.
////    func generateImage(prompt: String) async -> UIImage? {
////
////
////        // after generating image, upload the object to the database
////
////        // it will then have to be sized & placed at correct location
////        // placeEntity func
////    }
//    
//    // After finding or generating content, scale the entity and size it correctly based on user prompt.
//    func scaleEntity(modelId: String) {
//        // based on prompt scale the object
//        
//    }
//    
//    // After finding or generating content, rotate the entity correctly based on user prompt.
//    func rotateEntity(modelId: String) {
//        // based on prompt rotate the object
//        
//    }
//        public typealias Vector3 = SIMD3<Float>
//        public typealias Vector4 = SIMD4<Float>
//    
//    // After finding or generating content and scaling it, place the entity in the correct location based on user prompt.
//    func placeEntity(modelId: String) -> JSValue {
//        let planeAnchor = AnchorEntity(.plane([.vertical, .horizontal],
//                                              classification: [.floor, .ceiling],
//                                              minimumBounds: [0.7, 0.7]))
//        print("\(planeAnchor.position) is planeAnchor position")
//        planeAnchor.addChild(self.currentEntity)
//        self.sceneView.scene.addAnchor(planeAnchor)
//        
//        return JSValue(undefinedIn: _jsContext)
//    }
//
//    
//    func setupSpeech() {
//
//        //self.btnStart.isEnabled = false
//        self.speechRecognizer?.delegate = self
//
//        SFSpeechRecognizer.requestAuthorization { (authStatus) in
//
//            var isButtonEnabled = false
//
//            switch authStatus {
//            case .authorized:
//                isButtonEnabled = true
//
//            case .denied:
//                isButtonEnabled = false
//                print("User denied access to speech recognition")
//
//            case .restricted:
//                isButtonEnabled = false
//                print("Speech recognition restricted on this device")
//
//            case .notDetermined:
//                isButtonEnabled = false
//                print("Speech recognition not yet authorized")
//            @unknown default:
//                fatalError()
//            }
//
//            OperationQueue.main.addOperation() {
//                self.recordAudioImgView.isUserInteractionEnabled = isButtonEnabled
//            }
//        }
//    }
//
//    //------------------------------------------------------------------------------
//
//    func startRecording() {
//
//        // Clear all previous session data and cancel task
//        if recognitionTask != nil {
//            recognitionTask?.cancel()
//            recognitionTask = nil
//        }
//
//        // Create instance of audio session to record voice
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("audioSession properties weren't set because of an error.")
//        }
//
//        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//
//        let inputNode = audioEngine.inputNode
//
//        guard let recognitionRequest = recognitionRequest else {
//            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
//        }
//
//        recognitionRequest.shouldReportPartialResults = true
//
//        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
//
//            var isFinal = false
//
//            if result != nil {
//                self.changeInputMethodLabel.text = "Tap the record button again to stop recording. We'll take it from there!"
//                self.recordedSpeechLabel.backgroundColor = UIColor.white
//                self.recordedSpeechLabel.textColor = .black
//                self.recordedSpeechLabel.layer.cornerRadius = 12
//               // self.recordedSpeechLabel.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
////                self.recordedSpeechTextView.isScrollEnabled = false
////                self.recordedSpeechTextView.translatesAutoresizingMaskIntoConstraints = true
//                
//                print(result?.bestTranscription.formattedString)
//                self.recordedSpeechLabel.text = result?.bestTranscription.formattedString
//               // self.recordedSpeechTextView.sizeToFit()
//                isFinal = (result?.isFinal)!
//            }
//
//            if error != nil || isFinal {
//
//                self.audioEngine.stop()
//                inputNode.removeTap(onBus: 0)
//                self.recordAudioImgView.tintColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1.0)
//                self.recognitionRequest = nil
//                self.recognitionTask = nil
//
//                self.recordAudioImgView.isUserInteractionEnabled = true
//                // Send prompt to ChatGPT
//                self.sendToChatGPT(prompt: self.recordedSpeechLabel.text ?? "")
//               // self.placeTV()
//          //      self.placePainting()
//            }
//        })
//
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
//            self.recognitionRequest?.append(buffer)
//        }
//
//        self.audioEngine.prepare()
//
//        do {
//            try self.audioEngine.start()
//        } catch {
//            print("audioEngine couldn't start because of an error.")
//        }
//
//       // self.lblText.text = "Say something, I'm listening!"
//    }
//    
//    
//    func placeTV(){
//        ProgressHUD.show("Loading...")
//        view.isUserInteractionEnabled = false
//      
//    print("\(self.modelName) is modelName")
//        
//        let group = DispatchGroup()
//
//        // Enter the dispatch group before starting the first async task
//        group.enter()
//        FirestoreManager.getModel("MbfjeiKYGfOFTw74eb33") { model in
//            let modelName = model?.modelName
//            print("\(modelName ?? "") is model name")
//            // Enter the dispatch group before starting the second async task
//            group.enter()
//            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")")  { localUrl in
//                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                    switch loadCompletion {
//                    case.failure(let error): print("Unable to load modelEntity for Mayflower Ship Model. Error: \(error.localizedDescription)")
//                        ProgressHUD.dismiss()
//                    case.finished:
//                        break
//                    }
//                    // Leave the dispatch group after finishing the second async task
//                    group.leave()
//                }, receiveValue: { modelEntity in
//                    self.currentEntity = modelEntity
//                        self.currentEntity.name = model?.name ?? ""
//                     //   self.modelUid =
//                        print(self.currentEntity)
//                        self.currentEntity.generateCollisionShapes(recursive: true)
//                        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                                    material: .default,
//                                                                        mode: .dynamic)
//                    
//                      //  self.tvStand?.addChild(modelEntity) // .addAnchor(anchor!) //maybe currentEntity, not anchor
//                      //  modelEntity.setPosition(SIMD3(0.0, 0.78, 0.0), relativeTo: self.tvStand)
//                    guard let query = self.sceneView.makeRaycastQuery(from: self.sceneView.center,
//                                                                  allowing: .estimatedPlane,
//                                                                 alignment: .vertical)
//                            else { return }
//
//                            guard let result = self.sceneView.session.raycast(query).first
//                            else { return }
//
//                            let raycastAnchor = AnchorEntity(world: result.worldTransform)
//                    print("\(result.worldTransform) is worldTransform")
//                            raycastAnchor.addChild(self.currentEntity)
//                       // anchor?.addChild(self.currentEntity))
//                    self.sceneView.scene.anchors.append(raycastAnchor)
//
//                        print("modelEntity for Samsung 65' QLED 4K Curved Smart TV has been loaded.")
//                       // ProgressHUD.dismiss()
//                    self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//                        self.view.isUserInteractionEnabled = true
//                        self.sceneView.isUserInteractionEnabled = true
//                    
//                    self.cancelAIAction()
//                    self.placePainting()
//                })
//                // Leave the dispatch group after finishing the first async task
//                group.leave()
//                }
//                
//            }
//    }
//    
//    func placePainting(){
//     //   ProgressHUD.show("Loading...")
//      //  view.isUserInteractionEnabled = false
//      
//    print("\(self.modelName) is modelName")
//        
//        let group = DispatchGroup()
//
//        // Enter the dispatch group before starting the first async task
//        group.enter()
//        FirestoreManager.getModel("2mG9Q1zMR6Avye5JZHFX") { model in
//            let modelName = model?.modelName
//            print("\(modelName ?? "") is model name")
//            // Enter the dispatch group before starting the second async task
//            group.enter()
//            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")")  { localUrl in
//                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                    switch loadCompletion {
//                    case.failure(let error): print("Unable to load modelEntity for Mayflower Ship Model. Error: \(error.localizedDescription)")
//                        ProgressHUD.dismiss()
//                    case.finished:
//                        break
//                    }
//                    // Leave the dispatch group after finishing the second async task
//                    group.leave()
//                }, receiveValue: { modelEntity in
//                    self.currentEntity = modelEntity
//                        self.currentEntity.name = model?.name ?? ""
//                     //   self.modelUid =
//                        print(self.currentEntity)
//                        self.currentEntity.generateCollisionShapes(recursive: true)
//                        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                                    material: .default,
//                                                                        mode: .dynamic)
//                    
//                    let floorPlane = AnchoringComponent.Target.plane(.horizontal, classification: .floor, minimumBounds: [0.2, 0.2])
//                    let plane = AnchoringComponent.Target.Alignment.horizontal
//                    let planeAnchor = AnchorEntity(.plane([.horizontal],
//                                          classification: [.floor, .ceiling],
//                                                          minimumBounds: [0.7, 0.7]))
//                    let raycastAnchor = AnchorEntity(plane: plane)// (anchor: floorPlane)
//                    print("\(planeAnchor.position) is planeAnchor position")
//                    planeAnchor.addChild(self.currentEntity)
//                       // anchor?.addChild(self.currentEntity))
//                    self.sceneView.scene.anchors.append(planeAnchor)
//                    
//                 
//
//                        print("modelEntity for Samsung 65' QLED 4K Curved Smart TV has been loaded.")
//                        ProgressHUD.dismiss()
//                    self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//                        self.view.isUserInteractionEnabled = true
//                        self.sceneView.isUserInteractionEnabled = true
//                    
//                  //  self.cancelAIAction()
//                    //self.placePainting()
//                })
//                // Leave the dispatch group after finishing the first async task
//                group.leave()
//                }
//                
//            }
//    }
//    
//    public func onMessageReceived(id: String, data: Data) {
//        let decoder = JSONDecoder()
//        do {
////            let msg = try decoder.decode(ChatGPTResponseMessage.self, from: data)
////            print("[ViewController] ChatGPT response message received. Code:\n\(msg.code)")
////            self.runCode(code: msg.code)
//           //get code from chatGPT API response
//        }
//        catch {
//            print("[ViewController] Failed to decode message")
//        //    Util.hexDump(data)
//        }
//    }
//    let api = ChatGPTAPI(apiKey: "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")
//    
//
//    private func sendToChatGPT(prompt: String) {
////        // Augment the user's prompt with additional material
////        if let augmentedPrompt = self.augmentPrompt(prompt: prompt) {
////            //ChatGPTPromptMessage(prompt: augmentedPrompt) - chatGPT api
////        }
//        
//        Task {
//            do {
//                    print(self.augmentPrompt(prompt: prompt))
//                let response = try await self.api.sendMessage(text: self.augmentPrompt(prompt: prompt))
//                
//                   print(response)
//                self.runCode(code: response)
//               } catch {
//                   print(error.localizedDescription)
//               }
//        }
//    }
//                          
//    func chatGPTResponse(response: String){
//        
////        let msg = try decoder.decode(T.self, from: data) decoder.decode(response, from: <#Data#>)
////           print("[ViewController] ChatGPT response message received. Code:\n\(msg.code)")
////            self.runCode(code: msg.code)
//    }
//                          
//                          
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
//            self.libraryImageView.isHidden = false
//            self.videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//            self.networkBtn.isHidden = false
//            self.networksNearImg.isHidden = false
//         //   self.feedbackControl.isHidden = true
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
//    @objc func goToLibrary(){
//        if Auth.auth().currentUser != nil {
//            let user = Auth.auth().currentUser?.uid ?? ""
//            let vc = LibraryViewController.instantiate(with: user) //(user:user)
//            let navVC = UINavigationController(rootViewController: vc)
//           // var next = UserProfileViewController.instantiate(with: user)
//           //  navVC.modalPresentationStyle = .fullScreen
//          //  self.navigationController?.pushViewController(next, animated: true)
//            present(navVC, animated: true)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            var next = storyboard.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountViewController
//           // next.modalPresentationStyle = .fullScreen
//            self.present(next, animated: true, completion: nil)
//        }
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
//    
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
//        self.libraryImageView.isHidden = true
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
//    
//    @IBAction func cancelWalkthroughAction(_ sender: Any) {
//        let defaults = UserDefaults.standard
//        if defaults.bool(forKey: "finishedWalkthrough") == false {
//            let alert = UIAlertController(title: "Skip Tutorial", message: "Skip Blueprint's tutorial? If you already know how to use Blueprint, feel free to skip this part.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Skip", style: .default) { action in
//                
//                defaults.set(true, forKey: "finishedWalkthrough")
//                self.walkthroughView.isHidden = true
//                self.circle.isHidden = true
//                self.walkthroughLabel.isHidden = true
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
////    func textViewDidBeginEditing(_ textView: UITextView) {
////        if textView.textColor == UIColor.lightGray {
////            textView.text = nil
////            textView.textColor = UIColor.black
////        }
////    }
////
////    func textViewDidEndEditing(_ textView: UITextView) {
////        if textView.text.isEmpty {
////            textView.text = "Type message here"
////            textView.textColor = UIColor.lightGray
////        } // disable the post button
////        //messageText = messageTextView.text
////    }
////
////    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
////        if textView.text == nil || textView.text == "" || textView.text.isEmpty {
////            postMessageButton.backgroundColor = UIColor(red: 66/255, green: 126/255, blue: 251/255, alpha: 0.5)
////            postMessageButton.isUserInteractionEnabled = false
////        } else {
////            postMessageButton.backgroundColor = UIColor(red: 66/255, green: 126/255, blue: 251/255, alpha: 1.0)
////            postMessageButton.isUserInteractionEnabled = true
////        }
////    }
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
////            searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
////            searchBtn.isHidden = false
//            entityProfileBtn.isHidden = true
//            //networksNearImg.isHidden = false
//            self.networksNear()
//            self.buttonStackView.isHidden = false
//            anchorSettingsImg.isHidden = true
//            anchorUserImg.isHidden = true
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.libraryImageView.isHidden = false
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
////            searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
////            searchBtn.isHidden = false
//            entityProfileBtn.isHidden = true
//           // networksNearImg.isHidden = false
//            self.networksNear()
//          
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.libraryImageView.isHidden = false
//            self.buttonStackView.isHidden = false
//          
//            
//        }
//      //  }
//            
//        placementStackView.isHidden = true
//       //
//       // shareImg.isHidden = false
//    //    scanBtn.isHidden = true
//        
//     //   toggleBtn.isHidden = false
//        
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
//     
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
//    @objc func rotateEntity(){
//        selectedAnchor?.setOrientation(simd_quatf(ix: 0, iy: 0, iz: 90, r: 0), relativeTo: selectedEntity)
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
//            toggleBtn.isHidden = true
//            self.undoButton.isHidden = true
//            self.sceneInfoButton.isHidden = true
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
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
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
//        
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
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
//      //      shareImg.addGestureRecognizer(textSettingsRecognizer)
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
//                self.libraryImageView.isHidden = false
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
////        navigationController.popoverPresentationController?.sourceView = shareImg
////        navigationController.popoverPresentationController?.sourceRect = shareImg.bounds
//    }
//    
//    @objc func dismissSettings() {
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
//           // feedbackControl?.isHidden = true
//            anchorUserImg.isHidden = true
//            anchorInfoStackView.isHidden = true
//   //         anchorSettingsImg.isHidden = true
//            
//        } else {
//            progressView?.isHidden = false
//          //  feedbackControl?.isHidden = false
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
//                } else if defaults.bool(forKey: "flowerBoy") == true {
//                    self.addFlowerBoy()
//                    defaults.set(false, forKey: "flowerBoy")
//                } else if defaults.bool(forKey: "downloadImage") == true {
//                    self.downloadImageFromMarketplace()
//                    defaults.set(false, forKey: "downloadImage")
//                } else if defaults.bool(forKey: "showCreationSuccess") == true {
//                    self.showCreationSuccessAlert()
//                    defaults.set(false, forKey: "showCreationSuccess")
//                } else if defaults.bool(forKey: "showContentDeleted") == true {
//                    self.showContentDeletedAlert()
//                    defaults.set(false, forKey: "showContentDeleted")
//                }
//            }
//        
//    }
//    
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
//          //  self.currentlyPlacingAnchor = true
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
//           // self.createLocalAnchor(anchorLocation: anchorLocation)
//            self.sceneManager.anchorEntities.append(anchor)
//            
//            print("\(anchor.orientation) is the new anchor orientation")
//            print("\(currentEntity.scale) is the search entity scale")
//            
////            if (enoughDataForSaving && localAnchor != nil) { //currentlyPlacingAnchor &&
////              //  self.createCloudAnchor()
////            }
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
//         
//            
//            let component = ModelDebugOptionsComponent(visualizationMode: .none)
//            selectedEntity?.modelDebugOptions = component
//            
//            self.updatePersistanceAvailability(for: sceneView)
//           
//            entityName.isHidden = true
//            entityProfileBtn.isHidden = true
//            placementStackBottomConstraint.constant = 15
//            //      //topview.isHidden = false
//           
//            networkBtn.isHidden = false
//            
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.libraryImageView.isHidden = false
//            self.buttonStackView.isHidden = false
//           // networksNearImg.isHidden = false
//          
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.buttonStackView.isHidden = false
//           // networksNearImg.isHidden = false
//            self.networksNear()
//           
//            duplicateBtn.isHidden = true
//            //  shareImg.isHidden = false
//            placementStackView.isHidden = true
//            //  searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//            //  toggleBtn.isHidden = false
//          
//            self.sceneView.addGestureRecognizer(doubleTap)
//            self.sceneView.addGestureRecognizer(holdGesture)
//        } else {
//            networkBtn.isHidden = false
//            wordsBtn.isHidden = false
//            videoBtn.isHidden = false
//            self.libraryImageView.isHidden = false
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
//    
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
////        if (self.isMovingToParent || self.isBeingPresented){
////                // Controller is being pushed on or presented.
////            }
////            else{
////                // Controller is being shown as result of pop/dismiss/unwind.
////                let defaults = UserDefaults.standard
////                self.modelUid = defaults.value(forKey: "modelUid") as! String
////
////                if defaults.bool(forKey: "downloadContent") == true{
////                    if self.modelUid != "" {
////                        self.downloadContentFromMarketplace()
////                        defaults.set(false, forKey: "downloadContent")
////                    }
////                } else if defaults.bool(forKey: "flowerBoy") == true {
////                    self.addFlowerBoy()
////                    defaults.set(false, forKey: "flowerBoy")
////                } else if defaults.bool(forKey: "downloadImage") == true {
////                    self.downloadImageFromMarketplace()
////                    defaults.set(false, forKey: "downloadImage")
////                } else if defaults.bool(forKey: "showCreationSuccess") == true {
////                    self.showCreationSuccessAlert()
////                    defaults.set(false, forKey: "showCreationSuccess")
////                } else if defaults.bool(forKey: "showContentDeleted") == true {
////                    self.showContentDeletedAlert()
////                    defaults.set(false, forKey: "showContentDeleted")
////                }
////            }
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
//            self.libraryImageView.isHidden = false
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
//    
//    
//   
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
////    var worldMapData: Data? = {
////        storedData.data(forKey: mapKey)
////    }()
//    
//    func saveMap(){
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
//    @objc func showCreationSuccessAlert(){
//        SCLAlertView().showSuccess("Success!", subTitle: "Your work was successfully uploaded to the Marketplace and saved to your Profile! Check it out in your Library or on your Profile.")
//    }
//    
//    @objc func showContentDeletedAlert() {
//        SCLAlertView().showSuccess("Content Deleted", subTitle: "Your work was successfully removed from the Marketplace and your Profile.")
//    }
//    
//    @objc func dismissKeyboard() {
//       // searchBar.isHidden = true
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
//           
//            networkBtn.isHidden = false
//            //categoryScrollView.isHidden = true
//            networksNearImg.isHidden = false
//         
//            self.wordsBtn.isHidden = false
//            self.videoBtn.isHidden = false
//            self.libraryImageView.isHidden = false
//            self.buttonStackView.isHidden = false
//          
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
//                  
//                    self.toggleBtn.isHidden = true
//                    self.undoButton.isHidden = true
//                    self.sceneInfoButton.isHidden = true
//                    self.dismissKeyboard()
//                    ProgressHUD.show("Loading...")
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
//                       //     self.downloadModel()
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
//          
//        }}
//    
//    
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
//          //  browseTableView.reloadData()
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
//
//    
//    func loadMap(){
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
//    func addFlowerBoy() {
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
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
//     func addAsapPoster() {
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
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
//    func addChancePoster() {
//        toggleBtn.isHidden = true
//        self.undoButton.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
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
//    
//    var modelName = ""
//    var imageURL : URL?
//    
//    func downloadImageFromMarketplace(){
//        toggleBtn.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.undoButton.isHidden = true
//    self.anchorSettingsImg.isHidden = true
//    self.entityName.removeFromSuperview()
//    self.entityProfileBtn.removeFromSuperview()
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//        self.addCloseButton()
//    print("\(self.modelName) is modelName")
//    FirestoreManager.getModel(self.modelUid) { model in
//        let modelName = model?.modelName
//        print("\(modelName ?? "") is model name")
//        
//        let mesh = MeshResource.generateBox(width: 0.85, height: 0.04, depth: 0.85)// .generatePlane(width: 1.0, depth: 1.0)// .generatePlane(width: 1.5, height: 0.9)    // 16:9 video
//
//        var material = SimpleMaterial()// VideoMaterial(avPlayer: avPlayer) //UIImageView(image: pickedImageView.image) //pickedImageView.image
//        let thumbnailName = model?.thumbnail
//        self.imageURL = URL(string: "gs://blueprint-8c1ca.appspot.com/thumbnails/\(thumbnailName ?? "")")
//        
//    //    material.baseColor = try! .texture(.load(contentsOf: self.imageURL!))
//         //info[UIImagePickerController.InfoKey.imageURL] as? URL
//        
////        StorageManager.getModelThumbnail(thumbnailName ?? "") { image in
////            material.baseColor = image
////        }
//       
//        material.baseColor = try! .texture(.load(named: "chanceposter"))
//        let planeModel = ModelEntity(mesh: mesh, materials: [material])
//        
//        self.currentEntity = planeModel
//        self.currentEntity.name = model?.name ?? ""
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
//        }
//    }
//    
//    var tvStand : ModelEntity?
//    
//    func downloadContentFromMarketplace(){
//        toggleBtn.isHidden = true
//        self.sceneInfoButton.isHidden = true
//        self.undoButton.isHidden = true
//    self.anchorSettingsImg.isHidden = true
//    self.entityName.removeFromSuperview()
//    self.entityProfileBtn.removeFromSuperview()
//        dismissKeyboard()
//        ProgressHUD.show("Loading...")
//        view.isUserInteractionEnabled = false
//        self.addCloseButton()
//    print("\(self.modelName) is modelName")
//        
//        let group = DispatchGroup()
//
//        // Enter the dispatch group before starting the first async task
//        group.enter()
//        FirestoreManager.getModel(self.modelUid) { model in
//            let modelName = model?.modelName
//            print("\(modelName ?? "") is model name")
//            // Enter the dispatch group before starting the second async task
//            group.enter()
//            FirebaseStorageHelper.asyncDownloadToFilesystem(relativePath: "models/\(modelName ?? "")")  { localUrl in
//                self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl).sink(receiveCompletion: { loadCompletion in
//                    switch loadCompletion {
//                    case.failure(let error): print("Unable to load modelEntity for Mayflower Ship Model. Error: \(error.localizedDescription)")
//                        ProgressHUD.dismiss()
//                    case.finished:
//                        break
//                    }
//                    // Leave the dispatch group after finishing the second async task
//                    group.leave()
//                }, receiveValue: { modelEntity in
//                    self.currentEntity = modelEntity
//                    if self.modelUid == "kUCg8YOdf4buiXMwmxm7" {
//                        self.tvStand = modelEntity
//                    }
//                        self.currentEntity.name = model?.name ?? ""
//                     //   self.modelUid =
//                        print(self.currentEntity)
//                        self.currentEntity.generateCollisionShapes(recursive: true)
//                        let physics = PhysicsBodyComponent(massProperties: .default,
//                                                                    material: .default,
//                                                                        mode: .dynamic)
//                        // modelEntity.components.set(physics)
//                    if self.modelUid == "MbfjeiKYGfOFTw74eb33" {
//                        self.sceneView.installGestures([.rotation, .scale], for: self.currentEntity) //.translation
//                        let anchor =  self.focusEntity?.anchor
//                        print(anchor)
//                        anchor?.addChild(self.currentEntity)
//                        let scale = model?.scale
//                        print("\(scale) is scale")
//                        self.currentEntity.scale = [Float(scale ?? 0.01), Float(scale ?? 0.01), Float(scale ?? 0.01)]
//                        //create variable specifically for tvStand
//                        self.tvStand?.addChild(modelEntity) // .addAnchor(anchor!) //maybe currentEntity, not anchor
//                        modelEntity.setPosition(SIMD3(0.0, 0.78, 0.0), relativeTo: self.tvStand)
//                       // self.sceneView.scene.addAnchor(anchor!)
//                        print("modelEntity for Samsung 65' QLED 4K Curved Smart TV has been loaded.")
//                        ProgressHUD.dismiss()
//                        self.removeCloseButton()
//                       // print("modelEntity for \(self.name) has been loaded.")
//                        self.view.isUserInteractionEnabled = true
//                        self.sceneView.isUserInteractionEnabled = true
//                    } else {
//                        self.sceneView.installGestures([.translation, .rotation, .scale], for: self.currentEntity)
//                        let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//                        print(anchor)
//                        // anchor?.scale = [1.2,1.0,1.0]
//                        anchor?.addChild(self.currentEntity)
//                        let scale = model?.scale
//                        print("\(scale) is scale")
//                        self.currentEntity.scale = [Float(scale ?? 0.01), Float(scale ?? 0.01), Float(scale ?? 0.01)]
//                        self.sceneView.scene.addAnchor(anchor!)
//                        // self.currentEntity?.scale *= self.scale
//                        print("modelEntity for Mayflower Ship Model has been loaded.")
//                        ProgressHUD.dismiss()
//                        self.removeCloseButton()
//                        // print("modelEntity for \(self.name) has been loaded.")
//                        self.modelPlacementUI()
//                    }
//                    // Leave the dispatch group after finishing the first async task
//                    group.leave()
//                })
//            }
//        }
//        // Wait for all async tasks to finish and call the completion closure
//        group.notify(queue: .main) {
//            // Do something after all async tasks are finished
//            self.view.isUserInteractionEnabled = true
//        }
//
//                
//    }
//    
//    
//    var modelId1 = ""
//    var modelId2 = ""
//    
//    
//    private var cancellable: AnyCancellable?
//    
//    let nftView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 375))
//    let searchStackUnderView = UIView(frame: CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width / 2, height: 2))
//    
//    
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
//            } else if self.isPlacingModel == true {
//                self.networksNearImg.image = UIImage(systemName: "\(num).circle.fill")
//                self.networksNearImg.isHidden = false
//            }
//        }}
//    
//    var isPlacingModel = false
//    
//     func modelPlacementUI(){
//        self.sceneView.removeGestureRecognizer(holdGesture)
//        self.isPlacingModel = true
//        self.networksNearImg.isHidden = true
//        self.placementStackView.isHidden = false
//        //searchStackUnderView.isHidden = true
//        self.networkBtn.isHidden = true
//        self.networksNearImg.isHidden = true
//        self.wordsBtn.isHidden = true
//         self.libraryImageView.isHidden = true
//        self.videoBtn.isHidden = true
//        self.buttonStackView.isHidden = true
////        searchBtn.isHidden = true
//        addButton.isHidden = true
//        self.progressView?.isHidden = true
//        toggleBtn.isHidden = true
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
//     func goToSignUp(){
//        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
//        var next = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
//         next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//    }
//    
//    func updateUserLocation() {
//        if self.currentLocation?.distance(from: self.originalLocation) ?? 0 >= 7 && self.currentLocation?.distance(from: self.originalLocation) ?? 0 < 200 {
//          //  self.lookForAnchorsNearDevice()
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
//     func exit(){
//        ProgressHUD.dismiss()
//        self.updatePersistanceAvailability(for: sceneView)
//        entityName.isHidden = true
//        entityProfileBtn.isHidden = true
//        placementStackBottomConstraint.constant = 15
//            networkBtn.isHidden = false
//        wordsBtn.isHidden = false
//        videoBtn.isHidden = false
//         self.libraryImageView.isHidden = false
//            networksNearImg.isHidden = false
//       //
//        placementStackView.isHidden = true
//        duplicateBtn.isHidden = true
//        return
//    }
//    
//    func noLidarModelPlacementUI(){
//        
//    }
//    
//
//    
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        switch frame.worldMappingStatus {
//        case .notAvailable, .limited:
//            saveButton.isUserInteractionEnabled = false
//        case .extending:
//            saveButton.isUserInteractionEnabled = !multipeerSession.connectedPeers.isEmpty
//        case .mapped:
//            saveButton.isUserInteractionEnabled = !multipeerSession.connectedPeers.isEmpty
//        @unknown default:
//            saveButton.isUserInteractionEnabled = false
//        }
//            self.updateUserLocation()
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
//   
//    var anchorHostID = ""
//    var entityName = UILabel()
//    var entityDetailsView = UIView()
//    var entityProfileBtn = UIButton()
//    var image: UIImage? = nil
//    var detailAnchor = AnchorEntity()
//    
//    func goToNetworkSettings(_ sender: UITapGestureRecognizer){
//        let storyboard = UIStoryboard(name: "Networks", bundle: nil)
//        var next = storyboard.instantiateViewController(withIdentifier: "NetworkSettingsVC") as! NetworkSettingsTableViewController
//        //next.modalPresentationStyle = .fullScreen
//        self.present(next, animated: true, completion: nil)
//    }
////
////    @IBAction func sceneInfoAction(_ sender: Any) {
////        self.updatePersistanceAvailability(for: sceneView)
////        self.handlePersistence(for: sceneView)
////        print("\(sceneManager.persistenceURL) is persist url")
////        print("\(sceneManager.scenePersistenceData) is persist data")
////    }
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
//    
//    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) { //UILongPress
//        if gesture.state == UIGestureRecognizer.State.began {
//            //virtualTaps = 0
//            let touchLocation = gesture.location(in: sceneView)
//            let hits = self.sceneView.hitTest(touchLocation)
//            if let tappedEntity = hits.first?.entity  {
//                print("\(tappedEntity.name) is the name of the tapped enitity")
//                print("\(tappedEntity.position(relativeTo: currentEntity)) is the position relative to the current entity")
//                print("\(tappedEntity.position.y)) is the top y point of the tapped entity")
//                print("\(tappedEntity.anchor?.position.y ?? 0)) is the top y point of the tapped entity's anchor")
//          //      print("\(tappedEntity.size ?? 0)) is the tapped entity's size")
//                print("\(tappedEntity.scale) is the tapped entity's scale")
//                
//                let tappedName = tappedEntity.name
//                
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
//                    self.buttonStackView.isHidden = true
//                saveButton.isHidden = true
//                    undoButton.isHidden = true
//                    print("\(currentEntity.physicsBody?.massProperties.mass)")
//                numberOfEditsImg.isHidden = true
//                networkBtn.isHidden = true
//                    wordsBtn.isHidden = true
//                    videoBtn.isHidden = true
//                self.libraryImageView.isHidden = true
//                print(tappedEntity.name)
//                print("is tapped entity name")
//                placementStackView.isHidden = false
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
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error getting location: \(error.localizedDescription)")
//        // You can also display an alert to the user or show a message on the screen to inform them that there was an error getting their location.
//    }
//    
//    private let locationUpdateThreshold: CLLocationDistance = 50
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if self.currentLocation == nil {
//            if let location = locations.first {
//                //MAYBE LOCATIONMANAGER.COORDINATE.LAT
//                let latitude = location.coordinate.latitude
//                let longitude = location.coordinate.longitude
//                self.originalLocation = CLLocation(latitude: latitude, longitude: longitude)
//                self.networksNear()
//               // self.lookForAnchorsNearDevice()
//                if Auth.auth().currentUser != nil {
//                    let docRef = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
//                    docRef.updateData([
//                        "latitude": latitude,
//                        "longitude": longitude,
//                        "numSessions" : FieldValue.increment(Int64(1))
//                    ]) { (error) in
//                        if let error = error {
//                            print("Error updating location: \(error.localizedDescription)")
//                        } else {
//                            print("Location updated successfully!")
//                        }
//                    }
//                }
//            }
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
//             //       self.connectToNetwork(with: self.currentConnectedNetwork)
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
//    private func updateUserLocationInDatabase(_ location: CLLocation) {
//        let latitude = location.coordinate.latitude
//        let longitude = location.coordinate.longitude
//        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
//        docRef.updateData([
//            "latitude": latitude,
//            "longitude": longitude
//        ]) { (error) in
//            if let error = error {
//                print("Error updating location: \(error.localizedDescription)")
//            } else {
//                print("Location updated successfully!")
//            }
//        }
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
//            self.libraryImageView.isHidden = true
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
//
//extension LaunchViewController: SFSpeechRecognizerDelegate {
//
//    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        if available {
//        //    self.btnStart.isEnabled = true
//        } else {
//         //   self.btnStart.isEnabled = false
//        }
//    }
//}
