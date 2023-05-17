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
                case .failure(let err):
                    self?.state = .unsuccessful
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
