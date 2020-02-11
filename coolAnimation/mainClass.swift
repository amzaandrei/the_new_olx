//
//  mainClass.swift
//  coolAnimation
//
//  Created by Andrew on 7/1/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import Firebase

class mainClass: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        view.backgroundColor = UIColor.white
        addTabs()
        
    }
    
    
    
    @objc func addTabs(){
        let mainViewController1 = UINavigationController(rootViewController: expendedViewController())
        let mainViewController4 = UINavigationController(rootViewController: myFavouritProducts())
        let mainViewController2 = UINavigationController(rootViewController: coolAnimation())
        let mainViewController3 = UINavigationController(rootViewController: profilData())
        
        let image1 = UIImage(named: "products")
        let image2 = UIImage(named: "messages")
        let image3 = UIImage(named: "settings")
        let image4 = UIImage(named: "favourites")
        
        
        let tabOne = mainViewController1   ///////trebuie schimbata cu view ul unde vor fi obiectele de vanzare
        let tabOneBarItem = UITabBarItem(title: "Objects", image: image1, selectedImage: nil)
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = mainViewController2
        let tabTwoBarItem = UITabBarItem(title: "Personal Chat", image: image2, selectedImage: nil)
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThree = mainViewController3
        let tabThreeBarItem = UITabBarItem(title: "Settings", image: image3, selectedImage: nil)
        tabThree.tabBarItem = tabThreeBarItem
        
        let tabFour = mainViewController4
        let tabFourBarItem = UITabBarItem(title: "Favourits", image: image4, selectedImage: nil)
        tabFour.tabBarItem = tabFourBarItem
        
        
        self.viewControllers = [tabOne,tabFour, tabTwo, tabThree]
    }
    
    
    @objc func LogInPage(){
        let logPage = LogInEmailController()
        let navigationController = UINavigationController(rootViewController: logPage)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func profileDataPage(){
        let profilDataPage = profilData()
        let navigationController = UINavigationController(rootViewController: profilDataPage)
        present(navigationController, animated: true, completion: nil)
    }
    
    
    
}
