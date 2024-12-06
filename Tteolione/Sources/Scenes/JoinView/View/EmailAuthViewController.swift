//
//  EmailAuthViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/6/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class EmailAuthViewController: BaseViewController<EmailAuthView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = EmailAuthReactor()
    }
    
}

extension EmailAuthViewController: View {
    
    func bind(reactor: EmailAuthReactor) {
        
    }
    
}
