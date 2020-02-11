//
//  AppDelegate.swift
//  coolAnimation
//
//  Created by Andrew on 6/26/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import Fabric
import TwitterCore
import TwitterKit
import CoreData
import UserNotifications
import Crashlytics
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var lastStruct = [messages]()
    var savedStruct = [messages]()
    
    let userDefaults = UserDefaults()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Twitter.sharedInstance().start(withConsumerKey:"9qbb8JihNB0fAHmmOlpfKu7Zq", consumerSecret:"7qViAI7Y3akkn6A6GdYmKG9baPZYeu4oOCMNPUDcvCH3rOC6Bd")
        FirebaseApp.configure()
        Fabric.with([Twitter.self])
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
        
        STPPaymentConfiguration.shared().publishableKey = "pk_test_pweJ2DMZEm57mWtCh6CU0oO0"
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let isLoggedIn = userDefaults.bool(forKey: "isLoggedIn")
        if !isLoggedIn{
            window?.rootViewController = IntroductionPageController()
        }else{
            window?.rootViewController = mainClass()
        }
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        addShorcuts()
        let trace = Performance.startTrace(name: "test trace")
        trace?.incrementCounter(named:"retry")
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
     @objc func addShorcuts(){
        
        enum ShortcutKey: String{
            case home =  "com.AmzaAndrew123.coolAnimation.home"
            case messages = "com.AmzaAndrew123.coolAnimation.messages"
            case add = "com.AmzaAndrew123.coolAnimation.add"
            case userData = "com.AmzaAndrew123.coolAnimation.user"
        }
        
        
        let activityIcon = UIApplicationShortcutIcon(type: .home)
        let activityShorcutItem = UIApplicationShortcutItem(type: ShortcutKey.home.rawValue, localizedTitle: "See items for sell", localizedSubtitle: nil, icon: activityIcon, userInfo: nil)
        
        let messageIcon = UIApplicationShortcutIcon(type: .message)
        let messageShorcutItem = UIApplicationShortcutItem(type: ShortcutKey.messages.rawValue, localizedTitle: "See the messages", localizedSubtitle: nil, icon: messageIcon, userInfo: nil)
        
        let addDataIcon = UIApplicationShortcutIcon(type: .contact)
        let addDataShorcutItem = UIApplicationShortcutItem(type: ShortcutKey.add.rawValue, localizedTitle: "See your personal data", localizedSubtitle: nil, icon: addDataIcon, userInfo: nil)
        
        let userdataIcon = UIApplicationShortcutIcon(type: .add)
        let userdataShorcutItem = UIApplicationShortcutItem(type: ShortcutKey.userData.rawValue, localizedTitle: "Add more contacts", localizedSubtitle: nil, icon: userdataIcon, userInfo: nil)
        
        UIApplication.shared.shortcutItems = [activityShorcutItem, messageShorcutItem, addDataShorcutItem, userdataShorcutItem]
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err.localizedDescription)
            return
        }
        
        print("Successfully logged into Google", user)
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
        })
    }

    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let googlehandle = GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
        let facebookHandle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return googlehandle || facebookHandle
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        
        if response.actionIdentifier == "reply"{
            if let textResponse = response as? UNTextInputNotificationResponse {
                
                let name = response.notification.request.content.title
                let ref = Database.database().reference().child("users")
                ref.observe(.value, with: { (snapshot) in
                    print(snapshot.childrenCount)
                    let enumerate = snapshot.children
                    while let rest = enumerate.nextObject() as? DataSnapshot{
                        if let findName = rest.value as? [String: Any]{
                            if name == findName["name"] as? String{
                                let pageChatVar = pageChat()
                                pageChatVar.sendMessagesNotification(text: textResponse.userText, toId: rest.key)
                            }
                        }
                    }
                }, withCancel: nil)
                
                
                completionHandler()
            }
            completionHandler()
        }
    
        
    }
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if let tabVc = self.window?.rootViewController as? UITabBarController{
            if shortcutItem.type == "com.AmzaAndrew123.coolAnimation.home"{
                tabVc.selectedIndex = 0
            }else if shortcutItem.type == "com.AmzaAndrew123.coolAnimation.messages"{
                tabVc.selectedIndex = 2
            }else if shortcutItem.type == "com.AmzaAndrew123.coolAnimation.user"{
                tabVc.selectedIndex = 3
            }else if shortcutItem.type == "com.AmzaAndrew123.coolAnimation.add"{
                ///
            }
        }
        
        
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("inactive down write now")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
//        print("background write now")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let timeStamp = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970))
        let ref = Database.database().reference().child("users").child(uid)
        let value = ["active": false,"timeActibity": timeStamp]
        ref.updateChildValues(value) { (err, ref) in
            print("User is inactiev")
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        print("active write now")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let timeStamp = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970))
        let ref = Database.database().reference().child("users").child(uid)
        let value = ["active": true,"timeActibity": timeStamp]
        ref.updateChildValues(value) { (err, ref) in
            print("User is actiev")
        }
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("perform now")
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            
            messageRef.observe(.value, with: { (snapshot) in
                
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let messagesValue = messages(dictionary: dictionary)
                    self.lastStruct.append(messagesValue)
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        if savedStruct.count > 0{
            for (index,_) in savedStruct.enumerated(){
                print(savedStruct[index].text,lastStruct[index].text)
//                if savedStruct[index].text == lastStruct[index].text{
//                    print("yes")
//                }else{
//                    print("no")
//                }
            }
        }
//            coolAnimation().findTheThrought()
        // #TODO: completionHandler
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack@objc 

    @objc var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "coolAnimation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving  @objcsupport

    @objc func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

