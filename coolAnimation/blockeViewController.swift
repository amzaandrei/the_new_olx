//
//  blockeViewController.swift
//  coolAnimation
//
//  Created by Andrew on 1/26/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import Firebase
class blockeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let cellId = "cellId"
    var persArr = [User]()
    lazy var myTable: UITableView = {
        let myTable = UITableView()
        myTable.translatesAutoresizingMaskIntoConstraints = false
        myTable.register(custommTableCell.self, forCellReuseIdentifier: cellId)
        myTable.tableFooterView = UIView()
        myTable.delegate = self
        myTable.dataSource = self
        return myTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myTable)
        fetchPersonsBlocked()
        addConstraints()
    }
    
    func fetchPersonsBlocked(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid).child("personsBlocked")
        let refPerson = Database.database().reference().child("users")
        
        ref.observe(.value, with: { (snap) in
            if let dict = snap.value as? [String: AnyObject]{
                for personKey in dict.keys{
                    refPerson.observe(.value, with: { (snapshot) in
                        
                        for userObj in snapshot.children.allObjects as! [DataSnapshot]{
                            
                            if String(describing: personKey) == userObj.key {
                                if let dict = userObj.value as? [String: AnyObject]{
                                    let data = User(dictionary: dict)
                                    self.persArr.append(data)
                                    DispatchQueue.main.async {
                                        self.myTable.reloadData()
                                    }
                                }
                            }
                        }
                        
                    }, withCancel: { (err2) in
                        print(err2.localizedDescription)
                        return
                    })
                }
            }
        }) { (err) in
            print(err.localizedDescription)
            return
        }
    }
    
    
    
    func addConstraints(){
        myTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! custommTableCell
        let persData = persArr[indexPath.row]
        cell.otherLabels.text = persData.name
        if let urlExist = persData.profileImageUrl{
            cell.profileImageView.loadImageUsingCacheString(urlString: urlExist)
        }
        return cell
    }
}



















