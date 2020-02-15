//
//  UIViws.swift
//  coolAnimation
//
//  Created by Andrew on 2/14/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation


extension UIView {
    func addSubviews(_ views: [AnyHashable]?) {
        for view in views ?? [] {
            guard let view = view as? UIView else {
                continue
            }
            if (view is UIView) {
                addSubview(view)
            }
        }
    }
}
