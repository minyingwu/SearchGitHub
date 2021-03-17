//
//  MainViewController.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/2/17.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var userListCollectionView: UICollectionView!
    
    @IBOutlet weak var mainSearchBar: UISearchBar!
    
    @IBOutlet weak var emptyPageLabel: UILabel!
    
    var searchTextField: UITextField {
        if #available(iOS 13.0, *) { return mainSearchBar.searchTextField }
        else {
            guard let searchTextField = mainSearchBar.value(forKey: "searchField") as? UITextField else { return UITextField() }
            return searchTextField
        }
    }
    
    var viewModel: MainViewModel?
    weak var coordinator: Coordinator?
    
    private lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    func setupUI() {
        mainSearchBar.returnKeyType = .default
        setKeyboardGesture()
        bindLoading()?.disposed(by: disposeBag)
        userListCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        userListCollectionView.rx.willDisplayCell
            .filter { [weak self] in
                guard let self = self else { return false }
                return self.isLoadingIndexPath(indexPath: $0.at) }
            .subscribe(onNext: { [weak self] _ in
                guard
                    let self = self, let viewModel = self.viewModel, viewModel.hasMorePage()
                else { return }
                self.startQuery()
            }).disposed(by: self.disposeBag)
    }
    
    func setupViewModel() {
        (searchTextField.rx.textInput <-> viewModel?.inputText)
            .disposed(by: disposeBag)
        
        viewModel?.isHiddenEmpty
            .bind(to: emptyPageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel?.inputText
            .filter { $0 != "" }
            .throttle(RxTimeInterval.seconds(1),
                      scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.startQuery(isFirst: true)
            }).disposed(by: disposeBag)
        
        viewModel?.userItems
            .bind(to: userListCollectionView.rx.items) { collectionView, row, item in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(type: UserItemCell.self, indexPath: indexPath)
                return cell.configure(item) }
            .disposed(by: disposeBag)
    }
    
    private func startQuery(isFirst: Bool = false) {
        viewModel?.query(isFirst: isFirst)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onPossibleError: {
                    self.showAlert(message: $0.localizedDescription) })
            .disposed(by: self.disposeBag)
    }
    
    private func isLoadingIndexPath(indexPath: IndexPath) -> Bool {
        let lastSectionIndex = self.userListCollectionView.numberOfSections - 1
        let lastItemIndex = self.userListCollectionView.numberOfItems(inSection: lastSectionIndex) - 1
        return indexPath.section == lastSectionIndex && indexPath.row == lastItemIndex
    }

}

extension MainViewController: Storyboarded {}
extension MainViewController: Loadable {}
extension MainViewController: Alertable {}
extension MainViewController: ViewModelable {}
extension MainViewController: Coordinated {}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
