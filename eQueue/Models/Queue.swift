//
//  Queue.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

struct Queue: Codable {
    static var id = Int()
    var id = Int()
    var name = "Только спросить"
    var description = ""
    var startDate = Date()
    var people = [User]()
//    var isOwnCreated = Bool()
    var ownerId = Int()
    var isCompleted = Bool()
    
    init(name: String = "", description: String = "", startDate: Date = Date(), people: [User] = [], isCompleted: Bool = false) {
        Queue.id += 1
        self.id = Queue.id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.people = people
//        self.isOwnCreated = isOwnCreated
        self.ownerId = SceneDelegate.user!.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case startDate = "startDate"
        case people = "people"
        case ownerId = "owner"
        case isCompleted = "status"
    }
}

struct Data: Codable {
    var id: Int
    var name: String
    var owner: Int
    var expected_time: Int
}
