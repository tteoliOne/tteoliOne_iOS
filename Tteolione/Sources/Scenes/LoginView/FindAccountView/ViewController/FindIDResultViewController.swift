//
//  FindIDResultViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/3/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class FindIDResultViewController: BaseViewController<FindIDResultView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension FindIDResultViewController: View {
    
    func bind(reactor: LoginReactor) {
//        bindAction(reactor)
//        bindState(reactor)
//        bindNavigation(reactor)
    }
    
}
