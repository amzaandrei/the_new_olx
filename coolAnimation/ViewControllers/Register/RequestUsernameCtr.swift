//
//  setNamePage.swift
//  coolAnimation
//
//  Created by Andrew on 7/10/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase

class RequestUsernameViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @objc let nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Please set your user name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    @objc let doneButton: UIButton = {
        let mainButton = UIButton(type: .system)
        mainButton.setTitle("Done", for: .normal)
        mainButton.setTitleColor(UIColor.white, for: .normal)
        mainButton.backgroundColor = UIColor.black
        mainButton.layer.cornerRadius = 5
        mainButton.clipsToBounds = true
        mainButton.addTarget(self, action: #selector(Done), for: .touchUpInside)
        mainButton.layer.borderColor = UIColor.white.cgColor
        mainButton.layer.borderWidth = 2
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        return mainButton
    }()
    
    
    @objc lazy var profileImage: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        view.addSubview(nameTextField)
        view.addSubview(doneButton)
        view.addSubview(profileImage)
        let tapped = UITapGestureRecognizer(target: self, action: #selector(findImage))
        profileImage.addGestureRecognizer(tapped)
        addConstraints()
    }
    
    @objc func addConstraints(){
        
        nameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25).isActive = true
        
        doneButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func findImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var finalPicture: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            finalPicture = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            finalPicture = originalImage
        }
        
        if let selectedPicture = finalPicture{
            profileImage.image = selectedPicture
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width: nameTextField.frame.size.width, height: nameTextField.frame.size.height)
        border.borderWidth = width
        nameTextField.layer.addSublayer(border)
        nameTextField.layer.masksToBounds = true
    }
    
    @objc func Done(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let imageData = UIImagePNGRepresentation(profileImage.image!) else { return }
        FirebaseUser.instanceShared.uploadUserProfileImg(uid: uid, imgData: imageData, additionalVal: ["name": self.nameTextField.text!]) { (res, err) in
            if res{
                let mainClasss = MainTabController()
                self.present(mainClasss, animated: true, completion: nil)
            }else{
                print(err)
            }
        }
    }
}




















