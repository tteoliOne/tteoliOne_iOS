//
//  EtcReportViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import ReactorKit
import RxCocoa

final class EtcReportViewController: BaseViewController<EtcReportView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ReportCoordinatorDelegate?
    
}

extension EtcReportViewController: View {
    
    func bind(reactor: EtcReportReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: EtcReportReactor) {
        rootView.reportTextView.rx.text.orEmpty
            .map { $0.count <= 100 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
                if !isEditable {
                    self?.rootView.reportTextView.text = String(self?.rootView.reportTextView.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        rootView.reportTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { EtcReportReactor.Action.updateReportText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.reportButton.rx.tap
            .map { EtcReportReactor.Action.reportButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: EtcReportReactor) {
        reactor.state.map { $0.reportLengthText }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.remainCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: EtcReportReactor) {
        reactor.state.map { $0.isReport }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.delegate?.finishView()
            }
            .disposed(by: disposeBag)
    }
}

extension EtcReportViewController: DelegateOwner {
    typealias Delegate = ReportCoordinatorDelegate
}
