//
//  ProfileSetViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class ProfileSetViewController: BaseViewController<ProfileSetView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ProfileSetReactor()
    }
    
}

extension ProfileSetViewController: View {
    
    func bind(reactor: ProfileSetReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: ProfileSetReactor) {
        
    }
    
    private func bindState(_ reactor: ProfileSetReactor) {
        
    }
    
    private func bindNavigation(_ reactor: ProfileSetReactor) {
        
    }
}
