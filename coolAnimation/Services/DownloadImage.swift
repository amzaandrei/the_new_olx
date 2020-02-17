//
//  DownloadImage.swift
//  coolAnimation
//
//  Created by Andrew on 2/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation

class DownloadImage: NSObject {
    
    
    static let instanceShared = DownloadImage()
    
    func downloadImage(imgStr: String, completion: @escaping (Data?, String?) -> ()){
        
        let dispatch = DispatchGroup()
        dispatch.enter()
        
        var imgData: Data!
        
        let url = URL(string: imgStr)
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err != nil{
                completion(nil, err?.localizedDescription)
            }else{
                
                if let dataImg = data{
                    imgData = dataImg
                    dispatch.leave()
                }
            }
        }.resume()
        dispatch.wait()
        completion(imgData, nil)
    }
    
    
}
