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
    func request<T: Codable>(_ endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        // create url from string
        guard let url = endpoint.url else {
            // use Result completion handler to consume error
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        // create url request
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
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
    
    // MARK: -
    func request(_ endpoint: Endpoint, completion: @escaping (Result<Void, Error>) -> Void) {
        // create url from string
        guard let url = endpoint.url else {
            // use Result completion handler to consume error
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        // create url request
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
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
                return
            }
            
            completion(.success(()))
        }
        
        // don't forget resume data task
        dataTask.resume()
    }
}

extension NetworkingManager {
    enum NetworkingError: LocalizedError {
        case invalidURL
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension NetworkingManager.NetworkingError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL isn't valid"
        case .custom(let error):
            return "Something wrong. \(error)"
        case .invalidStatusCode(let statusCode):
            return "Status code: \(statusCode). Wrong response."
        case .invalidData:
            return "Wrong data response."
        case .failedToDecode(let error):
        return "Can't decoded data. \(error)"
        }
    }
}


private extension NetworkingManager {
    func buildRequest(from url: URL, methodType: Endpoint.MethodType) -> URLRequest {
        // create url request
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        }
        return request
    }
}
