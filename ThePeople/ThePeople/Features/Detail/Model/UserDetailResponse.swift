//
//  UserDetailResponse.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 04.05.2023.
//

import Foundation

// MARK: - UserDetailResponse
struct UserDetailResponse: Codable {
    let data: User
    let support: Support
}

