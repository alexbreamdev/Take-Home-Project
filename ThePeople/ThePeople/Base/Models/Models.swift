//
//  Models.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 04.05.2023.
//

import Foundation
// FILE WITH REUSABLE MODELS FOR DIFFERENT REQUESTS
// MARK: - User
struct User: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName
        case lastName
        case avatar
    }
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}

extension User: Identifiable, Hashable {
    
}
