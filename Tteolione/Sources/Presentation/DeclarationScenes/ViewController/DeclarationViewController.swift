//
//  DeclarationViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import ReactorKit
import RxCocoa
import UIKit

final class DeclarationViewController: BaseViewController<DeclarationView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ReportCoordinatorDelegate?
    
}

extension DeclarationViewController: View {
    
    func bind(reactor: DeclarationReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: DeclarationReactor) {
        rootView.tableView.rx.itemSelected
            .map { indexPath in
                return indexPath.row
            }
            .subscribe(onNext: { selectedIndex in
                switch selectedIndex {
                case 0:
                    reactor.action.onNext(.spamTap)
                case 1:
                    reactor.action.onNext(.imageAndViolenceTap)
                case 2:
                    reactor.action.onNext(.informationTap)
                case 3:
                    reactor.action.onNext(.etcTap)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: DeclarationReactor) {
        reactor.state.map { $0.tableViewItems }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: DeclaractionTableViewCell.identifier,
                cellType: DeclaractionTableViewCell.self
            )) { _, item, cell in
                cell.selectionStyle = .none
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: DeclarationReactor) {
        reactor.state.map { $0.isShowReportSuccess }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.delegate?.pushReportViewController()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowEtcScreen }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.delegate?.pushEtcReportViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension DeclarationViewController: DelegateOwner {
    typealias Delegate = ReportCoordinatorDelegate
}
