//
//  MainViewModel.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/2/22.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModel {
    
    let searchUserListUseCase: SearchUserListUseCase
    
    var inputText = BehaviorRelay<String>(value: "")
    
    var userItems = BehaviorRelay<[UserItem]>(value: [])
    
    var isHiddenEmpty: Observable<Bool> { userItems.map { $0.count > 0 } }
    
    var totalCount = 0
    var nextPath: String?
    
    init(searchUserListUseCase: SearchUserListUseCase) {
        self.searchUserListUseCase = searchUserListUseCase
    }
    
    func query(isFirst: Bool) -> Single<Void> {
        if isFirst { clearResult() }
        self.isLoading.accept(true)
        let userQuery = UserQuery(query: inputText.value, nextPath: nextPath)
        return searchUserListUseCase.execute(userQuery: userQuery).map { [weak self] result -> Void in
            self?.isLoading.accept(false)
            guard let self = self else { throw PossibleErrors.none }
            guard result.totalCount > 0 else { return }
            self.totalCount = result.totalCount
            self.nextPath = result.nextPath
            var currentItems = self.userItems.value
            currentItems.append(contentsOf: result.items)
            self.userItems.accept(currentItems)
        }
    }
    
    func hasMorePage() -> Bool {
        nextPath != nil && userItems.value.count < totalCount
    }
    
    private func clearResult() {
        userItems.accept([])
        totalCount = 0
        nextPath = nil
    }
    
}
