//
//  UsersResponse.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 04.05.2023.
//

// MARK: - UsersResponse
struct UsersResponse: Codable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support
}
