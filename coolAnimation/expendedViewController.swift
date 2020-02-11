//
//  expendedViewController.swift
//  coolAnimation
//
//  Created by Andrew on 6/26/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class expendedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    

    let pages: [Page] = {
        
        let firstString = Page(imageName: "hustle", title: "No mire items :(", subText: "Come back soon for more or Tap below to sell an item!")
        let secondString = Page(imageName: "hustle", title: "Messages :)", subText: "You have no messages Tap below to sell an item")
        
        return [firstString, secondString]
    }()
    
    var category: [String] = [""]
    
    let reachiability = Reachability()!
    var openingFrame: CGRect!
    @objc var users = [User]()
    var allObject = [object]()
    var imageProductArr = [UIImage]()
    @objc let textView: UITextView = {
        let text = UITextView()
        text.text = "Sample text,yeah bitch"
        text.isEditable = false
        text.textAlignment = .center
//        text.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor.black
        return text
    }()
    
    @objc let noItemsImage: UIImageView = {
        let image = UIImage(named: "hustle")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    @objc let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("List a New Item", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = UIColor.purple.cgColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    @objc let card: UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        myView.layer.cornerRadius = 15
        myView.clipsToBounds = true
        return myView
    }()
    
    @objc let productName: UILabel = {
       let text = UILabel()
        text.text = "Phone"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor.white
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.textAlignment = .center
        return text
    }()
    
    @objc let descriptionProduct: UILabel = {
        let text = UILabel()
        text.text = "Ana are mere si ii place fff mult merele"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor.white
        text.font = UIFont.boldSystemFont(ofSize: 16)
        return text
    }()
    
    @objc let imageProduct: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    @objc let thumbImage: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        return picker
    }()
    
    let categoryName: UITextView = {
        let text = UITextView()
        text.text = "Masina"
        text.backgroundColor = UIColor(white: 1,alpha: 0)
        text.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.textAlignment = .center
        text.isEditable = false
        return text
    }()
    
    let effectView: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effect.layer.cornerRadius = 8
        effect.layer.masksToBounds = true
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.color = UIColor.black
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    
    var dizisor: CGFloat!
    var manajedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manajedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseVC))
        self.view.addGestureRecognizer(tapGesture)

        dizisor = (view.frame.width / 2) / 0.61
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeCard))
        card.addGestureRecognizer(panGesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(registerNewCard))
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        card.addGestureRecognizer(tapped)
        openingFrame = self.view.frame
        self.navigationItem.titleView = categoryName
        
        addActivity()
        activityIndicator.startAnimating()
        findIfIsConnected()
        fetchContent(category: "Masina")
        
        findConnetionAndConstraints()
        
//        fetchUserData()
        
    }
    
    func fetchUserData(){
        
        let userFetch: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do{
            let allData = try manajedObjectContext.fetch(userFetch)
            guard let profileImage = allData[0].profileImage else { return }
            DispatchQueue.main.async {
                self.userImage.image = UIImage(data: profileImage)
                self.addConstraints()
            }
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navTapped = UITapGestureRecognizer(target: self, action: #selector(selectCategory))
        self.categoryName.addGestureRecognizer(navTapped)
        fetchCategoryList()
    }
    
    @objc func selectCategory(){
        self.addPicker()
    }
    
    func fetchCategoryList(){
        self.category.removeAll()
        let ref = Database.database().reference().child("products")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for product in snapshot.children.allObjects as! [DataSnapshot]{
                let productName = product.key
                self.category.append(productName)
                DispatchQueue.main.async {
                    self.categoryPicker.reloadAllComponents()
                }
            }
        }) { (err) in
            print(err.localizedDescription)
            return
        }
    }
    
    func addPicker(){
        view.addSubview(categoryPicker)
        categoryPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        categoryPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        categoryPicker.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!,constant: 0).isActive = true
        categoryPicker.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    func findConnetionAndConstraints(){
        reachiability.whenReachable = { _ in
            DispatchQueue.main.async(execute: {
                self.view.addSubview(self.card)
                self.card.addSubview(self.productName)
                self.card.addSubview(self.descriptionProduct)
                self.card.addSubview(self.imageProduct)
                self.imageProduct.addSubview(self.thumbImage)
                self.textView.text = "Random"
                self.addButton.setTitle("List Item", for: .normal)
                self.addCard()
            })
        }
        
        reachiability.whenUnreachable = { _ in
            DispatchQueue.main.async(execute: {
                self.view.addSubview(self.textView)
                self.view.addSubview(self.noItemsImage)
                self.view.addSubview(self.addButton)
                self.textView.text = "No connection"
                self.addButton.setTitle("Turn ON Wi-Fi", for: .normal)
                self.addButton.addTarget(self, action: #selector(self.openWifiSetting), for: .touchUpInside)
                self.cardExist()
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
        if reachiability.isReachable{
            DispatchQueue.main.async(execute: {
                
                self.textView.removeFromSuperview()
                self.noItemsImage.removeFromSuperview()
                self.addButton.removeFromSuperview()
                
                self.view.addSubview(self.card)
                self.card.addSubview(self.productName)
                self.card.addSubview(self.descriptionProduct)
                self.card.addSubview(self.imageProduct)
                self.imageProduct.addSubview(self.thumbImage)
                self.addCard()
                // #TODO: nu se incarca pozele ... trebuie sa ma uit de ce face asta :/
            })
        }else{
            DispatchQueue.main.async(execute: {
                self.card.removeFromSuperview()
                self.productName.removeFromSuperview()
                self.descriptionProduct.removeFromSuperview()
                self.imageProduct.removeFromSuperview()
                self.thumbImage.removeFromSuperview()
                
                self.view.addSubview(self.textView)
                self.view.addSubview(self.noItemsImage)
                self.view.addSubview(self.addButton)
                self.cardExist()
            })
        }
    }
    
    @objc func openWifiSetting(){
        let url = URL(string: "App-Prefs:root=WIFI")
        UIApplication.shared.open(url!, options: [:]) { (possible) in
            if possible{
                print("is possible")
            }else{
                print("isn't possbile")
            }
        }
        
    }
    
    @objc func imageTapped(){
        let presentObject = presentProduct()
        presentObject.key = keyValue
        presentObject.category = productCategory
        presentObject.transitioningDelegate = self
        presentObject.modalPresentationStyle = .custom
        let presentNav = UINavigationController(rootViewController: presentObject)
        present(presentNav, animated: true, completion: nil)
        
    }
    
    var imageUrlVar = [String]()
    var keyValue = ""
    var productCategory = ""
    
    var cardsNumber = 0
//    func fetchContent(index: Int,category: String?){
//        let uid = Auth.auth().currentUser?.uid
//        if uid != nil{
//            let ref = Database.database().reference().child("products")
//            ref.child(category!).observe(.value, with: { (snapshot) in
//                var indexVal = 0
//
//                let indexTotal = Int(bitPattern: snapshot.childrenCount)
//                if self.cardsNumber < indexTotal{
//                    for rest in snapshot.children.allObjects as! [DataSnapshot] {
//
//                        if indexVal == index{
//                            self.keyValue = rest.key
//                            self.productCategory = category!
//                            if let dict = rest.value as? [String: Any]{
//                                let content = object(dictionary: dict,urlArr: nil)
//                                self.allObject.append(content)
//                                self.reloadCards()
//                                self.allObject.removeAll()
//                                ref.child(category!).child(rest.key).child("photos").observe(.value, with: { (snapshot) in
//                                    if let dataExist = snapshot.value as? [String: Any]{
//                                        if let valueUrl = dataExist["photo0"] as? String{
//                                            DispatchQueue.main.async(execute: {
//                                                self.reloadImage(valueUrl: valueUrl)
//                                            })
////                                            let content = objects(dictionary: dict, urlArr: valueUrl)
////                                            self.allObject.append(content)
//                                        }
//                                    }
//                                }, withCancel: nil)
//
//                                break
//                            }
//                        }else{
//                            indexVal = indexVal + 1
//                        }
//
//                    }
//                }else{
//                    DispatchQueue.main.async(execute: {
//                        self.card.removeFromSuperview()
//                        self.productName.removeFromSuperview()
//                        self.descriptionProduct.removeFromSuperview()
//                        self.imageProduct.removeFromSuperview()
//                        self.thumbImage.removeFromSuperview()
//                        self.textView.text = "They are no more products for this category!"
//                        self.view.addSubview(self.textView)
//                        self.view.addSubview(self.noItemsImage)
//                        self.view.addSubview(self.addButton)
//                        self.addButton.addTarget(self, action: #selector(self.addProduct), for: .touchUpInside)
//                        self.cardExist()
//                    })
//                }
//            }, withCancel: nil)
//        }
//    }
    
    var indexTotal: Int = 0
    
    func fetchContent(category: String?){
        let ref = Database.database().reference().child("products")
        ref.child(category!).observe(.value, with: { (snapshot) in

            self.indexTotal = Int(bitPattern: snapshot.childrenCount)
            
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    self.keyValue = rest.key
                    self.productCategory = category!
                    if let dict = rest.value as? [String: Any]{
                        let content = object(dictionary: dict)
                        self.allObject.append(content)
                        ref.child(category!).child(rest.key).child("photos").observe(.value, with: { (snapshot) in
                            if let dataExist = snapshot.value as? [String: Any]{
                                if let valueUrl = dataExist["photo0"] as? String{
                                    DispatchQueue.main.async(execute: {
                                        self.reloadImage(valueUrl: valueUrl)
                                    })
                                }
                            }
                        }, withCancel: nil)
                    }
                }
//            DispatchQueue.main.async {
//                while true{
//                    if self.indexTotal == self.imageProductArr.count{
//                        for view in self.view.subviews {
//                            view.removeFromSuperview()
//                        }
//                        self.findConnetionAndConstraints()
//                        self.reloadCards(index: 0)
//                        break
//                    }
//                }
//            }
        }, withCancel: nil)
    }
    
    func reloadImage(valueUrl: String){
        let url = URL(string: valueUrl)
        //
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err != nil{
                print(err?.localizedDescription)
            }else{
                
                DispatchQueue.main.async(execute: {
                    if let image = UIImage(data: data!){
                        self.imageProductArr.append(image)
                    }
                })
            }
        }
        
        dataTask.resume()
    }
    
    
    func reloadCards(index: Int){
        let contentVar = allObject[index]
        let photoProduct = self.imageProductArr[index]
        if let productText = contentVar.productText, let describ = contentVar.describText{
            self.productName.text = productText
            self.descriptionProduct.text = describ
            self.imageProduct.image = photoProduct
        }
        self.allObject.remove(at: index)
        self.imageProductArr.remove(at: index)
    }
    
    @objc func addActivity(){
        self.view.addSubview(effectView)
        //        effectView.addSubview(activityIndicator)
        effectView.contentView.addSubview(activityIndicator)
        //        effectView.addSubview(loadingLabel)
        effectView.contentView.addSubview(loadingLabel)
        
        effectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        effectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        effectView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        effectView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        activityIndicator.leftAnchor.constraint(equalTo: effectView.leftAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: effectView.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 46).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 46).isActive = true
        
        
        loadingLabel.rightAnchor.constraint(equalTo: effectView.rightAnchor, constant: 5).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: effectView.centerYAnchor).isActive = true
        loadingLabel.heightAnchor.constraint(equalToConstant: 46).isActive = true
        loadingLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }

    @objc func addProduct(){
        let submitPage = ProductSubmitCtr()
        submitPage.alreadyCategory = categoryName.text
        present(submitPage, animated: true, completion: nil)
    }
    
    @objc func handleCloseVC(){
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func addCard(){
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        card.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        card.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        card.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        card.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        imageProduct.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15).isActive = true
        imageProduct.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 15).isActive = true
        imageProduct.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -15).isActive = true
        imageProduct.heightAnchor.constraint(equalToConstant: 275).isActive = true
        
        
        thumbImage.centerYAnchor.constraint(equalTo: imageProduct.centerYAnchor).isActive = true
        thumbImage.centerXAnchor.constraint(equalTo: imageProduct.centerXAnchor).isActive = true
        thumbImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        thumbImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        productName.topAnchor.constraint(equalTo: card.topAnchor, constant: 20).isActive = true
        productName.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        productName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        productName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        productName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        
        descriptionProduct.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10).isActive = true
        descriptionProduct.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        descriptionProduct.heightAnchor.constraint(equalToConstant: 20).isActive = true
        descriptionProduct.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        descriptionProduct.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
    }
    
    func addCardMore(){
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        card.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        card.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        card.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        card.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    var index = 0
    
    @objc func swipeCard(panGesture: UIPanGestureRecognizer){
        
        let card = panGesture.view!
        let point = panGesture.translation(in: view)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let xFromCenter = card.center.x - view.center.x
        let scale = min(100 / abs(xFromCenter),1)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / dizisor).scaledBy(x: scale, y: scale)
        
//        print("card: \(card.center.x)")
//        print("view: \(view.center.x)")
        
        
        if xFromCenter > 0{
            thumbImage.image = UIImage(named: "thumbUp")
        }else{
            thumbImage.image = UIImage(named: "thumbDown")
        }
        
        thumbImage.alpha = abs(xFromCenter) / self.view.center.x
        
        if panGesture.state == UIGestureRecognizerState.ended{
            
            if card.center.x < 75{
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (_) in
                    card.removeFromSuperview()
                    self.view.addSubview(card)
                    self.addCardMore()
                    card.transform = CGAffineTransform.identity
                    self.thumbImage.alpha = 0
                    card.alpha = 1
                    self.cardsNumber = self.cardsNumber + 1
                    self.index = self.index + 1
                    if(self.indexTotal == self.index){
                        self.noMoreProducts()
                        return
                    }
//                    self.fetchContent(index: self.index,category: self.categoryName.text)
                    let randomIndex = Int(arc4random_uniform(UInt32(self.allObject.count)))
                    self.reloadCards(index: randomIndex)
                })
                return
            }else if card.center.x > (view.frame.width - 75){
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (_) in
                    card.removeFromSuperview()
                    self.view.addSubview(card)
                    self.addCardMore()
                    card.transform = CGAffineTransform.identity
                    self.thumbImage.alpha = 0
                    card.alpha = 1
//                    self.cardsNumber = self.cardsNumber + 1
                    if(self.indexTotal == self.index){
                        self.noMoreProducts()
                        return
                    }
                    let randomIndex = Int(arc4random_uniform(UInt32(self.allObject.count)))
                    self.reloadCards(index: randomIndex)
                    self.addFavourits(index: randomIndex,category: self.categoryName.text)
                    self.index = self.index + 1
                    
//                    self.fetchContent(index: self.index,category: self.categoryName.text)
                })
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                card.center = self.view.center
                self.thumbImage.alpha = 0
                card.transform = CGAffineTransform.identity
            }
        }
        
    }
    
    func noMoreProducts(){
        DispatchQueue.main.async(execute: {
            self.card.removeFromSuperview()
            self.productName.removeFromSuperview()
            self.descriptionProduct.removeFromSuperview()
            self.imageProduct.removeFromSuperview()
            self.thumbImage.removeFromSuperview()
            self.textView.text = "They are no more products for this category!"
            self.view.addSubview(self.textView)
            self.view.addSubview(self.noItemsImage)
            self.view.addSubview(self.addButton)
            self.addButton.addTarget(self, action: #selector(self.addProduct), for: .touchUpInside)
            self.cardExist()
        })
    }
    
    let userDefaults = UserDefaults.standard
    var favWasAdded = false
    @objc func addFavourits(index: Int,category: String){
        favWasAdded = true
        userDefaults.set(favWasAdded, forKey: "cardAdded")
        let uid = Auth.auth().currentUser?.uid
        if uid != nil{
            let refFav = Database.database().reference().child("myFav").child(uid!).child("\(category)").childByAutoId()
            
            
            let ref = Database.database().reference().child("products")
            ref.child(category).observe(.value, with: { (snapshot) in
                
                var indexVal = 0
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if indexVal == index{
                        if let dict = rest.value as? [String: Any]{
                            
                            let values = ["\(rest.key)": 1]
                            refFav.setValue(values, withCompletionBlock: { (err, ref) in
                                if err != nil{
                                    print(err?.localizedDescription)
                                }else{
                                    print("Fav added")
                                }
                            })
                            break
                        }
                    }else{
                        indexVal = indexVal + 1
                    }
                }
            }, withCancel: nil)
        }
//
    }
    
    @objc func cardExist(){
        self.view.addSubview(noItemsImage)
        self.view.addSubview(addButton)
        self.view.addSubview(textView)
        
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        
        noItemsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noItemsImage.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -10).isActive = true
        noItemsImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        noItemsImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    @objc func registerNewCard(){
        
        let submittinPage = ProductSubmitCtr()
        let submittNav = UINavigationController(rootViewController: submittinPage)
        present(submittNav, animated: true, completion: nil)
    }
    
    //    TODO: these 3 functions are not useful anymore
    
    @objc func findIfIsConnected(){
        let uid = Auth.auth().currentUser?.uid
        if uid != nil{
            let ref = Database.database().reference().child("users").child(uid!)
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let user = User(dictionary: dictionary)
                    self.users.append(user)
                    if let imageUrl = user.profileImageUrl{
//                        self.setImageUserNav(imageUrl: imageUrl)
                    }
                }
                
            })
        }else{
        }
    }
    
    let userImage: UIImageView = {
        let button = UIImageView()
//        button.addTarget(self, action: #selector(profileDataPage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    
    @objc func setImageUserNav(imageUrl: String){
        let url = URL(string: imageUrl)
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err != nil{
                print(err!)
            }else{

                DispatchQueue.main.async(execute: {
                    let image = UIImage(data: data!)
                    self.userImage.image = image
                    self.addConstraints()
                })
            }
        }
        dataTask.resume()
    }
    
    func addConstraints(){
        let item = UIBarButtonItem(customView: self.userImage)
        self.navigationItem.setLeftBarButton(item, animated: false)
        userImage.heightAnchor.constraint(equalToConstant: 38).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 38).isActive = true
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
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = ExpandAnimation.animator
        presentationAnimator.openingFrame = openingFrame
        presentationAnimator.transitionMode = .Present
        return presentationAnimator
        
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = ExpandAnimation.animator
        presentationAnimator.openingFrame = openingFrame
        presentationAnimator.transitionMode = .Dismiss
        return presentationAnimator
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0{
            if category[row] != ""{
                DispatchQueue.main.async(execute: {
                    self.view.addSubview(self.card)
                    self.card.addSubview(self.productName)
                    self.card.addSubview(self.descriptionProduct)
                    self.card.addSubview(self.imageProduct)
                    self.imageProduct.addSubview(self.thumbImage)
                    self.addCard()
                    self.textView.removeFromSuperview()
                    self.noItemsImage.removeFromSuperview()
                    self.addButton.removeFromSuperview()
                })
                self.categoryName.text = category[row]
                self.categoryPicker.removeFromSuperview()
                self.cardsNumber = 0
                self.index = 0
                self.allObject.removeAll()
                self.imageProductArr.removeAll()
                self.fetchContent(category: self.categoryName.text)
            }else{
                let alertController = UIAlertController(title: "Important", message: "Please set your category preference", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    
}

