//
//  CreateViewModel.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 17.05.2023.
//

import Foundation

@MainActor
final class CreateViewModel: ObservableObject {
    @Published var person = NewPerson()
    @Published private(set) var state: SubmissionState?
    @Published private(set) var error: FormError?
    @Published var hasError = false
    // instance of validator
    private let validator = CreateValidator()
  
    func create() async {
        do {
            try validator.validate(person: person)
            self.state = .submitting
            // encode object to data to sent with networking manager
            defer {
                self.state = .successful
            }
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(person)
            
            try await NetworkingManager.shared.request(Endpoint.create(submissionData: data))
        } catch {
            self.hasError = true
            self.state = .unsuccessful
           
            switch error {
                case is NetworkingManager.NetworkingError:
                    self.error = .networking(error: error as! NetworkingManager.NetworkingError)
                case is CreateValidator.CreateValidatorError:
                    self.error = .networking(error: error as! CreateValidator.CreateValidatorError)
            default:
                self.error = .system(error: error)
            
            }
        }
    }
}

// MARK: - Submission state
extension CreateViewModel {
    enum SubmissionState {
        case unsuccessful
        case successful
        case submitting
    }
}

// MARK: - Generalize NetworkingError and CreateValidatorError
extension CreateViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateViewModel.FormError {
    var errorDescription: String? {
        switch self {
        case .networking(let error):
            return error.errorDescription
        case .validation(let error):
            return error.errorDescription
        case .system(let error) :
            return error.localizedDescription
        }
    }
}
