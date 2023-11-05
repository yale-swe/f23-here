//
//  api_call.swift
//  newHere
//
//  Created by Phuc Duong on 11/5/23.
//


import Foundation

let apiKey2 = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

struct UserMessage: Codable {
    struct Location: Codable {
        let type: String
        let coordinates: [Double]
    }

    let location: Location
    let _id: String
    let user_id: String
    let text: String
    let likes: Int
    let visibility: String
    let replies: [String]
}

func getUserMessages(userId: String, completion: @escaping (Result<[UserMessage], Error>) -> Void) {
    let urlString = "https://here-swe.vercel.app/user/\(userId)/messages"
    
    guard let url = URL(string: urlString) else {
        completion(.failure(URLError(.badURL)))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(apiKey2, forHTTPHeaderField: "X-API-Key")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        
        guard let data = data else {
            completion(.failure(URLError(.cannotParseResponse)))
            return
        }
        
        do {
            let messages = try JSONDecoder().decode([UserMessage].self, from: data)
            completion(.success(messages))
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
    
}
