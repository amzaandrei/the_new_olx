//
//  ProductCollCell.swift
//  coolAnimation
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

class ProductCollCell: UICollectionViewCell {
    
    var height: CGFloat = 250
    let mainPhoto: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainPhoto)
        
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints(){
        
        
        mainPhoto.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainPhoto.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainPhoto.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainPhoto.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    
}


