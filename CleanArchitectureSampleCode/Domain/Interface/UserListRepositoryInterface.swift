//
//  UserListRepositoryInterface.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/2/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserListRepositoryInterface {
    func fetchUserList(userQuery: UserQuery) -> Single<UserList>
}
