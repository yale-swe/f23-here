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
import CoreLocation

// Constants for API interaction and user defaults
let apiString = "https://here-swe.vercel.app/auth/user"
let apiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

// Geo constants
let earthRadiusKm: Double = 6371.0
let distanceThreshold: Double = 0.2 // kilometers

extension Double {
    // Degrees to radians
    var degreesToRadians: Double {
        return self * .pi / 180
    }
    
    // Radians to degrees
    var radiansToDegrees: Double {
        return self * 180 / .pi
    }
}

/// Structure for request body of posting a message
struct PostMessageRequest: Codable {
    let user_id: String
    let text: String
    let visibility: String
    let location: GeoJSONPoint
}

//// Structure for response of a message
struct MessageResponse: Codable {
    let _id: String
    let user_id: String
    let text: String
    let visibility: String
    let location: GeoJSONPoint
}

//// Structure for response of adding a friend
struct AddFriendResponse: Codable {
    let message: String
}

//// Structure for request body of adding a friend
struct FriendRequest: Codable {
    let friendName: String
}

//// Structure for user message data
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

//// Function to fetch user messages
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

/// Posts a message to a remote server.
/// - Parameters:
///   - user_id: A `String` representing the user's ID.
///   - text: The text content of the message.
///   - visibility: The visibility status of the message.
///   - locationDataManager: A `LocationDataManager` to provide the current location.
///   - completion: A completion handler that returns either `MessageResponse` or `Error`.
/// Posts a message to a remote server.
/// - Parameters:
///   - user_id: A `String` representing the user's ID.
///   - text: The text content of the message.
///   - visibility: The visibility status of the message.
///   - locationDataManager: A `LocationDataManager` to provide the current location.
///   - completion: A completion handler that returns either `MessageResponse` or `Error`.
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
func getAllUserFriends(userId: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
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
            let jsonMap = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            
            
            if let friends = jsonMap {
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

/// Function to add a friend by name
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

/// Function to delete a friend by name
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

func filterMessages(id: String, messages: [Message], location: (latitude: Double, longitude: Double), maxDistance: Double, friendsList: [String]) -> [Message] {
    return messages.filter { (message: Message) -> Bool in
        let messageLocation = (latitude: message.location.coordinate.latitude, longitude: message.location.coordinate.longitude)
        let distance = haversineDistance(la1: location.latitude, lo1: location.longitude, la2: messageLocation.latitude, lo2: messageLocation.longitude) * earthRadiusKm

        let isWithinDistance = distance <= maxDistance
        let isPublic = message.visibility == "public"
        let isFriend = message.visibility == "friends" && friendsList.contains(message.user_id)
        let byMe = message.user_id == id

        return isWithinDistance && (isPublic || isFriend || byMe)
    }
}

func haversineDistance(la1: Double, lo1: Double, la2: Double, lo2: Double) -> Double {
    let haversin = { (angle: Double) -> Double in
        return (1 - cos(angle))/2
    }

    let ahaversin = { (angle: Double) -> Double in
        return 2*asin(sqrt(angle))
    }

    // convert from degrees to radians
    let lat1 = la1.degreesToRadians
    let lon1 = lo1.degreesToRadians
    let lat2 = la2.degreesToRadians
    let lon2 = lo2.degreesToRadians

    return ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
}

func getFilteredMessages(userId: String, location: CLLocation, friendList: [String], completion: @escaping (Result<[Message], Error>) -> Void) {
    getUserMessages(userId: userId) {result in
        switch result {
        case .success(let response):
            print("Messages fetched successfully: \(response)")
            var convertedMessages:[Message] = []
            for m in response {
                do {
                    let convertedMessage = try Message(id: m._id,
                                                       user_id: userId,
                                                       location: m.location.toCLLocation(),
                                                       messageStr: m.text,
                                                       visibility: m.visibility)
                    convertedMessages.append(convertedMessage)
                }
                catch {
                    // Handle the error
                    print("Error: \(error)")
                }
            }
            
            let filteredMessages = filterMessages(
                id: userId,
                messages: convertedMessages,
                location: (location.coordinate.latitude, location.coordinate.longitude),
                maxDistance: distanceThreshold,
                friendsList: friendList)
            
            // JSON decoding
            completion(.success(filteredMessages))
            
            
        case .failure(let error):
            print("Error getting messages: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
 }


//getAllUserFriends(userId: <#T##String#>, completion: <#T##(Result<[String : String], Error>) -> Void#>) { friendsList in
//    guard let friendsList = friendsList else {
//        print("Failed to fetch friends list.")
//        return
//    }
//
//    fetchAllMessages(apiKey: apiKey) { messages in
//        if let messages = messages {
//            let filteredMessages = filterMessages(
//                messages: messages,
//                location: myLocation,
//                maxDistance: distanceThreshold,
//                friendsList: friendsList
//            )
//            print(messages.count)
//            print(filteredMessages.count)
//        } else {
//            print("Failed to fetch messages or decode them.")
//        }
//        semaphore.signal()
//    }
//    
//}
