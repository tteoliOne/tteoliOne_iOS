//
//  AuthReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/2/25.
//

import ReactorKit
import RxSwift

final class AuthReactor: Reactor {
    
    enum ViewType {
        case id
        case password
    }
    
    enum Action {
        case updateAuthNum(String)
        case authCheckButtonTap
        case backButtonTap
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
        case setResultId(FindIDDTO)
    }
    
    struct State {
        var authNum: String = ""
        var isButtonEnabled: Bool = false
        var remainingTime: String = AppText.Join.joinAuthTime
        var errorMessage: String?
        var navigateToNext: Bool = false
        var navigateBack: Bool = false
        var viewType: AccountCoordinator?
        var resultId: FindIDDTO?
    }
    
    private let stopTimerSubject = PublishSubject<Void>()
    private var timerDisposable: Disposable?
    private let networkProvider: NetworkProvider<FindAccountAPI>
    private let mediator: OnBoardingMediator
    private let viewType: AccountCoordinator
    private let totalSeconds = 180
    
    var initialState = State()
    
    init(networkProvider: NetworkProvider<FindAccountAPI>,
         mediator: OnBoardingMediator,
         viewType: AccountCoordinator) {
        self.networkProvider = networkProvider
        self.mediator = mediator
        self.viewType = viewType
        self.initialState = State(viewType: viewType)
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
            stopTimer()
            guard currentState.isButtonEnabled else { return .empty() }
            switch viewType {
            case .id:
                return .concat([
                    performAuthCheckToId(code: currentState.authNum)
                ])
            case .password:
                return .concat([
                    performAuthCheckToPassword(code: currentState.authNum)
                ])
            }
        
        case .backButtonTap:
            stopTimer()
            return .concat([
                .just(.setNavigateBack(true)),
                .just(.setNavigateBack(false))
            ])
            
        case .startTimer:
            return startTimer()
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
            newState.remainingTime = "남은시간 0:00"
            
        case let .showError(error):
            newState.errorMessage = error.errorDescription
            
        case let .setNavigateToNext(navigateToNext):
            newState.navigateToNext = navigateToNext
            
        case let .setNavigateBack(navigateBack):
            newState.navigateBack = navigateBack
            
        case let .setResultId(resultId):
            newState.resultId = resultId
        }
        
        return newState
    }
    
}

extension AuthReactor {
    
    private func performAuthCheckToId(code: String) -> Observable<Mutation> {
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
                        .just(.setResultId(dto)),
                        .just(.setNavigateToNext(true)),
                        .just(.setNavigateToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
    private func performAuthCheckToPassword(code: String) -> Observable<Mutation> {
        let email = mediator.get(\.email)
        let username = mediator.get(\.username)
        let id = mediator.get(\.loginId)
        let body = FindAccountRequestBody(email: email,
                                          authCode: code,
                                          username: username,
                                          loginId: id)
        return networkProvider
            .request(.validateIdEmail(body: body),
                     decodingType: ServerResponse<FindIDDTO>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(let dto):
                    return .concat([
                        .just(.setResultId(dto)),
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
