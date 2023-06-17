//
//  Anchor.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 8/12/22.
//  Copyright © 2022 Placenote. All rights reserved.
//

import Foundation
import UIKit

public class Anchor {
    
    static let GEOHASH       = "geohash"

    private(set) var latitude          : Double?// = ""
    private(set) var longitude          : Double?// = ""
    private(set) var altitude          : Double?// = ""
    private(set) var heading          : Double?// = ""
    private(set) var heightInPixels          : Double?// = ""
    private(set) var widthInPixels          : Double?// = ""
    private(set) var name         : String?// = ""
    private(set) var placeId         : String?
    private(set) var url         : String?
    private(set) var id         : String?
    private(set) var locationName        : String? // = ""
    private(set) var host     : String = ""
    private(set) var interactionCount          : Int?
    private(set) var likes          : Int?
    private(set) var description          : String?
    private(set) var geohash          : String?// = ""
    private(set) var comments          : Int?
    private(set) var price     : String = ""
    private(set) var originalCreator     : String = ""
    private(set) var contentType     : String = ""
    private(set) var rating     : String = ""
    private(set) var storagePath     : String = ""
    private(set) var modelId     : String = ""
    var timeStamp       = Date()
    var isPublic        : Bool?

//    // groups
//    private(set) var groups       = [[String:Any]]()
    
    //MARK: --- Methods ---
    init(_ userFirDoc: [String:Any]) {
        
        // uid
        if let originalCreator = userFirDoc["originalCreator"] as? String {
            self.originalCreator = originalCreator
        }
        
        // name
        if let name = userFirDoc["name"] as? String {
            self.name = name
        }
        
        // emailStr
        if let locationName = userFirDoc["locationName"] as? String {
            self.locationName = locationName
        }
        
        if let contentType = userFirDoc["contentType"] as? String {
            self.contentType = contentType
        }
        
        if let storagePath = userFirDoc["storagePath"] as? String {
            self.storagePath = storagePath
        }
        
        if let id = userFirDoc["id"] as? String {
            self.id = id
        }
        
        if let timeStamp = userFirDoc["timeStamp"] as? Date {
            self.timeStamp = timeStamp
        }
        
        if let isPublic = userFirDoc["isPublic"] as? Bool {
            self.isPublic = isPublic
        }
        
        // name
        if let placeId = userFirDoc["placeId"] as? String {
            self.placeId = placeId
        }
        
        //usernameStr
        if let host = userFirDoc["host"] as? String {
            self.host = host
        }
        
        if let geohash = userFirDoc["geohash"] as? String {
            self.geohash = geohash
        }
        
        if let url = userFirDoc["url"] as? String {
            self.url = url
        }
        
        if let description = userFirDoc["description"] as? String {
            self.description = description
        }
        
        if let modelId = userFirDoc["modelId"] as? String {
            self.modelId = modelId
        }
        
        if let comments = userFirDoc["comments"] as? Int {
            self.comments = comments
        }
        
        if let likes = userFirDoc["likes"] as? Int {
            self.likes = likes
        }
        
        if let interactionCount = userFirDoc["interactionCount"] as? Int {
            self.interactionCount = interactionCount
        }
        
        if let heightInPixels = userFirDoc["heightInPixels"] as? Double {
            self.heightInPixels = heightInPixels
        }
        
        if let widthInPixels = userFirDoc["widthInPixels"] as? Double {
            self.widthInPixels = widthInPixels
        }
        
        if let latitude = userFirDoc["latitude"] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = userFirDoc["longitude"] as? Double {
            self.longitude = longitude
        }
        
        if let altitude = userFirDoc["altitude"] as? Double {
            self.altitude = altitude
        }
        
        if let heading = userFirDoc["heading"] as? Double {
            self.heading = heading
        }
        
    }
    
//    static func transformUser(dict: [String: Any]) -> User? {
//        guard let email = dict["email"] as? String,
//            let username = dict["username"] as? String,
//            let bio = dict["bio"] as? String,
//            let name = dict["name"] as? String,
//            // let location = dict["location"] as? String,
//            //  let needs = dict["needs"] as? String,
//            //            let companySummary = dict["companySummary"] as? String,
//            //            let numberOfEmployees = dict["numberOfEmployees"] as? Double,
//            let uid = dict["uid"] as? String else {
//                return nil
//        }
//        let user = User(uid: uid, email: email, name: name, username: username, bio: bio)
//
//        if let locationImageUrl = dict["locationImageUrl"] as? String{
//            user.locationImageUrl = locationImageUrl
//        }
//
//        if let website = dict["website"] as? String{
//            user.website = website
//        }
//
//        if let revenueSplit = dict["revenue_Split"] as? Double{
//            user.revenueSplit = revenueSplit
//        }
//
//        if let companyType = dict["companyType"] as? String{
//            user.companyType = companyType
//        }
//
//        if let inviteCode = dict["inviteCode"] as? String{
//            user.inviteCode = inviteCode
//        }
//
////        if let address = dict["address"] as? String{
////            user.address = address
////        }
//        if let profileImageUrl = dict["profileImageUrl"] as? String{
//            user.profileImageUrl = profileImageUrl
//        }
//
//        if let isLoggedIn = dict["isLoggedIn"] as? Bool {
//            user.isLoggedIn = dict["isLoggedIn"] as? Bool
//        }
//        if let isAHost = dict["isAHost"] as? Bool {
//            user.isAHost = dict["isAHost"] as? Bool
//        }
//        if let hasViewedHostWalkthrough = dict["hasViewedHostWalkthrough"] as? Bool {
//            user.hasViewedHostWalkthrough = dict["hasViewedHostWalkthrough"] as? Bool
//        }
//        if let hasConfirmedDetails = dict["hasConfirmedDetails"] as? Bool {
//            user.hasConfirmedDetails = dict["hasConfirmedDetails"] as? Bool
//        }
//        if let isAnAdvertiser = dict["isAnAdvertiser"] as? Bool {
//            user.isAnAdvertiser = dict["isAnAdvertiser"] as? Bool
//        }
//        if let hasFinishedShippingProcess = dict["hasFinishedShippingProcess"] as? Bool {
//            user.hasFinishedShippingProcess = dict["hasFinishedShippingProcess"] as? Bool
//        }
//
////        if let phoneNumber = dict["phoneNumber"] as? String{
////            user.phoneNumber = phoneNumber
////        }
//
//        if let latitude = dict["current_latitude"] as? String {
//            user.latitude = latitude
//        }
//        if let longitude = dict["current_longitude"] as? String {
//            user.longitude = longitude
//        }
//        return user
//    }
    
//    func toString() -> String {
//        var ret: String = ""
//        
//        ret = ret + "uid: " + uid
//        ret = ret + "\nemailStr: " + email
//        ret = ret + "\nusernameStr: " + username
////        ret = ret + "\nbioStr: " + bio
////        ret = ret + "\nlocationStr: " + location
//      //  ret = ret + "\nurlStr: " + urlStr
//        
//        ret = ret + "\nfollowers: " + following.debugDescription
//        ret = ret + "\nfollowing: " + following.debugDescription
//        ret = ret + "\nproPicRef: " + profileImageUrl.debugDescription
//        
//        ret = ret + "\nsubscriptions: " + subscriptions.debugDescription
//        ret = ret + "\nsubscribers: " + subscribers.debugDescription
//        
//        // assets
//        ret = ret + "\nassetUids: " + assetUids.joined(separator: ",")
//        ret = ret + "\nownedAssets: " + ownedAssets.joined(separator: ",")
//        
//        return ret
//    }
}
