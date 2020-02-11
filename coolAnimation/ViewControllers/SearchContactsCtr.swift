
//
//  AddMoreContactsPage.swift
//  coolAnimation
//
//  Created by Andrew on 7/12/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase

class SearchContactsCtr: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating  {
    
    @objc var coolAnimationVar: TinderController?
    
    @objc let cellId = "cellId"
    @objc lazy var myTable: UITableView = {
        let myTable = UITableView()
        myTable.delegate = self
        myTable.dataSource = self
        myTable.translatesAutoresizingMaskIntoConstraints = false
        return myTable
    }()
    
    let searchBarController = UISearchController(searchResultsController: nil)
    
    @objc var users = [User]()
    var filteredArray = [User]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissView))
        view.addSubview(myTable)
        addCostraints()
        myTable.register(SearchContacts.self, forCellReuseIdentifier: cellId)
        fetchUSers()
        
        searchBarController.searchResultsUpdater = self
        searchBarController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.myTable.tableHeaderView = searchBarController.searchBar
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(facebookFriends))
        
    }
    @objc func filterContent(searchText: String){
        filteredArray = users.filter{ user in
            return (user.name?.contains(searchText))!
        }
        self.myTable.reloadData()
    }
    
    
    @objc func facebookFriends(){
        let facePage = facebookFriendsPage()
        self.navigationController?.pushViewController(facePage, animated: true)
    }
    
    
    @objc func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addCostraints(){
        
        myTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myTable.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    @objc func fetchUSers(){
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                print(dictionary)
                user.id = snapshot.key
                self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                    self.myTable.reloadData()
                })
            }
            
        }, withCancel: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarController.searchBar.text != "" && searchBarController.isActive{
            return filteredArray.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchContacts
        
        let mainUser: User
        
        if searchBarController.searchBar.text != "" && searchBarController.isActive{
            mainUser = filteredArray[indexPath.row]
        }else{
            mainUser = users[indexPath.row]
        }
        
        cell.textLabel?.text = mainUser.name
        cell.detailTextLabel?.text = mainUser.email
        
        if let profileImageUrl = mainUser.profileImageUrl{
            cell.profileImageView.loadImageUsingCacheString(urlString: profileImageUrl)
            
        }
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainUserName: User
        if self.searchBarController.searchBar.text != "" && self.searchBarController.isActive{
            mainUserName = self.filteredArray[indexPath.row]
            dismissView()
        }else{
            mainUserName = self.users[indexPath.row]
        }
        dismiss(animated: true) {
            
            self.coolAnimationVar?.otherStuff(user: mainUserName)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
    }
    
}










 
