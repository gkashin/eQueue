//
//  Queue.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

struct Queue: Codable {
    var id = Int()
    var name = String()
    var description = String()
    var startDate = String()
    var ownerId = Int()
    var expectedTime = Int()
    
    var people: [User]!
    var queue = [User]()
    
    var status = String()
    
    init(name: String = "", description: String = "", startDate: String = DateFormatter().getString(from: Date()), people: [User] = [], isCompleted: Bool = false) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.people = people
        self.ownerId = SceneDelegate.user?.id ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case startDate = "start_date"
        case ownerId = "owner"
        case expectedTime = "expected_time"
        
        case people = "people"
        case queue = "queue"
        
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
