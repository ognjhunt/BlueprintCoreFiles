//
//  Model.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 10/13/21.
//  Copyright © 2021 Placenote. All rights reserved.
//
import Foundation
import UIKit

public class Blueprint {
    static let GEOHASH       = "geohash"
    
    private(set) var latitude          : Double?// = ""
    private(set) var longitude          : Double?// = ""
    var id             : String = ""
    var creatorId      : String = ""
    var name            : String = ""
    var size            : Double = 10
    var password       : String = ""
    var storagePath       : String = ""
    var visibility       : String = ""
    var isPublic        : Bool?
    var date       = Date()
    
    private(set) var anchorIDs    = [String]()
    private(set) var historyUsers    = [String]()
    private(set) var currentUsers    = [String]()
    //    var price          : String = ""
    //   var timeStamp : Date()
    
    init(_ userFirDoc: [String:Any]) {
        
        // uid
        if let id = userFirDoc["id"] as? String {
            self.id = id
        }
        
        // name
        if let name = userFirDoc["name"] as? String {
            self.name = name
        }
        
        if let password = userFirDoc["password"] as? String {
            self.password = password
        }
        
        // emailStr
        if let creatorId = userFirDoc["creatorId"] as? String {
            self.creatorId = creatorId
        }
        
        if let storagePath = userFirDoc["storagePath"] as? String {
            self.storagePath = storagePath
        }
        
        if let date = userFirDoc["date"] as? Date {
            self.date = date
        }
        
        //usernameStr
        if let size = userFirDoc["size"] as? Double {
            self.size = size
        }
        
        if let visibility = userFirDoc["visibility"] as? String {
            self.visibility = visibility
        }
        
        if let latitude = userFirDoc["latitude"] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = userFirDoc["longitude"] as? Double {
            self.longitude = longitude
        }
        
    }
}
