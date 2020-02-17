//
//  myFavProdcut.swift
//  coolAnimation
//
//  Created by Andrew on 10/8/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import MessageUI
import Stripe

class MyFavProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate {
    
    var key = ""
    var category = ""
    var height: CGFloat = 250
    let cellId = "cellId"
    
    var arrayPhotosString = [String]()
    var arrayPhotos = [UIImage]()
    var allData = [Product]()
    
    lazy var myColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let myController = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myController.register(ProductCollCell.self, forCellWithReuseIdentifier: cellId)
        myController.isPagingEnabled = true
        myController.delegate = self
        myController.dataSource = self
        myController.translatesAutoresizingMaskIntoConstraints = false
        return myController
    }()
    
    lazy var pageController: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor.lightGray
        page.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        page.translatesAutoresizingMaskIntoConstraints = false
        return page
    }()
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "hustle"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(SMSSmth), for: .touchUpInside)
        return button
    }()
    
    let callButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "hustle"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(callSmth), for: .touchUpInside)
        return button
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(handleAddPaymentMethodButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        fetchContent()
        view.addSubview(myColl)
        view.addSubview(pageController)
        view.addSubview(callButton)
        view.addSubview(messageButton)
        view.addSubview(buyButton)
        addConstraints()
        self.edgesForExtendedLayout = []
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(dimiss))
        view.addGestureRecognizer(tapped)
    }
    
    
    
    
    @objc func SMSSmth(){
        if (MFMessageComposeViewController.canSendText()) {
            if let numberPhoneExist = allData[0].contactText{
                let messageView = MFMessageComposeViewController()
                messageView.delegate = self
                messageView.body = "Send message"
                messageView.recipients = ["\(numberPhoneExist)"]
                messageView.messageComposeDelegate = self
                present(messageView, animated: true, completion: nil)
            }
        }
    }
    @objc func callSmth(){
        if let numberPhoneExist = allData[0].contactText{
            let phone = "tel://\(numberPhoneExist)"
            let url = URL(string: phone)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchContent(){
        let ref = Database.database().reference().child("products").child(self.category).child(self.key)
        
        ref.child("photos").observe(.value, with: { (snapshot) in
            let count = Int(bitPattern: snapshot.childrenCount)
            let arrayCount = Array(0...count)
            if let dict = snapshot.value as? [String: Any]{
                for index in arrayCount{
                    var impKey = "photo\(index)"
                    if let imagesUrl = dict[impKey] as? String{
                        self.arrayPhotosString.append(imagesUrl)
                    }
                }
                self.downloadImages()
            }
        }, withCancel: nil)
        
        ref.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let contentVar = Product(dictionary: dict)
                self.allData.append(contentVar)
            }
        }, withCancel: nil )
        
    }
    
    func downloadImages(){
        for elem in self.arrayPhotosString{
            
            let imageUrl = URL(string: elem)
            
            let dataTask = URLSession.shared.dataTask(with: imageUrl!) { (data, response, err) in
                if err != nil{
                    print(err?.localizedDescription)
                }else{
                    DispatchQueue.main.async(execute: {
                        let image = UIImage(data: data!)
                        self.arrayPhotos.append(image!)
                        self.myColl.reloadData()
                        self.pageController.numberOfPages = self.arrayPhotos.count
                    })
                }
            }
            dataTask.resume()
        }
        
    }
    
    
    func addConstraints(){
        myColl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myColl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myColl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myColl.heightAnchor.constraint(equalToConstant: self.height).isActive = true
        
        pageController.bottomAnchor.constraint(equalTo: myColl.bottomAnchor, constant: -2).isActive = true
        pageController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        callButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -75).isActive = true
        callButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        callButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        messageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        buyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buyButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductCollCell
        let contentVar = arrayPhotos[indexPath.row]
        cell.mainPhoto.image = contentVar
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: self.height)
    }
    
    @objc func dimiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageController.currentPage = pageNumber
        
    }
    
}



