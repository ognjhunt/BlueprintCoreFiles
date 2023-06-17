//
//  CustomARView.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 5/30/21.
//  Copyright © 2021 Placenote. All rights reserved.
//

import RealityKit
import ARKit
import FocusEntity

class CustomARView: ARView {
    var focusEntity: FocusEntity?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        focusEntity = FocusEntity(on: self, focus: .classic)
        
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        session.run(config)
    }
}
