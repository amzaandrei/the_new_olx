//
//  Errors.swift
//  coolAnimation
//
//  Created by Andrew on 2/15/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation

enum ValidationError: Error {
    case tooShort
    case tooLong
    case invalidCharacterFound(Character)
}

extension ValidationError: LocalizedError {
    
    var errorDescription: String? {
        switch self{
        case .tooShort:
            return NSLocalizedString(
                "Your username needs to be at least 4 characters long",
                comment: ""
            )
        case .tooLong:
            return NSLocalizedString(
                "Your username can't be longer than 14 characters",
                comment: ""
            )
        case .invalidCharacterFound(let character):
            let format = NSLocalizedString(
                "Your username can't contain the character '%@'",
                comment: ""
            )
            return String(format: format, String(character))
        }
    }
    
}
