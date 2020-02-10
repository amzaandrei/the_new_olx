//
//  messages.swift
//  coolAnimation
//
//  Created by Andrew on 7/13/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase

class messages: NSObject{
    
    @objc var fromId: String?
    @objc var fromIdName: String?
    @objc var toId: String?
    @objc var text: String?
    @objc var timestamp: NSNumber?
    @objc var toIdImageUrl: String?
    @objc var imageUrl: String?
    @objc var heightImage: NSNumber?
    @objc var widthImage: NSNumber?
    @objc var videoUrl: String?
    @objc var active: String?
    
    
    @objc init(dictionary: [String: AnyObject]){
        self.fromId = dictionary["fromId"] as? String
        self.fromIdName = dictionary["name"] as? String
        self.toId = dictionary["toId"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timeStamp"] as? NSNumber
        self.toIdImageUrl = dictionary["toIdImageUrl"] as? String
        self.imageUrl = dictionary["imageUrl"] as? String
        self.heightImage = dictionary["imageHeight"] as? NSNumber
        self.widthImage = dictionary["imageWidth"] as? NSNumber
        self.videoUrl = dictionary["fileNameUrl"] as? String
        self.active = dictionary["active"] as? String
    }
    
    
    @objc func chatPartner() -> String?{
        
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        }else{
            return fromId
        }
    }
    
    
    public static func == (leftStr: messages, rightStr: messages) -> Bool{
        return leftStr.fromId == rightStr.fromId
    }
    
    
    
}
