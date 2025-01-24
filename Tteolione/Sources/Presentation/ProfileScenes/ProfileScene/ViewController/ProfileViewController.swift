//
//  ProfileViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class ProfileViewController: BaseViewController<ProfileView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ProfileCoordinatorDelegate?
    
}

extension ProfileViewController: View {
    
    func bind(reactor: ProfileReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ProfileReactor) {
        self.rx.viewWillAppear
            .map { _ in ProfileReactor.Action.fetchProfile }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.setButton.rx.tap
            .map { ProfileReactor.Action.resetProfileButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ProfileReactor) {
        reactor.state.map { $0.tableViewItems }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: ProfileListTableViewCell.identifier,
                cellType: ProfileListTableViewCell.self
            )) { _, item, cell in
                cell.selectionStyle = .none
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profile }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView, onNext: { owner, value in
                owner.setupViews(with: value)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isFailure }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView) { owner, _ in
                owner.resetProfile()
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ProfileReactor) {
        rootView.tableView.rx.itemSelected
            .map { indexPath in
                return indexPath.row
            }
            .subscribe(onNext: { selectedIndex in
                switch selectedIndex {
                case 0:
                    print(1)
                case 1:
                    print(2)
                case 2:
                    print(3)
                case 3:
                    print(4)
                case 4:
                    self.rootView.resetProfileField()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController: DelegateOwner {
    typealias Delegate = ProfileCoordinatorDelegate
}
