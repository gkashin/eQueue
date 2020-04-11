//
//  Queue.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

struct Queue {
    static var id = Int()
    var id = Int()
    var name = "Только спросить"
    var description = ""
    var startDate = Date()
    var people = [User]()
    var isOwnCreated = Bool()
    
    init(name: String = "", description: String = "", startDate: Date = Date(), people: [User] = [], isOwnCreated: Bool = Bool()) {
        Queue.id += 1
        self.id = Queue.id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.people = people
        self.isOwnCreated = isOwnCreated
    }
}
