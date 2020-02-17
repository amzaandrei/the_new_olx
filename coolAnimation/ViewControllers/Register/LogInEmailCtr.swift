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

    
    let userDefaults = UserDefaults()
    
    var logInView: LogInView!
    
    var manajedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        addViewAndGestures()
        
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
    
    
    @objc func logIn(){
        
        guard let emailText = logInView.emailTextField.text, let passwordText = logInView.passwordTextField.text else { return }
        
        
        
        do{
            try validateEmail(text: emailText)
        }catch {
            logInView.emailTextField.shake()
            print(error.localizedDescription)
            return
        }
        
        do{
            try validatePassword(text: passwordText)
        }catch{
            print(error.localizedDescription)
            logInView.passwordTextField.shake()
            return
        }
        
        logInView.addActivity()
        logInView.activityIndicator.startAnimating()
        
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText, completion: { (user, err) in
            if err != nil{
                print(err!)
                self.logInView.activityIndicator.stopAnimating()
                
                let alertController = UIAlertController(title: "Come om Bro", message: "You data is wrong! Try again please", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.logInView.effectView.removeFromSuperview()
                self.logInView.activityIndicator.stopAnimating()
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


















