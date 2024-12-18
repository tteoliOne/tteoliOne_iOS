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
    }

    struct State {
        var authNum: String = ""
        var isButtonEnabled: Bool = false
        var remainingTime: String = AppText.Join.joinAuthTime
        var errorMessage: String?
    }
    
    private var timerDisposable: Disposable?
    private let networkProvider: NetworkProvider<JoinAPI>
    private let mediator: SignUpMediator
    
    let initialState: State = State()
    let backNavigation = PublishSubject<Void>()
    let navigateToNextView = PublishSubject<Void>()
    
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
            backNavigation.onNext(())
            return Observable.empty()
            
        case let .authNumTextChanged(authNum):
            let isEnabled = !authNum.isEmpty
            return Observable.concat([
                .just(.setAuthNum(authNum)),
                .just(.setButtonEnabled(isEnabled))
            ])
            
        case .authCheckButtonTap:
            guard currentState.isButtonEnabled else { return .empty() }
            let authCode = currentState.authNum
            
            mediator.update(authCode, action: SignUpReactor.Action.updatePassword)
            return .concat([
                performAuthCheck(code: authCode)
            ])
            
        case .startTimer:
            return Observable.create { [weak self] observer in
                self?.startTimer { timeString in
                    observer.onNext(.updateTimer(timeString))
                }
                return Disposables.create()
            }
            
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
                    self.navigateToNextView.onNext(())
                    return .empty()
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
}

extension AuthNumReactor {
    
    private func startTimer(onUpdate: @escaping (String) -> Void) {
        var totalSeconds = 180
        timerDisposable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(while: { _ in totalSeconds > 0 })
            .subscribe(onNext: { _ in
                totalSeconds -= 1
                let minutes = totalSeconds / 60
                let seconds = totalSeconds % 60
                onUpdate(String(format: "남은시간 %d:%02d", minutes, seconds))
            }, onCompleted: {
                onUpdate("남은시간 0:00")
                self.backNavigation.onNext(())
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
}
