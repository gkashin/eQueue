//
//  DataQueues.swift
//  eQueue
//
//  Created by Георгий Кашин on 22.06.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

struct DataQueues: Codable {
    var queues = [Queue]()
    
    enum CodingKeys: String, CodingKey {
        case queues = "data"
    }
}
