//
//  ScenePersistenceHelper.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 10/11/21.
//  Copyright © 2021 Placenote. All rights reserved.
//

import Foundation
import RealityKit
import ARKit

class ScenePersistenceHelper {
    
//    class func saveScene(for arView: CustomARView, at persistenceUrl: URL) {
//        print("Save scene to local file system.")
//
//        //1. Get current worldMap
//        arView.session.getCurrentWorldMap { worldMap, error in
//            //2. Safely unwrap worldMap
//            guard let map = worldMap else {
//                print("Persistence error: unable to get current worldMap: \(error?.localizedDescription)")
//                return
//            }
//
//            //3. Archive data and write to filesystem
//            do {
//                let sceneData = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
//                try sceneData.write(to: persistenceUrl, options: [.atomic])
//            } catch {
//                print("Persistence error: Cant save scene to local filesystem: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    class func loadScene(for arView: CustomARView, with scenePersistenceData: Data) {
//        print("Load scene from local file system.")
//
//        //1. unarchive the scenePersistenceData and retrieve WorldMap
//        let worldMap : ARWorldMap = {
//            do {
//                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: scenePersistenceData) else {
//                    fatalError("Persistence Error: No ARWOrldMap in archive")
//                }
//
//                return worldMap
//            } catch {
//                fatalError("Persistence error: uable to unarchive ARworldmap from scenePersistenceData: \(error.localizedDescription)")
//            }
//        }()
//        let vc = LaunchViewController()
//        let newConfig = vc.defaultConfiguration
//        newConfig.initialWorldMap = worldMap
//        arView.session.run(newConfig, options: [.resetTracking, .removeExistingAnchors])
//    }
    
    
    class func saveScene (for arView: CustomARView, at persistenceURL: URL) {
        print("DEBUG: Saved scene")
        arView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else {
                return
            }
            do {
                let sceneData = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try sceneData.write(to: persistenceURL, options: [.atomic])
            } catch {
                print("DEBUG: Error saving the scene to disk")
            }
        }
    }
    
    class func loadScene (for arView: CustomARView, on scenePersistenceData: Data) {
        print("DEBUG: Load scene")
        let worldMap: ARWorldMap = {
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: scenePersistenceData)
                else {
                    fatalError("Persistence Error: No ARWorldMap in archive")
                }
                return worldMap
            } catch {
                fatalError("Persistence Error: No ARWorldMap in Archive #2")
            }
        }()
        let vc = LaunchViewController()
        let newConfig = vc.defaultConfiguration
        newConfig.initialWorldMap = worldMap
        arView.session.run(newConfig, options: [.resetTracking, .removeExistingAnchors])
    }
}
