/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Overlay UI additions to the app's main view controller.
*/

import UIKit
import ARKit

extension BlueprintViewController {
    
    // MARK: - Overlay UI layout constraints and setup
    
    func overlayUISetup() {
        
        // Setting up the shadeView, which is used to dim the camera feed when a user is editing a Sticky (helps to draw the user's focus).
        setupShadeView()
        
        // Setting up the trashZone, which is used to delete StickyViews and their associated StickyNotes.
        setupTrashZone()
        
        // Adding a Reset button, the user should always be able to reset the AR Experience at all times.
        addResetButton()
        
        // Adding the ARCoachingOverlayView, which helps guide users to establish tracking.
        addCoachingOverlay()
        
    }
    
    fileprivate func setupShadeView() {
        shadeView = UIView(frame: .zero)
        shadeView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(shadeView)
        NSLayoutConstraint.activate([
            shadeView.topAnchor.constraint(equalTo: sceneView.topAnchor),
            shadeView.leadingAnchor.constraint(equalTo: sceneView.leadingAnchor),
            shadeView.trailingAnchor.constraint(equalTo: sceneView.trailingAnchor),
            shadeView.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor)
        ])
        shadeView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        shadeView.alpha = 0
    }
    
    fileprivate func setupTrashZone() {
        trashZone = GradientView(topColor: UIColor.red.withAlphaComponent(0.7).cgColor, bottomColor: UIColor.red.withAlphaComponent(0).cgColor)
        trashZone.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(trashZone)
        NSLayoutConstraint.activate([
            trashZone.topAnchor.constraint(equalTo: sceneView.topAnchor),
            trashZone.leadingAnchor.constraint(equalTo: sceneView.leadingAnchor),
            trashZone.trailingAnchor.constraint(equalTo: sceneView.trailingAnchor),
            trashZone.heightAnchor.constraint(equalTo: sceneView.heightAnchor, multiplier: 0.33)
        ])
        trashZone.alpha = 0
        addDeleteLabel()
    }
    
    fileprivate func addDeleteLabel() {
        // Adding a Delete label to the trashZone for clarity
        let deleteLabel = UILabel()
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        trashZone.addSubview(deleteLabel)
        NSLayoutConstraint.activate([
            deleteLabel.topAnchor.constraint(equalTo: trashZone.safeAreaLayoutGuide.topAnchor, constant: 5),
            deleteLabel.centerXAnchor.constraint(equalTo: trashZone.centerXAnchor)
        ])
        deleteLabel.text = "Delete"
        deleteLabel.textColor = .white
    }
    
    fileprivate func addResetButton() {
        let resetButton = UIButton()
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: sceneView.safeAreaLayoutGuide.bottomAnchor),
            resetButton.trailingAnchor.constraint(equalTo: sceneView.trailingAnchor, constant: -25)
        ])
        resetButton.setImage(UIImage(imageLiteralResourceName: "restart"), for: .normal)
        resetButton.addTarget(self, action: #selector(tappedReset(_:)), for: .touchUpInside)
        resetButton.showsTouchWhenHighlighted = true
        resetButton.alpha = 0.7
    }
    
    fileprivate func addCoachingOverlay() {
        let coachingOverlay = ARCoachingOverlayView(frame: sceneView.frame)
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: sceneView.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: sceneView.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: sceneView.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor)
        ])
        coachingOverlay.goal = .tracking
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
    }
    
}
