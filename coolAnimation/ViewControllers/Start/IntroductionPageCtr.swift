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
    
    var intro: IntroPage!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myColl)
        addConstraintsAndIntro()

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
        let nextIndex = min(intro.pageController.currentPage + 1, 2) ///pages.count - 1
        let indexPath = IndexPath(item: nextIndex, section: 0)
        intro.pageController.currentPage = nextIndex
        if nextIndex == 2{
            DispatchQueue.main.async {
                self.createAni()
            }
        }
        
        myColl.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func scrollPagePrev(){
        let nextIndex = max(intro.pageController.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        intro.pageController.currentPage = nextIndex
        
        if nextIndex == 1{
            createAniReverse()
        }
        
        myColl.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func createAni(){
        UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseInOut, animations: {
//            self.bottomStackAnchor.constant = 25 + 51
            self.intro.bottomStackAnchor.constant = 25 + 51
            self.intro.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0.2,options: .curveEaseInOut, animations: {
            self.intro.secStack.alpha = 1
            self.intro.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func createAniReverse(){
        UIView.animate(withDuration: 0.3, delay: 0.2,options: .curveEaseInOut, animations: {
            self.intro.bottomStackAnchor.constant = -25
            self.intro.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseInOut, animations: {
            self.intro.secStack.alpha = 0
            self.intro.layoutIfNeeded()
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
        intro.pageController.currentPage = Int(x / view.frame.width)
        if intro.pageController.currentPage == 2{
            createAni()
        }else if intro.pageController.currentPage == 1{
            createAniReverse()
        }
    }
    
}
































