//
//  PeopleVIewModel.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 17.05.2023.
//

import Foundation

@MainActor
final class PeopleViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var isLoading: Bool = false
    @Published var hasError = false
    
    func fetchUsers() {
        isLoading = true
        NetworkingManager.shared.request("https://reqres.in/api/users?delay=3", type: UsersResponse.self) {[weak self] result in
            // returned last in the block
            defer {
                self?.isLoading = false
            }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.users = response.data
           
                }
            case .failure(let error):
                
                self?.hasError = true
                self?.error = error as? NetworkingManager.NetworkingError
            }
        }
    }
}
