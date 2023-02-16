//
//  UIColor + Extension.swift
//  ChatProject
//
//  Created by Vladimir on 13.02.2023.
//

import UIKit

extension UIColor {
    static func buttonRed() -> UIColor {
        return UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1)
//        return UIColor.red
    }
    
    static func mainWhite() -> UIColor {
//        return UIColor(red: 2.47, green: 2.48, blue: 2.53, alpha: 1)
//        return UIColor(red: 247/255, green: 248/25, blue: 253/255, alpha: 1)
        return #colorLiteral(red: 0.9551084638, green: 0.9532418847, blue: 0.9815134406, alpha: 1)
//        return UIColor.white
    }
    
    static func buttonDark() -> UIColor {
        return UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
//        return UIColor.black
    }
    
    static func textFieldLight() -> UIColor {
        return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
}
