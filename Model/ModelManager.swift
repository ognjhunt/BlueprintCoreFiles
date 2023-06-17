//
//  ModelManager.swift
//  DecorateYourRoom
//
//  Created by Neil Mathew on 10/13/19.
//  Copyright © 2019 Placenote. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

// Struct to hold the model data
struct ModelInfo {
    public var modelType: Int = 0
    public var modelPosition: SCNVector3 = SCNVector3(0,0,0)
    public var modelRotation: SCNVector4 = SCNVector4(0,0,0,0)
}

    //let viewController = ViewController()


// Main model manager class.
class ModelManager {
    
    // to hold the scene details
    private var sceneView: ARSCNView!
    
    // arrays to hold the model data
    private var modelInfoArray: [ModelInfo] = []
    private var modelNodeArray: [SCNNode] = []
    
    // variable that holds a static list of model paths
    private var modelNames: [String] = ["Chess/Chess Set.scn",
                                        "Smart TV/Smart TV.scn",
                                        "Guitar PBR/Guitar PBR.scn",
                                        "Ukelele/Ukelele.scn",
                                        "Armchair/Armchair.scn",
                                        "Dice/Dice.scn",
                                        "Deer/Deer.scn",
                                        "Barn Owl/Barn Owl.scn",
                                        "Clock/Black Wall Clock/Black Wall Clock.scn",
                                        "Coke/Coke.scn",
                                        "Monkeys/Monkeys.scn",
                                        "Achilles/Achilles.scn",
                                       // "Mona Lisa/Mona Lisa.scn",
                                        "Toilet Paper/Toilet Paper.scn",
                                        "Parrots/Parrots.scn",
                                        "Pharaoh Head/Pharaoh Head.scn",
                                        "Rum Barrels/Rum Barrels.scn",
                                        "Grand Piano/Grand Piano.scn",
//                                        
//                                        
//                                        
//                                        
//                                        "Furniture//",
//                                        "TV/Samsung.scn",
//                                        
//                                        "Furniture//",
//                                        "Furniture//",
//                                       
//                                        
//                                        "Furniture//",
//                                        "Music/Piano/Piano.scn",
//                                        "Furniture//",
//                                        "Furniture//",
//                                        "Calendar/Calendar.scn",
//                                        "Ship in Bottle/Ship in Bottle.scn",
//                                        "Sculptures//",
//                                        "Vintage Suitcase/Vintage Suitcase.scn",
//                                        "Sculptures//",
//                                        "Sculptures//",
//                                        "Sculptures//",
//                                        "Coke/",
//                                        "Furniture//",
//                                        "Mona Lisa/Mona Lisa.scn",
//                                        "Music/Carpenter Piano/Carpenter Piano.scn",
//                                        "Music/Grand Piano/Grand Piano.scn",
//                                        "Music/Upright Piano/Upright Piano.scn",
//                                        "Music/Synth/Synth.scn",
                                        "Frame/Black Frames/Black Frames.scn",
//                                        "Frame/Blank Frame/Blank Frame.scn",
//                                        "Frame/England Frame/England Frame.scn",
                                        "Frame/Venice Frame/Venice Frame.scn",
//                                        "Frame/White Frame/White Frame.scn",
//                                        "Frame/Wooden Frame/Wooden Frame.scn",
//                                        "Clock/Black Wall Clock/Black Wall Clock.scn",
//                                        "Clock/Silver Wall Clock/Silver Wall Clock.scn",
//                                        "Clock/Wooden Clock/Wooden Clock.scn",
//                                        "Globe/Cradle Globe/Cradle Globe.scn",
//                                        "Globe/Simplistic Globe/Simplistic Globe.scn",
//                                        "Globe/Vintage Globe/Vintage Globe.scn",
//                                        "Bookshelf/Old Bookshelf/Old Bookshelf.scn",
//                                        "Laptop/Laptop.scn",
//                                        "Macbook Pro/MacBook Pro.scn",
//                                        "Monitor/Monitor.scn",
//                                        "Food/Double Big Tasty.scn"
    ]
    
    
    // constructor that sets the scene
    init() {
    }
    
    var shouldUpdateAnchor = false
    
    public func setScene (view: ARSCNView) {
        sceneView = view
    }
    
    //add model to plane/mesh where reticle currently is, return the reticles global position
    public func addModelAtPose (pos: SCNVector3, rot: SCNVector4, index: Int) {
        
        // turn the scn file into a node
        let node = getModel(modelIndex: index)
        
        node.position = pos
        if objectName == "Empire State Building"  {
            node.scale = SCNVector3(x:0.08, y:0.08, z:0.08)
        } else if objectName == "Penn Tennis Ball" {//|| objectName == "Wayfair Malibu Sofa"{
             node.scale = SCNVector3(x:0.4, y:0.4, z:0.4)
        } else if objectName == "Kodak Camera" {
             node.scale = SCNVector3(x:0.16, y:0.16, z:0.16)
        }
        else {
        node.scale = SCNVector3(x:0.8, y:0.8, z:0.8)
            }
        
        // not using the rotation actually. Instead we are setting the rotation to look at the camera
        let targetLookPos = SCNVector3(x: (sceneView?.pointOfView!.position.x)!, y: node.position.y, z: (sceneView.pointOfView?.position.z)!)
        node.look(at: targetLookPos)
        
//        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
//        node.physicsBody = physicsBody
       // node.shouldUpdateAnchor = true
        
        
        // add node to the scene
        sceneView.scene.rootNode.addChildNode(node)
        
//        if virtualObject.shouldUpdateAnchor {
//            virtualObject.shouldUpdateAnchor = false
//            self.updateQueue.async {
//               self.sceneView.addOrUpdateAnchor(for: virtualObject)
//            }
//        }
        
        // add node the storage data structures
        let newModel: ModelInfo = ModelInfo(modelType: index, modelPosition: node.position, modelRotation: node.rotation)
        
        // add model to model list and model node list
        modelInfoArray.append(newModel)
        modelNodeArray.append(node)
//        viewController.progressBar.setProgress(0, animated: false)

    }
    
//    func asyncLoadModel(){
//        let fileNames = SCNScene(named: "art.scnassets/" + modelNames[modelIndex])
//      //  let filename = self.name + "scn"
//        
//    }
    
    var objectName = ""
    
    // turn the scn file into a node
    func getModel (modelIndex: Int) -> SCNNode {
        let fileNodes = SCNScene(named: "art.scnassets/" + modelNames[modelIndex])
        let node = SCNNode()
        for child in (fileNodes?.rootNode.childNodes)! {
            node.addChildNode(child)
            objectName = child.name ?? ""
            
           // viewController.searchBar.resignFirstResponder()
        }
        print ("created model from " + modelNames[modelIndex])
        return node
    }
    
    // turn the model array into a json object
    func getModelInfoJSON() -> [[String: [String: String]]]
    {
        var modelInfoJSON: [[String: [String: String]]] = []
        
        if (modelInfoArray.count > 0)
        {
            for i in 0...(modelInfoArray.count-1)
            {
                modelInfoJSON.append(["model": ["type": "\(modelInfoArray[i].modelType)", "px": "\(modelInfoArray[i].modelPosition.x)",  "py": "\(modelInfoArray[i].modelPosition.y)",  "pz": "\(modelInfoArray[i].modelPosition.z)", "qx": "\(modelInfoArray[i].modelRotation.x)", "qy": "\(modelInfoArray[i].modelRotation.y)", "qz": "\(modelInfoArray[i].modelRotation.z)", "qw": "\(modelInfoArray[i].modelRotation.w)" ]])
            }
        }
        return modelInfoJSON
    }
    
  
    

    // Load shape array
    func loadModelArray(modelArray: [[String: [String: String]]]?) -> Bool {

        clearModels()
        
        if (modelArray == nil) {
            print ("Model Manager: No models in this map")
            return false
        }

        for item in modelArray! {
            let px_string: String = item["model"]!["px"]!
            let py_string: String = item["model"]!["py"]!
            let pz_string: String = item["model"]!["pz"]!
            
            let qx_string: String = item["model"]!["qx"]!
            let qy_string: String = item["model"]!["qy"]!
            let qz_string: String = item["model"]!["qz"]!
            let qw_string: String = item["model"]!["qw"]!
            
            let position: SCNVector3 = SCNVector3(x: Float(px_string)!, y: Float(py_string)!, z: Float(pz_string)!)
            let rotation: SCNVector4 = SCNVector4(x: Float(qx_string)!, y: Float(qy_string)!, z: Float(qz_string)!, w: Float(qw_string)!)
            let type: Int = Int(item["model"]!["type"]!)!
            
            addModelAtPose(pos: position, rot: rotation, index: type)

            print ("Model Manager: Retrieved " + String(describing: type) + " type at position" + String (describing: position))
        }

        print ("Model Manager: retrieved " + String(modelInfoArray.count) + " models")
        return true
    }
    
    //clear shapes from scene
    func clearView() {
        for node in modelNodeArray {
            node.removeFromParentNode()
        }
    }
    
    // delete all models from scene and model lists
    func clearModels() {
        clearView()
        modelNodeArray.removeAll()
        modelInfoArray.removeAll()
        
    }
    
}
