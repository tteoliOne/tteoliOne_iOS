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
        case updateAuthNum(String)
        case authCheckButtonTap
        case startTimer
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
    
    private let stopTimerSubject = PublishSubject<Void>()
    private var timerDisposable: Disposable?
    private let networkProvider: NetworkProvider<JoinAPI>
    private let mediator: OnBoardingMediator
    private let totalSeconds = 180
    
    let initialState: State = State()
    
    init(networkProvider: NetworkProvider<JoinAPI>,
         mediator: OnBoardingMediator) {
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
            
        case let .updateAuthNum(authNum):
            let isEnabled = !authNum.isEmpty
            return Observable.concat([
                .just(.setAuthNum(authNum)),
                .just(.setButtonEnabled(isEnabled))
            ])
            
        case .authCheckButtonTap:
            stopTimer()
            guard currentState.isButtonEnabled else { return .empty() }
            stopTimer()
            return .concat([
                performAuthCheck(code: currentState.authNum)
            ])
            
        case .startTimer:
            return startTimer()
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
            newState.remainingTime = "남은시간 0:00"
            
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
            .flatMap { [weak self] response -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                switch handleResponse(response) {
                case .success(_):
                    self.mediator.update(code,
                                         action: OnBoardingReactor.Action.updateAuthCode)
                    return .concat([
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
    private func startTimer() -> Observable<Mutation> {
        guard timerDisposable == nil else { return .empty() }
        
        return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(totalSeconds + 1)
            .take(until: stopTimerSubject)
            .map { [weak self] elapsedSeconds in
                guard let self = self else { return .updateTimer("남은시간 0:00") }
                let remainingSeconds = self.totalSeconds - elapsedSeconds
                let minutes = remainingSeconds / 60
                let seconds = remainingSeconds % 60
                let timeString = String(format: "남은시간 %d:%02d", minutes, seconds)
                
                if remainingSeconds == 0 {
                    return .setNavigateBack(true)
                }
                return .updateTimer(timeString)
            }
            .do(onSubscribe: { print("타이머 시작") },
                onDispose: { [weak self] in
                self?.resetTimerState()
            })
    }
    
    private func stopTimer() {
        stopTimerSubject.onNext(())
        stopTimerSubject.onCompleted()
    }
    
    private func resetTimerState() {
        timerDisposable = nil
    }
    
}
