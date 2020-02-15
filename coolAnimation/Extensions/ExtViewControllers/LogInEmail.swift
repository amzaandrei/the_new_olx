//
//  SignUpEmail.swift
//  coolAnimation
//
//  Created by Andrew on 2/11/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

extension LogInEmailController {
    
    func addViewAndGestures(){
        logInView = LogInView(frame: .zero)
            logInView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(logInView)
            NSLayoutConstraint.activate([
                logInView.leftAnchor.constraint(equalTo: view.leftAnchor),
                logInView.rightAnchor.constraint(equalTo: view.rightAnchor),
                logInView.topAnchor.constraint(equalTo: view.topAnchor),
                logInView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            logInView.logInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
            
            logInView.emailTextField.becomeFirstResponder()
        logInView.textViewAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goback)))

            
            let dismissTapp = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(dismissTapp)
            
            let chatBoxTapp = UITapGestureRecognizer(target: self, action: #selector(animateView))
            logInView.emailTextField.addGestureRecognizer(chatBoxTapp)
    }
    
}


class LogInView: UIView {
    
    
    @objc let myView: UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    @objc let logo: UIImageView = {
        let image = UIImage(named: "hustle")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    @objc let emailTextField: modifyTextfieldLog = {
        let textField = modifyTextfieldLog()
        textField.textColor = UIColor.gray
        textField.attributedPlaceholder = NSAttributedString(string: "Please enter your email...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    @objc let passwordTextField: modifyTextfieldLog = {
        let textField = modifyTextfieldLog()
        textField.textColor = UIColor.gray
        textField.attributedPlaceholder = NSAttributedString(string: "Please enter your password...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        return textField
    }()
    
    @objc let logInButton: UIButton = {
        let mainButton = UIButton(type: .system)
        mainButton.setTitle("Sign In", for: .normal)
        mainButton.setTitleColor(UIColor.white, for: .normal)
        mainButton.backgroundColor = UIColor.black
        mainButton.layer.cornerRadius = 15
        mainButton.clipsToBounds = true
//        mainButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        mainButton.layer.borderColor = UIColor.white.cgColor
        mainButton.layer.borderWidth = 2
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        return mainButton
    }()
    
    @objc let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    @objc let effectView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effect.layer.cornerRadius = 8
        effect.clipsToBounds = true
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    
    @objc let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    
    @objc let textViewAccount: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor.white
        text.isUserInteractionEnabled = true
        text.attributedText = NSAttributedString(string: "Do you want to sign in?", attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        view.addSubview(logo)
//        view.addSubview(myView)
//        myView.addSubview(emailTextField)
//        myView.addSubview(passwordTextField)
//        view.addSubview(logInButton)
//        view.addSubview(textViewAccount)
        self.addSubviews([logo, myView])
        self.myView.addSubviews([emailTextField, passwordTextField])
        self.addSubviews([logInButton, textViewAccount])
        addConstraints()
    }
    
    func addConstraints(){
            myView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            myView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            myView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
            myView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
            myView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        logo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
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
            logInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            logInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            logInButton.widthAnchor.constraint(equalToConstant: 100).isActive = true

            textViewAccount.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
            textViewAccount.heightAnchor.constraint(equalToConstant: 35).isActive = true
            textViewAccount.widthAnchor.constraint(equalToConstant: 300).isActive = true
            textViewAccount.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc func addActivity(){
        
        self.addSubview(effectView)
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(loadingLabel)
        
        effectView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        effectView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        effectView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        effectView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        activityIndicator.leftAnchor.constraint(equalTo: effectView.leftAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: effectView.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 46).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 46).isActive = true
        
        
        loadingLabel.rightAnchor.constraint(equalTo: effectView.rightAnchor, constant: 5).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: effectView.centerYAnchor).isActive = true
        loadingLabel.heightAnchor.constraint(equalToConstant: 46).isActive = true
        loadingLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
