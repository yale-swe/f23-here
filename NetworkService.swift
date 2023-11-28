//
//  NetworkService.swift
//  newHereTests_v2
//
//  Created by Liyang Wang on 11/27/23.
//

import Foundation

struct UserData {
    //
}

class NetworkService {

    func fetchUserData(completion: @escaping (Result<UserData, Error>) -> Void) {

        DispatchQueue.global().async {

            let mockUserData = UserData()


            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                completion(.success(mockUserData))
            }
        }
    }

}
