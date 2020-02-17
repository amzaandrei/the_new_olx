 //
 //  ViewController.swift
 //  coolAnimation
 //
 //  Created by Andrew on 6/26/17.
 //  Copyright © 2017 Andrew. All rights reserved.
 //
 
 import UIKit
 import Firebase
 import FirebaseAuth
 import CoreData
 import UserNotifications
 import Crashlytics
 
 class TinderController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    let reachiability = Reachability()!
    @objc let colorArray: [UIColor] = [UIColor.red,UIColor.green,UIColor.blue,UIColor.yellow,UIColor.brown,UIColor.orange]
    
    //    var users = [User]()
    @objc var MESSAGES = [Messages]()
    @objc var messageCoreData = [ChatInfoModel]()
    @objc var messagesDictionary = [String: Messages]()
    
    @objc lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing  = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    @objc let connectionInternet: UILabel = {
        let text = UILabel()
        text.text = "Not internet connection"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor.lightText
        return text
    }()
    
    @objc let rect: UIView = {
        let rect = CGRect()
        let mainView = UIView(frame: rect)
        mainView.backgroundColor = UIColor.red
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()
    
    @objc let cellId = "cellId"
    @objc var timer: Timer?
    
    @objc var manageObjectContext: NSManagedObjectContext!
    

    
    override func viewDidLoad() {
//        Crashlytics.sharedInstance().crash()
//        navigationController?.navigationBar.prefersLargeTitles = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, Error in })
        super.viewDidLoad()
        MESSAGES.removeAll()
        messagesDictionary.removeAll()
        self.collectionView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddMoreContacts))
        findIdUserLoggedIn()
        collectionView.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        collectionView.register(PersonCollCell.self, forCellWithReuseIdentifier: cellId)
        addContraints()
        
        findConnectionInternetStatus()
//        observeUserMessages()
        
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appMovedToBackground() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.savedStruct = self.MESSAGES.map({ $0 })
        print(appDelegate.savedStruct)
    }
    
    @objc let chatInfoRequest: NSFetchRequest<ChatInfoModel> = ChatInfoModel.fetchRequest()
    
    @objc func loadData(){
        chatInfoRequest.sortDescriptors = [NSSortDescriptor(key: "fromTimeStamp", ascending: false)]
        chatInfoRequest.predicate = NSPredicate(format: "fromMessage = %@", "Hahahdhahhahs")
        chatInfoRequest.fetchLimit = 1
        do {
            messageCoreData = try manageObjectContext.fetch(chatInfoRequest)
            self.collectionView.reloadData()
        }catch{
            print("Could not load data from database \(error.localizedDescription)")
        }
        
    }
    
//    @objc func observeUserMessages(){
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        let ref = Database.database().reference().child("user-messages").child(uid)
//
//        ref.observe(.childAdded, with: { (snapshot) in
//            let messageId = snapshot.key
//            let messageRef = Database.database().reference().child("messages").child(messageId)
//
//            messageRef.observe(.value, with: { (snapshot) in
//
//                let coreDataVar = ChatInfoModel(context: self.manageObjectContext)
//
//                if let dictionary = snapshot.value as? [String: AnyObject]{
//                    let messagesValue = Messages(dictionary: dictionary)
//                    self.MESSAGES.append(messagesValue)
//                    coreDataVar.fromImage = messagesValue.toIdImageUrl
                    // TODO: create here seen messages
                    //print(messagesValue.active)
                    //self.addNotification(bodyText: messagesValue.text!,fromId: messagesValue.fromId!)
                    
//                    if let id = messagesValue.chatPartner(){
//
//                        Database.database().reference().child("users").child(id).observe(.value, with: { (snapshot) in
//                            if let dictionary = snapshot.value as? [String: AnyObject]{
//                                let users = messages(dictionary: dictionary)
//                                if let userName = users.fromIdName{
//                                    coreDataVar.fromName = userName
//                                }
//                            }
//                        })
//                    }
                    
                    
//                    coreDataVar.fromMessage = messagesValue.text
//                    if let timeStampExist = messagesValue.timestamp{
//                        coreDataVar.fromTimeStamp = Double(timeStampExist)
//                    }
//                    do{
//                        try self.manageObjectContext.save()
//                        self.collectionView.reloadData()
//                        self.loadData()
//                    }catch let err{
//                        print(err.localizedDescription)
//                    }
//
//                    if let toId = messagesValue.chatPartner(){
//                        self.messagesDictionary[toId] = messagesValue
//
//                        self.MESSAGES = Array(self.messagesDictionary.values)
//                        self.MESSAGES.sort(by: { (m1, m2) -> Bool in
//
//                            return (m1.timestamp?.intValue)! > (m2.timestamp?.intValue)!
//                        })
//                    }
//                    self.timer?.invalidate() /// blocheaza accesarea functiei iar la ult mess nu mai invalideaza ca e deasupra self.timer = si intra in functie
//                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//                }
//
//            }, withCancel: nil)
//
//        }, withCancel: nil)
//    }
    
//    @objc func handleReloadTable(){
//        DispatchQueue.main.async(execute: {
//            self.collectionView.reloadData()
//        })
//    }
    
    
    @objc func addNotification(bodyText: String,fromId: String){
        
        let reply = UNTextInputNotificationAction(identifier: "reply", title: "Reply", options: .authenticationRequired)
        let viewMessage = UNNotificationAction(identifier: "view", title: "View Message", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "category", actions: [reply,viewMessage], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        let content = UNMutableNotificationContent()
        content.body = bodyText
        content.sound = .default()
        content.categoryIdentifier = "category"
        let ref = Database.database().reference()
        
        ref.child("users").child(fromId).observe(.value, with: { (snapshot) in
            if let userName = snapshot.value as? [String: Any]{
                
                content.title = userName["name"] as! String
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "any", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }, withCancel: nil)
        
    }
    
    @objc func addContraintsInternet(findOut: Bool){
        view.addSubview(rect)
        rect.addSubview(connectionInternet)
        rect.isHidden = findOut
        
        rect.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rect.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rect.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rect.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!).isActive = true
        
        connectionInternet.centerXAnchor.constraint(equalTo: rect.centerXAnchor).isActive = true
        connectionInternet.centerYAnchor.constraint(equalTo: rect.centerYAnchor).isActive = true
    }
    
    func reachable(){
        DispatchQueue.main.async {
            self.view.addSubview(self.rect)
            UIView.animate(withDuration: 0.5, animations: {
                self.rect.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)! - 30).isActive = true //// nu merge din pacate :(
                self.addContraintsInternet(findOut: false)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func unreachable(){
        DispatchQueue.main.async {
            self.view.addSubview(self.rect)
            UIView.animate(withDuration: 0.5, animations: {
                self.rect.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!).isActive = true //// nu merge din pacate :(
                self.addContraintsInternet(findOut: false)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func findConnectionInternetStatus(){
        reachiability.whenReachable = { _ in
            DispatchQueue.main.async(execute: {
                self.reachable()
            })
        }
        
        reachiability.whenUnreachable = { _ in
            DispatchQueue.main.async(execute: {
                self.unreachable()
            })
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetConnectionHasChanged), name: ReachabilityChangedNotification, object: reachiability)
        
        do{
            try reachiability.startNotifier()
        }catch{
            print("could not start notifier")
        }
        
    }
    
    @objc func internetConnectionHasChanged(note: Notification){
        let reachiability = note.object as! Reachability
        if reachiability.isReachable {
            if reachiability.isReachableViaWiFi{ // cu wi fi daca nu cu mobile data
                DispatchQueue.main.async(execute: {
                    self.reachable()
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self.reachable()
                })
            }
        }else{
            DispatchQueue.main.async(execute: {
                self.unreachable()
            })
        }
    }
    
    @objc func findIdUserLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign In", style: .done, target: self, action: #selector(LogInPage))
        }else{
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let info = User(dictionary: dictionary)
                    if let imageNameUrl = info.profileImageUrl{
                        self.setProfileImage(imageNameUrl: imageNameUrl)
                    }
                    
                    
                    self.title = info.name
                    //                    if let imageNameUrl = dictionary["profilePicture"]{
                    //                        self.setProfileImage(imageNameUrl: imageNameUrl.absoluteString)
                    //                    }
                }
                
            }, withCancel: nil)
            
        }
    }
    
    
    @objc func setProfileImage(imageNameUrl: String){
        let url = URL(string: imageNameUrl)
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err != nil{
                print(err!)
            }else{
                
                DispatchQueue.main.async(execute: {
                    
                    let containerView = UIView()
                    containerView.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
                    
                    let profileImage = UIImage(data: data!)
                    let buttonProfile = UIButton(type: .system)
                    buttonProfile.setBackgroundImage(profileImage, for: .normal)
                    buttonProfile.addTarget(self, action: #selector(self.profileDataPage), for: .touchUpInside)
                    buttonProfile.contentMode = .scaleAspectFill
                    buttonProfile.frame = containerView.frame
                    buttonProfile.layer.cornerRadius = 19
                    buttonProfile.clipsToBounds = true
                    buttonProfile.imageView?.contentMode = .scaleAspectFill
                    let item1 = UIBarButtonItem(customView: containerView)
                    self.navigationItem.setLeftBarButtonItems([item1], animated: true)
                })
                
            }
        }
        dataTask.resume()
    }
    
    @objc func addContraints(){
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MESSAGES.count
        //        return messageCoreData.count
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PersonCollCell
        
        let mainUser = MESSAGES[indexPath.row]
        
        
        if let Id = mainUser.chatPartner() {
            Database.database().reference().child("users").child(Id).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let userName = Messages(dictionary: dictionary)
                    cell.textLabel.text = userName.fromIdName
                }
            }, withCancel: nil)
        }
        
        if mainUser.text == nil {
            cell.detailedLabel.text = "Sent image"
        }else{
            cell.detailedLabel.text = mainUser.text
        }
        
        if let time = mainUser.timestamp?.doubleValue {
            let timeStampDate = NSDate(timeIntervalSince1970: time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.timeStamp.text = dateFormatter.string(from: timeStampDate as Date)
        }
        
        if let profileImageUrl = mainUser.toIdImageUrl{
            cell.profileImage.loadImageUsingCacheString(urlString: profileImageUrl)
        }
        
        return cell
    }
    
    
    
    
    
    @objc func otherStuff(user: User?){
        let expandedViewController = ChatPageController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: expandedViewController)
        expandedViewController.userNameAddContact = user
        //        expandedViewController.sendActiveMessage(messageActive: "active")
        present(navController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let message = MESSAGES[indexPath.row]
        
        guard let chatPartnerId = message.chatPartner() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.otherStuff(user: user)
        }, withCancel: nil)
        
    }
    
    @objc func AddMoreContacts(){
        let addMoreFile = SearchContactsCtr()
        addMoreFile.coolAnimationVar = self
        let addMoreContactsFile = UINavigationController(rootViewController: addMoreFile)
        present(addMoreContactsFile, animated: true, completion: nil)
        
    }
    
    @objc func LogInPage(){
        let logPage = LogInEmailController()
        let navigationController = UINavigationController(rootViewController: logPage)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func profileDataPage(){
        let profilDataPage = UserProfileCtr()
        let navigationController = UINavigationController(rootViewController: profilDataPage)
        present(navigationController, animated: true, completion: nil)
    }
    
    
    
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
