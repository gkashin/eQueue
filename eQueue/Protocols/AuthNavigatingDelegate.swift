//
//  AuthNavigatingDelegate.swift
//  eQueue
//
//  Created by Георгий Кашин on 04.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

protocol AuthNavigatingDelegate: class {
    func toLoginVC()
    func toSignUpVC()
    func dismiss()
}
