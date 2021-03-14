//
//  AppCoordinator.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/2/17.
//

import UIKit

class AppCoordinator {
    var window: UIWindow
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    private lazy var networkService: NetworkService = NetworkService()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    private func makeMainVC() -> UIViewController {
        return MainViewController
            .instantiate(Storyboards[.Main])
            .bind(viewModel: MainViewModel(searchUserListUseCase: makeUseCase()))
            .bind(self)
    }
}

extension AppCoordinator: Coordinator {
    
    func start() {
        window.rootViewController = makeMainVC()
        window.makeKeyAndVisible()
    }
    
}
extension AppCoordinator {
    private func makeUseCase() -> SearchUserListUseCase {
        return SearchUserListUseCase(userListRepository: UserListRepository(networkService: networkService))
    }
}

