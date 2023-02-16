//
//  Label + Extension.swift
//  ChatProject
//
//  Created by Vladimir on 13.02.2023.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        self.text = text
        self.font = font
    }
}
