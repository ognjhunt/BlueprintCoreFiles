/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Gesture additions to the app's main view controller.
*/

import UIKit
import ARKit
import RealityKit

extension BlueprintViewController {
    
    
    // MARK: - Gesture recognizer setup
    // - Tag: AddViewTapGesture
    func arViewGestureSetup() {
        wordsTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnARView))
        sceneView.addGestureRecognizer(wordsTapGesture)
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedDownOnARView))
        swipeGesture.direction = .down
        sceneView.addGestureRecognizer(swipeGesture)
    }
    
    func stickyNoteGestureSetup(_ note: StickyNoteEntity) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnStickyView))
        note.view?.addGestureRecognizer(panGesture)
        
        let tapOnStickyView = UITapGestureRecognizer(target: self, action: #selector(tappedOnStickyView(_:)))
        note.view?.addGestureRecognizer(tapOnStickyView)
    }
    
    // MARK: - Gesture recognizer callbacks
    
    /// Tap gesture input handler.
    /// - Tag: TapHandler
    @objc
    func tappedOnARView(_ sender: UITapGestureRecognizer) {
        
        // Ignore the tap if the user is editing a sticky note.
        for note in stickyNotes where note.isEditing { return }
        
        // Create a new sticky note at the tap location.
        insertNewSticky(sender)
    }
    
    /**
    Hit test the feature point cloud and use any hit as the position of a new StickyNote. Otherwise, display a tip.
     - Tag: ScreenSpaceViewInsertionTag
     */
    fileprivate func insertNewSticky(_ sender: UITapGestureRecognizer) {

        // Get the user's tap screen location.
        let touchLocation = sender.location(in: sceneView)
        
        // Cast a ray to check for its intersection with any planes.
        guard let raycastResult = sceneView.raycast(from: touchLocation, allowing: .estimatedPlane, alignment: .any).first else {
            print("No surface detected, try getting closer.")
            return
        }
        
        // Create a new sticky note positioned at the hit test result's world position.
        let frame = CGRect(origin: touchLocation, size: CGSize(width: 240, height: 130))
        
        let note = StickyNoteEntity(frame: frame, worldTransform: raycastResult.worldTransform)
        
        let anchor = AnchorEntity(plane: .any)
        let profileImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 35, height: 35))
//        profileImage.topAnchor.constraint(equalTo: note.view!.topAnchor).isActive = true
//         profileImage.leadingAnchor.constraint(equalTo: note.view!.leadingAnchor).isActive = true
//         profileImage.trailingAnchor.constraint(equalTo: note.view!.trailingAnchor).isActive = true
//         profileImage.bottomAnchor.constraint(equalTo: note.view!.bottomAnchor).isActive = true
        profileImage.alpha = 0.9
//         profileImage.frame.size.width = 40
//         profileImage.frame.size.height = 40
        profileImage.layer.cornerRadius = 17.5
         profileImage.clipsToBounds = true
         profileImage.image = UIImage(named: "Kobe")

        // blurView.addSubview(profileImage)
        //note.anchor = true
        // Center the sticky note's view on the tap's screen location.
        note.setPositionCenter(touchLocation)
        note.view?.addSubview(profileImage)
        note.view?.layer.shadowRadius = 5
        note.view?.layer.shadowOpacity = 0.95
        note.view?.layer.shadowColor = UIColor.black.cgColor
        //note.view?.layer.cornerRadius = 5
        note.view?.layer.masksToBounds = false
        note.view?.layer.shadowOffset = CGSize(width: 1, height: 11.0)
       // note.c
       // anchor.addChild(note)
        // Add the sticky note to the scene's entity hierarchy.
       // anchor.scale = [0.25,0.25,0.25]
      //  note.scale = [0.25,0.25,0.25]
        sceneView.scene.addAnchor(note)
       // self.sceneView.scene.addAnchor(anchor)

        // Add the sticky note's view to the view hierarchy.
        guard let stickyView = note.view else { return }
       // stickyView.backgroundColor = .white
     //   stickyView.textView.backgroundColor = .white
        stickyView.alpha = 0.8
      //  stickyView.tintColor = .blue
     //   stickyView.textView.tintColor = .red
        //stickyView.textView.
      //  stickyView.backgroundColor = .orange
       // stickyView.textView.textColor = .black
        sceneView.insertSubview(stickyView, belowSubview: trashZone)
        
        // Enable gestures on the sticky note.
        stickyNoteGestureSetup(note)

        // Save a reference to the sticky note.
        stickyNotes.append(note)
        
        // Volunteer to handle text view callbacks.
    //    stickyView.textView.delegate = self
        
        
    }

    /// Dismisses the keyboard.
    @objc
    func swipedDownOnARView(_ sender: UISwipeGestureRecognizer) {
        dismissStickyKeyboard()
    }
    
    fileprivate func dismissStickyKeyboard() {
        for note in stickyNotes {
            guard let textView = note.view?.textView else { continue }
            if textView.isFirstResponder {
                textView.resignFirstResponder()
                return
            }
        }
    }
    
    @objc
    func tappedOnStickyView(_ sender: UITapGestureRecognizer) {
        guard let stickyView = sender.view as? StickyNoteView else { return }
        stickyView.textView.becomeFirstResponder()
    }
    
    //- Tag: PanOnStickyView
    fileprivate func panStickyNote(_ sender: UIPanGestureRecognizer, _ stickyView: StickyNoteView, _ panLocation: CGPoint) {
        //messageLabel.isHidden = true
        
        let feedbackGenerator = UIImpactFeedbackGenerator()
        
        switch sender.state {
        case .began:
            // Prepare the taptic engine to reduce latency in delivering feedback.
            feedbackGenerator.prepare()
            
            // Drag if the gesture is beginning.
            stickyView.stickyNote.isDragging = true
            
            // Save offsets to implement smooth panning.
            guard let frame = sender.view?.frame else { return }
            stickyView.xOffset = panLocation.x - frame.origin.x
            stickyView.yOffset = panLocation.y - frame.origin.y
            
            // Fade in the widget that's used to delete sticky notes.
            trashZone.fadeIn(duration: 0.4)
        case .ended:
            // Stop dragging if the gesture is ending.
            stickyView.stickyNote.isDragging = false
            
            // Delete the sticky note if the gesture ended on the trash widget.
            if stickyView.isInTrashZone {
                deleteStickyNote(stickyView.stickyNote)
                // ...
            } else {
                attemptRepositioning(stickyView)
            }
            
            // Fades out the widget that's used to delete sticky notes when there are no sticky notes currently being dragged.
            if !stickyNotes.contains(where: { $0.isDragging }) {
                trashZone.fadeOut(duration: 0.2)
            }
        default:
            // Update the sticky note's screen position based on the pan location, and initial offset.
            stickyView.frame.origin.x = panLocation.x - stickyView.xOffset
            stickyView.frame.origin.y = panLocation.y - stickyView.yOffset
            
            // Give feedback whenever the pan location is near the widget used to delete sticky notes.
            trashZoneThresholdFeedback(sender, feedbackGenerator)
        }
    }
    
    /// Sticky note pan-gesture handler.
    /// - Tag: PanHandler
    @objc
    func panOnStickyView(_ sender: UIPanGestureRecognizer) {
        
        guard let stickyView = sender.view as? StickyNoteView else { return }
        
        let panLocation = sender.location(in: sceneView)
        
        // Ignore the pan if any StickyViews are being edited.
        for note in stickyNotes where note.isEditing { return }
        
        panStickyNote(sender, stickyView, panLocation)
    }
    
    func deleteStickyNote(_ note: StickyNoteEntity) {
        guard let index = stickyNotes.firstIndex(of: note) else { return }
        note.removeFromParent()
        stickyNotes.remove(at: index)
        note.view?.removeFromSuperview()
        note.view?.isInTrashZone = false
    }
    
    /// - Tag: AttemptRepositioning
    fileprivate func attemptRepositioning(_ stickyView: StickyNoteView) {
        // Conducts a ray-cast for feature points using the panned position of the StickyNoteView
        let point = CGPoint(x: stickyView.frame.midX, y: stickyView.frame.midY)
        if let result = sceneView.raycast(from: point, allowing: .estimatedPlane, alignment: .any).first {
            stickyView.stickyNote.transform.matrix = result.worldTransform
        } else {
            print("No surface detected, unable to reposition note.")
            stickyView.stickyNote.shouldAnimate = true
        }
    }
    
    fileprivate func trashZoneThresholdFeedback(_ sender: UIPanGestureRecognizer, _ feedbackGenerator: UIImpactFeedbackGenerator) {
        
        guard let stickyView = sender.view as? StickyNoteView else { return }
        
        let panLocation = sender.location(in: trashZone)
        
        if trashZone.frame.contains(panLocation), !stickyView.isInTrashZone {
            stickyView.isInTrashZone = true
            feedbackGenerator.impactOccurred()
            
        } else if !trashZone.frame.contains(panLocation), stickyView.isInTrashZone {
            stickyView.isInTrashZone = false
            feedbackGenerator.impactOccurred()
            
        }
    }
    
    @objc
    func tappedReset(_ sender: UIButton) {
        reset()
    }
    
}
