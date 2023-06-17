//
//  SearchResultProtocol.swift
//  AdHost
//
//  Created by Nijel Hunt on 11/19/19.
//  Copyright © 2019 Nijel Hunt. All rights reserved.
//

import Foundation

protocol SearchResultProtocol {
//    var id: String? {get set}
//    var profileImageUrl:String? {get set}
//    var partnersSet: Bool? {get set}
//    var subscribedToSet: Bool? {get set}
//    var subscribersSet: Bool? {get set}
//    var isDeactivated: Bool? {get set}
    
   // var isLoggedIn: Bool?
    var uid : String? {get set}
    var email : String? {get set}
    var name : String? {get set}
    
//    var firstName : String? {get set}
//    var lastName : String? {get set}
//    var address: String? {get set}
//    var zipCode: String? {get set}
//   // var locationImage = UIImage()
//    var phoneNumber: String? {get set}
   // var latitude = ""
   // var longitude = ""
    //  var blockedUserIds: [String: Bool] { get set}
}
