//
//  presentProduct.swift
//  coolAnimation
//
//  Created by Andrew on 10/6/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase

class ProductPresentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var key = ""
    var category = ""
    var height: CGFloat = 250
    let cellId = "cellId"
    
    var arrayPhotosString = [String]()
    var arrayPhotos = [UIImage]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(myColl)
        view.addSubview(pageController)
        addConstraints()
        self.edgesForExtendedLayout = []
        fetchContent()
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(dimiss))
        view.addGestureRecognizer(tapped)
    }
    
    func fetchContent(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("products").child(self.category).child(self.key).child("photos")
        
        ref.observe(.value, with: { (snapshot) in
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
