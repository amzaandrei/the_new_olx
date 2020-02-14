//
//  realLogInPage.swift
//  coolAnimation
//
//  Created by Andrew on 7/15/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class LogInEmailController: UIViewController {

    
    @objc let myView: UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    let userDefaults = UserDefaults()
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
        mainButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
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
    
    var manajedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(logo)
        view.addSubview(myView)
        myView.addSubview(emailTextField)
        myView.addSubview(passwordTextField)
        view.addSubview(logInButton)
        view.addSubview(textViewAccount)
        
        emailTextField.becomeFirstResponder()
        
        textViewAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goback)))
        
        adddConstraints()
        
        let dismissTapp = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissTapp)
        
        let chatBoxTapp = UITapGestureRecognizer(target: self, action: #selector(animateView))
        emailTextField.addGestureRecognizer(chatBoxTapp)
        
        NotificationCenter.default.addObserver(self, selector: #selector(findKeyboardHeight), name: .UIKeyboardDidShow, object: nil)
        
        manajedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    
    
    
    @objc func findKeyboardHeight(note: Notification){
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            animateView(height: keyboardSize.height)
        }
    }
    
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
    
    @objc func goback(){
        present(LogInEmailController(), animated: true, completion: nil)
    }
    @objc func addActivity(){
        
        view?.addSubview(effectView)
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(loadingLabel)
        
        effectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        effectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
    
    
    @objc func logIn(){
        
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        
        
        if emailText == "" && passwordText == ""{
            emailTextField.shake()
            passwordTextField.shake()
            return
        }
        
        if emailText == ""  {
            emailTextField.shake()
            return
        }
        
        if passwordText == "" {
            passwordTextField.shake()
            return
        }
        
        addActivity()
        activityIndicator.startAnimating()
        
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText, completion: { (user, err) in
            if err != nil{
                print(err!)
                self.activityIndicator.stopAnimating()
                
                let alertController = UIAlertController(title: "Come om Bro", message: "You data is wrong! Try again please", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.effectView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            }else{
                
                self.userDefaults.set(true, forKey: "isLoggedIn")
                
                self.present(MainTabController(), animated: true, completion: nil)
            }
        })
        
    }
    
    
}


class modifyTextfieldLog: UITextField {
    
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


















