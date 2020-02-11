//
//  SignUpEmail.swift
//  coolAnimation
//
//  Created by Andrew on 2/11/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

extension LogInEmailController {
    @objc func adddConstraints(){
        
        myView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        myView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        myView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.bottomAnchor.constraint(equalTo: myView.topAnchor, constant: -25).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        emailTextField.centerYAnchor.constraint(equalTo: myView.centerYAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: myView.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: myView.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: myView.leftAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: myView.rightAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
        logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        textViewAccount.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        textViewAccount.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textViewAccount.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textViewAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
