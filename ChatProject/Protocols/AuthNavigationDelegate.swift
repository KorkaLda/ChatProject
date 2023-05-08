//
//  AuthNavigationDelegate.swift
//  ChatProject
//
//  Created by Vladimir on 06.05.2023.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}
