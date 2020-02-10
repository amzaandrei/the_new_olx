//
//  objectStruct.swift
//  coolAnimation
//
//  Created by Andrew on 10/6/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

struct object {
    var location: String?
    var contactText: String?
    var productText: String?
    var categoryText: String?
    var describText: String?
    var emailText: String?
    var urlImages: String?
    
    
    init(dictionary: [String: Any]){
        self.location = dictionary["location"] as? String
        self.contactText = dictionary["contactText"] as? String
        self.productText = dictionary["productText"] as? String
        self.categoryText = dictionary["categoryText"] as? String
        self.emailText = dictionary["emailtext"] as? String
        self.describText = dictionary["describText"] as? String
    }
}

