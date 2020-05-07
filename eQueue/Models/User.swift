//
//  User.swift
//  eQueue
//
//  Created by Георгий Кашин on 06.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

struct User: Codable {
    var id = Int()
    var username = String()
//    var firstName = String()
//    var lastName = String()
    
    var password: String!
    var email: String!
    var avatarData: Data!
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.password = password
        self.email = email
//        self.firstName = firstName
//        self.lastName = lastName
    }
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
//        case firstName = "first_name"
//        case lastName = "last_name"

        case password = "password"
        case email = "email"
        case avatarData = "avatar"
    }
}
