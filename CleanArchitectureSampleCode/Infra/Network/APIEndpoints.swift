//
//  APIEndpoints.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/2/23.
//

import Foundation

class APIEndpoints {
    
    static func getUserList(query: String) -> String {
        return "https://api.github.com/search/users?q=\(query)+in:login&type=Users".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

