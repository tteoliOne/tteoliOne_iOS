//
//  LoginDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 12/20/24.
//

import Foundation

protocol LoginCoordinatorDelegate: Coordinator {
    func showSignUpView()
    func showFindIDView()
    func showFindPasswordView()
    func showAddressView()
}
