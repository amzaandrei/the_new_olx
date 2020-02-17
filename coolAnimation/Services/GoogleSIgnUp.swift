//
//  GoogleSIgnUp.swift
//  coolAnimation
//
//  Created by Andrew on 2/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation
import Firebase

class GoogleSignUp: NSObject {
    
    static let instanceShared = GoogleSignUp()
    
    func signUpGoogle(credentials: AuthCredential, completion: @escaping (Bool, String?) -> ()){
        
        Auth.auth().signIn(with: credentials) { (user, err) in
            if err != nil{
                completion(false, err?.localizedDescription)
            }
            
            
            var userData: [String: String] = [
                "name": user?.displayName as! String,
                "email": user?.email as! String,
                "profilePicture": user?.photoURL?.absoluteString as! String
            ]
            if let uid = user?.uid{
                FirebaseUser.instanceShared.createUserData(uid: uid, values: userData) { (res, err2) in
                    if res{
                        completion(true, nil)
                    }else{
                        completion(false, err2)
                    }
                }
            }
            
        }
    }
    
    
}
