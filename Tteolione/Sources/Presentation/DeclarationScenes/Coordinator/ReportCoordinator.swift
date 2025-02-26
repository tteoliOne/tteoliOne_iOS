//
//  ReportCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import UIKit

final class ReportCoordinator: NSObject, ReportCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    private let reportType: ReportType
    private let reportId: Int
    private let opponentId: Int?
    
    init(navigationController: UINavigationController,
         dependency: AppDependency,
         reportType: ReportType,
         reportId: Int,
         opponentId: Int? = nil) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.reportType = reportType
        self.reportId = reportId
        self.opponentId = opponentId
    }
    
    func start() {
        pushDeclarationViewController()
    }
    
}

extension ReportCoordinator {
    
    func pushDeclarationViewController() {
        let reactor = DeclarationReactor(networkProvider: dependency.userProvider,
                                         reportId: reportId,
                                         reportType: reportType,
                                         opponent: opponentId)
        let viewController = createViewController(
            ofType: DeclarationViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.view.backgroundColor = .myAppLightGray2
        viewController.modalPresentationStyle = .pageSheet
        viewController.isModalInPresentation = false
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.delegate = self
        }
        show(viewController, as: .present)
    }
    
    func pushReportViewController() {
        let reactor = ReportReactor()
        let viewController = createViewController(
            ofType: ReportViewController.self,
            with: reactor,
            delegate: self
        )

        viewController.modalPresentationStyle = .pageSheet
        viewController.transitioningDelegate = self
        viewController.view.backgroundColor = .myAppLightGray2
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.view.layer.cornerRadius = 20
        viewController.view.layer.masksToBounds = true

        if let presentedVC = navigationController.presentedViewController {
            presentedVC.present(viewController, animated: true, completion: nil)
        } else {
            navigationController.present(viewController, animated: true)
        }
    }
    
    func pushEtcReportViewController() {
        let reactor = EtcReportReactor(networkProvider: dependency.userProvider,
                                       reportId: reportId,
                                       reportType: reportType,
                                       opponentId: opponentId)
        let viewController = createViewController(
            ofType: EtcReportViewController.self,
            with: reactor,
            delegate: self
        )

        viewController.modalPresentationStyle = .pageSheet
        viewController.transitioningDelegate = self
        viewController.view.backgroundColor = .myAppLightGray2
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.view.layer.cornerRadius = 20
        viewController.view.layer.masksToBounds = true

        if let presentedVC = navigationController.presentedViewController {
            presentedVC.present(viewController, animated: true, completion: nil)
        } else {
            navigationController.present(viewController, animated: true)
        }
    }
    
    func finishView() {
        finishAllChildren()
        Task { @MainActor in
            await dismissAllPresentedViewControllers()
            await Task.yield()
            self.parentCoordinator?.removeChild(self)
        }
    }
    
    @MainActor
    private func dismissAllPresentedViewControllers() async {
        while let presentedVC = navigationController.presentedViewController {
            await withCheckedContinuation { continuation in
                presentedVC.dismiss(animated: true) {
                    continuation.resume()
                }
            }
            await Task.yield()
        }
    }
    
}

extension ReportCoordinator: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        finishView()
    }
}

extension ReportCoordinator: UIViewControllerTransitioningDelegate {
    func presentationController(
            forPresented presented: UIViewController,
            presenting: UIViewController?,
            source: UIViewController
        ) -> UIPresentationController? {
            return nil
        }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: .fromRight,
                                           isPresentation: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: .fromRight,
                                           isPresentation: false)
    }
}
