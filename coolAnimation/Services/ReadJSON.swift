//
//  ReadJSON.swift
//  coolAnimation
//
//  Created by Andrew on 2/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation

class ReadJSON: NSObject {
    
    static let instanceShared = ReadJSON()
    
    func loadJson(filename fileName: String, completion: @escaping ([[String: String]]?, String?) -> () ) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: String]]
                if let dictionary = object  {
                    completion(dictionary, nil)
                }
            } catch {
                completion(nil, "Error!! Unable to parse  \(fileName).json")
            }
        }else{
            completion(nil, "Error!! Unable to find  \(fileName).json")
        }
    }
    
}
