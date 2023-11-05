//
//  Message_View.swift
//  here
//
//  Created by Liyang Wang on 10/10/23.
//

import SwiftUI
import CoreLocation
import Foundation

let apiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

struct PostMessageRequest: Codable {
    let user_id: String
    let text: String
    let visibility: String
    let location: GeoJSONPoint
}

struct MessageResponse: Codable {
    let _id: String
    let user_id: String
    let text: String
    let visibility: String
    let location: GeoJSONPoint
}

struct PostsPopup: View {
    @Binding var isPresented: Bool
    @Binding var storedMessages: [Message]
    
    @State private var noteMessage: String = "This is your message!"
    
    @EnvironmentObject var messageState: MessageState
    
    let senderName: String = "Username"

    @EnvironmentObject var locationDataManager: LocationDataManager
    
    func postMessage(user_id: String, text: String, visibility: String, completion: @escaping (Result<MessageResponse, Error>) -> Void) {
        // make sure you can get the current location
        if let currentLocation = locationDataManager.location {
            
            guard let url = URL(string: "https://here-swe.vercel.app/message/post_message") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
            
            let requestBody = PostMessageRequest(user_id: user_id, text: text, visibility: visibility, location: currentLocation.toGeoJSONPoint())
            request.httpBody = try? JSONEncoder().encode(requestBody)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                            // Handle the case when the response is not an HTTPURLResponse or the status code is not in the range.
                            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                            completion(.failure(NSError(domain: "", code: statusCode, userInfo: nil)))
                            return
                    }
                    do {
                        let messageResponse = try JSONDecoder().decode(MessageResponse.self, from: data)
                        completion(.success(messageResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
        }
        
        
        
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                VStack(spacing: 10) {
                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented.toggle() // Close the popup
                        }) {
                            Text("Close")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.trailing, 20) // Adjust the position of the close button
                    }
                    .padding(.leading, 20)

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)

                        VStack {
                            TextEditor(text: $noteMessage)
                                .padding(.all, 30)

                            Spacer(minLength: 20)

                            HStack {
                                Button(action: {
                                    // Share Action
                                }, label: {
                                    Image(systemName: "square.and.arrow.up.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, 20)
                                })

                                Spacer()

                                Button(action: {
                                    postMessage(user_id: "653d51478ff5b3c9ace45c26", text: noteMessage, visibility: "friends") {
                                        result in
                                        switch result {
                                        case .success(let response):
                                            print("Message posted successfully: \(response)")
                                            
                                            
                                            do {
                                                let newMessage = try Message(id: response._id, location: response.location.toCLLocation(), author: "Anna", messageStr: response.text)
                                                // Use newMessage here
                                                    self.storedMessages.append(newMessage)
                                                
                                                messageState.currentMessage = newMessage
                                                
                                            } catch {
                                                // Handle the error
                                                print("Error: \(error)")
                                            }
                                                                                        
                                            
                                        case .failure(let error):
                                            print("Error posting message: \(error.localizedDescription)")
                                        }
                                    }
                                }, label: {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 20)
                                })
                            }
                            .padding(.bottom, 25)
                        }
                    }
                    .opacity(0.5)
                    .frame(width: geometry.size.width - 40, height: geometry.size.width - 40)
                    
                    Spacer()
                }
            }
        }
    }
}
