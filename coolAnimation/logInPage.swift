//
//  logInPage.swift
//  coolAnimation
//
//  Created by Andrew on 6/30/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreData
//class LogInController: UIViewController, GIDSignInUIDelegate,FBSDKLoginButtonDelegate,GIDSignInDelegate {
class LogInController: UIViewController {
    
    let userDefaults = UserDefaults()
    
    let logo: UIImageView = {
        let image = UIImage(named: "hustle")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let emailTextField: modifyTextfield = {
        let textField = modifyTextfield()
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
    let passwordTextField: modifyTextfield = {
        let textField = modifyTextfield()
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
    
    let contactTextField: modifyTextfield = {
        let textField = modifyTextfield()
        textField.textColor = UIColor.gray
        textField.attributedPlaceholder = NSAttributedString(string: "Please enter your contact number...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let logInButton: UIButton = {
        let mainButton = UIButton(type: .system)
        mainButton.setTitle("Sign In", for: .normal)
        mainButton.setTitleColor(UIColor.white, for: .normal)
        mainButton.backgroundColor = UIColor.black
        mainButton.layer.cornerRadius = 15
//        mainButton.clipsToBounds = true
        mainButton.layer.borderColor = UIColor.white.cgColor
        mainButton.layer.borderWidth = 2
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        return mainButton
    }()
    
    let registerButton: UIButton = {
        let mainButton = UIButton(type: .system)
        mainButton.setTitle("Multimedia Register", for: .normal)
        mainButton.setTitleColor(UIColor.white, for: .normal)
        mainButton.backgroundColor = UIColor.black
        mainButton.layer.cornerRadius = 15
        //        mainButton.clipsToBounds = true
        mainButton.layer.borderColor = UIColor.white.cgColor
        mainButton.layer.borderWidth = 2
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.addTarget(self, action: #selector(redirectRedirectPageFunc), for: .touchUpInside)
        return mainButton
    }()
    
    let separator1: UIView = {
        let linie = UIView()
        linie.backgroundColor = UIColor.white
        linie.translatesAutoresizingMaskIntoConstraints = false
        return linie
    }()
    
    let separator2: UIView = {
        let linie = UIView()
        linie.backgroundColor = UIColor.white
        linie.translatesAutoresizingMaskIntoConstraints = false
        return linie
    }()
    
    let or: UILabel = {
        let text = UILabel()
        text.text = "OR"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.textColor = UIColor.white
        return text
    }()
    
    let textView: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor.white
        text.isUserInteractionEnabled = true
        text.attributedText = NSAttributedString(string: "Have you forgetten your password?", attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        return text
    }()
    
    let textViewAccount: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor.white
        text.isUserInteractionEnabled = true
        text.attributedText = NSAttributedString(string: "Do you have already an account?", attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        return text
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    let effectView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effect.layer.cornerRadius = 8
        effect.layer.masksToBounds = true
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    var manajedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissView))
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.black
        
        self.view.addSubview(self.logo)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.logInButton)
        self.view.addSubview(self.textView)
        self.view.addSubview(contactTextField)
        self.view.addSubview(self.separator1)
        self.view.addSubview(self.separator2)
        self.view.addSubview(self.or)
        self.view.addSubview(self.textViewAccount)
        self.view.addSubview(registerButton)
//        self.view.addSubview(self.facebookBtt)
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(forgetPass))
        textView.addGestureRecognizer(tapped)
        
        let dismissTapp = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissTapp)
        
        let chatBoxTapp = UITapGestureRecognizer(target: self, action: #selector(animateView))
        emailTextField.addGestureRecognizer(chatBoxTapp)
        
        let tappedAccountLog = UITapGestureRecognizer(target: self, action: #selector(theRealLogIn))
        textViewAccount.addGestureRecognizer(tappedAccountLog)
        
        addConstraints()
        
        manajedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
//        setupGoogleButtons()
//        setupTwitterButton()
//        setupFacebookButton()
    }
    
    
    
    
    
    
    
    
//    func setupFacebookButton(){
//        facebookBtt.topAnchor.constraint(equalTo: or.bottomAnchor,constant: 150).isActive = true
//        facebookBtt.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    }
    
    @objc func dismissKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        view.endEditing(true)
    }
    
    @objc func animateView(height: CGFloat){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -height, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    @objc func theRealLogIn(){
        let realLogInFile = realLogInPage()
        present(realLogInFile, animated: true, completion: nil)
    }
    
    @objc func addActivity(){
        self.view.addSubview(effectView)
        //        effectView.addSubview(activityIndicator)
        effectView.contentView.addSubview(activityIndicator)
        //        effectView.addSubview(loadingLabel)
        effectView.contentView.addSubview(loadingLabel)
        
        effectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        effectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        effectView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        effectView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        activityIndicator.leftAnchor.constraint(equalTo: effectView.leftAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: effectView.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 46).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 46).isActive = true
        
        
        loadingLabel.rightAnchor.constraint(equalTo: effectView.rightAnchor, constant: 5).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: effectView.centerYAnchor).isActive = true
        loadingLabel.heightAnchor.constraint(equalToConstant: 46).isActive = true
        loadingLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    
    
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
    
    @objc func redirectRedirectPageFunc(){
        self.present(redirectRedirectPage(), animated: true, completion: nil)
    }
    
    @objc func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func forgetPass(){
        
        
        if emailTextField.text == "" {
            
            let alert = UIAlertController(title: "Come on Bro", message: "Do you reset your password or not? So than please fill your email field to send you an email", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (err) in
            if err != nil{
                print(err!)
            }
        }
    }
    
    @objc func logIn(){
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text, let contact = contactTextField.text else { return }
        
        
        if emailText == "" && passwordText == ""{
            emailTextField.shake()
            passwordTextField.shake()
            return
        }
        
        if emailText == "" {
            emailTextField.shake()
            return
        }
        
        if passwordText == "" {
            passwordTextField.shake()
            return
        }
        
        if contact == "" {
            contactTextField.shake()
            return
        }
        
        addActivity()
        activityIndicator.startAnimating()
        Auth.auth().createUser(withEmail: emailText, password: passwordText, completion: { (user, error) in
            if error != nil{
                print(error!)
                let actionController = UIAlertController(title: "Warning", message: "We found that this account is already used", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .default, handler: nil)
                actionController.addAction(action)
                self.present(actionController, animated: true, completion: nil)
                self.effectView.removeFromSuperview()
                self.loadingLabel.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            }else{
                        self.activityIndicator.stopAnimating()
                        let setPageName = setName()
                        self.present(setPageName, animated: true, completion: nil)
                        let values = ["email": emailText, "password": passwordText,"contact": contact]
                        let ref = Database.database().reference()
                        let usersRef = ref.child("users").child((user?.user.uid)!)
                        usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                            }else{
                                let userDefaults = UserDefaults()
                                self.userDefaults.set(true, forKey: "isLoggedIn")
                                
                                print("User data succesfully  uploaded")
                            }
                        })
            }
        })
        
    }
    
}




class modifyTextfield: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    @objc func shake(){
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        
        
        self.layer.add(animation, forKey: "position")
    }
}



















