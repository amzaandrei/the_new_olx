//
//  CountrySelector.swift
//  coolAnimation
//
//  Created by Andrew on 2/17/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation

protocol PrefixCountry: class{
    func sendPrefixCountry(prefix: String)
}

class CountrySelector: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    
    var data: [[String: String]]!
    
    weak var delegate: PrefixCountry!
    
    lazy var countriesTable: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(countriesTable)
        readJson()
        addConstraints()
    }
    func addConstraints(){
        NSLayoutConstraint.activate([
            countriesTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            countriesTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            countriesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            countriesTable.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    func readJson(){
        ReadJSON.instanceShared.loadJson(filename: "countries") { (json, err) in
            if let jsonFound = json{
                self.data = jsonFound
                DispatchQueue.main.async {
                    self.countriesTable.reloadData()
                }
            }else{
                print(err)
            }
        }
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let dataa = data[indexPath.row]
        cell.textLabel?.text = flag(country: dataa["code"]!) + "  " + dataa["name"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataa = data[indexPath.row]
        delegate.sendPrefixCountry(prefix: dataa["dial_code"]!)
        self.dismiss(animated: true, completion: nil)
    }
    
}
