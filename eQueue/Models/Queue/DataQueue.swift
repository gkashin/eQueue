//
//  DataQueue.swift
//  eQueue
//
//  Created by Георгий Кашин on 22.06.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

struct DataQueue: Codable {
    var queue = Queue()
    
    enum CodingKeys: String, CodingKey {
        case queue = "data"
    }
}
