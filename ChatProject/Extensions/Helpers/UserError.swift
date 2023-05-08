//
//  UserError.swift
//  ChatProject
//
//  Created by Vladimir on 06.05.2023.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannotGetUserInfo
    case cannotUnwrapToMUser
}

extension UserError:LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Не выбрано фото", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно загрузить информацию о пользователе", comment: "")
        case .cannotUnwrapToMUser:
            return NSLocalizedString("Невозхможно конвертировать MUser из User", comment: "")
        }
    }
}
