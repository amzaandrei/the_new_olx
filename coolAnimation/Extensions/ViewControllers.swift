//
//  ViewControllers.swift
//  coolAnimation
//
//  Created by Andrew on 2/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func lengthError(text: String) throws{
        guard text.count > 7 else {
            throw ValidationError.tooShort
        }
        
        guard text.count < 25 else {
            throw ValidationError.tooLong
        }
    }
    
    func validateUsername(text: String) throws {
        
        try lengthError(text: text)
        
        for ch in text{
            guard ch.isLetter else {
                throw ValidationError.invalidCharacterFound(ch)
            }
        }
    }
    
    func validateEmail(text: String) throws {

        try lengthError(text: text)
        
        for ch in text{
            if ch == "@" || ch == "." {
                continue
            }
            guard ch.isLetter else {
                throw ValidationError.invalidCharacterFound(ch)
            }
        }
    }
    
    func validatePassword(text: String) throws {
        
        try lengthError(text: text)
        
        for ch in text{
            if ch == "-" || ch == "_" {
                continue
            }
            guard ch.isLetter else {
                throw ValidationError.invalidCharacterFound(ch)
            }
        }
    }
    
    func validateContact(text: String) throws {
        
        try lengthError(text: text)
        
        for ch in text{
            if ch == "+" {
                continue
            }
            guard ch.isNumber else {
                throw ValidationError.invalidCharacterFound(ch)
            }
        }
    }
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
