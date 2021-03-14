//
//  UserListRepository.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/2/23.
//

import Foundation
import RxSwift
import RxCocoa

class UserListRepository: UserListRepositoryInterface {
    
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchUserList(userQuery: UserQuery) -> Single<UserList> {
        var path = APIEndpoints.getUserList(query: userQuery.query)
        if let nextPath = userQuery.nextPath { path = nextPath }
        guard let url = URL(string: path)
        else { return Single.error(PossibleErrors.none) }
        
        return Single<UserList>.create { [weak self] single in
            self?.networkService.get(url: url) { (data, response, error) in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard
                    let response = response as? HTTPURLResponse,
                    let data = data,
                    var userList = try? JSONDecoder().decode(UserList.self, from: data)
                else {
                    return
                }
                if let nextPath = response.getPath(relType: .next) {
                    userList.nextPath = nextPath
                }else { userList.nextPath = nil }
                single(.success(userList))
            }
            
            return Disposables.create {}
        }
    }
    
}
