//
//  ARRoomModelView.swift
//  Indoor Blueprint
//
//  Created by CodisteMac on 16/05/23.
//

import UIKit
import ARKit
import SceneKit
import RoomPlan
import FirebaseAuth
import FocusEntity
import FirebaseFirestore
import SceneKit.ModelIO

class ARRoomModelView: UIViewController , ARSCNViewDelegate , SCNSceneRendererDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var searchImgView: UIImageView!
    @IBOutlet weak var stylesImgView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var optionsScrollView: UIScrollView!
    @IBOutlet weak var placementStackView: UIStackView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var styleTableView: UITableView!
    @IBOutlet weak var sceneView: ARSCNView!
    
    var capturedRoom: CapturedRoom?
    var modelScene = SCNScene()
    var modelURL : URL!
    var modelNode = SCNNode()
    
    var modelUid = ""
    var blueprintId = ""
    
    var selectedNode: SCNNode?
    var selectedModel : SCNNode?
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        return configuration
    }
    
    private var spaceNode: SCNNode? {
        sceneView.scene.rootNode.childNodes.first(where: \.isSpaceNode)
    }
    
    var focusEntity: FocusEntity?
    var configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.selectedModel = self.spaceNode
        
        self.selectedNode = self.spaceNode
        
        styleTableView.delegate = self
        styleTableView.dataSource = self
        styleTableView.register(StyleTableViewCell.self, forCellReuseIdentifier: "StyleTableViewCell")

        setup()
        // ARKit config
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // Render roomplan .usdz model
        Task {
            let asset = MDLAsset(url: modelURL)
            let scene = SCNScene(mdlAsset: asset)
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                
                scene.rootNode.markAsSpaceNode()
          //      self.decorateScene(scene)
                
                let rootScene = SCNScene()
                rootScene.rootNode.addChildNode(scene.rootNode)
                self.modelNode = scene.rootNode
                self.sceneView.scene = rootScene
                
//                let selectedStyle = "Minimalist Haven"
//                chooseFloorMaterial(forStyle: selectedStyle) { selectedTexture in
//                    if let selectedTexture = selectedTexture {
//                        print("Selected texture for style \(selectedStyle): \(selectedTexture)")
//                        self.applyMaterialToFloor()
//                    } else {
//                        print("Failed to choose wall material for style \(selectedStyle)")
//                    }
//                }
                
                self.addFloor()
                self.addCeiling()
                
                self.occlusionForWindowsAndDoors()
                self.decorateScene(scene)
            }
            
        }
        
        
        let pinchGesture =
          UIPinchGestureRecognizer(target: self,
                                   action: #selector(handlePinch(gesture:)))
        pinchGesture.delegate = self
        sceneView.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        sceneView.addGestureRecognizer(rotationGesture)
        
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(moveNode(_:)))
        moveGesture.delegate = self
        sceneView.addGestureRecognizer(moveGesture)
        
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        holdGesture.delegate = self
        sceneView.addGestureRecognizer(holdGesture)
        
    }
    
    //Add Floor plane node
    func addFloor() {
        guard let spaceNode = spaceNode else {
            print("No space node found")
            return
        }
        
        var hasFloor = false
        spaceNode.enumerateHierarchy({ node, _ in
            if node.type == .floor {
                hasFloor = true
                node.removeFromParentNode()
                return
            }
        })
        if hasFloor { return }
        
        let boundingBox = spaceNode.boundingBox
        let floorHeight: CGFloat = 0.001
        let boxOffset = Float(0.001) // make sides hangs off the wall
        let boxWidth = (boundingBox.max.x - boundingBox.min.x) + (boxOffset * 2)
        let boxLenght = (boundingBox.max.z - boundingBox.min.z) + (boxOffset * 2)
        let box = SCNBox(
            width: CGFloat(boxWidth),
            height: floorHeight,
            length: CGFloat(boxLenght),
            chamferRadius: 0
        )
        
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "Floor"
        box.firstMaterial?.diffuse.contents =  UIColor.green.withAlphaComponent(0.75) //UIImage(named: "wildtextures_mossed-tree-bark-seamless-2k-texture")
        let x = boundingBox.min.x + (boxWidth / 2.0) - boxOffset
        let z = boundingBox.min.z + (boxLenght / 2.0) - boxOffset
        // For, Up/Down Floor change Y position
        boxNode.localTranslate(by: .init(x: x, y: boundingBox.min.y - Float(box.height-0.1), z: z))
        spaceNode.addChildNode(boxNode)
        
        let roomModelEulerAngles = modelNode.eulerAngles
        let floorPlaneEulerAngles = SCNVector3(x: 0, y: roomModelEulerAngles.y, z: 0)
        boxNode.eulerAngles = floorPlaneEulerAngles
    }
    
    var selectedTextureId = ""
    var selectedTextureName = ""
    
    // Add Celling Plane Node
    func addCeiling() {
        guard let spaceNode = spaceNode else {
            print("No space node found")
            return
        }
        
        var hasFloor = false
        spaceNode.enumerateHierarchy({ node, _ in
            if node.type == .ceiling {
                hasFloor = true
                node.removeFromParentNode()
                return
            }
        })
        if hasFloor { return }
        
        let boundingBox = spaceNode.boundingBox
        let floorHeight: CGFloat = 0.001
        let boxOffset = Float(0.35)//(0.001) // make sides hangs off the wall
        let boxWidth = (boundingBox.max.x - boundingBox.min.x) + (boxOffset * 2)
        let boxLenght = (boundingBox.max.z - boundingBox.min.z) + (boxOffset * 2)
        let box = SCNBox(
            width: CGFloat(boxWidth),
            height: floorHeight,
            length: CGFloat(boxLenght),
            chamferRadius: 0
        )
        
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "Ceiling"
        box.firstMaterial?.diffuse.contents = UIImage(named: "sistineimg")
        let x = boundingBox.min.x + (boxWidth / 2.0) - boxOffset
        let z = boundingBox.min.z + (boxLenght / 2.0) - boxOffset
        // For, Up/Down Ceiling change Y position
        boxNode.localTranslate(by: .init(x: x, y: boundingBox.min.y + 2.8, z: z))
        spaceNode.addChildNode(boxNode)
        
        let roomModelEulerAngles = modelNode.eulerAngles
        let floorPlaneEulerAngles = SCNVector3(x: 0, y: roomModelEulerAngles.y, z: 0)
        boxNode.eulerAngles = floorPlaneEulerAngles
    }
    
    func chooseFloorMaterial(forStyle style: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        // Step 1: Retrieve the style document from Firestore
        let styleRef = db.collection("styles").document(style)
        styleRef.getDocument { (snapshot, error) in
            guard let document = snapshot, document.exists else {
                completion(nil) // Style not found in Firestore
                return
            }
            
            // Step 2: Retrieve the texture IDs from the style document
            guard let textureIDs = document.data()?["textures"] as? [String] else {
                completion(nil) // No texture IDs found for the style
                return
            }
            
            // Step 3: Get a random value from the texture IDs array
            let randomTexture = textureIDs.randomElement()
            self.selectedTextureId = randomTexture ?? ""
            
            completion(randomTexture)
        }
    }

    func applyMaterialToFloor() {
        FirestoreManager.getTexture(self.selectedTextureId) { texture in
            self.selectedTextureName = texture?.name ?? ""
           
            let thumbnailName = texture?.thumbnail
            StorageManager.getTextureThumbnail(thumbnailName ?? "") { image in
            //    self.selectedTexture.image = image
                
                // Apply the selected texture to the floor geometry
                let floorNode = self.modelNode.childNode(withName: "Floor", recursively: true)
                floorNode?.geometry?.firstMaterial?.diffuse.contents = image
            }
        }
    }
    
    func chooseWallMaterial(forStyle style: String, completion: @escaping (String?) -> Void) {

    }
    
    func chooseCeilingMaterial(forStyle style: String, completion: @escaping (String?) -> Void) {

    }
    
    func pickCategoryOptions(){
        
    }
    
    func showCategories(){
//    materials: wood, brick, stone, tile, concrete, metal, glass, fabric, plastic
//    designs: patterns, art, wallpapers
//    colors:
    }
    
    // Decorate RoomPlan nodes/object
    func decorateScene(_ scene: SCNScene) {
        let rootNode = scene.rootNode
        rootNode.enumerateHierarchy { node, _ in
            guard let geometry = node.geometry else { return }
            switch node.type {
            case .door:
                geometry.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.75)
            case .floor:
                print("Position before rotation:", node.position, "pivot: ", node.pivot)
           //     geometry.firstMaterial?.diffuse.contents = UIImage(named: "wildtextures_mossed-tree-bark-seamless-2k-texture")
                geometry.firstMaterial?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.5)

            case .ceiling:
                geometry.firstMaterial?.diffuse.contents = UIImage(named: "sistineimg")
            case .furniture:
                geometry.firstMaterial?.diffuse.contents = UIColor(red: 75/255, green: 145/255, blue: 250/255, alpha: 0.85)
            case .wall:
                geometry.firstMaterial?.diffuse.contents = UIColor.clear.withAlphaComponent(0.70)
     //           geometry.firstMaterial?.diffuse.contents = chooseWallMaterial()
            //    print("Position before rotation:", node.position, "pivot: ", node.pivot)
            case .opening, .window:
                geometry.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.75)
            case .none:
                break
            }
        }
    }
    
    //Break nodes of window and door
    func occlusionForWindowsAndDoors() {
        guard let spaceNode = spaceNode else { return }
        spaceNode.enumerateHierarchy { node, _ in
            guard node.type == .window || node.type == .door || node.type == .furniture  else { return }
            
            let occlusionMaterial = SCNMaterial()
            occlusionMaterial.colorBufferWriteMask = []
            occlusionMaterial.isDoubleSided = true
            
            // Apply the occlusion material to the windows node
            node.geometry?.materials = [occlusionMaterial]
            node.geometry?.firstMaterial?.writesToDepthBuffer = true
            node.renderingOrder = -1
        }
    }
    
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        if let selectedModel = self.selectedModel {
            if gesture.state == .changed {
                let pinchScaleX = Float(gesture.scale) * selectedModel.scale.x
                let pinchScaleY = Float(gesture.scale) * selectedModel.scale.y
                let pinchScaleZ = Float(gesture.scale) * selectedModel.scale.z
                selectedModel.scale = SCNVector3(pinchScaleX, pinchScaleY, pinchScaleZ)
                gesture.scale = 1.0
            }
        }
    }

    var currentAngleY: Float = 0.0

    @objc func didRotate(_ gesture: UIRotationGestureRecognizer) {
        if let selectedModel = self.selectedModel {
            let rotation = Float(gesture.rotation)
            
            if gesture.state == .changed {
                selectedModel.eulerAngles.y = currentAngleY + rotation
            }
            
            if gesture.state == .ended {
                currentAngleY = selectedModel.eulerAngles.y
            }
        }
    }

    @objc func moveNode(_ gesture: UIPanGestureRecognizer) {
        let currentTouchPoint = gesture.location(in: self.sceneView)
        
        guard let hitTest = self.sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
        
        let worldTransform = hitTest.worldTransform
        let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
        
        if let selectedModel = self.selectedModel {
            selectedModel.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
        }
    }
    
    func aniColor(from: UIColor, to: UIColor, percentage: CGFloat) -> UIColor {
        let fromComponents = from.cgColor.components!
        let toComponents = to.cgColor.components!

        let color = UIColor(red: fromComponents[0] + (toComponents[0] - fromComponents[0]) * percentage,
            green: fromComponents[1] + (toComponents[1] - fromComponents[1]) * percentage,
            blue: fromComponents[2] + (toComponents[2] - fromComponents[2]) * percentage,
            alpha: fromComponents[3] + (toComponents[3] - fromComponents[3]) * percentage)
        return color
    }
    
    @IBAction func likeAction(_ sender: Any) {
    }
    
    
    @IBAction func removeAction(_ sender: Any) {
    }
    
    @IBAction func confirmAction(_ sender: Any) {
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) { //UILongPress
        if gesture.state == UIGestureRecognizer.State.began {
            //virtualTaps = 0
            let touchLocation = gesture.location(in: sceneView)
            let hits = self.sceneView.hitTest(touchLocation) //.hitTest(touchLocation, options: nil)
            
            // if Auth.auth().currentUser != nil {
            if let tappedObject = hits.first?.node  {
                selectedNode = tappedObject
                
                print("\(tappedObject.name) is tappedobject name")
                print("\(selectedNode?.name) is selected node name")
                
                if tappedObject.name?.contains("Ceiling") == true {
                    tappedObject.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "wildtextures-climbing_vine_wall")
                } else if tappedObject.name?.contains("Floor")  == true  {
                    tappedObject.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "wildtextures_winter-leafs")
                } else if tappedObject.name?.contains("Wall")  == true {
                    //   tappedObject.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "wildtextures-climbing_vine_wall")
                    let oldColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.45)
                    let newColor =  UIColor(red: 0.9, green: 0.9, blue: 0.0, alpha: 0.80)// (colorLiteralRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.65)
                    let duration: TimeInterval = 1.3
                    let act0 = SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
                        let percentage = elapsedTime / CGFloat(duration)
                        node.geometry?.firstMaterial?.diffuse.contents = self.aniColor(from: newColor, to: oldColor, percentage: percentage)
                    })
                    let act1 = SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
                        let percentage = elapsedTime / CGFloat(duration)
                        node.geometry?.firstMaterial?.diffuse.contents = self.aniColor(from: oldColor, to: newColor, percentage: percentage)
                    })

                    let act = SCNAction.repeatForever(SCNAction.sequence([act0, act1]))
                    tappedObject.runAction(act)

                }
                
            }
            
        }
    }
    
    var overView = UIView()
    
    var editInstructions = UILabel()
    
    //  private var searchedModels  = [Model]()
    var stylesArray = ["Minimalist Haven", "Modern Fusion", "Japanese Zen", "Art Deco Glamour", "Bohemian Oasis", "Coastal Breeze", "Scandinavian Sanctuary", "Cyberpunk", "French Countryside"]
      private var styles        = [Style]()
      private var styleImages = [String: UIImage?]()
      private var fetchingImages = false
    
    var cancelImg = UIImageView()
    var promptLabel = UILabel()

   
    @objc func showStyles(){
     
        self.overView = UIView(frame: CGRect(x: 0, y: styleTableView.frame.minY - 20, width: UIScreen.main.bounds.width, height: 20))
        
        self.overView.clipsToBounds = true
        self.overView.layer.cornerRadius = 12
        self.overView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        styleTableView.isHidden = false
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
    
    @objc func searchUI(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var next = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        present(next, animated: true, completion: nil)

    }
    
    @objc func goToProfile(_ sender: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
      //  let modelUid = "6CwMVBiRJob46q4gR5VV" // modelId1
        var next = ObjectProfileViewController.instantiate(with: modelUid)
        next.modalPresentationStyle = .fullScreen
   //     self.navigationController?.pushViewController(ObjectProfileViewController.instantiate(with: modelUid), animated: true)
        self.present(next, animated: true, completion: nil)

    }
    
    @objc func cancelAIAction(){
      
        buttonStackView.isHidden = false
        self.styleTableView.isHidden = true
        self.overView.isHidden = true
       
        self.editInstructions.isHidden = true
        promptLabel.isHidden = true
        cancelImg.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StyleTableViewCell.identifier, for: indexPath) as! StyleTableViewCell
        
        tableView.rowHeight = 130

        // Determine the index in the styles array based on the row
        let index = indexPath.row * 3
        
        let isFirstFiveUnlocked = index < 5  // Adjust the condition based on the desired range of unlocked styles
        
        // Configure the cell with the corresponding styles
//        cell.configure(with: stylesArray[index])
//        cell.configure2(with: stylesArray[index + 1])
//        cell.configure3(with: stylesArray[index + 2])
        
        cell.configure(with: stylesArray[index], isFirstFiveUnlocked: isFirstFiveUnlocked)
            cell.configure2(with: stylesArray[index + 1], isFirstFiveUnlocked: isFirstFiveUnlocked)
            cell.configure3(with: stylesArray[index + 2], isFirstFiveUnlocked: isFirstFiveUnlocked)
            
        
        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func setup(){
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchUI))
        searchImgView.addGestureRecognizer(searchTap)
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile))
        profileImgView.addGestureRecognizer(profileTap)
      
        let styleTap = UITapGestureRecognizer(target: self, action: #selector(showStyles))//goToCapturedRoom
        stylesImgView.addGestureRecognizer(styleTap)
        
        sceneView.delegate = self
        
     //   focusEntity = FocusEntity(on: sceneView, focus: .classic)
        
        // ARView on its own does not turn on mesh classification.
        configuration.planeDetection = [.horizontal, .vertical]
        
        if #available(iOS 16.0, *) {
            if let hiResFormat = ARWorldTrackingConfiguration.recommendedVideoFormatFor4KResolution {
                configuration.videoFormat = hiResFormat
            }
        } else {
            // Fallback on earlier versions
        }
        sceneView.session.run(configuration)
    }
    
}


//MARK:- RoomPlan 3D model Node classifications
extension SCNNode {
    
    private static var nameIdentifier = "Space"
    
    func markAsSpaceNode() {
        name = "\(Self.nameIdentifier)_\(UUID().uuidString)"
    }
    
    var isSpaceNode: Bool {
        name?.starts(with: Self.nameIdentifier) ?? false
    }
    
    var type: NodeType? {
        NodeType(name: name)
    }
    
    enum NodeType: String, CaseIterable {
        case wall
        case door
        case opening
        case window
        case furniture
        case floor
        case ceiling
        
        init?(name: String?) {
            guard let name = name?.lowercased() else { return nil }
            if let type = NodeType.allCases.first(where: { name.starts(with: $0.rawValue) }) {
                self = type
                return
            }
            
            let furnitureTypes = CapturedRoom.Object.Category.allCases.map(\.detail)
            if furnitureTypes.contains(where: { name.starts(with: $0) }) {
                self = .furniture
                return
            }
            return nil
        }
    }
}


//MARK: - ValidScan result from RoomPlan or not!
extension CapturedRoom {
    var isValidScan: Bool {
        !walls.isEmpty && !doors.isEmpty && !objects.isEmpty && !windows.isEmpty && !openings.isEmpty
    }

}

//MARK: - Objects of Room Model
extension CapturedRoom.Object.Category: CaseIterable {

    public static var allCases: [CapturedRoom.Object.Category] {
        [
            .storage,
            .refrigerator,
            .stove,
            .bed,
            .sink,
            .washerDryer,
            .toilet,
            .bathtub,
            .oven,
            .dishwasher,
            .table,
            .sofa,
            .chair,
            .fireplace,
            .television,
            .stairs,
        ]
    }

    public var detail: String {
        "\(self)"
    }

}
