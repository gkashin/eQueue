//
//  Queue.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

struct Queue: Codable {
//    static var id = Int()
    var id = Int()
    var name = String()
    var description: String!
    var startDate: Date!
    var people: [User]!
    var queue = [Int]()
//    var isOwnCreated = Bool()
    var ownerId = Int()
    var isCompleted: Bool!
    var expectedTime = Int()
    var status = String()
    
    init(name: String = "", description: String = "", startDate: Date = Date(), people: [User] = [], isCompleted: Bool = false) {
//        Queue.id += 1
//        self.id = Queue.id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.people = people
//        self.isOwnCreated = isOwnCreated
        self.ownerId = SceneDelegate.user?.id ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case startDate = "startDate"
        case people = "people"
        case queue = "queue"
        case ownerId = "owner"
        case isCompleted = "is_completed"
        case expectedTime = "expected_time"
        case status = "status"
    }
}

struct DataQueue: Codable {
    var queue = Queue()
    
    enum CodingKeys: String, CodingKey {
        case queue = "data"
    }
}

struct DataQueues: Codable {
    var queues = [Queue]()
    
    enum CodingKeys: String, CodingKey {
        case queues = "data"
    }
}
