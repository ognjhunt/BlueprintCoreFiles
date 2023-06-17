////
////  RealityKitARRoomModelViewController.swift
////  Indoor Blueprint
////
////  Created by Nijel Hunt on 5/19/23.
////
//
//import UIKit
//import ARKit
//import RealityKit
//import RoomPlan
//
//class RealityKitARRoomModelView: UIViewController, ARSessionDelegate {
//
//    @IBOutlet weak var arView: ARView!
//
//    var capturedRoom: CapturedRoom?
//    var modelURL: URL!
//    var modelEntity: ModelEntity?
//
//    var defaultConfiguration: ARWorldTrackingConfiguration {
//        let configuration = ARWorldTrackingConfiguration()
//        return configuration
//    }
//
////    private var spaceEntity: ModelEntity? {
////        arView.scene.anchors.first { $0 is spaceEntity }
////    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set AR session delegate
//        arView.session.delegate = self
//
//        // ARKit config
//        let configuration = ARWorldTrackingConfiguration()
//        arView.session.run(configuration)
//
//        // Render roomplan .usdz model
//        let group = DispatchGroup()
//
//        // Enter the dispatch group before starting the async task
//        group.enter()
//        let request = ModelEntity.loadModelAsync(contentsOf: self.modelURL)
//
//        request.sink { completion in
//            switch completion {
//            case .failure(let error):
//                print("Unable to load modelEntity. Error: \(error.localizedDescription)")
//             //   ProgressHUD.dismiss()
//            case .finished:
//                break
//            }
//            // Leave the dispatch group after finishing the async task
//            group.leave()
//        } receiveValue: { modelEntity in
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                self.modelEntity = modelEntity
//                // Add the model entity to the scene
////                self.arView.scene.anchors.append(contentsOf: modelEntity)
//
//                self.addFloor()
//                self.addCelling()
//
//                self.occlusionForWindowsAndDoors()
//
//                self.arView.installGestures([.translation, .rotation, .scale], for: self.modelEntity!)
//                let anchor =  self.focusEntity?.anchor //AnchorEntity(plane: .any)// // AnchorEntity(world: [0,-0.2,0])
//                print(anchor)
//                // anchor?.scale = [1.2,1.0,1.0]
//                anchor?.addChild(self.modelEntity)
////                let scale = model?.scale
////                print("\(scale) is scale")
////                self.modelEntity.scale = [Float(scale ?? 0.01), Float(scale ?? 0.01), Float(scale ?? 0.01)]
//                self.arView.scene.addAnchor(anchor!)
//          //      ProgressHUD.dismiss()
//            }
//        }
//
//        // Wait for the completion of the async task
//        group.wait()
//
//    }
//
//    // Add floor plane entity
//    func addFloor() {
////        guard let spaceEntity = arView.scene.anchors.compactMap({ $0 as? modelEntity }).first else {
////            print("No space entity found")
////            return
////        }
//
//        guard let spaceEntity = modelEntity else {
//            print("No space node found")
//            return
//        }
//
//        var hasFloor = false
//        spaceEntity.children.forEach { child in
//            if child.name == "Floor" {
//                hasFloor = true
//                child.removeFromParent()
//                return
//            }
//        }
//
//        if hasFloor { return }
//
//        let boundingBox = spaceEntity.visualBounds(relativeTo: nil)
//        let floorHeight: Float = 0.001
//        let boxOffset: Float = 0.001 // make sides hang off the wall
//        let boxWidth = (boundingBox.max.x - boundingBox.min.x) + (boxOffset * 2)
//        let boxLength = (boundingBox.max.z - boundingBox.min.z) + (boxOffset * 2)
//
//        let boxMesh = MeshResource.generateBox(size: SIMD3<Float>(boxWidth, floorHeight, boxLength))
//        let boxMaterial = SimpleMaterial(color: .white, isMetallic: false)
//
//        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
//        boxEntity.name = "Floor"
//        boxEntity.position = SIMD3<Float>(
//            boundingBox.min.x + (boxWidth / 2.0) - boxOffset,
//            boundingBox.min.y - floorHeight,
//            boundingBox.min.z + (boxLength / 2.0) - boxOffset
//        )
//
//        spaceEntity.addChild(boxEntity)
//    }
//
//    // Add ceiling plane entity
//    func addCelling() {
////        guard let spaceEntity = arView.scene.anchors.compactMap({ $0 as? modelEntity }).first else {
////            print("No space entity found")
////            return
////        }
//        guard let spaceEntity = self.modelEntity else {
//            print("No space node found")
//            return
//        }
//
//        var hasCeiling = false
//        spaceEntity.children.forEach { child in
//            if child.name == "Ceiling" {
//                hasCeiling = true
//                child.removeFromParent()
//                return
//            }
//        }
//
//        if hasCeiling { return }
//
//        let boundingBox = spaceEntity.visualBounds(relativeTo: nil)
//        let ceilingHeight: Float = 0.001
//        let boxOffset: Float = 0.001 // make sides hang off the wall
//        let boxWidth = (boundingBox.max.x - boundingBox.min.x) + (boxOffset * 2)
//        let boxLength = (boundingBox.max.z - boundingBox.min.z) + (boxOffset * 2)
//
//        let boxMesh = MeshResource.generateBox(size: SIMD3<Float>(boxWidth, ceilingHeight, boxLength))
//        let boxMaterial = SimpleMaterial(color: .white, isMetallic: false)
//
//        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
//        boxEntity.name = "Ceiling"
//        boxEntity.position = SIMD3<Float>(
//            boundingBox.min.x + (boxWidth / 2.0) - boxOffset,
//            boundingBox.max.y + ceilingHeight,
//            boundingBox.min.z + (boxLength / 2.0) - boxOffset
//        )
//
//        spaceEntity.addChild(boxEntity)
//    }
//    
//    // Decorate RoomPlan entities
//    // Decorate RoomPlan nodes/object
//    func decorateScene(_ entity: Entity) {
//        entity.children.forEach { child in
//            if let modelComponent = child.components[ModelComponent.self] {
//                switch child.name {
//                case "door":
//                    modelComponent.material = [SimpleMaterial(color: UIColor.green.withAlphaComponent(0.75), isMetallic: false)]
//                case "floor":
//                    print("Position before rotation:", child.position(relativeTo: entity), "pivot: ", child.anchor?.position)
//                    modelComponent.materials = [SimpleMaterial(color: UIColor.yellow.withAlphaComponent(0.5), isMetallic: false)]
//                case "ceiling":
//                    modelComponent.materials = [SimpleMaterial(color: UIColor.white, isMetallic: false, roughness: 0.5)]
//                case "furniture":
//                    modelComponent.materials = [SimpleMaterial(color: UIColor(red: 75/255, green: 145/255, blue: 250/255, alpha: 0.85), isMetallic: false)]
//                case "wall":
//                    modelComponent.materials = [SimpleMaterial(color: UIColor.clear.withAlphaComponent(0.70), isMetallic: false)]
//                case "opening", "window":
//                    modelComponent.materials = [SimpleMaterial(color: UIColor.red.withAlphaComponent(0.75), isMetallic: false)]
//                default:
//                    break
//                }
//            }
//            decorateScene(child)
//        }
//    }
//
////    // Decorate RoomPlan entities/objects
////    func decorateScene(_ modelEntity: ModelEntity) {
////
////
////        modelEntity.children.forEach { child in
////            if let meshComponent = child.components[ModelComponent] as? ModelComponent,
////               let material = meshComponent.materials.first {
////                switch child.type {
////                case .door:
////                    material.baseColor = .green.withAlphaComponent(0.75)
////                case .floor:
////                    material.baseColor = .texture(.init(named: "wildtextures_mossed-tree-bark-seamless-2k-texture"))
////                case .ceiling:
////                    material.baseColor = .texture(.init(named: "sistineimg"))
////                case .furniture:
////                    material.baseColor = UIColor(red: 75/255, green: 145/255, blue: 250/255, alpha: 0.0)
////                case .wall:
////                    // You can modify the wall material properties here
////                    break
////                case .opening, .window:
////                    material.baseColor = .red.withAlphaComponent(0.75)
////                }
////            }
////
////            // Recursively decorate children
////            decorateScene(child)
////        }
////    }
//
//
//
//    // Apply occlusion material to windows and doors
//    func occlusionForWindowsAndDoors() {
//        guard let spaceEntity = arView.scene.anchors.compactMap({ $0 as? spaceEntity }).first else {
//            return
//        }
//
//        spaceEntity.traverse { node in
//            if node.type == .window || node.type == .door {
//                let material = OcclusionMaterial()
//                node.model?.materials = [material]
//            }
//        }
//    }
//
//    // MARK: - ARSessionDelegate
//
//    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//        decorateScene()
//    }
//}
//
//// MARK: - RoomPlan 3D model entity classifications
//extension ModelEntity {
////    enum EntityType: String {
////        case wall
////        case door
////        case opening
////        case window
////        case furniture
////        case floor
////        case ceiling
////    }
//    
//
//    var type: EntityType? {
//        EntityType(name: name)
//    }
//    
//    enum EntityType: String, CaseIterable {
//        case wall
//        case door
//        case opening
//        case window
//        case furniture
//        case floor
//        case ceiling
//        
//        init?(name: String?) {
//            guard let name = name?.lowercased() else { return nil }
//            if let type = EntityType.allCases.first(where: { name.starts(with: $0.rawValue) }) {
//                self = type
//                return
//            }
//            
//            let furnitureTypes = CapturedRoom.Object.Category.allCases.map(\.detail)
//            if furnitureTypes.contains(where: { name.starts(with: $0) }) {
//                self = .furniture
//                return
//            }
//            return nil
//        }
//    }
//}
//
////MARK: - ValidScan result from RoomPlan or not!
//extension CapturedRoom {
//    var isValidScan: Bool {
//        !walls.isEmpty && !doors.isEmpty && !objects.isEmpty && !windows.isEmpty && !openings.isEmpty
//    }
//    
//}
//
////MARK: - Objects of Room Model
//extension CapturedRoom.Object.Category: CaseIterable {
//    
//    public static var allCases: [CapturedRoom.Object.Category] {
//        [
//            .storage,
//            .refrigerator,
//            .stove,
//            .bed,
//            .sink,
//            .washerDryer,
//            .toilet,
//            .bathtub,
//            .oven,
//            .dishwasher,
//            .table,
//            .sofa,
//            .chair,
//            .fireplace,
//            .television,
//            .stairs,
//        ]
//    }
//    
//    public var detail: String {
//        "\(self)"
//    }
//    
//}
