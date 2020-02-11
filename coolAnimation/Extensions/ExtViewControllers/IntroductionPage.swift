//
//  IntroductionPageExtension.swift
//  coolAnimation
//
//  Created by Andrew on 2/11/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

extension IntroductionPageController {
    
    @objc func addConstraints(){
        
        stack = UIStackView(arrangedSubviews: [prevBtt,pageController,nextBtt])
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        secStack = UIStackView(arrangedSubviews: [logInBtt,OrpBtt,signUpBtt])
        secStack.distribution = .fillEqually
        secStack.translatesAutoresizingMaskIntoConstraints = false
        secStack.alpha = 0
        view.addSubview(secStack)
        view.addSubview(stack)
        
        myColl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myColl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myColl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myColl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomStackAnchor = stack.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -25)
        bottomStackAnchor.isActive = true
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        secStack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        secStack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        secStack.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -25).isActive = true
        secStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
