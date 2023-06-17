//
//  BrowseViewController.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 5/28/21.
//  Copyright © 2021 Placenote. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
//import PlacenoteSDK
import MultipeerConnectivity

protocol BrowseViewControllerDelegate {
    func updateNetworkImg()
}

class BrowseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var delegate: BrowseViewControllerDelegate?
    
   let launchVC = LaunchViewController()
    

    @IBOutlet weak var searchBar: HomeSearchBar!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    private var modelManager: ModelManager = ModelManager()
    
   // var demoVC = DemoViewController()
    
   // private var loadedMetaData: LibPlacenote.MapMetadata = LibPlacenote.MapMetadata()
      
      var selectedObject: VirtualObject?
      var selectedNode: SCNNode?

      /// The object that is tracked for use by the pan and rotation gestures.
      var trackedObject: VirtualObject? {
          didSet {
              guard trackedObject != nil else { return }
              selectedObject = trackedObject
          }
      }
    
//    
//    @IBAction func addChess(_ sender: Any) {
//////        print (String (describing: reticle.getReticlePosition()))
//////        modelManager.addModelAtPose(pos: reticle.getReticlePosition(),
//////                                    rot: reticle.getReticleRotation() ,index: 0)
////
////      //  navigationController?.popViewController(animated: true)
////        navigationController?.dismiss(animated: true, completion: nil)
////
////        let url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/toycar/toy_car.usdz")
////        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
////        let destination = documents.appendingPathComponent(url!.lastPathComponent)
////        let session = URLSession(configuration: .default,
////                                      delegate: nil,
////                                 delegateQueue: nil)
////
////        var request = URLRequest(url: url!)
////        request.httpMethod = "GET"
////
////        let downloadTask = session.downloadTask(with: request, completionHandler: { (location: URL?,
////                                  response: URLResponse?,
////                                     error: Error?) -> Void in
////
////            let fileManager = FileManager.default
////
////            if fileManager.fileExists(atPath: destination.path) {
////                try! fileManager.removeItem(atPath: destination.path)
////            }
////            try! fileManager.moveItem(atPath: location!.path,
////                                      toPath: destination.path)
////
////            DispatchQueue.main.async {
////                            do {
////                                let model = try Entity.load(contentsOf: destination)
////                                model.generateCollisionShapes(recursive: true)
////
////                                let anchor = AnchorEntity(plane: .any) //self.focusEntity?.anchor // AnchorEntity(world: [0,-0.2,0])
////                                anchor.addChild(model)
////                                anchor.scale = [2,2,2]
////                                self.launchVC.sceneView?.scene.addAnchor(anchor)
////
////                                model.playAnimation(model.availableAnimations.first!.repeat())
////                            } catch {
////                                print("Fail loading entity.")
////                            }
////                        }
////                    })
////                    downloadTask.resume()
//    }
//
//    @IBAction func addTV(_ sender: Any) {
////        modelManager.addModelAtPose(pos: demoVC.focusNode.position,
////                                    rot: demoVC.focusNode.rotation ,index: 1)
//        
//        self.dismiss(animated: true, completion: nil)
//        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
//        view2.networkBtnImg = UIImage(named: "smarttv")
//        self.delegate?.updateNetworkImg()
//    }
//
//    @IBAction func addGuitar(_ sender: Any) {
//        print (String (describing: demoVC.focusNode.position))
////        if let presenter = presentingViewController as? OOTDListViewController {
////                presenter.testValue = "Test"
////            }
////        
//        self.dismiss(animated: true, completion: nil)
//        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
//        view2.networkBtnImg = UIImage(named: "guitarpbr")
//        //demoVC.networkBtn.setImage(UIImage(named: "guitarpbr"), for: .normal)
//      //  modelManager.addModelAtPose(pos: demoVC.focusNode.position, rot: demoVC.focusNode.rotation ,index: 2)
//    }
//
//    @IBAction func addUkelele(_ sender: Any) {
////        print (String (describing: demoVC.focusNode.position))
////        modelManager.addModelAtPose(pos: demoVC.focusNode.position,
////                                    rot: demoVC.focusNode.rotation ,index: 3)
//        
//        self.dismiss(animated: true, completion: nil)
//        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
//        view2.networkBtnImg = UIImage(named: "ukelele")
//    }
//
//    @IBAction func addArmchair(_ sender: Any) {
////        print (String (describing: demoVC.focusNode.position))
////        modelManager.addModelAtPose(pos: demoVC.focusNode.position,
////                                    rot: demoVC.focusNode.rotation ,index: 4)
//        self.dismiss(animated: true, completion: nil)
//        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
//        view2.networkBtnImg = UIImage(named: "armchair")
//    }
//
//
//    @IBAction func addDice(_ sender: Any) {
////        print (String (describing: demoVC.focusNode.position))
////        modelManager.addModelAtPose(pos: demoVC.focusNode.position,
////                                    rot: demoVC.focusNode.rotation ,index: 5)
//        self.dismiss(animated: true, completion: nil)
//        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
//        view2.networkBtnImg = UIImage(named: "3d dice")
//    }
//
//    @IBAction func addDeer(_ sender: Any) {
////        print (String (describing: demoVC.focusNode.position))
////        modelManager.addModelAtPose(pos: demoVC.focusNode.position,
////                                    rot: demoVC.focusNode.rotation,index: 6)
//        
//        self.dismiss(animated: true, completion: nil)
//        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
//        view2.networkBtnImg = UIImage(named: "deer")
//    }
//
//    @IBAction func addOwl(_ sender: Any) {
////        print (String (describing: demoVC.focusNode.position))
////        modelManager.addModelAtPose(pos: demoVC.focusNode.position,
////                                    rot: demoVC.focusNode.rotation,index: 7)
//        
//        self.dismiss(animated: true, completion: nil)
//        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
//        view2.networkBtnImg = UIImage(named: "barnowl")
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if indexPath.row == 0 {
                               // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PeopleNearYouCell")

                let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyUsedCell", for: indexPath)
            
                tableView.rowHeight = 245
                return cell
            }
            if indexPath.row == 1 {
              //  tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendsCell")

                let cell = tableView.dequeueReusableCell(withIdentifier: "MostPopularCell", for: indexPath)
                tableView.rowHeight = 245
                return cell
            }
                     if indexPath.row == 2 {
                        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OrderCell")

                         let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEssentialsCell", for: indexPath)
                         tableView.rowHeight = 245
                         return cell
                     }
               return UITableViewCell()
           }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
       // NSLog(searchText)
    }
    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//      // return true
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchViewTopConstraint.constant = 11
//        searchViewTrailing.constant = 10
//        searchBarHeight.constant = 48
//        searchBarWidth.constant = 296
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchViewTopConstraint.constant = 0
//        searchViewTrailing.constant = 0
//        searchBarHeight.constant = 60
//        searchBarWidth.constant = 375
    }
          
    }

