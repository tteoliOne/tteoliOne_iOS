//
//  PostReceiptViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class PostReceiptViewController: BaseViewController<PostReceiptView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
        }
    }
    
}
