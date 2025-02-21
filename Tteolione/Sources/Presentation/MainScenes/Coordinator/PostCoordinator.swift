//
//  PostCoordinator.swift
//  Tteolione
//
//  Created by 전준영 on 2/21/25.
//

import UIKit

final class PostCoordinator: PostCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    private let dependency: AppDependency
    private let viewType: PostViewType
    private let productDetail: ProductDetailDTO?
    
    init(navigationController: UINavigationController,
         dependency: AppDependency,
         viewType: PostViewType,
         productDetail: ProductDetailDTO? = nil) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.viewType = viewType
        self.productDetail = productDetail
    }
    
    func start() {
        pushPostViewController()
    }
    
}

extension PostCoordinator {
    
    func pushPostViewController() {
        let reactor = PostReactor(viewType: viewType,
                                  productDetail: productDetail)
        let viewController = createViewController(
            ofType: PostViewController.self,
            with: reactor,
            delegate: self
        )
        navigationController.setNavigationBarHidden(false, animated: false)
        show(viewController)
    }
    
    func pushMapViewController() {
        let reactor = MapReactor()
        let viewController = createViewController(
            ofType: MapViewController.self,
            with: reactor,
            delegate: self
        )
        if let postViewController = navigationController.viewControllers.last as? PostViewController {
            viewController.delegates = postViewController
        }
        let rightButton = UIBarButtonItem(title: "완료",
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapDoneButton))
        viewController.navigationItem.rightBarButtonItem = rightButton
        show(viewController)
    }
    
    func pushPostReceiptViewController(with viewType: PostViewType,
                                       productRequestBody: ProductRequestBody,
                                       productImages: [UIImage],
                                       receiptImage: UIImage?,
                                       productId: Int? = nil) {
        let reactor = PostReceiptReactor(viewType: viewType,
                                         networkProvider: dependency.productServiceProvider,
                                         response: productRequestBody,
                                         images: productImages,
                                         receiptImage: receiptImage,
                                         productId: productId)
        let viewController = createViewController(
            ofType: PostReceiptViewController.self,
            with: reactor,
            delegate: self
        )
        viewController.modalPresentationStyle = .pageSheet
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
        }
        show(viewController, as: .present)
    }
    
    func dismissAndPop() {
        navigationController.dismiss(animated: true) { [weak navigationController] in
            guard let navigationController = navigationController else { return }
            navigationController.popViewController(animated: true)
        }
    }
    
    @objc private func didTapDoneButton() {
        if let mapViewController = navigationController.viewControllers.last as? MapViewController {
            mapViewController.completeSelection()
        }
        navigationController.popViewController(animated: true)
    }
}
