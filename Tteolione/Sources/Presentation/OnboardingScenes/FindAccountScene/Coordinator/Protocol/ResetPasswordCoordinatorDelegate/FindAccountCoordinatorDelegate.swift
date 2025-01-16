//
//  FindAccountCoordinatorDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/16/25.
//

import Foundation

protocol FindAccountCoordinatorDelegate: Coordinator {
    func pushFindIdViewController()
    func pushResultIdViewController(with resultData: FindIDDTO)
    func pushResetPasswordChcekViewController()
    func pushAuthViewController(viewType: AccountCoordinator)
    func pushResetPasswordViewController()
    func finish()
}
