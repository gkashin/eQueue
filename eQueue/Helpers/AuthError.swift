//
//  AuthError.swift
//  eQueue
//
//  Created by Георгий Кашин on 19.05.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

enum AuthError {
    case emailNotFilled
    case invalidEmail
    case passwordNotFilled
    case passwordsNotMatched
    case confirmPasswordNotFilled
    case noError
    case wrongData
    case nameNotFilled
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emailNotFilled:
            return NSLocalizedString("Поле \"Email\" не может быть пустым", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Email введен некорректно", comment: "")
        case .passwordsNotMatched:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .passwordNotFilled:
            return NSLocalizedString("Поле \"Пароль\" не может быть пустым", comment: "")
        case .confirmPasswordNotFilled:
            return NSLocalizedString("Поле \"Подтвердить пароль\" не может быть пустым", comment: "")
        case .noError:
            return NSLocalizedString("Все ок", comment: "")
        case .wrongData:
            return NSLocalizedString("Неправильный email или пароль", comment: "")
        case .nameNotFilled:
            return NSLocalizedString("Поле \"Имя\" не может быть пустым", comment: "")
        }
    }
}
