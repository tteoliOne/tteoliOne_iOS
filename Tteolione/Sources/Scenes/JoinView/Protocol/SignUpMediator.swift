//
//  SignUpMediator.swift
//  Tteolione
//
//  Created by 전준영 on 12/18/24.
//

import Foundation

protocol SignUpMediator {
    func update<T>(_ value: T, action: (T) -> SignUpReactor.Action)
    func get<T>(_ keyPath: KeyPath<SignUpReactor.State, T>) -> T
}
