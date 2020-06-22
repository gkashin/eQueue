//
//  Queue.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

struct Queue: Codable {
    
    // MARK: Stored Properties
    var id = Int()
    var name = String()
    var description = String()
    var startDate: String? = String()
    var ownerId = Int()
    var expectedTime = Int()
    var queue: [User]!
    var status: String!
    
    
    // MARK: Initializers
    init(name: String = "", description: String = "", startDate: String = DateFormatter().getString(from: Date()), people: [User] = [], isCompleted: Bool = false) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.ownerId = SceneDelegate.user?.id ?? 0
    }
}

// MARK: - Coding Keys
extension Queue {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case startDate = "start_date"
        case ownerId = "owner"
        case expectedTime = "expected_time"
        case queue = "queue"
        case status = "status"
    }
}
