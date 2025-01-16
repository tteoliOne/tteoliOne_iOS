//
//  OnBoardingMediator.swift
//  Tteolione
//
//  Created by 전준영 on 12/18/24.
//

import Foundation

protocol OnBoardingMediator {
    func update<T>(_ value: T, action: (T) -> OnBoardingReactor.Action)
    func get<T>(_ keyPath: KeyPath<OnBoardingReactor.State, T>) -> T
}
