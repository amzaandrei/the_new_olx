//
//  pageCellCollectionViewCell.swift
//  coolAnimation
//
//  Created by Andrew on 6/26/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class pageCell: UICollectionViewCell {
    
    
    @objc let textLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    @objc let detailedLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    @objc let separator: UIView = {
        let linie = UIView()
        linie.backgroundColor = UIColor.gray
        linie.translatesAutoresizingMaskIntoConstraints = false
        return linie
    }()
    
    
    @objc let profileImage: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    @objc let timeStamp: UILabel = {
        let text = UILabel()
        text.text = ""
        text.font = UIFont.boldSystemFont(ofSize: 12)
        text.textColor = UIColor.darkGray
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            setupView()
            addSubview(textLabel)
            addSubview(detailedLabel)
            addSubview(separator)
            addSubview(profileImage)
            addSubview(timeStamp)
            addConstraints()
    }
    
    @objc func setupView(){
        self.backgroundColor = UIColor.white
    }
    
    @objc func addConstraints(){
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        textLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        detailedLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        detailedLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 3).isActive = true
        detailedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        detailedLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        separator.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -15).isActive = true
        timeStamp.heightAnchor.constraint(equalTo : textLabel.heightAnchor).isActive = true
        timeStamp.widthAnchor.constraint(equalToConstant: 60).isActive = true
        timeStamp.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
