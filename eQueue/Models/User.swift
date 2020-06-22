//
//  User.swift
//  eQueue
//
//  Created by Георгий Кашин on 06.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

struct User: Codable {
    
    // MARK: Stored Properties
    var id = Int()
    var username = String()
    var password: String!
    var email: String!
    var avatarData: Data!
    
    
    // MARK: Initializers
    init(username: String, email: String, password: String) {
        self.username = username
        self.password = password
        self.email = email
    }
    
    init() {}
}

// MARK: - Coding Keys
extension User {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case password = "password"
        case email = "email"
        case avatarData = "avatar"
    }
}
