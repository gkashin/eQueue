//
//  DateFormatter+Extension.swift
//  eQueue
//
//  Created by Георгий Кашин on 18.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    func getString(from date: Date) -> String {
        self.dateFormat = "yyyy-MM-dd"
        return self.string(from: date)
    }
    
    func getDate(from string: String) -> Date {
        self.dateFormat = "yyyy-MM-dd"
        return self.date(from: string)!
    }
}
