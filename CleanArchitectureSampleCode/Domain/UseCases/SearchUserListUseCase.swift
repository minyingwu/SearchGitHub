//
//  SearchUserListUseCase.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/2/23.
//

import Foundation
import RxSwift
import RxCocoa

class SearchUserListUseCase {
    
    private let userListRepository: UserListRepositoryInterface
    
    init(userListRepository: UserListRepositoryInterface) {
        self.userListRepository = userListRepository
    }
    
    func execute(userQuery: UserQuery) -> Single<UserList> {
        return userListRepository.fetchUserList(userQuery: userQuery)
    }
    
}


