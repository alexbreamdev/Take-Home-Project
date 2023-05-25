//
//  CreateValidator.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 25.05.2023.
//

import Foundation

// MARK: - Validates form fields in CreateView
// throws error if field is empty
struct CreateValidator {
    func validate(person: NewPerson) throws {
        if person.firstName.isEmpty {
            throw CreateValidatorError.invalidFirstName
        }
        
        if person.lastName.isEmpty {
            throw CreateValidatorError.invalidLastName
        }
        
        if person.job.isEmpty {
            throw CreateValidatorError.invalidJob
        }
    }
}

extension CreateValidator {
    enum CreateValidatorError: LocalizedError {
        case invalidFirstName
        case invalidLastName
        case invalidJob
    }
}

extension CreateValidator.CreateValidatorError {
    var errorDescription: String? {
        switch self {
        case .invalidFirstName:
            return "First name can't be empty"
        case .invalidLastName:
            return "Last name can't be empty"
        case .invalidJob:
            return "Job name can't be empty"
        }
    }
}
