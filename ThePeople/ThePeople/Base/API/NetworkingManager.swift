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
    
    // MARK: - Request async/avait
    func request<T: Codable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        // create url from string
        guard let url = endpoint.url else {
            // throw error if url returns nill
            throw NetworkingError.invalidURL
        }
        // create url request
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        // async request to API returns data and response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // check if resp status code is correct
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode)
        else {
            // get status failed code
            let statusCode = (response as! HTTPURLResponse).statusCode
            // pass status code with error enum
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        
        // decode data object
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let res = try decoder.decode(T.self, from: data)
        return res
      
    }
    
    // MARK: - check response status code and other errors
    func request(_ endpoint: Endpoint) async throws {
        // create url from string
        guard let url = endpoint.url else {
            // throw error if url returns nill
            throw NetworkingError.invalidURL
        }
        // create url request
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        // async request to API returns data and response
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // check if resp status code is correct
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode)
        else {
            // get status failed code
            let statusCode = (response as! HTTPURLResponse).statusCode
            // pass status code with error enum
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
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
