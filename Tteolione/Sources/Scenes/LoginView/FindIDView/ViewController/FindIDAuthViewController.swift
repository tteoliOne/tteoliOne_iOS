//
//  FindIDAuthViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/2/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class FindIDAuthViewController: BaseViewController<FindIDAuthView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension FindIDAuthViewController: View {
    
    func bind(reactor: LoginReactor) {
//        bindAction(reactor)
//        bindState(reactor)
//        bindNavigation(reactor)
    }
    
}
