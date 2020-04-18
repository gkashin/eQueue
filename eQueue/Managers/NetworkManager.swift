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
    
    let baseURL = URL(string: "http://queues.herokuapp.com")!
    
    func register(user: User, completion: @escaping (User?) -> Void) {
        let registerURL = baseURL.appendingPathComponent("/auth/users/")
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
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            guard let user = try? jsonDecoder.decode(User.self, from: data) else {
                print("Couldn't decode data from \(data)")
                return completion(nil)
            }
            completion(user)
        }
        task.resume()
    }
    
    func login(username: String, password: String, completion: @escaping (Int?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("/auth/jwt/create")
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["username": username, "password": password]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(data)
        //        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            //            let jsonDecoder = JSONDecoder()
            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Couldn't decode data from \(data)")
                return completion(nil)
            }
            guard let token = jsonDictionary["access"] as? String else {
                print("Couldn't get access token from \(jsonDictionary)")
                return completion(nil)
            }
            
            SceneDelegate.defaults.set(token, forKey: "token")
            completion(200)
        }
        task.resume()
    }
    
    func verifyToken(token: String, completion: @escaping (Int?) -> Void) {
        let verifyURL = baseURL.appendingPathComponent("auth/jwt/verify")
        var request = URLRequest(url: verifyURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["token": token]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            completion(httpResponse?.statusCode)
        }.resume()
    }
    
    func createQueue(queue: Queue, completion: @escaping (Queue?) -> Void) {
        let createQueueURL = baseURL.appendingPathComponent("create/")
        var request = URLRequest(url: createQueueURL)
        request.httpMethod = "POST"
    
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let data = ["name": queue.name]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            
            guard let dataQueue = try? jsonDecoder.decode(DataQueue.self, from: data) else {
                print("Couldn't decode data from \(data)")
                return completion(nil)
            }
            
            completion(dataQueue.queue)
//            let httpResponse = response as? HTTPURLResponse
//            print(#line, #function, httpResponse?.statusCode)
        }.resume()
    }
    
    func findQueue(id: Int, completion: @escaping (Queue?) -> Void) {
        let findQueueURL = baseURL.appendingPathComponent("enqueue/\(id)")
        var request = URLRequest(url: findQueueURL)
        request.httpMethod = "POST"
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            
            guard let dataQueue = try? jsonDecoder.decode(DataQueue.self, from: data) else {
                print("Couldn't decode data from \(data)")
                return completion(nil)
            }
            
            completion(dataQueue.queue)
        }.resume()
    }
}
