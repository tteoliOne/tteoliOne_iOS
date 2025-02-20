//
//  AddressViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

import ReactorKit
import RxCocoa
import MapKit

final class AddressViewController: BaseViewController<AddressView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: AddressCoordinatorDelegate?
    
}

extension AddressViewController: View {
    
    func bind(reactor: AddressReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: AddressReactor) {
        rootView.searchBar.rx.text.orEmpty
            .map { AddressReactor.Action.updateSearchWord($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.myLocationButton.rx.tap
            .map { AddressReactor.Action.myLocationButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.backButton.rx.tap
            .map { AddressReactor.Action.myLocationButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(MKLocalSearchCompletion.self)
            .map { AddressReactor.Action.selectSearchResult($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AddressReactor) {
        reactor.state.map { $0.searchResults }
            .distinctUntilChanged()
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: AddressTableViewCell.identifier,
                cellType: AddressTableViewCell.self
            )) { _, model, cell in
                cell.addressTitleLabel.text = model.title
                cell.addressSubTitleLabel.text = model.subtitle
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: AddressReactor) {
        reactor.state.map { $0.isBackButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.finshView()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { ($0.isLocationSelected, $0.addressViewType) }
            .filter { $0.0 }
            .compactMap { $0.1 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, status in
                print(status)
                switch status {
                case .login:
                    owner.delegate?.goHome()
                    
                case .change:
                    owner.delegate?.finshView()
                }
            }
            .disposed(by: disposeBag)
    }
    
}

extension AddressViewController: DelegateOwner {
    typealias Delegate = AddressCoordinatorDelegate
}
