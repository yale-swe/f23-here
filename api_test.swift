import Foundation
import CoreLocation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


struct Message: Codable {
    let location: Location
    let _id: String
    let user_id: String
    let text: String
    let likes: Int
    let visibility: String
    let replies: [Reply]
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case location, _id, user_id, text, likes, visibility, replies
        case __v = "__v"
    }
}

struct Location: Codable {
    let type: String
    let coordinates: [Double]
}

struct Reply: Codable {
    let _id: String
    let parent_message: String
    let content: String
    let likes: Int
    let __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, parent_message, content, likes
        case __v = "__v"
    }
}

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



// constants
let ogUserId = "653d51628ff5b3c9ace45c2c"
let apiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"
let semaphore = DispatchSemaphore(value: 0)

// Earth's radius in kilometers
let myLocation = (latitude: 41.3126240684926, longitude: -72.9291935416862)
let earthRadiusKm: Double = 6371.0
let distanceThreshold: Double = 0.2 // kilometers


func fetchFriendsList(userId: String, apiKey: String, completion: @escaping ([String]?) -> Void) {
    let url = URL(string: "http://localhost:6000/user/\(userId)/friends")!

    var request = URLRequest(url: url)
    request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        do {
            let friendsList = try JSONDecoder().decode([String].self, from: data)
            completion(friendsList)
        } catch {
            print(error)
            completion(nil)
        }
    }

    task.resume()
}

func fetchAllMessages(apiKey: String, completion: @escaping ([Message]?) -> Void) {
    let urlString = "http://localhost:6000/message/get_all_messages"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching messages: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Server error")
            completion(nil)
            return
        }

        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }

        do {
            let messages = try JSONDecoder().decode([Message].self, from: data)
            completion(messages)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            completion(nil)
        }
    }

    task.resume()
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

func filterMessages(messages: [Message], location: (latitude: Double, longitude: Double), maxDistance: Double, friendsList: [String]) -> [Message] {
    return messages.filter { message in
        let messageLocation = (latitude: message.location.coordinates[1], longitude: message.location.coordinates[0])
        let distance = haversineDistance(la1: location.latitude, lo1: location.longitude, la2: messageLocation.latitude, lo2: messageLocation.longitude) * earthRadiusKm

        let isWithinDistance = distance <= maxDistance
        let isPublic = message.visibility == "public"
        let isFriend = message.visibility == "friends" && friendsList.contains(message.user_id)

        return isWithinDistance && (isPublic || isFriend)
    }
}

fetchFriendsList(userId: ogUserId, apiKey: apiKey) { friendsList in
    guard let friendsList = friendsList else {
        print("Failed to fetch friends list.")
        return
    }

    fetchAllMessages(apiKey: apiKey) { messages in
        if let messages = messages {
            let filteredMessages = filterMessages(
                messages: messages,
                location: myLocation,
                maxDistance: distanceThreshold,
                friendsList: friendsList
            )
            print(messages.count)
            print(filteredMessages.count)
        } else {
            print("Failed to fetch messages or decode them.")
        }
        semaphore.signal()
    }
    
}

semaphore.wait()

