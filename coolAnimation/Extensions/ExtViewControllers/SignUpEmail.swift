//
//  SignUpEmail.swift
//  coolAnimation
//
//  Created by Andrew on 2/11/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

extension SignUpEmailController {
    
    @objc func addConstraints(){
            
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
            logo.heightAnchor.constraint(equalToConstant: 60).isActive = true
            logo.widthAnchor.constraint(equalToConstant: 60).isActive = true
            
            emailTextField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30).isActive = true
            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
            emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30).isActive = true
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            logInButton.topAnchor.constraint(equalTo: contactTextField.bottomAnchor, constant: 30).isActive = true
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            logInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            logInButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            textView.heightAnchor.constraint(equalToConstant: 35).isActive = true
            textView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            contactTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
            contactTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
            contactTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
            contactTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            
            or.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 15).isActive = true
            or.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            or.heightAnchor.constraint(equalToConstant: 36).isActive = true
            or.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            separator1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
            separator1.topAnchor.constraint(equalTo: or.topAnchor, constant: 15).isActive = true
            separator1.heightAnchor.constraint(equalToConstant: 2).isActive = true
            separator1.widthAnchor.constraint(equalToConstant: 115).isActive = true
            
            
            separator2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
            separator2.topAnchor.constraint(equalTo: or.topAnchor, constant: 15).isActive = true
            separator2.heightAnchor.constraint(equalToConstant: 2).isActive = true
            separator2.widthAnchor.constraint(equalToConstant: 115).isActive = true
            
            textViewAccount.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -3).isActive = true
            textViewAccount.heightAnchor.constraint(equalToConstant: 35).isActive = true
            textViewAccount.widthAnchor.constraint(equalToConstant: 300).isActive = true
            textViewAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    //
            registerButton.topAnchor.constraint(equalTo: or.bottomAnchor, constant: 15).isActive = true
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            registerButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            registerButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
        }
    
}
