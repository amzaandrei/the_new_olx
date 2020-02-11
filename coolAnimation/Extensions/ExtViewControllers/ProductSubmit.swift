////
////  ProductSubmit.swift
////  coolAnimation
////
////  Created by Andrew on 2/12/20.
////  Copyright © 2020 Andrew. All rights reserved.
////
//
//import Foundation
//
//extension ProductSubmitController {
//    
//    func addCostraints(){
//        myColl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        myColl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        myColl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        myColl.heightAnchor.constraint(equalToConstant: height).isActive = true
//        
//        pageController.bottomAnchor.constraint(equalTo: myColl.bottomAnchor, constant: -2).isActive = true
//        pageController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        
//        basementCollController.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        basementCollController.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        basementBott = basementCollController.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: height)
//        basementBott.isActive = true
//        basementCollController.heightAnchor.constraint(equalToConstant: height).isActive = true
//        
//        doneButton.topAnchor.constraint(equalTo: basementCollController.topAnchor, constant: 10).isActive = true
//        doneButton.rightAnchor.constraint(equalTo: basementCollController.rightAnchor, constant: -15).isActive = true
//        doneButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        productNameTextField.topAnchor.constraint(equalTo: myColl.bottomAnchor, constant: 20).isActive = true
//        productNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        productNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        productNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        
//        
//        bottomProduct = productText.bottomAnchor.constraint(equalTo: productNameTextField.bottomAnchor)
//        bottomProduct.isActive = true
//        productText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        productText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        productText.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        
//        personNameTextField.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: 20).isActive = true
//        personNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        personNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        personNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        
//        bottomPerson = personText.bottomAnchor.constraint(equalTo: personNameTextField.bottomAnchor)
//        bottomPerson.isActive = true
//        personText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        personText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        personText.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        
//        describtionNameTextField.topAnchor.constraint(equalTo: personNameTextField.bottomAnchor, constant: 20).isActive = true
//        describtionNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        describtionNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        describtionNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        
//        bottomDescrib = describtionText.bottomAnchor.constraint(equalTo: describtionNameTextField.bottomAnchor)
//        bottomDescrib.isActive = true
//        describtionText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        describtionText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        describtionText.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        mailNameTextField.topAnchor.constraint(equalTo: describtionNameTextField.bottomAnchor, constant: 20).isActive = true
//        mailNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        mailNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        mailNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        
//        bottomMail = mailText.bottomAnchor.constraint(equalTo: mailNameTextField.bottomAnchor)
//        bottomMail.isActive = true
//        mailText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        mailText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        mailText.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        categoryTextField.topAnchor.constraint(equalTo: mailNameTextField.bottomAnchor, constant: 20).isActive = true
//        categoryTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        categoryTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        categoryTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        bottomCategory = categoryText.bottomAnchor.constraint(equalTo: categoryTextField.bottomAnchor)
//        bottomCategory.isActive = true
//        categoryText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        categoryText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        categoryText.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        LocationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        LocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//        LocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        LocationButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20).isActive = true
//        LocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////
//        
//        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
//        stack.heightAnchor.constraint(equalToConstant: height).isActive = true
//        stack.heightAnchor.constraint(equalToConstant: 100).isActive = true
////
//        allPhotos.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30).isActive = true
//        allPhotos.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40).isActive = true
//        allPhotos.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        allPhotos.widthAnchor.constraint(equalToConstant: 50).isActive = true
//
//        cameraPhoto.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30).isActive = true
//        cameraPhoto.bottomAnchor.constraint(equalTo: allPhotos.topAnchor,constant: -30).isActive = true
//        cameraPhoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        cameraPhoto.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
//        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        submitButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        submitButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
//        
//    }
//    
//    func sendLocation(citiName: String, countryName: String) {
//        self.cityNameVar = citiName
//        self.countryNameVar = countryName
//        self.locationLabel.text = "\(cityNameVar + " " + countryNameVar)"
//        
//        
//        if cityNameVar != nil && countryNameVar != nil{
//            
//            self.locationLabel.isHidden = false
//            self.LocationButton.isHidden = true
//            locationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//            locationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
//            locationLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20).isActive = true
//        }
//    }
//    
//}
//
