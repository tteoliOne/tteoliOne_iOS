//
//  FindAccountDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/4/25.
//

import Foundation

protocol FindIDViewControllerDelegate: AnyObject, Coordinator {
    func showFindAuth()
}

protocol AuthViewControllerDelegate: AnyObject, Coordinator {
    func showFindIDResult(with dto: FindIDDTO)
}

protocol FindIDResultViewControllerDelegate: AnyObject, Coordinator {
    func showFindIDResult()
}
