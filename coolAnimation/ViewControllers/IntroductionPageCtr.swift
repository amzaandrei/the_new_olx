//
//  introPage.swift
//  scoalaAltfel
//
//  Created by Andrew on 11/27/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class IntroductionPageController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    lazy var myColl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let myCol = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myCol.translatesAutoresizingMaskIntoConstraints = false
        myCol.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        myCol.delegate = self
        myCol.dataSource = self
        myCol.isPagingEnabled = true
        return myCol
    }()
    
    let pageController: UIPageControl = {
        let page = UIPageControl()
        page.translatesAutoresizingMaskIntoConstraints = false
        page.currentPage = 0
        page.numberOfPages = 3
        page.currentPageIndicatorTintColor = UIColor.white
        page.pageIndicatorTintColor = UIColor.black
        return page
    }()
    
    let nextBtt: UIButton = {
        let mainBtt = UIButton(type: .system)
        mainBtt.setTitle("NEXT", for: .normal)
        mainBtt.translatesAutoresizingMaskIntoConstraints = false
        mainBtt.addTarget(self, action: #selector(scrollPageNext), for: .touchUpInside)
        return mainBtt
    }()
    
    let prevBtt: UIButton = {
        let mainBtt = UIButton(type: .system)
        mainBtt.setTitle("PREV", for: .normal)
        mainBtt.translatesAutoresizingMaskIntoConstraints = false
        mainBtt.addTarget(self, action: #selector(scrollPagePrev), for: .touchUpInside)
        return mainBtt
    }()
    
    let logInBtt: UIButton = {
        let btt = UIButton(type: .system)
        btt.setTitle("Log In", for: .normal)
        btt.setTitleColor(UIColor.black, for: .normal)
//        btt.layer.cornerRadius = 5
//        btt.layer.masksToBounds = true
        btt.translatesAutoresizingMaskIntoConstraints = false
        btt.backgroundColor = UIColor(white: 1.0,alpha: 0)
//        btt.layer.borderWidth = 1
//        btt.layer.borderColor = UIColor.black.cgColor
        btt.addTarget(self, action: #selector(logInPageFunc), for: .touchUpInside)
        return btt
    }()
    
    let signUpBtt: UIButton = {
        let btt = UIButton(type: .system)
        btt.setTitle("Sign up", for: .normal)
        btt.setTitleColor(UIColor.black, for: .normal)
//        btt.layer.cornerRadius = 5
//        btt.layer.masksToBounds = true
        btt.translatesAutoresizingMaskIntoConstraints = false
        btt.backgroundColor = UIColor(white: 1.0,alpha: 0)
//        btt.layer.borderWidth = 1
//        btt.layer.borderColor = UIColor.black.cgColor
        btt.addTarget(self, action: #selector(signUpPage), for: .touchUpInside)
        return btt
    }()
    
    let OrpBtt: UIButton = {
        let btt = UIButton(type: .system)
        btt.setTitle("Or", for: .normal)
        btt.setTitleColor(UIColor.black, for: .normal)
//        btt.layer.cornerRadius = 5
//        btt.layer.masksToBounds = true
        btt.translatesAutoresizingMaskIntoConstraints = false
        btt.backgroundColor = UIColor(white: 1.0,alpha: 0)
//        btt.layer.borderWidth = 1
//        btt.layer.borderColor = UIColor.black.cgColor
        btt.addTarget(self, action: #selector(orPage), for: .touchUpInside)
        return btt
    }()
    
    let helpView: UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myColl)
        addConstraints()
    }
    
    var bottomStackAnchor: NSLayoutConstraint!
    var stack: UIStackView!
    var secStack: UIStackView!
    
    
    @objc func logInPageFunc(){
        let logPage = LogInEmailController()
        present(logPage, animated: true, completion: nil)
    }
    
    @objc func signUpPage(){
        let signUpPage = ChooseWhichRegisterController()
        present(signUpPage, animated: true, completion: nil)
    }
    
    @objc func orPage(){
//        let orPage = redirectPage()
//        present(orPage, animated: true, completion: nil)
    }
    
    @objc func scrollPageNext(){
        let nextIndex = min(pageController.currentPage + 1, 2) ///pages.count - 1
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageController.currentPage = nextIndex
        if nextIndex == 2{
            createAni()
        }
        
        myColl.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func scrollPagePrev(){
        let nextIndex = max(pageController.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageController.currentPage = nextIndex
        
        if nextIndex == 1{
            createAniReverse()
        }
        
        myColl.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func createAni(){
        UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseInOut, animations: {
            self.bottomStackAnchor.constant = 25 + 51
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.2,options: .curveEaseInOut, animations: {
            self.secStack.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func createAniReverse(){
        UIView.animate(withDuration: 0.3, delay: 0.2,options: .curveEaseInOut, animations: {
            self.bottomStackAnchor.constant = -25
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseInOut, animations: {
            self.secStack.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageController.currentPage = Int(x / view.frame.width)
        if pageController.currentPage == 2{
            createAni()
        }else if pageController.currentPage == 1{
            createAniReverse()
        }
    }
    
}
































