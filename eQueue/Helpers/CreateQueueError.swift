//
//  CreateQueueError.swift
//  eQueue
//
//  Created by Георгий Кашин on 19.05.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

enum CreateQueueError {
    case nameNotFilled
    case noError
    case descNotFilled
    case dateNotFilled
}

extension CreateQueueError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nameNotFilled:
            return NSLocalizedString("Поле \"Название\" не может быть пустым", comment: "")
        case .noError:
            return NSLocalizedString("Все ок", comment: "")
        case .descNotFilled:
            return NSLocalizedString("Поле \"Описание\" не может быть пустым", comment: "")
        case .dateNotFilled:
            return NSLocalizedString("Поле \"Дата начала\" не может быть пустым", comment: "")
        }
    }
}
