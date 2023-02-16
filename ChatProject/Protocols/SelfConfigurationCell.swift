//
//  SelfConfigurationCell.swift
//  ChatProject
//
//  Created by Vladimir on 15.02.2023.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String {get}
    func configure<U: Hashable>(with value: U)
}
