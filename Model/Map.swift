//
//  Map.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 8/3/20.
//  Copyright © 2020 Placenote. All rights reserved.
//

import Foundation
import UIKit

class Map {
    var ownerID: String? //specific ad
    var ownerName: String?
    var mapID: String? //video, gif, image
    var mapName: String?
    var size: Double?
    var password: String?
    var date: Double?
  //  var screenCount: Double?
 //   var screenSize: String?
  //  var mapImageUrl: String?
    var isPrivate: Bool?
    var latitude: Double?
    var longitude: Double?
    var currentlyConnectedUsers: [String:[String: Any]]?
    var savedUsers: [String:[String: Any]]?
    
    
    
    
    init(mapName: String, ownerID: String, mapID: String) {//, password: String, size: Double, dateCreated: Double, isPrivate: Bool
        self.mapName = mapName
        self.ownerID = ownerID
        self.mapID = mapID
        
//        self.password = password
//     //   self.screenSize = screenSize
//
//        self.size = size
//        self.dateCreated = dateCreated
//        self.isPrivate = isPrivate
        
        //        self.companySummary = companySummary
        //        self.numberOfEmployees = numberOfEmployees
        //        self.needs = needs
        // self.location = location
    }
    
    static func transformMap(dict: [String: Any]) -> Map? {
        guard let mapName = dict["mapName"] as? String,
            let ownerID = dict["ownerID"] as? String,
           // let mapID = dict["mapID"] as? String,
//            let screenCount = dict["screenCount"] as? Double,
//            let screenSize = dict["screenSize"] as? String,
          //  let password = dict["password"] as? String,
          //  let popularityRating = dict["popularityRating"] as? Double,
           // let isPrivate = dict["isPrivate"] as? Bool,
           // let size = dict["size"] as? Double,
            // let location = dict["location"] as? String,
            //  let needs = dict["needs"] as? String,
            //            let companySummary = dict["companySummary"] as? String,
            //            let numberOfEmployees = dict["numberOfEmployees"] as? Double,
            let mapID = dict["mapID"] as? String else {
                return nil
        }
        let map = Map(mapName: mapName, ownerID: ownerID, mapID: mapID)
        
        
         if let isPrivate = dict["isPrivate"] as? Bool {
                   map.isPrivate = isPrivate
               }
               if let ownerName = dict["ownerName"] as? String {
                   map.ownerName = ownerName
               }
        if let password = dict["password"] as? String {
                          map.password = password
                      }
        
        if let date = dict["date"] as? Double {
            map.date = date
        }
        
        if let size = dict["size"] as? Double {
            map.size = size
        }
        
        if let currentlyConnectedUsers = dict["currentlyConnectedUsers"] as? [String:[String: Any]] {
                   map.currentlyConnectedUsers = currentlyConnectedUsers
               }
        
        if let savedUsers = dict["savedUsers"] as? [String:[String: Any]] {
                          map.savedUsers = savedUsers
                      }
      
        if let latitude = dict["map_Lat"] as? Double {
            map.latitude = latitude
        }
        if let longitude = dict["map_Long"] as? Double {
            map.longitude = longitude
        }
        
        //        if let phoneNumber = dict["phoneNumber"] as? String{
        //            user.phoneNumber = phoneNumber
        //        }
        
        return map
    }
    
    func updateData(key: String, value: String) {
        switch key {
        case "mapName": self.mapName = value
        case "ownerID": self.ownerID = value
        case "mapID": self.mapID = value
            
   //     case "screenCount": self.screenCount = value
      //  case "screenID": self.screenID = value
    //    case "popularityRating": self.popularityRating = value
            
     //   case "locationImageUrl": self.locationImageUrl = value
     //   case "rate": self.rate = value
      //  case "estimatedImpressions": self.estimatedImpressions = value
        // case "location": self.location = value
        default: break
        }
    }
}

//extension User: Equatable{
//    static func == (lhs: User, rhs: User) -> Bool {
//        return lhs.uid == rhs.uid
//    }
//}

