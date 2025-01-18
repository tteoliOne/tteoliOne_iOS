//
//  Reactive+Extension.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import UIKit
import RxSwift

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
    }

    var viewDidAppear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .map { _ in }
    }
    
    var viewWillDisappear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
            .map { _ in }
    }
}
