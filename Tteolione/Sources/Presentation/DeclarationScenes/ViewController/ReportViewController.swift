//
//  ReportViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import ReactorKit
import RxCocoa

final class ReportViewController: BaseViewController<ReportView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ReportCoordinatorDelegate?
    
}

extension ReportViewController: View {
    
    func bind(reactor: ReportReactor) {
        bindAction(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ReportReactor) {
        rootView.checkButton.rx.tap
            .map { ReportReactor.Action.checkButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ReportReactor) {
        reactor.state.map { $0.isCheckButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.delegate?.finishView()
            }
            .disposed(by: disposeBag)
    }
}

extension ReportViewController: DelegateOwner {
    typealias Delegate = ReportCoordinatorDelegate
}
