//
//  AuthNumReactor.swift
//  Tteolione
//
//  Created by 전준영 on 12/7/24.
//

import Foundation
import ReactorKit
import RxSwift

final class AuthNumReactor: Reactor {
    
    enum Action {
        case backButtonTap
        case authNumTextChanged(String)
        case authCheckButtonTap
        case startTimer
        case stopTimer
    }
    
    enum Mutation {
        case setAuthNum(String)
        case setButtonEnabled(Bool)
        case updateTimer(String)
        case stopTimer
        case showError(NetworkError)
        case setNavigateToNext(Bool)
        case setNavigateBack(Bool)
    }
    
    struct State {
        var authNum: String = ""
        var isButtonEnabled: Bool = false
        var remainingTime: String = AppText.Join.joinAuthTime
        var errorMessage: String?
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
    }
    
    private var timerDisposable: Disposable?
    private let networkProvider: NetworkProvider<JoinAPI>
    private let mediator: SignUpMediator
    
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<JoinAPI>,
         mediator: SignUpMediator) {
        self.networkProvider = networkProvider
        self.mediator = mediator
    }
    
}

extension AuthNumReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case let .authNumTextChanged(authNum):
            let isEnabled = !authNum.isEmpty
            return Observable.concat([
                .just(.setAuthNum(authNum)),
                .just(.setButtonEnabled(isEnabled))
            ])
            
        case .authCheckButtonTap:
            guard currentState.isButtonEnabled else { return .empty() }
            stopTimer()
            return .concat([
                performAuthCheck(code: currentState.authNum)
            ])
            
        case .startTimer:
            return startTimer()
            
        case .stopTimer:
            stopTimer()
            return .just(.stopTimer)
        }
    }
    
}

extension AuthNumReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setAuthNum(authNum):
            newState.authNum = authNum
            
        case let .setButtonEnabled(isEnabled):
            newState.isButtonEnabled = isEnabled
            
        case let .updateTimer(timeString):
            newState.remainingTime = timeString
            
        case .stopTimer:
            break
            
        case let .showError(error):
            newState.errorMessage = error.errorDescription
            
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case let .setNavigateBack(navigateBack):
            newState.navigateBack = navigateBack
        }
        
        return newState
    }
    
}

extension AuthNumReactor {
    
    private func performAuthCheck(code: String) -> Observable<Mutation> {
        let email = mediator.get(\.email)
        let body = JoinRequestBody(email: email, code: code)
        return networkProvider
            .request(.validateEmail(body: body), decodingType: ServerResponse<String>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(_):
                    self.mediator.update(code,
                                         action: SignUpReactor.Action.updateAuthCode)
                    return .concat([
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
}

extension AuthNumReactor {
    
    private func startTimer() -> Observable<Mutation> {
        guard timerDisposable == nil else {
            return .empty()
        }

        let totalSeconds = 15
        let timerObservable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { totalSeconds - $0 - 1 }
            .take(while: { $0 >= 0 })
            .flatMap { remainingSeconds -> Observable<Mutation> in
                let minutes = remainingSeconds / 60
                let seconds = remainingSeconds % 60
                let timeString = String(format: "남은시간 %d:%02d", minutes, seconds)
                if remainingSeconds == 0 {
                    return .concat([
                        .just(.updateTimer("남은시간 0:00")),
                        .just(.setNavigateBack(true)),
                        .just(.setNavigateBack(false))
                    ])
                }
                return .just(.updateTimer(timeString))
            }

        timerDisposable = timerObservable
            .subscribe()

        return timerObservable
    }

    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
}
