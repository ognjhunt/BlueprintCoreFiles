//
//  Texture.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 4/21/23.
//

import Foundation
import UIKit

public class Texture {
    
    var id             : String = ""
    var creatorId      : String = ""
    var name            : String = ""
    var description  : String = ""
    var category        : String = ""
  //  var scale           : Double = 1
    var size            : Double = 10
    var thumbnail       : String? = nil
   // var modelName       : String = ""
 //    var isPublic        : Bool?
     var price          : Int?
    var tags     : String = ""
 //   var prompt     : String = ""
//    var date = Date()
    
    static let CREATOR         = "creatorId"
   // static let DATE         = "date"
    static let NAME         = "name"
  //  static let MODELNAME         = "modelName"
    
    init(_ textureFirDoc: [String:Any]) {
        
        // uid
        if let id = textureFirDoc["id"] as? String {
            self.id = id
        }
        
        // name
        if let name = textureFirDoc["name"] as? String {
            self.name = name
        }
        
        // emailStr
        if let creatorId = textureFirDoc["creatorId"] as? String {
            self.creatorId = creatorId
        }
        
        if let description = textureFirDoc["description"] as? String {
            self.description = description
        }
        
        if let category = textureFirDoc["category"] as? String {
            self.category = category
        }
       
        //usernameStr
        if let size = textureFirDoc["size"] as? Double {
            self.size = size
        }
        
        if let thumbnail = textureFirDoc["thumbnail"] as? String {
            self.thumbnail = thumbnail
        }
        
        if let tags = textureFirDoc["tags"] as? String {
            self.tags = tags
        }
       
    }
    
 }
