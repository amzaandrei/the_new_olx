//
//  chatPageInfo.swift
//  coolAnimation
//
//  Created by Andrew on 1/19/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import Contacts
import ContactsUI
class chatPageInfo: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource,MFMessageComposeViewControllerDelegate, CNContactViewControllerDelegate {
    
    var userInfoData = [User]()
    var numberOfRows = ["","Notifications","Save number","Ignore Messages","Block"]
    var userFirebaseMessages = [String]()
    var allPicturesUrls = [String]()
    var activityText = ""
    
    var userInfoName: String! = nil{
        didSet{
            fetchUserContent(userInfoName: userInfoName)
        }
    }
    let cellId = "cellId"
    var myProfileKey: String! = nil
    var userFirebaseKey: String! = nil{
        didSet{
            if userFirebaseKey != nil{
                self.getImages(myProfileKey: self.myProfileKey,userFirebaseKey: self.userFirebaseKey)
            }
        }
    }
    
    lazy var myTable: UITableView = {
        let myTable = UITableView()
        myTable.translatesAutoresizingMaskIntoConstraints = false
//        myTable.tableFooterView = UIView()
        myTable.register(customTableCell.self, forCellReuseIdentifier: "cellId")
        return myTable
    }()
    
    let cellIdMyColl = "cellIdMyColl"
    lazy var myColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 3
        let myColl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myColl.delegate = self
        myColl.dataSource = self
        myColl.translatesAutoresizingMaskIntoConstraints = false
        myColl.backgroundColor = UIColor.white
        myColl.register(cumstomCollCell.self, forCellWithReuseIdentifier: "cellIdMyColl")
        return myColl
    }()
    var tableHeight: CGFloat = 0.0
    override func viewDidLoad() {
        self.view.addSubview(self.myTable)
        var nr = 0
        self.myTable.alwaysBounceVertical = false
        self.myTable.alwaysBounceHorizontal = false
        for (index, _) in numberOfRows.enumerated(){
//            if index != 0 {
//                tableHeight += Int(UITableViewAutomaticDimension)
//            }else{
//                tableHeight += 80
//            }
            self.tableHeight += index == 0 ? UITableViewAutomaticDimension : 80
            nr += 1
        }
        self.view.addSubview(self.myColl)
        myProfileKey = Auth.auth().currentUser!.uid
        self.addObserver(self, forKeyPath: "userFirebaseKey", options: [], context: nil)
        self.addConstraints()
    }
    
    func addConstraints(){
        myTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTable.heightAnchor.constraint(equalToConstant: self.tableHeight).isActive = true
        
        myColl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myColl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myColl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myColl.topAnchor.constraint(equalTo: myTable.bottomAnchor).isActive = true
    }
    
    func fetchUserContent(userInfoName: String){
        
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for allChilds in  snapshot.children.allObjects as! [DataSnapshot]{
                guard let object = allChilds.value as? [String: AnyObject] else { return }
                if object["name"] as? String  == userInfoName{ //// aici
                    let dict = User(dictionary: object)
                    let activeStatement = object["active"] as? Bool
                    if activeStatement!{
                        self.activityText = "Active now"
                    }else{
                        let pastData = object["timeActibity"] as? NSNumber
                        let date = Date(timeIntervalSince1970: (pastData?.doubleValue)!)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm a"
                        self.activityText = "Last seen at: " + dateFormatter.string(from: date)
                    }
                    self.userInfoData.append(dict)
                    DispatchQueue.main.async {
                        self.userFirebaseKey = allChilds.key
                        
                        self.myTable.delegate = self
                        self.myTable.dataSource = self
                        self.myTable.reloadData()
                    }
                }
            }
        }) { (err) in
            print(err.localizedDescription)
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.userFirebaseKey = nil
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "userFirebaseKey"{
//            DispatchQueue.main.async {
//                if self.myProfileKey != nil && self.userFirebaseKey != nil{
//                    self.getImages(myProfileKey: self.myProfileKey,userFirebaseKey: self.userFirebaseKey)
//                }
//            }
//        }
//    }
    
    func getImages(myProfileKey: String,userFirebaseKey: String){
        var userArrayKeys = [String]()
//        let group = DispatchGroup()
//        group.enter()
        let refUserMes = Database.database().reference().child("user-messages").child(userFirebaseKey)
        let refMes = Database.database().reference().child("messages")
        refUserMes.observe(.value, with: { (snapshot) in
            for obj in snapshot.children.allObjects as! [DataSnapshot]{
                let objKey = obj.key
                userArrayKeys.append(objKey)
            }
            refMes.observe(.value, with: { (snap) in
                for objMes in snap.children.allObjects as! [DataSnapshot]{
                    for userKeyElem in userArrayKeys{
                        if objMes.key == userKeyElem{
                            if let objValue = objMes.value as? [String: Any]{
                                let imageUrl = objValue["imageUrl"] as? String
                                let userKeyIdentifier = objValue["toId"] as? String
                                let myselfKeyIdentifier = objValue["fromId"] as? String
                                if imageUrl != nil{
                                    if (userKeyIdentifier == userFirebaseKey && myselfKeyIdentifier == myProfileKey) || (myselfKeyIdentifier == userFirebaseKey && userKeyIdentifier == myProfileKey){
                                        print(objMes.key)
                                        self.allPicturesUrls.append(imageUrl!)
                                        DispatchQueue.main.async(execute: {
                                            self.myColl.reloadData()
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }, withCancel: { (err2) in
                print(err2.localizedDescription)
                return
            })
//            group.leave()
        }) { (err) in
            print(err.localizedDescription)
            return
        }
//        group.wait()
        
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! customTableCell
        let rowText = numberOfRows[indexPath.row]
        if indexPath.row == 0{
            let userData = userInfoData[0]
            if let profileImageExists = userData.profileImageUrl{
                cell.profileImageView.loadImageUsingCacheString(urlString: profileImageExists)
            }
            cell.userNameLabel.text = userData.name
            cell.callButton.addTarget(self, action: #selector(callPerson), for: .touchUpInside)
            cell.messageButton.addTarget(self, action: #selector(messagePerson), for: .touchUpInside)
            cell.activityLabel.text = activityText
        }else{
            cell.callButton.isHidden = true
            cell.messageButton.isHidden = true
            cell.userNameLabel.text = rowText
            cell.activityLabel.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            saveThatNumberInMemory()
        }else if indexPath.row == 4{
            blockPerson()
        }
    }
    
    @objc func blockPerson(){
        
        let alertController = UIAlertController(title: "IMportant", message: "Do you you really want to block this person?", preferredStyle: .alert)
        let actionYeap = UIAlertAction(title: "Yeap", style: .default) { (_) in
            self.updateBlockUser()
        }
        let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(actionYeap)
        alertController.addAction(actionNo)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func updateBlockUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid).child("personsBlocked")
        guard let personToBlock = userFirebaseKey else { return }
        let value = ["\(personToBlock)": userInfoName]
        ref.updateChildValues(value) { (err, dataRef) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }
            print("Personed blocked")
        }
    }
    
    @objc func saveThatNumberInMemory(){
        guard let numberExist = userInfoData[0].numberContact else { return }
        guard let nameExist = userInfoData[0].name else { return }
        let con = CNMutableContact()
        con.givenName = nameExist
        con.phoneNumbers.append(CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: numberExist)))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = "Phone number"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = false
        self.navigationController?.pushViewController(unkvc, animated: true)
    }
    
    @objc func callPerson(){
        print("yeah")
        guard let numberExist = userInfoData[0].numberContact else { return }
        let url = URL(string: "tel://\(numberExist)")
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.open(url!, options: [:], completionHandler: { (possible) in
                if possible{
                    print("possible")
                }else{
                    print("impossible")
                }
            })
        }else{
            print("not possible do that action")
        }
    }
    
    
    @objc func messagePerson(){
        print("yeah")
        guard let numberExist = userInfoData[0].numberContact else { return }
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [numberExist]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            print("not possible do that action")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80
        }
        return UITableViewAutomaticDimension
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPicturesUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdMyColl, for: indexPath) as! cumstomCollCell
        let imagesData = allPicturesUrls[indexPath.row]
        cell.imagesView.loadImageUsingCacheString(urlString: imagesData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3 - 9, height: 100)
    }
    
}

class cumstomCollCell: UICollectionViewCell {
    
    let imagesView: UIImageView = {
        let image = UIImage(named: "hustle")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imagesView)
        
        
//        imagesView.bounds = self.frame
        addConstraints()
    }
    func addConstraints(){
        imagesView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imagesView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imagesView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imagesView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class customTableCell: UITableViewCell{
    
    let profileImageView: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let callButton: UIButton = {
        let image = UIImage(named: "call")
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let messageButton: UIButton = {
        let image = UIImage(named: "message")
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let userNameLabel: UILabel = {
        let text = UILabel()
        text.text = "mama"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let activityLabel: UILabel = {
        let text = UILabel()
        text.text = "mama"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.thin)
        return text
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cellId")
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(messageButton)
        addSubview(callButton)
        addSubview(activityLabel)
        addConstraints()
    }
    
    
    func addConstraints(){
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        activityLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5).isActive = true
        activityLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
        
        messageButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        messageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        callButton.rightAnchor.constraint(equalTo: messageButton.leftAnchor, constant: -15).isActive = true
        callButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        callButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



//    func getUserImage(){
//        let imageUrl = URL(string: self.userInfoData[0].profileImageUrl!)
//
//        let dataTask = URLSession.shared.dataTask(with: imageUrl!) { (data, response, err) in
//            if err != nil{
//                print(err?.localizedDescription)
//                return
//            }
//
//            if let imageData = UIImage(data: data!){
//
//            }
//        }
//    }






