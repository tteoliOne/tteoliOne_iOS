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
        
    }
    
    func bindState(_ reactor: EtcReportReactor) {
        
    }
    
    func bindNavigation(_ reactor: EtcReportReactor) {
        
    }
}

extension EtcReportViewController: DelegateOwner {
    typealias Delegate = ReportCoordinatorDelegate
}
