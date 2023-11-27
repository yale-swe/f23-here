//
//  api_call.swift
//  newHere
//
//  Created by Phuc Duong on 11/5/23.
//
//  Description:
//  This file contains structures and functions for handling API calls in the 'newHere' application.
//  It includes functionalities for posting messages, fetching user messages, managing friends, etc.

import Foundation

// Constants for API interaction and user defaults
let apiString = "https://here-swe.vercel.app/auth/user"
let apiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

// Structure for request body of posting a message
struct PostMessageRequest: Codable {
    let user_id: String
    let text: String
    let visibility: String
    let location: GeoJSONPoint
}

// Structure for response of a message
struct MessageResponse: Codable {
    let _id: String
    let user_id: String
    let text: String
    let visibility: String
    let location: GeoJSONPoint
}

// Structure for response of adding a friend
struct AddFriendResponse: Codable {
    let message: String
}

// Structure for request body of adding a friend
struct FriendRequest: Codable {
    let friendName: String
}

// Structure for user message data
struct UserMessage: Codable {
    struct Location: Codable {
        let type: String
        let coordinates: [Double]
    }

    let location: GeoJSONPoint
    let _id: String
    let user_id: String
    let text: String
    let likes: Int
    let visibility: String
    let replies: [String]
}

// Function to fetch user messages
func getUserMessages(userId: String, completion: @escaping (Result<[MessageResponse], Error>) -> Void) {
    // API URL
    let urlString = "https://here-swe.vercel.app/user/\(userId)/messages"
    
    // URL validation
    guard let url = URL(string: urlString) else {
        completion(.failure(URLError(.badURL)))
        return
    }
    
    // Setup request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
    
    // URLSession data task
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Error handling
        if let error = error {
            completion(.failure(error))
            return
        }
        
        // Response status code check
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        
        // Data validation
        guard let data = data else {
            completion(.failure(URLError(.cannotParseResponse)))
            return
        }
        
        // JSON decoding
        do {
            let messages = try JSONDecoder().decode([MessageResponse].self, from: data)
            completion(.success(messages))
            
            
            
        } catch {
            completion(.failure(error))
        }
    }
    // Start the task
    task.resume()
    
}

func postMessage(user_id: String, text: String, visibility: String, locationDataManager: LocationDataManager, completion: @escaping (Result<MessageResponse, Error>) -> Void) {
    // make sure you can get the current location
    if let currentLocation = locationDataManager.location {
        // API URL
        guard let url = URL(string: "https://here-swe.vercel.app/message/post_message") else {
            print("Invalid URL")
            return
        }
        
        // Setup request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
        
        // Encode request body
        let requestBody = PostMessageRequest(user_id: user_id, text: text, visibility: visibility, location: currentLocation.toGeoJSONPoint())
        request.httpBody = try? JSONEncoder().encode(requestBody)
        
        // URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Error handling
            if let error = error {
                completion(.failure(error))
                return
            }
            // Response status code check
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                // Handle the case when the response is not an HTTPURLResponse or the status code is not in the range.
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: nil)))
                return
            }
            // JSON decoding
            do {
                let messageResponse = try JSONDecoder().decode(MessageResponse.self, from: data)
                completion(.success(messageResponse))
            } catch {
                completion(.failure(error))
            }
        }
        // Start the task
        task.resume()
    }
}

// Function to get all friends of a user
func getAllUserFriends(userId: String, completion: @escaping (Result<[String], Error>) -> Void) {
    // API URL
    let urlString = "https://here-swe.vercel.app/user/\(userId)/friends"
    
    // URL validation
    guard let url = URL(string: urlString) else {
        completion(.failure(URLError(.badURL)))
        return
    }
    
    // Setup request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
    
    // URLSession data task
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Error handling
        if let error = error {
            completion(.failure(error))
            return
        }
        
        // Response status code check
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        
        // Data validation
        guard let data = data else {
            completion(.failure(URLError(.cannotParseResponse)))
            return
        }
        
        // JSON deserialization
        do {
            print("Friends")
            print(data)
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            let valuesList = jsonArray?.values.map { $0 }
            
            if let friends = valuesList {
                completion(.success(friends))
            } else {
                completion(.failure(URLError(.cannotParseResponse)))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // Start the task
    task.resume()
}

// Function to add a friend by name
func addFriendByName(userId: String, friendName: String, completion: @escaping (Result<AddFriendResponse, Error>) -> Void) {
    // API URL
    let urlString = "https://here-swe.vercel.app/user/\(userId)/friends_name"
    
    // URL validation
    guard let url = URL(string: urlString) else {
        completion(.failure(URLError(.badURL)))
        return
    }
    
    // Setup request
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type") // Ensure this matches what's used in Postman
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
    
    // Encode request body
    let requestBody = FriendRequest(friendName: friendName)
    do {
        request.httpBody = try JSONEncoder().encode(requestBody)
    } catch {
        completion(.failure(error))
        return
    }
    
    // URLSession data task
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Error handling
        if let error = error {
            completion(.failure(error))
            return
        }
        
        // Response status code check
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        
        // Data validation
        guard let data = data else {
            completion(.failure(URLError(.cannotParseResponse)))
            return
        }
        
        // JSON decoding
           do {
            let addFriendResponse = try JSONDecoder().decode(AddFriendResponse.self, from: data)
            completion(.success(addFriendResponse))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Start the task
    task.resume()
}

// Function to delete a friend by name
func deleteFriendByName(userId: String, friendName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    // API URL
    let urlString = "https://here-swe.vercel.app/user/\(userId)/friends_name"

    // URL validation
    guard let url = URL(string: urlString) else {
        completion(.failure(URLError(.badURL)))
        return
    }
    
    // Setup request
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")

    // Encode request body
    let requestBody = FriendRequest(friendName: friendName)
    do {
        request.httpBody = try JSONEncoder().encode(requestBody)
    } catch {
        completion(.failure(error))
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }

        // Check for successful status code
        if (200...299).contains(httpResponse.statusCode) {
            completion(.success(true))
        } else {
            completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)))
        }
    }

    task.resume()
}
