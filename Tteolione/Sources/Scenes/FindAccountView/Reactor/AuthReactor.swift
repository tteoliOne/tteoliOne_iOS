//
//  AuthReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/2/25.
//

import Foundation
import ReactorKit
import RxSwift

final class AuthReactor: Reactor {
    
    enum Action {
        case updateAuthNum(String)
        case authCheckButtonTap
        case backButtonTap
        case startTimer
        case stopTimer
    }
    
    enum Mutation {
        case setAuthNum(String)
        case setButtonEnabled(Bool)
        case updateTimer(String)
        case stopTimer
        case showError(NetworkError)
        case setNavigateToNext(FindIDDTO?)
        case setNavigateBack(Bool)
    }
    
    struct State {
        var authNum: String = ""
        var isButtonEnabled: Bool = false
        var remainingTime: String = AppText.Join.joinAuthTime
        var errorMessage: String?
        var navigateToNext: FindIDDTO? = nil
        var navigateBack: Bool = false
    }
    
    private var timerDisposable: Disposable?
    private let networkProvider: NetworkProvider<FindAccountAPI>
    private let mediator: OnBoardingMediator
    let initialState = State()
    
    init(networkProvider: NetworkProvider<FindAccountAPI>,
         mediator: OnBoardingMediator) {
        self.networkProvider = networkProvider
        self.mediator = mediator
    }
    
}

extension AuthReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateAuthNum(let auth):
            let isEnabled = !auth.isEmpty
            return Observable.concat([
                .just(.setAuthNum(auth)),
                .just(.setButtonEnabled(isEnabled))
            ])
            
        case .authCheckButtonTap:
            guard currentState.isButtonEnabled else { return .empty() }
            stopTimer()
            return .concat([
                performAuthCheck(code: currentState.authNum)
            ])
            
        case .backButtonTap:
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .startTimer:
            return startTimer()
            
        case .stopTimer:
            stopTimer()
            return .just(.stopTimer)
        }
    }
    
}

extension AuthReactor {
    
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

extension AuthReactor {
    
    private func performAuthCheck(code: String) -> Observable<Mutation> {
        let email = mediator.get(\.email)
        let username = mediator.get(\.username)
        let body = FindAccountRequestBody(email: email,
                                          authCode: code,
                                          username: username)
        return networkProvider
            .request(.validateIdEmail(body: body),
                     decodingType: ServerResponse<FindIDDTO>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let dto):
                    return .concat([
                        .just(.setNavigateToNext(dto)),
                        .just(.setNavigateToNext(nil))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
    private func startTimer() -> Observable<Mutation> {
        guard timerDisposable == nil else {
            return .empty()
        }
        
        let totalSeconds = 15
        let timerObservable = Observable<Int>.interval(
            .seconds(1),
            scheduler: MainScheduler.instance)
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
            .subscribe(onNext: { _ in},
                       onError: { [weak self] _ in
                self?.stopTimer()
            },
                       onCompleted: { [weak self] in
                self?.stopTimer()
            })
        
        return timerObservable
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
}
