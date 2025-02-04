//
//  SideMenuViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class SideMenuViewController: BaseViewController<SideMenuView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: MainCoordinatorDelegate?
    
}

extension SideMenuViewController: View {
    
    func bind(reactor: SideMenuReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: SideMenuReactor) {
        self.rx.viewWillAppear
            .map { _ in SideMenuReactor.Action.fetchLikeLists }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.xButton.rx.tap
            .map { SideMenuReactor.Action.xButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                let products = reactor.currentState.products.flatMap { $0.products }
                let selectedProduct = products[indexPath.row]
                reactor.action.onNext(.navigateToDetailView(selectedProduct.productId))
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: SideMenuReactor) {
        reactor.state.map { $0.products }
            .map { products in
                products.flatMap { $0.products }
            }
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: SideMenuTableViewCell.identifier,
                cellType: SideMenuTableViewCell.self
            )) { _, productList, cell in
                cell.selectionStyle = .none
                cell.configureData(productList)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, errorMessage in
                owner.showAlert(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: SideMenuReactor) {
        reactor.state.map { $0.navigateToPop }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.dismissVC()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { ($0.navigateToDetailView, $0.productId) }
            .distinctUntilChanged { $0.0 == $1.0 }
            .filter { $0.0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, data in
                guard let productId = data.1 else { return }
                owner.delegate?.dismissVC()
                owner.delegate?.pushProductDetailViewController(productId: productId)
            }
            .disposed(by: disposeBag)
    }
}

extension SideMenuViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}

final class SideMenuPresentationController: UIPresentationController {
    private let dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    private func setupDimmingView() {
        dimmingView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        
        let safeAreaInsets = containerView.safeAreaInsets
        let width = containerView.bounds.width * 0.5
        
        presentedView.frame = CGRect(
            x: 0,
            y: safeAreaInsets.top,
            width: width,
            height: containerView.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        )
        presentedView.layer.shadowColor = UIColor.black.cgColor
        presentedView.layer.shadowOpacity = 0.3
        presentedView.layer.shadowOffset = CGSize(width: 0, height: 5)
        presentedView.layer.shadowRadius = 10
        
        let path = UIBezierPath(
            roundedRect: presentedView.bounds,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        presentedView.layer.mask = mask
    }
    
}


final class SideMenuAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else { return }
            let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
            toView.frame = CGRect(x: -finalFrame.width, y: 0, width: finalFrame.width, height: finalFrame.height)
            containerView.addSubview(toView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.frame = finalFrame
            }) { completed in
                transitionContext.completeTransition(completed)
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            }) { completed in
                if completed {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(completed)
            }
        }
    }
}

