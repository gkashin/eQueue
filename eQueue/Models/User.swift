//
//  User.swift
//  eQueue
//
//  Created by Георгий Кашин on 06.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

struct User: Codable {
    var username: String
    var password: String
    var email: String
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}