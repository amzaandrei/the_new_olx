//
//  redirectRegisterPage.swift
//  coolAnimation
//
//  Created by Andrew on 1/23/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import TwitterKit
import Crashlytics
import FBSDKLoginKit
import CoreData

class ChooseWhichRegisterController: UIViewController,FBSDKLoginButtonDelegate, GIDSignInUIDelegate,GIDSignInDelegate {
    
    //class redirectRedirectPage: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate {
    let userDefaults = UserDefaults()
    
    let facebookProfileImage: UIImageView = {
        let image = UIImage(named: "facebook")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var faceBookCustomButton: FBSDKLoginButton = { //FBSDKLoginButton
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        let buttonColor = UIColor(red: 69 / 255, green: 55 / 255, blue: 218 / 255, alpha: 100)
        button.backgroundColor = buttonColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Continue with Facebook", for: .normal)
//        button.addTarget(self, action: #selector(logWithFacebook), for: .touchUpInside)
        return button
    }()
    
    let googleCustomButton: UIButton = {
        let image = UIImage(named: "google")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(logWithGoogle), for: .touchUpInside)
        return button
    }()
    
    let emailRegister: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(presentRealSignInPage), for: .touchUpInside)
        button.setTitle("Continue with Email", for: .normal)
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonColor = UIColor(red: 18 / 255, green: 186 / 255, blue: 111 / 255, alpha: 100)
        button.setTitleColor(buttonColor, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    let alreadyAccountLabel: UILabel = {
        let text = UILabel()
        text.text = "Do you have already an account?"
        text.textColor = UIColor.white
        text.isUserInteractionEnabled = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var userId: String! = nil
    
    var manajedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Crashlytics.sharedInstance().crash()
        view.addSubview(googleCustomButton)
        view.addSubview(emailRegister)
        view.addSubview(faceBookCustomButton)
        view.addSubview(alreadyAccountLabel)
        faceBookCustomButton.addSubview(facebookProfileImage)
        view.backgroundColor = UIColor(red: 18 / 255, green: 186 / 255, blue: 111 / 255, alpha: 100)
        
        let tapp = UITapGestureRecognizer(target: self, action: #selector(logInPage))
        alreadyAccountLabel.addGestureRecognizer(tapp)
        addConstrains()
        setupTwitterButton()
        faceBookCustomButton.delegate = self
        
        manajedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    
    @objc func logInPage(){
        let logInPagge = LogInEmailController()
        self.present(logInPagge, animated: true, completion: nil)
    }
    
    @objc func presentRealSignInPage(){
        let realLogPage = SignUpEmailController()
        self.present(realLogPage, animated: true, completion: nil)
    }
    
    @objc func logWithGoogle(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("user created")
        
        if error != nil{
            print(error.localizedDescription)
            return
        }
        
        if !result.isCancelled{
            userDefaults.set(true, forKey: "isLoggedIn")
            introduceUserFirebase()
        }
        
        // TODO: ceva nu merge aici ca nu se mai incarca log in ul la fb
        
    }
    
    func introduceUserFirebase(){
        guard let accessToken = FBSDKAccessToken.current().tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { (user, err) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }else{
                self.uploadSomeData(userId: (user?.uid)!)
            }
        }
    }
    
    func uploadSomeData(userId: String){
        let param = ["fields":"email,name,picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: param).start { (conn, result, err) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }else{
                
                guard let dataObj = result as? NSDictionary else { return }
                
                let emailAdress = dataObj["email"] as? String
                let userName = dataObj["name"] as? String
                if let picture = dataObj["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"]{
                    let ref = Database.database().reference().child("users").observe(.value, with: { (snapshot) in
                        if err != nil{
                            print(err?.localizedDescription)
                            return
                        }
                        var ok: Bool = true
                        for elem in snapshot.children.allObjects as! [DataSnapshot]{
                            let elemKey = elem.key
                            if elemKey == userId{
                                ok = false
                            }
                        }
                        if ok {
                            self.present(MainTabController(), animated: true, completion: nil)
                            self.uploadDataToFirebase(emailAdress: emailAdress!,userName: userName!,url: url as! String,userId: userId)
                        }else{
                            let alertController = UIAlertController(title: "Important", message: "In our database exists a similiar account", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .default, handler: nil) /// poti sa introduc sa si reseteza parola daca vrea
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                            if FBSDKAccessToken.current() != nil{
                                FBSDKLoginManager().logOut()
                            }
                        }
                    }, withCancel: { (err) in
                        print(err.localizedDescription)
                        return
                    })
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil{
            print(error.localizedDescription)
            return
        }
        
        if let user = user {
            userDefaults.set(true, forKey: "isLoggedIn")
            self.uploadGoogleUserData(user: user)
        }
    }
    
    func uploadGoogleUserData(user: GIDGoogleUser){
        guard let authentification = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentification.idToken, accessToken: authentification.accessToken)
        Auth.auth().signIn(with: credential) { (user, err) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }
            Database.database().reference().child("users").observe(.value, with: { (snapshot) in
                if err != nil{
                    print(err?.localizedDescription)
                    return
                }
                let userName = user?.displayName
                let emailAdress = user?.email
                let url = user?.photoURL?.absoluteString
                var ok: Bool = true
                for elem in snapshot.children.allObjects as! [DataSnapshot]{
                    let elemKey = elem.key
                    if elemKey == user?.uid{
                        ok = false
                    }
                }
                if ok {
                    self.present(MainTabController(), animated: true, completion: nil)
                    self.uploadDataToFirebase(emailAdress: emailAdress!,userName: userName!,url: url as! String,userId: (user?.uid)!)
                }else{
                    let alertController = UIAlertController(title: "Important", message: "In our database exists a similiar account", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil) /// poti sa introduc sa si reseteza parola daca vrea
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    if let googleUser = GIDSignIn.sharedInstance().currentUser{
                        GIDSignIn.sharedInstance().signOut()
                    }
                }
            }
            )}
    }
    
    @objc func setupTwitterButton() {
        
        
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
            
            print("Successfully logged in under Twitter...")
            
            
            //lets login with Firebase
            
            guard let token = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
            self.present(MainTabController(), animated: true, completion: nil)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                
                if let err = error {
                    print("Failed to login to Firebase with Twitter: ", err)
                    return
                }
                print("Successfully created a Firebase-Twitter user: ", user?.uid ?? "")
                self.userId = user?.uid
                let twitterClient = TWTRAPIClient(userID: session?.userID)
                if user != nil{
                    //                    twitterClient.loadUser(withID: (session?.userID)!) { (user, error) in
                    //
                    //                    }
                    
                    let statusesShowEndpoint = "https://api.twitter.com/1.1/account/verify_credentials.json"
                    let params = ["include_email": "true"]
                    var clientError : NSError?
                    
                    let request = twitterClient.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
                    
                    twitterClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                        if connectionError != nil {
                            print("Error: \(connectionError)")
                        }
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: [])
                            
                            self.addUser(json: json as! [String : Any])
                        } catch let jsonError as NSError {
                            print("json error: \(jsonError.localizedDescription)")
                        }
                    }
                    
                    
                }
            })
        })
        
        
        view.addSubview(logInButton)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        logInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        logInButton.topAnchor.constraint(equalTo: emailRegister.bottomAnchor, constant: 15).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    let group = DispatchGroup()
    
    @objc func addUser(json: [String: Any]){
        let userEntity = UserEntity(context: manajedObjectContext)
        let ref = Database.database().reference().child("users").child(userId)
        let email = json["screen_name"] as! String
        let name = json["name"] as! String
        
        let profileImage = downloadImage(url: json["profile_image_url"] as! String)
        userEntity.email = email
        userEntity.profileImage = profileImage
        userEntity.name = name
        
        do{
            try manajedObjectContext.save()
        }catch let err{
            print(err.localizedDescription)
        }
        
        let values = ["email": email,"name": name,"password":"iDontKnowThat","profilePicture":json["profile_image_url"] as! String ]
        ref.updateChildValues(values) { (err, ref) in
            if err != nil{
                print(err?.localizedDescription)
            }else{
                
                self.userDefaults.set(true, forKey: "isLoggedIn")
                
                print("Created user")
            }
        }
    }
    
    func downloadImage(url: String) -> Data{
        let url = URL(string: url)
        var imageDataVar = Data()
        group.enter()
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            if let imageData = data{
                imageDataVar = imageData
                self.group.leave()
            }
            
        }).resume()
        group.wait()
        return imageDataVar
    }
    
    func uploadDataToFirebase(emailAdress: String,userName: String, url: String,userId: String){
        
        let ref = Database.database().reference().child("users").child(userId)
        let values = ["emailAdress":emailAdress,"name":userName,"profilePicture":url]
        ref.setValue(values) { (err, ref) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }else{
                print("data uploaded succesfully")
            }
        }
    }
    
}
