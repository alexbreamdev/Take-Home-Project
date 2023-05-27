//
//  DetailViewModel.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 17.05.2023.
//

import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var support: Support?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var isLoading: Bool = false
    @Published var hasError = false
    
    func fetchDetails(for userId: Int) async {
        // set status is loading
        isLoading = true
        // reset isLoading status when everything is executed
        defer {
            isLoading = false
        }
        
        do {
            // request using endpoint and user
            let userResponse = try await NetworkingManager.shared.request(Endpoint.detail(id: userId), type: UserDetailResponse.self)
            self.user = userResponse.data
            self.support = userResponse.support
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
