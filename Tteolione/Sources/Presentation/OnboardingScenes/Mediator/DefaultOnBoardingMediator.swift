//
//  DefaultOnBoardingMediator.swift
//  Tteolione
//
//  Created by 전준영 on 12/18/24.
//

import Foundation

final class DefaultOnBoardingMediator: OnBoardingMediator {
    
    private let signUpReactor: OnBoardingReactor

    init(signUpReactor: OnBoardingReactor) {
        self.signUpReactor = signUpReactor
    }

    func update<T>(_ value: T, action: (T) -> OnBoardingReactor.Action) {
        let reactorAction = action(value)
        self.signUpReactor.action.onNext(reactorAction)
    }

    func get<T>(_ keyPath: KeyPath<OnBoardingReactor.State, T>) -> T {
        return signUpReactor.currentState[keyPath: keyPath]
    }
}
