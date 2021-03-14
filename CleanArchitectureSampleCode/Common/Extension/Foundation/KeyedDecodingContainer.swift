//
//  KeyedDecodingContainer.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/2/23.
//

import Foundation

extension KeyedDecodingContainer {
    
    func decodeWrapper<T: Decodable>(key: K, defaultValue: T) throws -> T {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
    
}
