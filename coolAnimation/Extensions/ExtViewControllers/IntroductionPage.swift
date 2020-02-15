//
//  IntroductionPageExtension.swift
//  coolAnimation
//
//  Created by Andrew on 2/11/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

extension IntroductionPageController {
    
    @objc func addConstraintsAndIntro(){
        
        self.intro = IntroPage(frame: .zero)
        self.intro.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.intro)

        NSLayoutConstraint.activate([
            self.intro.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.intro.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.intro.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.intro.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])

        self.intro.nextBtt.addTarget(self, action: #selector(self.scrollPageNext), for: .touchUpInside)

        self.intro.prevBtt.addTarget(self, action: #selector(self.scrollPagePrev), for: .touchUpInside)
        
        self.intro.signUpBtt.addTarget(self, action: #selector(signUpPage), for: .touchUpInside)
        
        self.intro.logInBtt.addTarget(self, action: #selector(logInPageFunc), for: .touchUpInside)
        
        myColl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myColl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myColl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myColl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


class IntroPage: UIView {
    
    let pageController: UIPageControl = {
            let page = UIPageControl()
            page.translatesAutoresizingMaskIntoConstraints = false
            page.currentPage = 0
            page.numberOfPages = 3
            page.currentPageIndicatorTintColor = UIColor.white
            page.pageIndicatorTintColor = UIColor.black
            return page
        }()
        
        let nextBtt: UIButton = {
            let mainBtt = UIButton(type: .system)
            mainBtt.setTitle("NEXT", for: .normal)
            mainBtt.translatesAutoresizingMaskIntoConstraints = false
            return mainBtt
        }()
        
        let prevBtt: UIButton = {
            let mainBtt = UIButton(type: .system)
            mainBtt.setTitle("PREV", for: .normal)
            mainBtt.translatesAutoresizingMaskIntoConstraints = false
            return mainBtt
        }()
        
        let logInBtt: UIButton = {
            let btt = UIButton(type: .system)
            btt.setTitle("Log In", for: .normal)
            btt.setTitleColor(UIColor.black, for: .normal)
            btt.translatesAutoresizingMaskIntoConstraints = false
            btt.backgroundColor = UIColor(white: 1.0,alpha: 0)
            return btt
        }()
        
        let signUpBtt: UIButton = {
            let btt = UIButton(type: .system)
            btt.setTitle("Sign up", for: .normal)
            btt.setTitleColor(UIColor.black, for: .normal)
            btt.translatesAutoresizingMaskIntoConstraints = false
            btt.backgroundColor = UIColor(white: 1.0,alpha: 0)
            return btt
        }()
        
        let OrpBtt: UIButton = {
            let btt = UIButton(type: .system)
            btt.setTitle("Or", for: .normal)
            btt.setTitleColor(UIColor.black, for: .normal)
            btt.translatesAutoresizingMaskIntoConstraints = false
            btt.backgroundColor = UIColor(white: 1.0,alpha: 0)
//            btt.addTarget(self, action: #selector(orPage), for: .touchUpInside)
            return btt
        }()
        
        let helpView: UIView = {
            let myView = UIView()
            myView.translatesAutoresizingMaskIntoConstraints = false
            return myView
        }()
    
    
    var bottomStackAnchor: NSLayoutConstraint!
    var stack: UIStackView!
    var secStack: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stack = UIStackView(arrangedSubviews: [prevBtt,pageController,nextBtt])
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        secStack = UIStackView(arrangedSubviews: [logInBtt,OrpBtt,signUpBtt])
        secStack.distribution = .fillEqually
        secStack.translatesAutoresizingMaskIntoConstraints = false
        secStack.alpha = 0
        
        self.addSubviews([secStack, stack])
        
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomStackAnchor = stack.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -25)
        bottomStackAnchor.isActive = true
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        secStack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        secStack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        secStack.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -25).isActive = true
        secStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
