//
//  userProfileData.swift
//  coolAnimation
//
//  Created by Andrew on 6/30/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData
import GoogleSignIn
import FBSDKLoginKit
import Stripe
//class profilData: UIViewController, UITableViewDelegate, UITableViewDataSource,STPShippingAddressViewControllerDelegate, STPAddCardViewControllerDelegate  {
class UserProfileCtr: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @objc let cellIdSettings = "cellId"
    
//    let settingsVC = SettingsViewController()
    
    var mainArray = [["Persons blocked","Change User Data","Payment","Shipping"],["Log out"]]
    @objc var users = [User]()
    
    let userDefaults = UserDefaults()
    
    @objc lazy var bigProfilePicture: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc lazy var profileImage: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc lazy var myTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        return table
    }()
    
    @objc let blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
//        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurView
    }()
    
    
    
    @objc var managedObjectContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        myTable.backgroundColor = UIColor.white
        DispatchQueue.main.async() {
            self.view.addSubview(self.bigProfilePicture)
            self.bigProfilePicture.addSubview(self.blurEffect)
            self.blurEffect.contentView.addSubview(self.profileImage)
            self.view.addSubview(self.myTable)
            self.addConstraints()
        }
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdSettings)
        
        findIfIsConnected()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    @objc func dismissMe(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func findIfIsConnected(){
        let uid = Auth.auth().currentUser?.uid
        if uid != nil{
            let ref = Database.database().reference().child("users").child(uid!)
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let user = User(dictionary: dictionary)
                    self.users.append(user)
                    if let imageUrl = user.profileImageUrl{
                        self.setImageUserNav(imageUrl: imageUrl)
                    }
                }
            })
        }else{
//            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign In", style: .done, target: self, action: #selector(LogInPage))
        }
    }
    
    @objc func setImageUserNav(imageUrl: String){
        let url = URL(string: imageUrl)
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err != nil{
                print(err!)
            }else{
                
                if let downloadedImage = UIImage(data: data!){
                    DispatchQueue.main.async(execute: {
                        self.profileImage.image = downloadedImage
                        self.bigProfilePicture.image = downloadedImage
                    })
                }
            }
        }
        dataTask.resume()
    }
    
    @objc func addConstraints(){
        
        bigProfilePicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        bigProfilePicture.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bigProfilePicture.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        blurEffect.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        blurEffect.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurEffect.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        profileImage.centerXAnchor.constraint(equalTo: bigProfilePicture.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: bigProfilePicture.centerYAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        myTable.topAnchor.constraint(equalTo: bigProfilePicture.bottomAnchor).isActive = true
        myTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdSettings, for: indexPath)
        
        let cellText = mainArray[indexPath.section][indexPath.row]
        
        if indexPath.section == 1{
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.textAlignment = .center
        }else{
            cell.textLabel?.frame = CGRect(x: 15, y: (cell.textLabel?.frame.origin.y)!, width: (cell.textLabel?.frame.width)!, height: (cell.textLabel?.frame.height)!)
        }
        cell.textLabel?.text = cellText
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 1{
            logOut()
        }else if indexPath.row == 1 && indexPath.section == 0{
            let editPage = changeUserProfileData()
            self.navigationController?.pushViewController(editPage, animated: true)
        }else if indexPath.row == 0 && indexPath.section == 0{
            let blockPage = blockeViewController()
            self.navigationController?.pushViewController(blockPage, animated: true)
        }else if indexPath.row == 3 && indexPath.section == 0{
//            let checkoutViewController = CheckoutViewController(product: "masina",
//                                                                price: 100,
//                                                                settings: self.settingsVC.settings)
//            self.navigationController?.pushViewController(checkoutViewController, animated: true)
        }else if indexPath.row == 2 && indexPath.section == 0{
//            self.handleAddPaymentMethodButtonTapped()
        }
    }
    
    
    
    @objc func logOut(){
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatInfoModel")
            userDefaults.set(false, forKey: "isLoggedIn")
            let results = try managedObjectContext.fetch(fetchRequest)
            
            for managedObject in results{
                let managedObjectData = managedObject
                managedObjectContext.delete(managedObjectData as! NSManagedObject)
            }
            
            if FBSDKAccessToken.current() != nil{
                FBSDKLoginManager().logOut()
            }
            
            if let googleUser = GIDSignIn.sharedInstance().currentUser{
                if googleUser != nil{
                    GIDSignIn.sharedInstance().signOut()
                }
            }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let timeStamp = NSNumber(integerLiteral: Int(NSDate().timeIntervalSince1970))
            let ref = Database.database().reference().child("users").child(uid)
            let value = ["active": false,"timeActibity": timeStamp]
            ref.updateChildValues(value) { (err, ref) in
                print("User is inactiev")
            }
            try Auth.auth().signOut()
        }catch let error{
            print(error)
        }
        present(IntroductionPageController(), animated: true, completion: nil)
    }
    
}

//extension profilData {
//
//
//    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didEnter address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
//        let upsGroundShippingMethod = PKShippingMethod()
//        upsGroundShippingMethod.amount = 0.00
//        upsGroundShippingMethod.label = "UPS Ground"
//        upsGroundShippingMethod.detail = "Arrives in 3-5 days"
//        upsGroundShippingMethod.identifier = "ups_ground"
//
//        let fedExShippingMethod = PKShippingMethod()
//        fedExShippingMethod.amount = 5.99
//        fedExShippingMethod.label = "FedEx"
//        fedExShippingMethod.detail = "Arrives tomorrow"
//        fedExShippingMethod.identifier = "fedex"
//
//        if address.country == "US" {
//            let availableShippingMethods = [upsGroundShippingMethod, fedExShippingMethod]
//            let selectedShippingMethod = upsGroundShippingMethod
//
//            completion(.valid, nil, availableShippingMethods, selectedShippingMethod)
//        }
//        else {
//            completion(.invalid, nil, nil, nil)
//        }
//    }
//
//    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didFinishWith address: STPAddress, shippingMethod method: PKShippingMethod?) {
//        // Save selected address and shipping method
//        //        selectedAddress = address
//        //        selectedShippingMethod = method
//        print(address, method)
//        // Dismiss shipping address view controller
//        dismiss(animated: true)
//    }
//
//    func shippingAddressViewControllerDidCancel(_ addressViewController: STPShippingAddressViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//
//    @objc func handleAddPaymentMethodButtonTapped(){
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//
//        let navigationController = UINavigationController(rootViewController: addCardViewController)
//        present(navigationController, animated: true)
//    }
//
//    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
//        print(STPErrorBlock.self)
//    }
//
//}
//
