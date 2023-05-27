//
//  Endpoint.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 26.05.2023.
//

import Foundation

// MARK: - Way to interact with API endpoints, using enum, query
enum Endpoint {
    // to PeopleView // page is using query parameter to make pagination
    case people(page: Int)
    
    // to DetailView
    case detail(id: Int)
    
    // to CreateView
    case create(submissionData: Data?)
}

// MARK: - Method type GET POST for endpoint
extension Endpoint {
    enum MethodType {
        case GET
        // send data with post method
        case POST(data: Data?)
    }
}

// MARK: - Paths
extension Endpoint {
    // base url
    var host: String { "reqres.in" }
    
    // path to different endpoints
    var path: String {
        switch self {
        case .people:
            return "/api/users"
        case let .detail(id):
            return "/api/users/\(id)"
        case .create:
            return "/api/users" // can merge 1 and 3 cases in one
        }
    }
    
    // method type from enum
    var methodType: MethodType {
        switch self {
        case .people:
            return .GET
        case .detail:
            return .GET
        case .create(let data):
            return .POST(data: data)
        }
    }
    
    
    // query items
    var queryItems: [String: String]? {
        switch self {
        case .people(let page):
            return ["page": "\(page)"]
        default:
            return nil
        }
    }
}

// MARK: - URL creation
extension Endpoint {
    
    var url: URL? {
        // create URLComponents object to create URL conditionally
        var urlComponents = URLComponents()
        // request schema http or https
        urlComponents.scheme = "https"
        // adding base url address to components
        urlComponents.host = host
        // adding path to components (people, detail(id: Int, create)
        urlComponents.path = path
        
        
        var requestQueryItems = queryItems?.compactMap { item in
            URLQueryItem(name: item.key, value: item.value)
        }
        #if DEBUG
        // query parameters (items) such as delay=3, pages
        requestQueryItems?.append(URLQueryItem(name: "delay", value: "1"))
        #endif
        urlComponents.queryItems = requestQueryItems
        return urlComponents.url
    }
}
