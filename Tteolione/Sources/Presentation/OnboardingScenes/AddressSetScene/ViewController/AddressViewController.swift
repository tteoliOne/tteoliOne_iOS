//
//  AddressViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

//import UIKit
import ReactorKit
import RxCocoa
import MapKit

final class AddressViewController: BaseViewController<AddressView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: LoginCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "주소설정"
    }
    
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
        reactor.state.map { $0.isLocationSelected }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.goHome()
            }
            .disposed(by: disposeBag)
    }
    
}

extension AddressViewController: DelegateOwner {
    typealias Delegate = LoginCoordinatorDelegate
}
