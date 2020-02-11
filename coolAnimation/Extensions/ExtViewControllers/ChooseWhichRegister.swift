//
//  ChooseWhichRegisterExtension.swift
//  coolAnimation
//
//  Created by Andrew on 2/11/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

extension ChooseWhichRegisterController {
    
    func addConstrains(){
        emailRegister.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailRegister.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emailRegister.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailRegister.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        googleCustomButton.bottomAnchor.constraint(equalTo: emailRegister.topAnchor, constant: -15).isActive = true
        googleCustomButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        googleCustomButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        googleCustomButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        faceBookCustomButton.leftAnchor.constraint(equalTo: emailRegister.leftAnchor).isActive = true
        faceBookCustomButton.bottomAnchor.constraint(equalTo: emailRegister.topAnchor, constant: -15).isActive = true
        faceBookCustomButton.rightAnchor.constraint(equalTo: googleCustomButton.leftAnchor, constant: -10).isActive = true
        faceBookCustomButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        facebookProfileImage.leftAnchor.constraint(equalTo: faceBookCustomButton.leftAnchor, constant: 10).isActive = true
        facebookProfileImage.centerYAnchor.constraint(equalTo: faceBookCustomButton.centerYAnchor).isActive = true
        facebookProfileImage.widthAnchor.constraint(equalToConstant: 5).isActive = true
        facebookProfileImage.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        alreadyAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alreadyAccountLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
    }
    
}
