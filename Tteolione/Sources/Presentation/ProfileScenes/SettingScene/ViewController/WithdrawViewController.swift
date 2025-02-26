//
//  WithdrawViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/20/25.
//

import ReactorKit
import RxCocoa
import AuthenticationServices

final class WithdrawViewController: BaseViewController<WithdrawView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: SettingCoordinatorDelegate?
    
}

extension WithdrawViewController: View {
    
    func bind(reactor: WithdrawReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: WithdrawReactor) {
        rootView.backButton.rx.tap
            .map { WithdrawReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.withdrawButton.rx.tap
            .map { WithdrawReactor.Action.withdrawButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: WithdrawReactor) {
        
    }
    
    func bindNavigation(_ reactor: WithdrawReactor) {
        reactor.state.map { $0.isBackButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.popVC()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isWithdrawButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "회원탈퇴",
                                message: "정말로 회원탈퇴 하시겠습니까?",
                                cancelTitle: "취소") {
                    if UserDefaultsStorage.typeLogin == "apple" {
                        owner.performAppleSignIn()
                    } else {
                        reactor.action.onNext(.withdrawCheckButtonTap)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension WithdrawViewController {
    
    private func performAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension WithdrawViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let authorizationCode = appleIDCredential.authorizationCode,
               let authCodeString = String(data: authorizationCode, encoding: .utf8) {
                print("✅ Apple Authorization Code: \(authCodeString)")
                reactor?.action.onNext(.withdrawApple(authCodeString))
            }
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple 인증 실패: \(error.localizedDescription)")
    }
}

extension WithdrawViewController: DelegateOwner {
    typealias Delegate = SettingCoordinatorDelegate
}
