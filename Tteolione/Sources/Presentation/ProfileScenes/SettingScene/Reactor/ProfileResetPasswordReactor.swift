//
//  ProfileResetPasswordReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/17/25.
//

import Foundation
import ReactorKit
import RxSwift

final class ProfileResetPasswordReactor: Reactor {
    
    enum Action {
        case updateOriginalPassword(String)
        case updateNewPassword(String)
        case updateConfirmPassword(String)
        case originalPasswordTextFieldTapBegin
        case newPasswordTextFieldTapBegin
        case confirmPasswordTextFieldTapBegin
        case originalPasswordTextFieldTapEnd
        case newPasswordTextFieldTapEnd
        case confirmPasswordTextFieldTapEnd
        case originalPasswordSecureButtonTap
        case newPasswordSecureButtonTap
        case confirmPasswordSecureButtonTap
        case resetPasswordButtonTap
        case backButtonTap
    }
    
    enum Mutation {
        case setOriginalPassword(String)
        case setNewPassword(String)
        case setConfirmPassword(String)
        case setOriginalPasswordLabelPosition(up: Bool)
        case setNewPasswordLabelPosition(up: Bool)
        case setConfirmPasswordLabelPosition(up: Bool)
        case toggleOriginalPasswordSecureMode
        case toggleNewPasswordSecureMode
        case toggleConfirmPasswordSecureMode
        case resetSuccess(Bool)
        case showError(NetworkError)
        case clearErrorMessage
        case setResetButtonEnabled([Bool])
        case backButtonTapped(Bool)
    }
    
    struct State {
        var originalPassword: String = ""
        var newPassword: String = ""
        var confirmPassword: String = ""
        var isOriginalPasswordLabelUp: Bool = false
        var isNewPasswordLabelUp: Bool = false
        var isConfirmPasswordLabelUp: Bool = false
        var isOriginalPasswordSecure: Bool = true
        var isNewPasswordSecure: Bool = true
        var isConfirmPasswordSecure: Bool = true
        var isResetSuccess: Bool = false
        var errorMessage: String?
        var isResetButtonEnabled: [Bool] = [false, false, false]
        var isBackButtonTapped: Bool = false
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<UserAPI>) {
        self.networkProvider = networkProvider
    }
    
}

extension ProfileResetPasswordReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateOriginalPassword(let password):
            return .concat([
                .just(.setResetButtonEnabled(updateLoginButtonState(at: 0, isValid: isValidCount(password)))),
                .just(.setOriginalPassword(password))
            ])
            
        case .updateNewPassword(let password):
            return .concat([
                .just(.setResetButtonEnabled(updateLoginButtonState(at: 1, isValid: isValidCount(password)))),
                .just(.setNewPassword(password))
            ])
            
        case .updateConfirmPassword(let password):
            return .concat([
                .just(.setResetButtonEnabled(updateLoginButtonState(at: 2, isValid: isValidCount(password)))),
                .just(.setConfirmPassword(password))
            ])
            
        case .originalPasswordTextFieldTapBegin:
            return .just(.setOriginalPasswordLabelPosition(up: true))
            
        case .newPasswordTextFieldTapBegin:
            return .just(.setNewPasswordLabelPosition(up: true))
            
        case .confirmPasswordTextFieldTapBegin:
            return .just(.setConfirmPasswordLabelPosition(up: true))
            
        case .originalPasswordTextFieldTapEnd:
            return .just(.setOriginalPasswordLabelPosition(up: false))
            
        case .newPasswordTextFieldTapEnd:
            return .just(.setNewPasswordLabelPosition(up: false))
            
        case .confirmPasswordTextFieldTapEnd:
            return .just(.setConfirmPasswordLabelPosition(up: false))
            
        case .originalPasswordSecureButtonTap:
            return .just(.toggleOriginalPasswordSecureMode)
            
        case .newPasswordSecureButtonTap:
            return .just(.toggleNewPasswordSecureMode)
            
        case .confirmPasswordSecureButtonTap:
            return .just(.toggleConfirmPasswordSecureMode)
            
        case .resetPasswordButtonTap:
            guard currentState.isResetButtonEnabled.allSatisfy({ $0 }) else { return .empty() }
            return resetPassword(passwrod: currentState.originalPassword,
                                 newPassword: currentState.newPassword,
                                 newPasswordConfirm: currentState.confirmPassword)
            
        case .backButtonTap:
            return .concat([
                .just(.backButtonTapped(true)),
                .just(.backButtonTapped(false))
            ])
        }
    }
    
}

extension ProfileResetPasswordReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .setOriginalPassword(let password):
            newState.originalPassword = password
            
        case .setNewPassword(let password):
            newState.newPassword = password
            
        case .setConfirmPassword(let password):
            newState.confirmPassword = password
            
        case .setOriginalPasswordLabelPosition(let up):
            newState.isOriginalPasswordLabelUp = up
            
        case .setNewPasswordLabelPosition(let up):
            newState.isNewPasswordLabelUp = up
            
        case .setConfirmPasswordLabelPosition(let up):
            newState.isConfirmPasswordLabelUp = up
            
        case .toggleOriginalPasswordSecureMode:
            newState.isOriginalPasswordSecure.toggle()
            
        case .toggleNewPasswordSecureMode:
            newState.isNewPasswordSecure.toggle()
            
        case .toggleConfirmPasswordSecureMode:
            newState.isConfirmPasswordSecure.toggle()
            
        case .resetSuccess(let isSuccess):
            newState.isResetSuccess = isSuccess
            
        case .showError(let error):
            newState.errorMessage = error.errorDescription
            
        case .clearErrorMessage:
            newState.errorMessage = nil
            
        case .setResetButtonEnabled(let isEnabled):
            newState.isResetButtonEnabled = isEnabled
            
        case .backButtonTapped(let isTap):
            newState.isBackButtonTapped = isTap
        }
        
        return newState
    }
    
}

extension ProfileResetPasswordReactor {
    private func resetPassword(passwrod: String,
                               newPassword: String,
                               newPasswordConfirm: String) -> Observable<Mutation> {
        let body = NewPasswordRequestBody(password: passwrod,
                                          newPassword: newPassword,
                                          newPasswordConfirm: newPasswordConfirm)
        return .concat([
            .just(.clearErrorMessage),
            networkProvider.request(.changePassword(body: body),
                                    decodingType: ServerResponse<String>.self)
            .asObservable()
            .catch { error in
                if let networkError = error as? NetworkError {
                    return .just(ServerResponse<String>(success: false, code: -1, message: networkError.errorDescription, data: nil))
                }
                return .just(ServerResponse<String>(success: false, code: -1, message: "알 수 없는 오류", data: nil))
            }
                .flatMap { response -> Observable<Mutation> in
                    switch handleResponse(response) {
                    case .success(_):
                        return .concat([
                            .just(.resetSuccess(true)),
                            .just(.resetSuccess(false))
                        ])
                    case .failure(let error):
                        return .just(.showError(error))
                    }
                }
        ])
    }
    
}

extension ProfileResetPasswordReactor {
    private func updateLoginButtonState(at index: Int, isValid: Bool) -> [Bool] {
        var loginButtonEnabled = currentState.isResetButtonEnabled
        loginButtonEnabled[index] = isValid
        return loginButtonEnabled
    }
    
    private func isValidCount(_ str: String) -> Bool {
        return str.count >= 1
    }
}
