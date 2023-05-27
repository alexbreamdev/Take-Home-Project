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
    
    func fetchUsers() async {
        // set status is loading
        isLoading = true
        // reset isLoading status when everything is executed
        defer {
            isLoading = false
        }
        
        do {
            // request using endpoint and user
            self.users = try await NetworkingManager.shared.request(Endpoint.people, type: UsersResponse.self).data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}
