//
//  FirebaseUser.swift
//  coolAnimation
//
//  Created by Andrew on 2/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class FirebaseUser: NSObject {
    
    let ref = Database.database().reference().child("users")
    
    static let instanceShared = FirebaseUser()
    
    typealias JSONStandard = [String: AnyObject]
    
    func collectUserData(uid: String, completion: @escaping (User?, String?) -> ()){
        
        ref.child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User(dictionary: dictionary)
                completion(user, nil)
            }
        }) { (err) in
               completion(nil, err.localizedDescription)
               return
           }
        
    }
    
    func createUserData(uid: String, values: [String: String], completion: @escaping (Bool, String?) -> ()){
        
        ref.child(uid).setValue(values) { (err, ref) in
            if err != nil{
                completion(false, err?.localizedDescription)
            }else{
                completion(true, nil)
            }
        }
        
    }
    
    func uploadUserProfileImg(uid: String, imgData: Data, additionalVal: [String: String]?, completion: @escaping (Bool, String?) -> ()){
        
        let imageName = NSUUID().uuidString
        let refStorage = Storage.storage().reference().child(imageName)
        
        refStorage.putData(imgData, metadata: nil) { (metadata, err) in
            if err != nil{
                completion(false, err?.localizedDescription)
            }else{
                
                refStorage.downloadURL(completion: { (imageURl, err2) in
                    if err != nil{
                        completion(false, err2?.localizedDescription)
                    }
                    guard let profilePictureStr = imageURl?.absoluteString else { return }
                    var values = ["profilePicture": profilePictureStr]
                    if let addValExt = additionalVal{
                        for (key, item) in addValExt{
                            values.updateValue(item, forKey: key)
                        }
                    }
                    self.ref.child(uid).updateChildValues(values, withCompletionBlock: { (err3, ref) in
                        if err != nil{
                            completion(false, err3?.localizedDescription)
                        }else{
                            completion(true, nil)
                        }
                    })
                })
            }
        }
        
    }
    
    
    
    func updateUserChildData(uid: String, values: JSONStandard, completion: @escaping (Bool, String?) -> ()){
        
        ref.child(uid).updateChildValues(values) { (err, _) in
            if err != nil{
                completion(false, err?.localizedDescription)
            }else{
                completion(true, nil)
            }
        }
    }
    
    func logOutUser(uid: String, completion: @escaping (Bool, String?) -> ()){
        
        let timeStamp = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970))
        let values = ["active": false,"timeActibity": timeStamp]
        
        FirebaseUser.instanceShared.updateUserChildData(uid: uid, values: values) { (res, err) in
            if (err != nil) {
                completion(false, err)
            }else{
                
                do{
                    if FBSDKAccessToken.current() != nil{
                        FBSDKLoginManager().logOut()
                    }
                    
                    if let _ = GIDSignIn.sharedInstance().currentUser{
                        GIDSignIn.sharedInstance().signOut()
                    }
                    
                    try Auth.auth().signOut()
                }catch let err2{
                    completion(false, err2.localizedDescription)
                }
            }
        }
        
        completion(true, nil)
        
    }
    
}
