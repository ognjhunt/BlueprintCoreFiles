//
//  LaunchViewController+CoachingOverlay.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 5/27/21.
//  Copyright © 2021 Placenote. All rights reserved.
//

import UIKit
import ARKit

extension BlueprintViewController: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        hideMeshButton.isHidden = true
//        resetButton.isHidden = true
//        planeDetectionButton.isHidden = true
    }

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        hideMeshButton.isHidden = false
//        resetButton.isHidden = false
//        planeDetectionButton.isHidden = false
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
     //   resetButtonPressed(self)
    }

    func setupCoachingOverlay() {
        // Set up coaching view
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
    }
    
    //    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
    //
    //        messageLabel.ignoreMessages = true
    //        messageLabel.isHidden = true
    //
    //        // Disables user interaction when the coaching overlay activates.
    //        view.isUserInteractionEnabled = false
    //
    //        // Stops editing of sticky notes if any are being edited when the coaching overlay activates.
    //        for stickyNote in stickyNotes where stickyNote.isEditing {
    //            stickyNote.shouldAnimate = true
    //            stickyNote.isEditing = false
    //            guard let stickyView = stickyNote.view else { return }
    //            stickyView.textView.dismissKeyboard()
    //        }
    //    }
    //
    //    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
    //
    //        messageLabel.ignoreMessages = false
    //
    //        // Re-enables user interaction once the coaching overlay deactivates.
    //        view.isUserInteractionEnabled = true
    //    }
}
