//
//  StorageManager.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 1/16/22.
//  Copyright © 2022 Placenote. All rights reserved.
//

import Foundation
import FirebaseStorage

public class StorageManager {
    
    enum BlueprintError: Error {
        case currentUserNotFound
        case uploadFailed
        case downloadFailed
    }

    
    static let fs = Storage.storage()
    
    static var photoAnchorRandomID = ""
    static var videoAnchorRandomID = ""
    static var thumbnailRandomID = ""
    static var blueprintID = ""
    
    //MARK: -- WRITE --
    public static func updateProfilePicture(withData data: Data, completion: @escaping (String?) -> Void ) {
        guard let currentUserUid = FirebaseAuthHelper.getCurrentUserUid() else {
            return completion(nil)
        }
        
        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("profileImages")
        let refUid = "\(currentUserUid)"
        let photoRef = ref.child(refUid)
        
        photoRef.putData(data, metadata: nil) {storageMetaData, err in
            if let err = err { print(err.localizedDescription); completion(nil); return }
            completion(refUid)
        }
    }
    
    public static func randomStorageString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
//    public static func uploadBlueprint(withData data: Data, completion: @escaping (String?) -> Void ) {
//        guard let currentUserUid = FirebaseAuthHelper.getCurrentUserUid() else {
//            return completion(nil)
//        }
//
//        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("blueprints")
//      //  let refUid = "\(currentUserUid)"
//        let randID = NSUUID().uuidString// self.randomStorageString(length: 30)
//        self.blueprintID = randID
//        let networkRef = ref.child(randID)
//
//        networkRef.putData(data, metadata: nil) {storageMetaData, err in
//            if let err = err { print(err.localizedDescription); completion(nil); return }
//            completion(randID)
//        }
//    }
    public static func uploadBlueprint(withData data: Data, name: String, completion: @escaping (String?) -> Void) {
      //  guard let currentUserUid = FirebaseAuthHelper.getCurrentUserUid() else {
            let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("blueprints")
            let randID = NSUUID().uuidString
            let blueprintID = "\(randID)-\(name).usdz"
            let networkRef = ref.child(blueprintID)

            let metadata = StorageMetadata()
            metadata.contentType = "model/vnd.usdz+zip"

            networkRef.putData(data, metadata: metadata) { storageMetaData, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                completion(blueprintID)
            }
//            return// completion(nil)
//        }
//
//        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("blueprints")
//        let randID = NSUUID().uuidString
//        let blueprintID = "\(randID)-\(name).usdz"
//        let networkRef = ref.child(blueprintID)
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "model/vnd.usdz+zip"
//
//        networkRef.putData(data, metadata: metadata) { storageMetaData, error in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(nil)
//                return
//            }
//
//            completion(blueprintID)
//        }
    }

    
    public static func uploadBlueprint(withFileURL fileURL: URL, completion: @escaping (String?) -> Void ) {
        guard let currentUserUid = FirebaseAuthHelper.getCurrentUserUid() else {
            return completion(nil)
        }

        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("blueprints")
      //  let refUid = "\(currentUserUid)"
        let randID = NSUUID().uuidString// self.randomStorageString(length: 30)
        self.blueprintID = randID
        let networkRef = ref.child(randID)
        
        do {
            let data = try Data(contentsOf: fileURL)

            networkRef.putData(data, metadata: nil) {storageMetaData, err in
                if let err = err { print(err.localizedDescription); completion(nil); return }
                completion(randID)
            }
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
    }


    
    public static func uploadThumbnail(withData data: Data, completion: @escaping (String?) -> Void ) {
        guard let currentUserUid = FirebaseAuthHelper.getCurrentUserUid() else {
            return completion(nil)
        }

        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("thumbnails")
        let randID = NSUUID().uuidString
        self.thumbnailRandomID = randID
        let photoRef = ref.child(randID)

        photoRef.putData(data, metadata: nil) { storageMetaData, error in
            if let error = error {
                print("Error uploading thumbnail:", error.localizedDescription)
                completion(nil)
                return
            }
            completion(randID)
        }
    }

    
//    public static func uploadThumbnail(withData data: Data, completion: @escaping (String?) -> Void ) {
//        guard let currentUserUid = FirebaseAuthHelper.getCurrentUserUid() else {
//            return completion(nil)
//        }
//
//        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("thumbnails")
//      //  let refUid = "\(currentUserUid)"
//        let randID = NSUUID().uuidString// self.randomStorageString(length: 30)
//        self.thumbnailRandomID = randID
//        let photoRef = ref.child(randID)
//
//        photoRef.putData(data, metadata: nil) {storageMetaData, err in
//            if let err = err { print(err.localizedDescription); completion(nil); return }
//            completion(randID)
//        }
//    }
    
    public static func uploadVideo(withData data: Data, completion: @escaping (String?) -> Void ) {
        guard let currentUserUid = FirebaseAuthHelper.getCurrentUserUid() else {
            return completion(nil)
        }

        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("videos")
      //  let refUid = "\(currentUserUid)"
        let randID = NSUUID().uuidString// self.randomStorageString(length: 30)
        self.videoAnchorRandomID = randID
        let photoRef = ref.child(randID)
        
        photoRef.putData(data, metadata: nil) {storageMetaData, err in
            if let err = err {
                print(err.localizedDescription)
                completion(nil)
                return
                
            }
            completion(randID)
        }
    }
    
   
    public static func deleteUserDirectory(_ userUid: String, completion: @escaping (Bool) -> Void) {
        
        let fileRef = fs.reference(withPath: userUid)
        
        fileRef.listAll { storageListResult, err in
            var count = 0
            for fileRef in storageListResult.items {
                print("Deleting \(fileRef.fullPath)")
                fileRef.delete { err in
                    if let err = err {
                        print("ERROR - deleteUserDirectory: \(err)")
                    }
                    completion(false)
                    
                    count += 1
                    if (count == storageListResult.items.count) {
                        return completion(true)
                    }
                }
            }
        }
    }
    
    
    // Create a cache for the images
    private static var profilePicCache = NSCache<NSString, UIImage>()
    
    public static func getProPic(_ userId: String, completion: @escaping (UIImage) -> Void) {
        profilePicCache.countLimit = 10
        profilePicCache.evictsObjectsWithDiscardedContent = true
        
        // Check if the image is in the cache
           if let cachedImage = profilePicCache.object(forKey: userId as NSString) {
               // Return the cached image
               return completion(cachedImage)
           }

           // Image is not in cache, fetch it from storage
           let defaultImage = UIImage(named: "nouser") ?? UIImage()
           let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("profileImages").child(userId)
           ref.getData(maxSize: 10000000) { (data, err) in
               if let err = err {
                   print("ERROR - getImage: \(err.localizedDescription)")
               }

               guard let data = data, let image = UIImage(data: data) else {
                   return completion(defaultImage)
               }

               // Add the image to the cache
               profilePicCache.setObject(image, forKey: userId as NSString)
               completion(image)
           }
        
    }
    

    
    // Create a cache for the images
    private static var imageCache = NSCache<NSString, UIImage>()
    //using a cache method
    public static func getModelThumbnail(_ thumbnailName: String, completion: @escaping (UIImage) -> Void) {
        
        imageCache.countLimit = 70
        imageCache.evictsObjectsWithDiscardedContent = true
        
        // Check if the image is in the cache
        if let cachedImage = imageCache.object(forKey: thumbnailName as NSString) {
            // Return the cached image
            return completion(cachedImage)
        }

        
        
        // Image is not in cache, fetch it from storage
        let defaultImage = UIImage(named: "nouser") ?? UIImage()
        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("thumbnails").child(thumbnailName)
        ref.getData(maxSize: 10000000) { (data, err) in
            if let err = err {
                print("ERROR - getImage: \(err.localizedDescription)")
            }

            guard let data = data, let image = UIImage(data: data) else {
                return completion(defaultImage)
            }

            // Add the image to the cache
            imageCache.setObject(image, forKey: thumbnailName as NSString)
            completion(image)
        }
    }
    
    public static func getTextureThumbnail(_ thumbnailName: String, completion: @escaping (UIImage) -> Void) {
        
        imageCache.countLimit = 70
        imageCache.evictsObjectsWithDiscardedContent = true
        
        // Check if the image is in the cache
        if let cachedImage = imageCache.object(forKey: thumbnailName as NSString) {
            // Return the cached image
            return completion(cachedImage)
        }

        
        
        // Image is not in cache, fetch it from storage
        let defaultImage = UIImage(named: "nouser") ?? UIImage()
        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("textureImages").child(thumbnailName)
        ref.getData(maxSize: 100000000) { (data, err) in
            if let err = err {
                print("ERROR - getImage: \(err.localizedDescription)")
            }

            guard let data = data, let image = UIImage(data: data) else {
                return completion(defaultImage)
            }

            // Add the image to the cache
            imageCache.setObject(image, forKey: thumbnailName as NSString)
            completion(image)
        }
    }


    
//    public static func getModelThumbnail(_ thumbnailName: String, completion: @escaping (UIImage) -> Void) {
//
//        let defaultImage = UIImage(named: "nouser") ?? UIImage()
//
//        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("thumbnails").child(thumbnailName)
//
//      //  let storagePath = "\(userUid)/profileImage"
//     //   fs.reference(withPath: storagePath).getData(maxSize: 10000000) {
//
//        ref.getData(maxSize: 10000000) { (data, err) in
//            if let err = err {
//                print("ERROR - getImage: \(err.localizedDescription)")
//            }
//
//            guard let data = data, let image = UIImage(data: data) else {
//                return completion(defaultImage)
//            }
//
//            completion(image)
//        }
//
//    }
    
    public static func getThumbnail(_ fullPath: String?, completion: @escaping (UIImage) -> Void) {
        
        let defaultImage = UIImage(named: "stock_profile_picture") ?? UIImage()
        guard let fullPath = fullPath else {
            return completion(defaultImage)
        }
        
        let fileRef = fs.reference(withPath: fullPath)
        
        fileRef.getData(maxSize: 10000000) { (data, err) in
            if let err = err {
                print("ERROR - getImage: \(err.localizedDescription)")
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                return completion(defaultImage)
            }
            
            completion(image)
        }
        
    }
    
//    public static func getBlueprintModel(_ blueprintStoragePath: String, completion: @escaping (Blueprint) -> Void) {
//        let ref = fs.reference(forURL: "gs://blueprint-8c1ca.appspot.com").child("blueprints").child(blueprintStoragePath)
//
//        ref.getData(maxSize: 10000000) { (data, err) in
//            if let err = err {
//                print("ERROR - getNetwo: \(err.localizedDescription)")
//            }
//
//            guard let data = data, let network = UIImage(data: data) else {
//                return completion(defaultImage)
//            }
//
//            completion(image)
//        }
//        
//
//    }
    
    static func deleteProPic(_ userUid: String, completion: @escaping (Bool) -> Void) {
        
        fs.reference().child("\(userUid)").delete() { err in
            
            if let err = err {
                print("ERROR - deleteProPic: \(err.localizedDescription)")
                return completion(false)
            }
            
            return completion(true)
        }
    }
}
