//
//  CreateViewModel.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 17.05.2023.
//

import Foundation


final class CreateViewModel: ObservableObject {
    @Published var person = NewPerson()
    @Published private(set) var state: SubmissionState?
    @Published private(set) var error: FormError?
    @Published var hasError = false
    // instance of validator
    private let validator = CreateValidator()
    func create() {
        do {
            try validator.validate(person: person)
            self.state = .submitting
            // encode object to data to sent with networking manager
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? encoder.encode(person)
            
            NetworkingManager.shared.request(methodType: .POST(data: data), "https://reqres.in/api/users?delay=3", completion: {[weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.state = .successful
                    case .failure(let error):
                        self?.state = .unsuccessful
                        self?.hasError = true
                        if let networkingError = error as? NetworkingManager.NetworkingError {
                            self?.error = .networking(error: networkingError)//!!!!!!!!
                        }
                    }
                }
            })
        } catch {
            self.hasError = true
            if let validationError = error as? CreateValidator.CreateValidatorError {
                self.error = .validation(error: validationError)
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
    }
}

extension CreateViewModel.FormError {
    var errorDescription: String? {
        switch self {
        case .networking(let error):
            return error.errorDescription
        case .validation(let error):
            return error.errorDescription
        }
    }
}
