//
//  ImagePickerCollView.swift
//  coolAnimation
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

class ImagePickerCollView: UICollectionViewCell{
    
    var height: CGFloat = 250
    let mainPhoto: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    
    let blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainPhoto)
        addSubview(blurEffect)
        
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imagesLibrary(){
        print("tapped")
    }
    
    func addConstraints(){
        blurEffect.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blurEffect.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        blurEffect.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blurEffect.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        mainPhoto.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainPhoto.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainPhoto.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainPhoto.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    
}
