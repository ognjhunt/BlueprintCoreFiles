//
//  ViewController.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 9/11/22.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
//        
//        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
    }
}
