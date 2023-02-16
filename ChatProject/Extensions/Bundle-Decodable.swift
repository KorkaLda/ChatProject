//
//  Bundle-Decodable.swift
//  ChatProject
//
//  Created by Vladimir on 15.02.2023.
//

import Foundation
import UIKit

extension Bundle {
    func decode <T: Decodable> (_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("failed to locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode")
        }
        
        return loaded
    }
}
