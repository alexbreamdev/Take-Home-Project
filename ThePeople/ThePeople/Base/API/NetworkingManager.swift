//
//  NetworkingManager.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 17.05.2023.
//

import Foundation


class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {}
    
    // MARK: - Request with closure
    func request<T: Codable>(_ absoluteURL: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        // create url from string
        guard let url = URL(string: absoluteURL) else {
            // use Result completion handler to consume error
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        // create url request
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, resp, error in
            // check if there is an error
            if error != nil {
                completion(.failure(NetworkingError.custom(error: error!)))
                return
            }
            
            // check if resp status code is correct
            guard let response = resp as? HTTPURLResponse,
                  (200...300).contains(response.statusCode)
            else {
                let statusCode = (resp as! HTTPURLResponse).statusCode
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
                return }
            
            // check if there is data object
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return }
        
            // decode data object
            let decoder = JSONDecoder()
            do {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let res = try decoder.decode(T.self, from: data)
                completion(.success(res))
            } catch {
                completion(.failure(NetworkingError.failedToDecode(error: error)))
            }
        }
        
        // don't forget resume data task
        dataTask.resume()
    }
}

extension NetworkingManager {
    enum NetworkingError: Error {
        case invalidURL
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}