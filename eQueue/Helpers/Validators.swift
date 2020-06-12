//
//  Validators.swift
//  eQueue
//
//  Created by Георгий Кашин on 19.05.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

class Validators {
    
    // isFilled
    static func isFilled(email: String?, password: String?) -> AuthError {
        guard email != "" else {
            return .emailNotFilled
        }
        
        guard Validators.isSimpleEmail(email!) else {
            return .invalidEmail
        }
        
        guard password != "" else {
            return .passwordNotFilled
        }
        
        return .noError
    }
    
    static func isFilled(username: String?, email: String?, password: String?, confirmPassword: String?) -> AuthError {
        guard username != "" else {
            return .nameNotFilled
        }
        
        guard email != "" else {
            return .emailNotFilled
        }
        
        guard Validators.isSimpleEmail(email!) else {
            return .invalidEmail
        }
        
        guard password != "" else {
            return .passwordNotFilled
        }
        
        guard confirmPassword != "" else {
            return .confirmPasswordNotFilled
        }
        
        guard password == confirmPassword else {
            return .passwordsNotMatched
        }
        
        return .noError
    }
    
    static func isFilled(name: String?, desc: String?, startDate: String?) -> CreateQueueError {
        
        guard name != "" else {
            return .nameNotFilled
        }
        
        guard desc != "" else {
            return .descNotFilled
        }
        
        guard startDate != "" else {
            return .dateNotFilled
        }
        
        return .noError
    }
    
    static func isFilled(name: String?, password: String?) -> EditProfileError {
        
        guard name != "" else {
            return .nameNotFilled
        }
        
        guard password != "" else {
            return .passwordNotFilled
        }
        
        return .noError
    }
    
    // Email check
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}

