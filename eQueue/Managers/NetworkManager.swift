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
        
        let _ = URLSession.shared.dataTask(with: request) { _, response, error in
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
        
//        let data = ["name": queue.name, "expected_time": queue.expectedTime, "description": queue.description, "start_date": queue.startDate]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(queue)
        
        request.httpBody = jsonData
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            
            guard let dataQueue = try? jsonDecoder.decode(DataQueue.self, from: data) else {
                print(#line, #function, "Couldn't decode data from \(data)")
                print((response as! HTTPURLResponse).statusCode)
                return completion(nil)
            }
            
            completion(dataQueue.queue)
        }.resume()
    }
    
    func findQueue(id: Int, completion: @escaping (Queue?) -> Void) {
        let findQueueURL = baseURL.appendingPathComponent("get_queue_info/\(id)")
        
        var request = URLRequest(url: findQueueURL)
        request.httpMethod = "GET"
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            
            let httpResponse = response as? HTTPURLResponse
            
            guard httpResponse?.statusCode == 200 else {
                return completion(nil)
            }
            
            guard let dataQueue = try? jsonDecoder.decode(DataQueue.self, from: data) else {
                print("Couldn't decode data from \(data)")
                return completion(nil)
            }
            
            completion(dataQueue.queue)
        }.resume()
    }
    
    func enterQueue(id: Int, completion: @escaping (Queue?) -> Void) {
        let enterQueueURL = baseURL.appendingPathComponent("enqueue/\(id)")
        
        var request = URLRequest(url: enterQueueURL)
        request.httpMethod = "POST"
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            
            let httpResponse = response as? HTTPURLResponse
            
            guard httpResponse?.statusCode == 200 else {
                print(#line, #function, "Response with status code \(httpResponse?.statusCode)")
                return completion(nil)
            }
            
            guard let dataQueue = try? jsonDecoder.decode(DataQueue.self, from: data) else {
                print("Couldn't decode data from \(data)")
                return completion(nil)
            }
            
            completion(dataQueue.queue)
        }.resume()
    }
    
    func leaveQueue(id: Int, completion: @escaping (Int?) -> Void) {
        let leaveQueueURL = baseURL.appendingPathComponent("leave_queue/\(id)")
        var request = URLRequest(url: leaveQueueURL)
        request.httpMethod = "POST"
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let _ = URLSession.shared.dataTask(with: request) { _, response, error in
            let httpResponse = response as? HTTPURLResponse
            completion(httpResponse?.statusCode)
        }.resume()
    }
    
    func getCurrentUser(completion: @escaping (User?) -> Void) {
        let getCurrentUserURL = baseURL.appendingPathComponent("auth/users/me/")
        var request = URLRequest(url: getCurrentUserURL)
        request.httpMethod = "GET"
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            
            guard let user = try? jsonDecoder.decode(User.self, from: data) else {
                print(#line, #function, "Couldn't decode data from \(data)")
                return completion(nil)
            }
            
            completion(user)
        }.resume()
    }
}

// MARK: - Queues
extension NetworkManager {
    func myQueues(completion: @escaping ([Queue]?) -> Void) {
        let myQueuesURL = baseURL.appendingPathComponent("my_queues/")
        var request = URLRequest(url: myQueuesURL)
        request.httpMethod = "GET"
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            
            guard let dataQueues = try? jsonDecoder.decode(DataQueues.self, from: data) else {
                print(#line, #function, "Couldn't decode data from \(data)")
                return completion(nil)
            }
            
            completion(dataQueues.queues)
        }.resume()
    }
    
    func myQueuesOwner(completion: @escaping ([Queue]?) -> Void) {
        let myQueuesOwnerURL = baseURL.appendingPathComponent("my_queues_owner/")
        var request = URLRequest(url: myQueuesOwnerURL)
        request.httpMethod = "GET"
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Couldn't get data, \(error!.localizedDescription)")
                return completion(nil)
            }
            let jsonDecoder = JSONDecoder()
            
            guard let dataQueues = try? jsonDecoder.decode(DataQueues.self, from: data) else {
                print(#line, #function, "Couldn't decode data from \(data)")
                return completion(nil)
            }
            
            completion(dataQueues.queues)
        }.resume()
    }
}

// MARK: - Update Info
extension NetworkManager {
    func updateName(name: String, password: String, completion: @escaping (Int?) -> Void) {
        let updateNameURL = baseURL.appendingPathComponent("set_first_name/")
        var request = URLRequest(url: updateNameURL)
        request.httpMethod = "POST"
            
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let data = ["new_first_name": name, "current_password": password]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let _ = URLSession.shared.dataTask(with: request) { _, response, error in
            let httpResponse = response as? HTTPURLResponse
            completion(httpResponse?.statusCode)
        }.resume()
    }
    
    func updateSurname(surname: String, password: String, completion: @escaping (Int?) -> Void) {
        let updateSurnameURL = baseURL.appendingPathComponent("set_last_name/")
        var request = URLRequest(url: updateSurnameURL)
        request.httpMethod = "POST"
            
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let data = ["new_last_name": surname, "current_password": password]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(data)
        
        request.httpBody = jsonData        
        
        let _ = URLSession.shared.dataTask(with: request) { _, response, error in
            let httpResponse = response as? HTTPURLResponse
            completion(httpResponse?.statusCode)
        }.resume()
    }
    
    func updatePassword(newPassword: String, password: String, completion: @escaping (Int?) -> Void) {
        let updatePasswordURL = baseURL.appendingPathComponent("auth/users/set_password/")
        var request = URLRequest(url: updatePasswordURL)
        request.httpMethod = "POST"
            
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")

        let data = ["new_password": newPassword, "re_new_password": newPassword, "current_password": password]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let _ = URLSession.shared.dataTask(with: request) { _, response, error in
            let httpResponse = response as? HTTPURLResponse
            completion(httpResponse?.statusCode)
        }.resume()
    }
}
