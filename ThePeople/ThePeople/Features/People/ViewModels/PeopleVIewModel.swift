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
    
    func fetchUsers() {
        NetworkingManager.shared.request("https://reqres.in/api/users", type: UsersResponse.self) {[weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.users = response.data
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
