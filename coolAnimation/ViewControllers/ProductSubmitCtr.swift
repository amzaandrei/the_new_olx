//
//  submittingForm.swift
//  coolAnimation
//
//  Created by Andrew on 10/2/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import Firebase
class ProductSubmitCtr: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    let cellId = "cellId"
    let cellId2 = "cellId2"
    var arrayPhotos: [UIImage] = [UIImage(named: "hustle")!]
    var allLibraryPhotos = [UIImage]()
    var category: [String] = [""]
//    ,"Masina","Smartphones","Mobilier"
    var alreadyCategory: String!{
        didSet{
            categoryTextField.text = alreadyCategory
        }
    }
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureVideoDataOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var height: CGFloat = 250
    
    var countryNameVar: String! = nil
    var cityNameVar: String! = nil
    
    lazy var categoryPicker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsSelectionIndicator = true
        return picker
    }()
    
    lazy var myColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let myController = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myController.translatesAutoresizingMaskIntoConstraints = false
        myController.isPagingEnabled = true
        myController.delegate = self
        myController.dataSource = self
        myController.register(ImagePickerCollView.self, forCellWithReuseIdentifier: cellId)
        myController.backgroundColor = UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1)
        return myController
    }()
    
    lazy var basementCollController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        let myController = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myController.translatesAutoresizingMaskIntoConstraints = false
        myController.delegate = self
        myController.dataSource = self
        myController.isPagingEnabled = true
        myController.register(ImagePickerCollView.self, forCellWithReuseIdentifier: cellId2)
        myController.backgroundColor = UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1)
        return myController
    }()
    
    @objc let submitButton: UIButton = {
        let mainButton = UIButton(type: .system)
        mainButton.setTitle("Submit", for: .normal)
        mainButton.setTitleColor(UIColor.black, for: .normal)
        //        mainButton.backgroundColor = UIColor.black
        mainButton.layer.cornerRadius = 5
        mainButton.clipsToBounds = true
        mainButton.addTarget(self, action: #selector(Done), for: .touchUpInside)
        //        mainButton.layer.borderColor = UIColor.white.cgColor
        mainButton.layer.borderWidth = 2
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        return mainButton
    }()
    
    @objc let doneButton: UIButton = {
        let mainButton = UIButton(type: .system)
        mainButton.setTitle("Done", for: .normal)
        mainButton.setTitleColor(UIColor.white, for: .normal)
        //        mainButton.backgroundColor = UIColor.black
        mainButton.layer.cornerRadius = 5
        mainButton.clipsToBounds = true
        mainButton.addTarget(self, action: #selector(savePhotos), for: .touchUpInside)
        mainButton.layer.borderColor = UIColor.white.cgColor
        mainButton.layer.borderWidth = 2
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        return mainButton
    }()
    
    @objc let LocationButton: UIButton = {
        let mainButton = UIButton(type: .system)
        mainButton.setTitle("Set location", for: .normal)
        mainButton.setTitleColor(UIColor.red, for: .normal)
        //        mainButton.backgroundColor = UIColor.black
        mainButton.layer.cornerRadius = 5
        mainButton.clipsToBounds = true
        mainButton.addTarget(self, action: #selector(setLocation), for: .touchUpInside)
        mainButton.layer.borderColor = UIColor.white.cgColor
        mainButton.layer.borderWidth = 2
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        return mainButton
    }()
    
    @objc let productNameTextField: UITextField = {
        let textField = UITextField()
        //        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Please set your user name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Product name!"
        textField.addTarget(self, action: #selector(animateProduct), for: .editingChanged)
        textField.backgroundColor = UIColor.clear
        return textField
    }()
    
    let productText: UILabel = {
        let text = UILabel()
        text.text = "Product name!"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.backgroundColor = UIColor.clear
        text.alpha = 0
        return text
    }()
    
    
    @objc let personNameTextField: UITextField = {
        let textField = UITextField()
        //        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Please set your user name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Contact!"
        textField.addTarget(self, action: #selector(animateProduct), for: .editingChanged)
        textField.backgroundColor = UIColor.clear
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let personText: UILabel = {
        let text = UILabel()
        text.text = "Contact!"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.backgroundColor = UIColor.clear
        text.alpha = 0
        return text
    }()
    
    
    
    @objc let describtionNameTextField: UITextField = {
        let textField = UITextField()
        //        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Please set your user name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Describe your product!"
        textField.addTarget(self, action: #selector(animateProduct), for: .editingChanged)
        textField.backgroundColor = UIColor.clear
        return textField
    }()
    
    let describtionText: UILabel = {
        let text = UILabel()
        text.text = "Describe your product!"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.backgroundColor = UIColor.clear
        text.alpha = 0
        return text
    }()
    
    @objc let mailNameTextField: UITextField = {
        let textField = UITextField()
        //        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Please set your user name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Set your email!"
        textField.addTarget(self, action: #selector(animateProduct), for: .editingChanged)
        textField.backgroundColor = UIColor.clear
        return textField
    }()
    
    
    let mailText: UILabel = {
        let text = UILabel()
        text.text = "Set your email!"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.backgroundColor = UIColor.clear
        text.alpha = 0
        return text
    }()
    
    @objc let categoryTextField: UITextField = {
        let textField = UITextField()
        //        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Please set your user name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "What type of product is?"
        textField.addTarget(self, action: #selector(addPicker), for: .editingChanged)
        textField.backgroundColor = UIColor.clear
        return textField
    }()
    
    
    let categoryText: UILabel = {
        let text = UILabel()
        text.text = "What type of product is?"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.backgroundColor = UIColor.clear
        text.alpha = 0
        return text
    }()
    
    
    
    lazy var pageController: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor.lightGray
        page.numberOfPages = self.arrayPhotos.count
        page.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        page.translatesAutoresizingMaskIntoConstraints = false
        return page
    }()
    
    let cameraPhoto: UIImageView = {
        let image = UIImage(named: "camera")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
    }()
    
    
    let allPhotos: UIImageView = {
        let image = UIImage(named: "photos")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
    }()
    
    let toolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        return toolBar
    }()
    
    let locationLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.isHidden = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var stack: UIStackView!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        view.addSubview(myColl)
        view.addSubview(pageController)
        view.addSubview(submitButton)
        view.addSubview(productText)
        view.addSubview(productNameTextField)
        view.addSubview(personNameTextField)
        view.addSubview(personText)
        view.addSubview(describtionNameTextField)
        view.addSubview(describtionText)
        view.addSubview(LocationButton)
        view.addSubview(locationLabel)
        
        view.addSubview(mailNameTextField)
        view.addSubview(mailText)
        view.addSubview(categoryTextField)
        view.addSubview(categoryText)
        view.addSubview(basementCollController)
        view.addSubview(cameraPhoto)
        view.addSubview(allPhotos)
        view.addSubview(doneButton)
        
        fetchCategoryList()
        
        productNameTextField.becomeFirstResponder()
        
        self.edgesForExtendedLayout = []
        
        stack = UIStackView(arrangedSubviews: [cameraPhoto,allPhotos])
        stack.distribution = .fillEqually
        stack.axis  = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 30
        view.addSubview(stack)
        
        
        let cameraTapped = UITapGestureRecognizer(target: self, action: #selector(addCamera))
        cameraPhoto.addGestureRecognizer(cameraTapped)
        let photosTapped = UITapGestureRecognizer(target: self, action: #selector(addLibraryPhotos))
        allPhotos.addGestureRecognizer(photosTapped)
        
        let viewTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        view.addGestureRecognizer(viewTapped)
        
        //        let donePickerButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        let spacePickerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelPickerButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismisPicker))
        
        toolbar.setItems([spacePickerButton, cancelPickerButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolbar
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissView))
        
        addCostraints()
        fetchUserEmail()
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func fetchCategoryList(){
        let ref = Database.database().reference().child("products")
        ref.observe(.value, with: { (snapshot) in
            for product in snapshot.children.allObjects as! [DataSnapshot]{
                let productName = product.key
                self.category.append(productName)
            }
            self.category.append("Custom")
        }) { (err) in
            print(err.localizedDescription)
            return
        }
    }
    
    @objc func dismisPicker(){
        self.view.endEditing(true)
    }
    
    @objc func dismissKey(){
        self.view.endEditing(true)
    }
    
    func fetchUserEmail(){
        
        let reference = Database.database().reference().child("users")
        let uid = Auth.auth().currentUser?.uid
        reference.child(uid!).observe(.value, with: { (snapshot) in
            if let exist = snapshot.value as? [String: Any]{
                DispatchQueue.main.async(execute: {
                    self.mailNameTextField.text = exist["email"] as? String
                })
            }
        }, withCancel: nil)
        
    }
    
    let inputVieww: UIView = {
        let input = UIView()
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
    @objc func addPicker(){
        
        if categoryTextField.placeholder == "Custom product name"{
            categoryTextField.becomeFirstResponder()
            print("yeah")
        }else{
            
            self.view.addSubview(categoryPicker)
            categoryPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            categoryPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            categoryPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            categoryPicker.heightAnchor.constraint(equalToConstant: 250).isActive = true
        }
    }
    
    var basementBott: NSLayoutConstraint!
    var bottomProduct: NSLayoutConstraint!
    var bottomPerson: NSLayoutConstraint!
    var bottomDescrib: NSLayoutConstraint!
    var bottomMail: NSLayoutConstraint!
    var bottomCategory: NSLayoutConstraint!
    
    
    
    
    @objc func animateProduct(){
        if self.productNameTextField.text != "" {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.productText.alpha = 1
                self.bottomProduct.constant = -20
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.productText.alpha = 0
                self.bottomProduct.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if self.personNameTextField.text != "" {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.personText.alpha = 1
                self.bottomPerson.constant = -20
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.personText.alpha = 0
                self.bottomPerson.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if self.describtionNameTextField.text != "" {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.describtionText.alpha = 1
                self.bottomDescrib.constant = -20
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.describtionText.alpha = 0
                self.bottomDescrib.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if self.mailNameTextField.text != "" {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.mailText.alpha = 1
                self.bottomMail.constant = -20
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.mailText.alpha = 0
                self.bottomMail.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if self.categoryTextField.text != "" {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.categoryText.alpha = 1
                self.bottomCategory.constant = -20
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.categoryText.alpha = 0
                self.bottomCategory.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    @objc func setLocation(){
        let locationView = LocationViewController()
        let locationNav = UINavigationController(rootViewController: locationView)
        locationView.chooseDelegate = self
        present(locationNav, animated: true, completion: nil)
    }
    
    @objc func addCamera(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
        isVisible = false
        // #TODO Here tot intra pe isVisible ca true
        
    }
    
    @objc func addLibraryPhotos(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        isVisible = false
        // #TODO Here tot intra pe isVisible ca true
    }
    
    
    
    @objc func Done(){
        
        //        borderMail.shake()
        guard let productText = productNameTextField.text, let contactText = personNameTextField.text, let describText = describtionNameTextField.text, let emailText = mailNameTextField.text, let categoryText = categoryTextField.text, let mainLocation = locationLabel.text else {
        
            let actionController = UIAlertController(title: "Important", message: "Please fill in all text fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            actionController.addAction(action)
            present(actionController, animated: true, completion: nil)
            return
        }
        
        if arrayPhotos.count == 1{
            let actionController = UIAlertController(title: "Important", message: "Please add more photos", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            actionController.addAction(action)
            present(actionController, animated: true, completion: nil)
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("products").child("\(categoryText)").childByAutoId()
        ref.setValue([
            "productText": productText,
            "contactText": contactText,
            "describText": describText,
            "emailtext": emailText,
            "categoryText": categoryText,
            "location": mainLocation,
            "number": self.arrayPhotos.count
            ])
        let key = ref.key
        for (index,element) in arrayPhotos.enumerated(){
            if index != 0{
                
                let imageName = NSUUID().uuidString
                let refStorage = Storage.storage().reference().child("\(categoryText)").child(imageName)
                let updatedImage = UIImageJPEGRepresentation(arrayPhotos[index], 0.2)
                
                refStorage.putData(updatedImage!, metadata: nil, completion: { (metadata, err) in
                    if err != nil{
                        print(err?.localizedDescription)
                    }else{
//                        if let imageUrl = metadata?.downloadURL()?.absoluteString{
                        refStorage.downloadURL(completion: { (imageUrl, err) in
                            if err != nil{
                                debugPrint(err?.localizedDescription)
                            }
                            let values = ["photo\(index - 1)": imageUrl]
                            Database.database().reference().child("products").child("\(categoryText)").child(key!).child("photos").updateChildValues(values, withCompletionBlock: { (err, ref) in
                                if err != nil{
                                    print(err?.localizedDescription)
                                }else{
                                    print("Data succesfullt uploaded")
                                }
                            })
                        })
                        
//                        }
                    }
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func savePhotos(){
        isVisible = false
        DispatchQueue.main.async {
            self.pageController.numberOfPages = self.arrayPhotos.count
            self.myColl.reloadData()
        }
        basementBott.constant = 250
        cameraPhoto.isHidden = true
        allPhotos.isHidden = true
        // #TODO to scroll to that index
    }
    let width = CGFloat(2.0)

    lazy var borderProduct: CALayer = {
        let borderShape = CALayer()
        borderShape.borderWidth = width
        borderShape.borderColor = UIColor.darkGray.cgColor
        return borderShape
    }()
    
    lazy var borderContact: CALayer = {
        let borderShape = CALayer()
        let width = CGFloat(2.0)
        borderShape.borderWidth = width
        borderShape.borderColor = UIColor.darkGray.cgColor
        return borderShape
    }()
    
    lazy var borderDescrib: CALayer = {
        let borderShape = CALayer()
        borderShape.borderWidth = width
        borderShape.borderColor = UIColor.darkGray.cgColor
        return borderShape
    }()
    
    lazy var borderMail: CALayer = {
        let borderShape = CALayer()
        borderShape.borderWidth = width
        borderShape.borderColor = UIColor.darkGray.cgColor
        return borderShape
    }()
    
    lazy var borderCategory: CALayer = {
        let borderShape = CALayer()
        borderShape.borderWidth = width
        borderShape.borderColor = UIColor.darkGray.cgColor
        return borderShape
    }()
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        borderProduct.frame = CGRect(x: 0, y: productNameTextField.frame.size.height - width, width: productNameTextField.frame.size.width, height: productNameTextField.frame.size.height)
        borderContact.frame = CGRect(x: 0, y: personNameTextField.frame.size.height - width, width: personNameTextField.frame.size.width, height: personNameTextField.frame.size.height)
        borderDescrib.frame = CGRect(x: 0, y: describtionNameTextField.frame.size.height - width, width: describtionNameTextField.frame.size.width, height: describtionNameTextField.frame.size.height)
        borderMail.frame = CGRect(x: 0, y: mailNameTextField.frame.size.height - width, width: mailNameTextField.frame.size.width, height: mailNameTextField.frame.size.height)
        borderCategory.frame = CGRect(x: 0, y: categoryTextField.frame.size.height - width, width: categoryTextField.frame.size.width, height: categoryTextField.frame.size.height)
        
        
        productNameTextField.layer.addSublayer(borderProduct)
        productNameTextField.layer.masksToBounds = true
        personNameTextField.layer.addSublayer(borderContact)
        personNameTextField.layer.masksToBounds = true
        describtionNameTextField.layer.addSublayer(borderDescrib)
        describtionNameTextField.layer.masksToBounds = true
        mailNameTextField.layer.addSublayer(borderMail)
        mailNameTextField.layer.masksToBounds = true
        categoryTextField.layer.addSublayer(borderCategory)
        categoryTextField.layer.masksToBounds = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageController.currentPage = pageNumber
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if category[row] == "Custom"{
            categoryTextField.inputView = nil
            categoryTextField.inputAccessoryView = nil
            categoryTextField.text = ""
            categoryTextField.placeholder = "Custom product name"
        }else{
            categoryTextField.text = category[row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isVisible{
            return arrayPhotos.count
        }else{
            return allLibraryPhotos.count
        }
    }
    
    var isVisible: Bool! = false
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !isVisible{
            let cell = myColl.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImagePickerCollView
            let mainArrayPhotos = arrayPhotos[indexPath.row]
            cell.mainPhoto.image = mainArrayPhotos
            
            let tapped = myTapp(target: self, action: #selector(cellTapp))
            cell.addGestureRecognizer(tapped)
            return cell
        }else{
            let basementArrayPhotos = allLibraryPhotos[indexPath.row]
            let cell2 = basementCollController.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ImagePickerCollView
            cell2.mainPhoto.image = basementArrayPhotos
            
            let tapped2 = myTapp(target: self, action: #selector(cell2Tapp))
            tapped2.cell = cell2
            tapped2.indexPath = indexPath
            cell2.addGestureRecognizer(tapped2)
            return cell2
        }
        
    }
    
    @objc func cellTapp(tapped: myTapp){
        isVisible = true
        basementCollController.reloadData()
        if self.allLibraryPhotos.count == 0{
            fetchPhotos()
        }
        self.cameraPhoto.isHidden = false
        self.allPhotos.isHidden = false
        animateBasement()
    }
    
    @objc func cell2Tapp(tapped: myTapp){
        UIView.animate(withDuration: 0.1) {
            tapped.cell.blurEffect.alpha = 0.8
            self.view.layoutIfNeeded()
        }
        self.arrayPhotos.append(self.allLibraryPhotos[tapped.indexPath.row])
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var finalImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            finalImage = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            finalImage = originalImage
        }
        
        if finalImage != nil{
            UIImageWriteToSavedPhotosAlbum(finalImage!, nil, nil, nil)
        }
        dismiss(animated: true) {
            self.arrayPhotos.append(finalImage!)
            self.pageController.numberOfPages = self.arrayPhotos.count
            self.myColl.reloadData()
        }
        
    }
    
    func animateBasement(){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.basementBott.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: height)
    }
    
}

extension ProductSubmitCtr {
    
    func fetchPhotos(){
        
        let imageManager = PHCachingImageManager()
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                allPhotos.enumerateObjects{(object: AnyObject!,count: Int,stop: UnsafeMutablePointer<ObjCBool>) in
                    
                    if object is PHAsset{
                        let asset = object as! PHAsset
                        
                        let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                        
                        let options = PHImageRequestOptions()
                        options.deliveryMode = .fastFormat
                        options.isSynchronous = true
                        options.isNetworkAccessAllowed = true
                        
                        imageManager.requestImage(for: asset,targetSize: imageSize,contentMode: .aspectFill,options: options,resultHandler: {(image, info) -> Void in
                            
                            if image != nil{
                                self.allLibraryPhotos.append(image!)
                            }
                            DispatchQueue.main.async(execute: {
                                self.basementCollController.reloadData()
                            })
                        })
                    }
                }
                
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
        
        
    }
    func addCostraints(){
        myColl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myColl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myColl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myColl.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        pageController.bottomAnchor.constraint(equalTo: myColl.bottomAnchor, constant: -2).isActive = true
        pageController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        basementCollController.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        basementCollController.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        basementBott = basementCollController.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: height)
        basementBott.isActive = true
        basementCollController.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        doneButton.topAnchor.constraint(equalTo: basementCollController.topAnchor, constant: 10).isActive = true
        doneButton.rightAnchor.constraint(equalTo: basementCollController.rightAnchor, constant: -15).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        productNameTextField.topAnchor.constraint(equalTo: myColl.bottomAnchor, constant: 20).isActive = true
        productNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        productNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        productNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        bottomProduct = productText.bottomAnchor.constraint(equalTo: productNameTextField.bottomAnchor)
        bottomProduct.isActive = true
        productText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        productText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        productText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        personNameTextField.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: 20).isActive = true
        personNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        personNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        personNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        bottomPerson = personText.bottomAnchor.constraint(equalTo: personNameTextField.bottomAnchor)
        bottomPerson.isActive = true
        personText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        personText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        personText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        describtionNameTextField.topAnchor.constraint(equalTo: personNameTextField.bottomAnchor, constant: 20).isActive = true
        describtionNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        describtionNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        describtionNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        bottomDescrib = describtionText.bottomAnchor.constraint(equalTo: describtionNameTextField.bottomAnchor)
        bottomDescrib.isActive = true
        describtionText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        describtionText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        describtionText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mailNameTextField.topAnchor.constraint(equalTo: describtionNameTextField.bottomAnchor, constant: 20).isActive = true
        mailNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        mailNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        mailNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        bottomMail = mailText.bottomAnchor.constraint(equalTo: mailNameTextField.bottomAnchor)
        bottomMail.isActive = true
        mailText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        mailText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        mailText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        categoryTextField.topAnchor.constraint(equalTo: mailNameTextField.bottomAnchor, constant: 20).isActive = true
        categoryTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        categoryTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        categoryTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        bottomCategory = categoryText.bottomAnchor.constraint(equalTo: categoryTextField.bottomAnchor)
        bottomCategory.isActive = true
        categoryText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        categoryText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        categoryText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        LocationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        LocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        LocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        LocationButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20).isActive = true
        LocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
        
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        stack.heightAnchor.constraint(equalToConstant: height).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        allPhotos.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30).isActive = true
//        allPhotos.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40).isActive = true
//        allPhotos.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        allPhotos.widthAnchor.constraint(equalToConstant: 50).isActive = true
//
//        cameraPhoto.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30).isActive = true
//        cameraPhoto.bottomAnchor.constraint(equalTo: allPhotos.topAnchor,constant: -30).isActive = true
//        cameraPhoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        cameraPhoto.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
    }
    
}

extension ProductSubmitCtr: sendLocationData{
    func sendLocation(citiName: String, countryName: String) {
        self.cityNameVar = citiName
        self.countryNameVar = countryName
        self.locationLabel.text = "\(cityNameVar + " " + countryNameVar)"
        
        
        if cityNameVar != nil && countryNameVar != nil{
            
            self.locationLabel.isHidden = false
            self.LocationButton.isHidden = true
            locationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
            locationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
            locationLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20).isActive = true
        }
    }
}


class myTapp: UITapGestureRecognizer{
    var cell = ImagePickerCollView()
    var indexPath = IndexPath()
}
























