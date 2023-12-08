//
//  UserProfileViewModel.swift
//  newHere
//
//  Created by YIMING GUAN on 2023/12/7.
//

import Foundation
import SwiftUI

class UserProfileViewModel: ObservableObject {
    @Published var username: String = userName
    @Published var email: String = userEmail
    @Published var profileImage: UIImage? = nil
    // Add other profile properties here

    // Implement methods to update these properties, for example, from an API
}
