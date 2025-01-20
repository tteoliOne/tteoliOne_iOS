//
//  PostReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit
import ReactorKit
import RxSwift

final class PostReactor: Reactor {
    
    enum Action {
        case productPhotoTap
        case imagesSelected([UIImage])
        case updateTitle(String)
        case updatePurchasePrice(String)
        case updatePurchaseCount(String)
    }
    
    enum Mutation {
        case setProductImagePicker(Bool)
        case addProductImages([UIImage])
        case setTitle(String)
        case setTitleValidity(Bool)
        case setTitleLengthText(String)
        case setPurchasePrice(Int)
        case setPurchaseCount(Int)
        case setPurchaseValidity([Bool])
    }

    struct State {
        var isProductImagePickerShown: Bool = false
        var productImages: [UIImage] = []
        var title: String = ""
        var titleLengthText: String = "0/20"
        var isTitleValid: Bool = false
        var purchasePrice: Int = 0
        var purchaseCount: Int = 0
        var isPurchaseValid: [Bool] = [false, false]
    }
    
    let initialState: State = State()
    
}

extension PostReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .productPhotoTap:
            return .concat([
                .just(.setProductImagePicker(true)),
                .just(.setProductImagePicker(false))
            ])
            
        case let.imagesSelected(images):
            let currentImages = currentState.productImages
            let newImages = (currentImages + images).prefix(5)
            return .just(.addProductImages(Array(newImages)))
            
        case let .updateTitle(title):
            let maxLength = 20
            let trimmedTitle = String(title.prefix(maxLength))
            let titleLengthText = "\(trimmedTitle.count)/\(maxLength)"
            let isValid = !trimmedTitle.isEmpty
            return .concat([
                .just(.setTitle(trimmedTitle)),
                .just(.setTitleValidity(isValid)),
                .just(.setTitleLengthText(titleLengthText))
            ])
            
        case let .updatePurchasePrice(price):
            return .concat([
                .just(.setPurchaseValidity(updateState(at: 0, isValid: isValidCount(price)))),
                .just(.setPurchasePrice(Int(price) ?? 0))
            ])
            
        case let .updatePurchaseCount(count):
            return .concat([
                .just(.setPurchaseValidity(updateState(at: 1, isValid: isValidCount(count)))),
                .just(.setPurchaseCount(Int(count) ?? 0))
            ])
        }
    }
    
}

extension PostReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProductImagePicker(let isPickerShown):
            newState.isProductImagePickerShown = isPickerShown
            
        case .addProductImages(let images):
            newState.productImages = images
            
        case .setTitle(let title):
            newState.title = title
            
        case .setTitleValidity(let isValid):
            newState.isTitleValid = !isValid
            
        case .setTitleLengthText(let titleLengthText):
            newState.titleLengthText = titleLengthText
            
        case .setPurchasePrice(let price):
            newState.purchasePrice = price
            
        case .setPurchaseCount(let count):
            newState.purchaseCount = count
            
        case .setPurchaseValidity(let isCheck):
            newState.isPurchaseValid = isCheck
        }
        
        return newState
    }
    
}

extension PostReactor {
    private func updateState(at index: Int, isValid: Bool) -> [Bool] {
        var isEnabled = currentState.isPurchaseValid
        isEnabled[index] = isValid
        return isEnabled
    }
    
    private func isValidCount(_ str: String) -> Bool {
        return str.count >= 1
    }
}
