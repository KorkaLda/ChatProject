//
//  UIImageView + Extension.swift
//  ChatProject
//
//  Created by Vladimir on 13.02.2023.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
}
