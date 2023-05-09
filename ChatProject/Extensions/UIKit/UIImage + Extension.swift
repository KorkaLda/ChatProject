//
//  UIImage + Extension.swift
//  ChatProject
//
//  Created by Vladimir on 08.05.2023.
//

import UIKit

extension UIImage {
    
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSizeLength: CGFloat = 480
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSizeLength ? largerSide / maxImageSizeLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        
        return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
