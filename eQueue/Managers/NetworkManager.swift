//
//  NetworkManager.swift
//  eQueue
//
//  Created by Георгий Кашин on 06.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init() {}
    
    let baseURL = URL(string: "https://apple.com")!
    
    func register(user: User, completion: @escaping (User?) -> Void) {
        let registerURL = baseURL.appendingPathComponent("/auth/jwt/create")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let data = ["user": user]
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(user)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let jsonDecoder = JSONDecoder()
            let user = try? jsonDecoder.decode(User.self, from: data)
            completion(user)
        }
        task.resume()
    }
    
//    func checkLogin(for username: String, with password: String, completion: @escaping (User?) -> Void) {
//        let loginURL = baseURL.appendingPathComponent("login/basic")
//
//        var request = URLRequest(url: loginURL)
//
//        request.httpMethod = "GET"
//
//        let loginString = String(format: "\(username):\(password)")
//        guard let loginData = loginString.data(using: .utf8) else {
//            print(#line, #function, "Can't encode login string to data using utf8")
//            return completion(nil)
//        }
//        let base64LoginString = loginData.base64EncodedString()
//        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print(#line, #function, "Couldn't get data")
//                return completion(nil)
//            }
//
//            let jsonDecoder = JSONDecoder()
//            guard let user = try? jsonDecoder.decode(User.self, from: data) else {
//                print(#line, #function, "Can't decode data from \(data)")
//                return completion(nil)
//            }
//
//            completion(user)
//        }
//
//        task.resume()
//    }
}
