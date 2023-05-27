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
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    private var page = 1
    private var totalPages: Int?
    
    func fetchUsers() async {
        reset()
        // set status is loading
        viewState = .loading
        // reset isLoading status when everything is executed
        defer {
            viewState = .finished
        }
        
        do {
            // request using endpoint and user
            let response = try await NetworkingManager.shared.request(Endpoint.people(page: page), type: UsersResponse.self)
            totalPages = response.totalPages
            self.users = response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    // pagination function
    func fetchNextSetOfUsers() async {
        guard page != totalPages else {
            return
        }
        
        viewState = .fetching
        defer {
            viewState = .finished
        }
        // change
        page += 1
        
        do {
            // append new butch of users to
            let response = try await NetworkingManager.shared.request(Endpoint.people(page: page), type: UsersResponse.self)
            totalPages = response.totalPages
            self.users += response.data
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    // function compares last user in array with user passed (visible on screen)
    func hasReachedEnd(of user: User) -> Bool {
        return users.last?.id == user.id
    }
}

// MARK: - State of VIew
extension PeopleViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

private extension PeopleViewModel {
    func reset() {
        if viewState == .finished {
            users.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
}
