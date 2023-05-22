//
//  DetailViewModel.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 17.05.2023.
//

import Foundation

final class DetailViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var support: Support?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var isLoading: Bool = false
    @Published var hasError = false
    
    func fetchDetails(for userId: Int) {
        isLoading = true
        NetworkingManager.shared.request("https://reqres.in/api/users/\(userId)", type: UserDetailResponse.self) {[weak self] result in
            defer {
                self?.isLoading = false
            }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.user = response.data
                    self?.support = response.support
                }
            case .failure(let error):
                self?.hasError = true
                self?.error = error as? NetworkingManager.NetworkingError
            }
        }
    }
}
