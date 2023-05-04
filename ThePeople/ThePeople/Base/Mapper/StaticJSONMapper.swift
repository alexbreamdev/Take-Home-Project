//
//  StaticJSONMapper.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 04.05.2023.
//

import Foundation

// MARK: - DECODING FROM JSON FILES WITH DUMMY DATA
struct StaticJSONMapper {
    // using generics to use any codable type in function
    static func decode<T: Codable>(file: String, type: T.Type) throws -> T {
        // check if there is data at file and file in file system
        guard let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else { throw MapperError.failedToGetContents }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let result = try decoder.decode(type, from: data)
            return result
        } catch {
            throw MapperError.failedToDecode
        }
    }
}

// MARK: - Error for StaticJSONMapper
extension StaticJSONMapper {
    enum MapperError: Error {
        case failedToGetContents
        case failedToDecode
    }
}
