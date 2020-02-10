//
//  facebookFriendsPage.swift
//  coolAnimation
//
//  Created by Andrew on 1/31/18.
//  Copyright © 2018 Andrew. All rights reserved.
//

import UIKit
import Firebase

class facebookFriendsPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    lazy var myTable: UITableView = {
        let myTable = UITableView()
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        myTable.delegate = self
        myTable.dataSource = self
        myTable.translatesAutoresizingMaskIntoConstraints = false
        return myTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myTable)
        fetchFriends()
        addConstraints()
    }
    func addConstraints(){
        myTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func fetchFriends(){
//        let accesToken = FBSDKAccessToken.current().tokenString
//        print(accesToken)
        let param = ["fields":"email,name,picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: param).start(completionHandler: { (conn, result, err) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }
            if let dict = result as? [String: Any]{
                print(dict)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "mama"
        return cell
    }
    
}
