//
//  HTTPURLResponse+linkHeader.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/3/14.
//

import Foundation

extension HTTPURLResponse {
    
    var linkHeader: [String: String]? {
        guard let linkHeader = self.allHeaderFields["Link"] as? String else {
            return nil
        }
        let links = linkHeader.components(separatedBy: ",")
        var dictionary: [String: String] = [:]
        links.forEach({
            let components = $0.components(separatedBy:"; ")
            let cleanPath = components[0]
                .trimmingCharacters(in: .whitespaces)
                .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            dictionary[components[1]] = cleanPath
        })
        return dictionary
    }
    
    func getPath(relType: RelType) -> String? {
        guard let linkHeader = linkHeader else { return nil }
        return linkHeader[relType.key]
    }
    
    enum RelType {
        case first
        case last
        case prev
        case next
        
        var key: String { "rel=\"\(String(describing: self))\"" }
    }
    
}
