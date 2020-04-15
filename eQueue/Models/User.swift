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
    var password = "Password"
    var email = "Email"
    var avatarData = #imageLiteral(resourceName: "circle").pngData()!
//    var group = String()
    var firstName = "Name"
    var lastName = "Surname"
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
        case email = "email"
//        case group = "group"
        case avatarData = "avatar"
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
