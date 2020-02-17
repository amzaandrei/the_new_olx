//
//  changeUserProfileData.swift
//  coolAnimation
//
//  Created by Andrew on 1/22/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import Firebase

class ChangeUserDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cellId = "cellId"
    var userData: User!
    var cellTapped: String! = ""
    
    let rowsText = ["","Name","Email","Number"]
    
    @objc let chatBox: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Send a message to...."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(uploadData), for: .touchUpInside)
        return button
    }()
    
    @objc let separator: UIView = {
        let linie = UIView()
        linie.translatesAutoresizingMaskIntoConstraints = false
        linie.backgroundColor = UIColor.black
        return linie
    }()
    
    lazy var myTable: UITableView = {
        let myTable = UITableView()
        myTable.translatesAutoresizingMaskIntoConstraints = false
        myTable.register(custommTableCell.self, forCellReuseIdentifier: cellId)
        myTable.tableFooterView = UIView()
        return myTable
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myTable)
        view.addSubview(chatBox)
        view.addSubview(sendButton)
        view.addSubview(separator)
        textFiledAnimateAndConstraints()
        addConstraints()
        fetchUserContent(refresh: false)
        viewTappedDismissKeyboard()
    }
    var heightBottomchatBox: NSLayoutConstraint!
    var heightBottomseparator: NSLayoutConstraint!
    var heightBottomsendButton: NSLayoutConstraint!
    func textFiledAnimateAndConstraints(){
        self.chatBox.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.chatBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.chatBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -70).isActive = true
        heightBottomchatBox = self.chatBox.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0)
        heightBottomchatBox.isActive = true
        
        heightBottomseparator = self.separator.bottomAnchor.constraint(equalTo: self.chatBox.topAnchor)
        heightBottomseparator.isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        self.sendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        heightBottomsendButton = self.sendButton.bottomAnchor.constraint(equalTo: chatBox.bottomAnchor)
        heightBottomsendButton.isActive = true
    }
    
    func viewTappedDismissKeyboard(){
        UIView.animate(withDuration: 1) {
            self.heightBottomchatBox.constant = 0
        }
    }
    
    @objc func animateTextField(){
        UIView.animate(withDuration: 1) {
            self.heightBottomchatBox.constant = -150
//            self.heightBottomseparator.constant = -50
//            self.heightBottomsendButton.constant = -59
            self.view.layoutIfNeeded()
        }
    }
    
    func fetchUserContent(refresh: Bool){
        var refreshData : User!
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirebaseUser.instanceShared.collectUserData(uid: uid) { (user, err) in
            if let userEx = user{
                if !refresh{
                    self.userData = userEx
                }else{
                    refreshData = userEx
                }
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                    self.myTable.delegate = self
                    self.myTable.dataSource = self
                }
            }else{
                print(err)
            }
        }
        
    }
    
    func addConstraints(){
        myTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! custommTableCell
        let rowTextData = rowsText[indexPath.row]
        if indexPath.row == 0{
            cell.profileImageView.loadImageUsingCacheString(urlString: userData.profileImageUrl!)
            cell.otherLabels.text = "Profile Image"
        }else if indexPath.row == 1{
            cell.otherLabels.text = rowTextData + " : " + userData.name!
            cell.profileImageView.image = UIImage(named: "name")
        }else if indexPath.row == 2{
            cell.otherLabels.text = rowTextData + " : " + userData.email!
            cell.profileImageView.image = UIImage(named: "email")
        }else if indexPath.row == 3{
            if let contactNumber = userData.numberContact {
                cell.otherLabels.text = rowTextData + " : " + contactNumber
                cell.profileImageView.image = UIImage(named: "contact")
            }else{
                cell.otherLabels.text = rowTextData + " : " + "not available yet"
                cell.profileImageView.image = UIImage(named: "contact")
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            changePicture()
        }else{
            if indexPath.row == 1{
                cellTapped = "name"
            }else if indexPath.row == 2{
                cellTapped = "email"
            }else if indexPath.row == 3{
                cellTapped = "contact"
            }
            animateTextField()
        }
    }
    
    @objc func uploadData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let textFieldUpdate = chatBox.text else { return }
        let values = [cellTapped: textFieldUpdate]
        FirebaseUser.instanceShared.updateUserChildData(uid: uid, values: values as! FirebaseUser.JSONStandard) { (res, err) in
            if res{
                print("updated")
                self.chatBox.text = ""
                self.fetchUserContent(refresh: true)
            }else{
                print(err)
            }
        }
    }
    
    @objc func changePicture(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        var finalPicture: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            finalPicture = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            finalPicture = originalImage
        }
        
        if let selectedImage = finalPicture{
            //            profileImage.image = selectedImage
            //            bigProfilePicture.image = selectedImage
            
            let compressedImage = UIImageJPEGRepresentation(selectedImage, 0.2)
            
            self.changeUserProfilImage(compressedImage: compressedImage!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeUserProfilImage(compressedImage: Data){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        FirebaseUser.instanceShared.uploadUserProfileImg(uid: uid, imgData: compressedImage) { (res, err) in
            if res{
                print("Your data was succesfullt updated")
            }else{
                print(err)
            }
        }
        
    }
    
}


class custommTableCell: UITableViewCell {
    
    
    
    let profileImageView: UIImageView = {
        let image = UIImage(named: "hustle")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    let otherLabels: UILabel = {
        let text = UILabel()
        text.text = "mama"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cellId")
        addSubview(profileImageView)
        addSubview(otherLabels)
        addConstraints()
    }
    
    func addConstraints(){
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        otherLabels.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        otherLabels.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        otherLabels.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        otherLabels.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        otherLabels.heightAnchor.constraint(equalToConstant: 25).isActive = true
        otherLabels.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

