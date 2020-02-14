//
//  userStruct.swift
//  coolAnimation
//
//  Created by Andrew on 7/10/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit


class User: NSObject {
    
    @objc var id: String?
    var active: Bool?
    var activeTimeStamp: NSNumber?
    var numberContact: String?
    @objc var name: String?
    @objc var email: String?
    @objc var profileImageUrl: String?
    @objc init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profilePicture"] as? String
        self.active = dictionary["active"] as? Bool
        self.activeTimeStamp = dictionary["timeStamp"] as? NSNumber
        self.numberContact = dictionary["contact"] as? String
    }
}
