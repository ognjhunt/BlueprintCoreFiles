//
//  Model.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 10/13/21.
//  Copyright © 2021 Placenote. All rights reserved.
//
import Foundation
import UIKit

public class Style {
    
    var name            : String = ""
    var description  : String = ""
    var thumbnail       : String? = nil
    var usage : Int?
    
    static let NAME         = "name"
    
    private(set) var textures    = [String]()
    private(set) var artworkModelIds    = [String]()
    private(set) var lightingModelIds    = [String]()
    private(set) var plantModelIds    = [String]()
    private(set) var furnitureModelIds    = [String]()
    private(set) var otherModelIds    = [String]()
    
    init(_ userFirDoc: [String:Any]) {
        
        // name
        if let name = userFirDoc["name"] as? String {
            self.name = name
        }
        
        if let description = userFirDoc["description"] as? String {
            self.description = description
        }
        
        //usernameStr
        if let usage = userFirDoc["usage"] as? Int {
            self.usage = usage
        }
        
        if let thumbnail = userFirDoc["thumbnail"] as? String {
            self.thumbnail = thumbnail
        }
        
        if let textures = userFirDoc["textures"] as? [String] {
            self.textures = textures
        }
        
        if let artworkModelIds = userFirDoc["artworkModelIds"] as? [String] {
            self.artworkModelIds = artworkModelIds
        }
        
        if let plantModelIds = userFirDoc["plantModelIds"] as? [String] {
            self.plantModelIds = plantModelIds
        }
        
        if let lightingModelIds = userFirDoc["lightingModelIds"] as? [String] {
            self.lightingModelIds = lightingModelIds
        }
        
        if let furnitureModelIds = userFirDoc["furnitureModelIds"] as? [String] {
            self.furnitureModelIds = furnitureModelIds
        }
        
        if let otherModelIds = userFirDoc["otherModelIds"] as? [String] {
            self.otherModelIds = otherModelIds
        }
        
        
    }
    
 }
