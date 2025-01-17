//
//  AppleAuthManager.swift
//  Tteolione
//
//  Created by 전준영 on 1/17/25.
//

import AuthenticationServices
import RxSwift
import RxCocoa

final class AppleAuthManager: NSObject  {
    
    private let networkProvider: NetworkProvider<SocialAPI>
    private let disposeBag = DisposeBag()
    
    init(networkProvider: NetworkProvider<SocialAPI>) {
        self.networkProvider = networkProvider
    }
    
    func handleAppleSignIn() -> Single<SocialLoginResult> {
        return Single<SocialLoginResult>.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "AppleAuthManager",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "AppleAuthManager is deallocated"])))
                return Disposables.create()
            }
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            self.signInCompletion = { result in
                switch result {
                case .success(let loginResult):
                    single(.success(loginResult))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            authorizationController.performRequests()
            
            return Disposables.create()
        }
    }
    
    private var signInCompletion: ((Result<SocialLoginResult, Error>) -> Void)?
}

extension AppleAuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCode = appleIDCredential.authorizationCode,
              let authCodeString = String(data: authorizationCode, encoding: .utf8) else {
            signInCompletion?(.failure(NSError(domain: "AppleAuthManager",
                                               code: -2,
                                               userInfo: [NSLocalizedDescriptionKey: "Failed to extract authorization code"])))
            return
        }
        let body = SocialRequestBody(authorization: authCodeString)
        
        networkProvider.request(.appleLogin(body: body),
                                decodingType: ServerResponse<UserDTO>.self)
        .flatMap { response -> Single<SocialLoginResult> in
            switch handleResponse(response) {
            case .success(let data):
                if data.existsUser {
                    return .just(.existingUser)
                } else if let token = data.accessToken {
                    return .just(.newUser(accessToken: token))
                } else {
                    return .just(.failure(message: "Access token is missing for a new user."))
                }
            case .failure(let error):
                return .just(.failure(message: "Apple login failed: \(error.localizedDescription)"))
            }
        }
        .subscribe(onSuccess: { [weak self] loginResult in
            self?.signInCompletion?(.success(loginResult))
        }, onFailure: { [weak self] error in
            self?.signInCompletion?(.failure(error))
        })
        .disposed(by: disposeBag)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInCompletion?(.failure(error))
    }
}
