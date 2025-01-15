//
//  AddressViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

//import UIKit
import ReactorKit
import RxCocoa

final class AddressViewController: BaseViewController<AddressView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: AddressCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "주소설정"
    }
    
}

extension AddressViewController: View {
    
    func bind(reactor: AddressReactor) {
//        bindAction(reactor)
//        bindState(reactor)
//        bindNavigation(reactor)
    }
    
}

extension AddressViewController: DelegateOwner {
    typealias Delegate = AddressCoordinatorDelegate
}
