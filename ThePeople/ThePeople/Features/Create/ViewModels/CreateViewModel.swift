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
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError = false
    
    func create() {
        // encode object to data to sent with networking manager
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(person)
        
        NetworkingManager.shared.request(methodType: .POST(data: data), "https://reqres.in/api/users", completion: {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.state = .successful
                case .failure(let error):
                    self?.state = .unsuccessful
                    self?.hasError = true
                    self?.error = error as? NetworkingManager.NetworkingError
                }
            }
        })
    }
}

// MARK: - Submission state
extension CreateViewModel {
    enum SubmissionState {
        case unsuccessful
        case successful
    }
}
