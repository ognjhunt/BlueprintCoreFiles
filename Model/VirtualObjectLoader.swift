/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A type which loads and tracks virtual objects.
*/

import Foundation
import ARKit

/**
 Loads multiple `VirtualObject`s on a background queue to be able to display the
 objects quickly once they are needed.
*/
class VirtualObjectLoader {
    private(set) var loadedObjects = [VirtualObject]()
    private(set) var remoteObject = [VirtualObject]()
    
    private(set) var isLoading = false
    
    var tv = VirtualObject()
    var computer = VirtualObject()
    var remote = VirtualObject()
    
    var tvIsHere: Bool? = false
    var computerIsHere: Bool? = false
    var remoteIsHere: Bool? = false
    
    // MARK: - Loading object

    /**
     Loads a `VirtualObject` on a background queue. `loadedHandler` is invoked
     on a background queue once `object` has been loaded.
    */
    func loadVirtualObject(_ object: VirtualObject, loadedHandler: @escaping (VirtualObject) -> Void) {
        isLoading = true
        loadedObjects.append(object)
        if object.modelName == "TV1" {
            tv = object
            tvIsHere = true
        }
        if object.modelName == "Samsung" {
            tv = object
            tvIsHere = true
        }
        if object.modelName == "Laptop" {
            computer = object
            computerIsHere = true
        }
        if object.modelName == "remote1" {
            tv = object
            remoteIsHere = true
        }
        
        // Load the content into the reference node.
        DispatchQueue.global(qos: .userInitiated).async {
            object.load()
            self.isLoading = false
            loadedHandler(object)
        }
    }
    
    func loadComputer(_ object: VirtualObject, loadedHandler: @escaping (VirtualObject) -> Void){
        isLoading = true
        loadedObjects.append(object)
        DispatchQueue.global(qos: .userInitiated).async {
            object.load()
            self.isLoading = false
            loadedHandler(object)
        }
    }
    
    func loadTV(_ object: VirtualObject, loadedHandler: @escaping (VirtualObject) -> Void){
        if object.modelName == "TV1"{
            isLoading = true
            loadedObjects.append(object)
            DispatchQueue.global(qos: .userInitiated).async {
                object.load()
                self.isLoading = false
                loadedHandler(object)
            }
        }
           
       }
    
    func loadTablet(_ object: VirtualObject, loadedHandler: @escaping (VirtualObject) -> Void){
           isLoading = true
           loadedObjects.append(object)
           DispatchQueue.global(qos: .userInitiated).async {
               object.load()
               self.isLoading = false
               loadedHandler(object)
           }
       }
    
    
    // MARK: - Removing Objects
    
    func removeAllVirtualObjects() {
        // Reverse the indices so we don't trample over indices as objects are removed.
        for index in loadedObjects.indices.reversed() {
            removeVirtualObject(at: index)
            remoteIsHere = true
            computerIsHere = true
            tvIsHere = true
        }
    }

    /// - Tag: RemoveVirtualObject
    func removeVirtualObject(at index: Int) {
        guard loadedObjects.indices.contains(index) else { return }
        
        // Stop the object's tracked ray cast.
        loadedObjects[index].stopTrackedRaycast()
        
        // Remove the visual node from the scene graph.
        loadedObjects[index].removeFromParentNode()
        // Recoup resources allocated by the object.
        loadedObjects[index].unload()
        loadedObjects.remove(at: index)
    }
}
