//
//  NewPerson.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 17.05.2023.
//

import Foundation

// MARK: - Struct to create and send person data with POST request
struct NewPerson: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var job: String = ""
}
