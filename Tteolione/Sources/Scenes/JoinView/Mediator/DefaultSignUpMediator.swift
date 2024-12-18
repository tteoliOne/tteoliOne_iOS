//
//  DefaultSignUpMediator.swift
//  Tteolione
//
//  Created by 전준영 on 12/18/24.
//

import Foundation

final class DefaultSignUpMediator: SignUpMediator {
    
    private let signUpReactor: SignUpReactor

    init(signUpReactor: SignUpReactor) {
        self.signUpReactor = signUpReactor
    }

    func update<T>(_ value: T, action: (T) -> SignUpReactor.Action) {
        let reactorAction = action(value)
        self.signUpReactor.action.onNext(reactorAction)
    }

    func get<T>(_ keyPath: KeyPath<SignUpReactor.State, T>) -> T {
        return signUpReactor.currentState[keyPath: keyPath]
    }
}
