//
//  myFavouritProducts.swift
//  coolAnimation
//
//  Created by Andrew on 10/7/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase

class MyFavouritProductsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let cellId = "cellId"
    var objectContent = [object]()
    var objectImages = [Data]()
    lazy var myTable: UITableView = {
        let myTable = UITableView()
        myTable.tableFooterView = UIView()
        myTable.translatesAutoresizingMaskIntoConstraints = false
        myTable.register(pageTableCell.self, forCellReuseIdentifier: cellId)
        myTable.delegate = self
        myTable.dataSource = self
        return myTable
    }()
    
    var categoryArray = [String]()
    var keysArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Favourits"
        self.edgesForExtendedLayout = []
        view.addSubview(myTable)
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavContent()
    }
    
    let userDefaults = UserDefaults.standard
    func fetchFavContent(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let refFav = Database.database().reference().child("myFav").child(uid)
        let boolVal = userDefaults.bool(forKey: "cardAdded")
        if uid != nil && boolVal == true{
            self.objectContent.removeAll()
            self.categoryArray.removeAll()
            self.keysArray.removeAll()
            self.objectImages.removeAll()
            DispatchQueue.main.async {
                self.myTable.reloadData()
            }
            refFav.observeSingleEvent(of: .value, with: { (snapsoht) in
                let enumerate = snapsoht.children
                while let rest = enumerate.nextObject() as? DataSnapshot{
                    let enumerate2 = rest.children
                    while let rest2 = enumerate2.nextObject() as? DataSnapshot{
                        if let dict = rest2.value as? [String: Any]{
                            for childKey in dict.keys{
                                let category = rest.key
                                let ref = Database.database().reference().child("products").child(category).child("\(childKey)")
                                
                                self.categoryArray.append(category)
                                self.keysArray.append(childKey)
                                
                                ref.observe(.value, with: { (snapshot) in
                                    if let dict = snapshot.value as? [String: Any]{
                                        let contentVar = object(dictionary: dict)
                                        
                                        self.objectContent.append(contentVar)
                                        
                                    }
                                }, withCancel: nil)
                                
                                ref.child("photos").observe(.value, with: { (snapshot) in
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
                    }
                }
            }, withCancel: { (err) in
                print(err.localizedDescription)
                return
            })
        }
        
    }
    
    func reloadImage(valueUrl: String){
        
        var url = URL(string: valueUrl)
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err != nil{
                print(err?.localizedDescription)
            }else{
                
                if let imageData = data{
                    DispatchQueue.main.async(execute: {
                        self.objectImages.append(imageData)
                        if self.objectImages.count == self.objectContent.count{
                            self.myTable.reloadData()
                        }
                    })
                }
            }
        }
        dataTask.resume()
        
    }
    
    func addConstraints(){
        myTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectContent.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objectContentVar = objectContent[indexPath.row]
        let objectImagesVar = objectImages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! pageTableCell
        cell.textLabelName.text = objectContentVar.productText
        cell.detailedLabelName.text = objectContentVar.describText
        cell.profileImage.image = UIImage(data: objectImagesVar)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myFavProductPage = myFavProduct()
        myFavProductPage.key = self.keysArray[indexPath.row]
        myFavProductPage.category = self.categoryArray[indexPath.row]
        present(myFavProductPage, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.objectContent.remove(at: indexPath.row)
            self.myTable.deleteRows(at: [indexPath], with: .automatic)
            self.myTable.reloadRows(at: [indexPath], with: .automatic)
            self.myTable.reloadData()
        }
        
        let objectCon = objectContent[indexPath.row]
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("myFav").child(uid!)
        var number = 0
        ref.observe(.value) { (snapshot) in
            let enumarate = snapshot.children
            while let rest = enumarate.nextObject() as? DataSnapshot{
                let enumerate2 = rest.children
                while let rest2 = enumerate2.nextObject() as? DataSnapshot{
                    if let dict = rest2.value as? [String: Any]{
                        for childKey in dict.keys{
                            if number == indexPath.row{
                                ref.child(rest.key).child(rest2.key).observe(.value, with: { (snap) in
                                    print(snap.value)
                                })
//                               ref.child(rest.key).child(rest2.key).removeAllObservers()
                                return
                            }else{
                                number = number + 1
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
}















