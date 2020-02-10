//
//  shorcuts.swift
//  coolAnimation
//
//  Created by Andrew on 8/12/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class ShortcutParser {
    
    
    enum ShortcutKey: String {
        case userData = "com.myApp.newListing"
        case activity = "com.myApp.activity"
        case messages = "com.MyApp.messages"
    }
    
    static let shared = ShortcutParser()
    private init() { }
    
    
    let asd = UIApplicationShortcutwidget
    
    func registerShortcuts() {
        let activityIcon = UIApplicationShortcutIcon(templateImageName: "hustle")
        let activityShorcutItem = UIApplicationShortcutItem(type: ShortcutKey.activity.rawValue, localizedTitle: "See items for sell", localizedSubtitle: nil, icon: activityIcon, userInfo: nil)
        
        let messageIcon = UIApplicationShortcutIcon(templateImageName: "hustle")
        let messageShorcutItem = UIApplicationShortcutItem(type: ShortcutKey.messages.rawValue, localizedTitle: "See the messages", localizedSubtitle: nil, icon: messageIcon, userInfo: nil)
        
        let userdataIcon = UIApplicationShortcutIcon(templateImageName: "hustle")
        let userdataShorcutItem = UIApplicationShortcutItem(type: ShortcutKey.userData.rawValue, localizedTitle: "See your data", localizedSubtitle: nil, icon: userdataIcon, userInfo: nil)
        UIApplication.shared.shortcutItems?.append(contentsOf: [activityShorcutItem, messageShorcutItem, userdataShorcutItem])
    }
    
    
    
    
}

