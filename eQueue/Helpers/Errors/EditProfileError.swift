//
//  EditProfileError.swift
//  eQueue
//
//  Created by Георгий Кашин on 19.05.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

enum EditProfileError {
    case nameNotFilled
    case noError
    case passwordNotFilled
    case passwordNotMatched
}

extension EditProfileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nameNotFilled:
            return NSLocalizedString("Поле \"Имя\" не может быть пустым", comment: "")
        case .noError:
            return NSLocalizedString("Все ок", comment: "")
        case .passwordNotFilled:
            return NSLocalizedString("Поле \"Пароль\" не может быть пустым", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Неверный пароль", comment: "")
        }
    }
}
