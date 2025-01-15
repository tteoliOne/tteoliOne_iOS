//
//  FindAccountDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/4/25.
//

import Foundation

protocol FindIDCoordinatorDelegate: Coordinator {
    func showFindAuth()
}

protocol AuthCoordinatorDelegate: Coordinator {
    func showFindIDResult(with resultData: FindIDDTO)
}

protocol FindIDResultCoordinatorDelegate: Coordinator {
    func showPasswordResetView()
    func goToLogin()
}
