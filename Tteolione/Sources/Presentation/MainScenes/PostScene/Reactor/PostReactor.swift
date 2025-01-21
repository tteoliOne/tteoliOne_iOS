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
        case updateSharePrice(String)
        case updateShareCount(String)
        case vegetableButtonTap
        case fruitButtonTap
        case mealKitButtonTap
        case meatButtonTap
        case seaFoodButtonTap
        case etcButtonTap
        case updateDescriptionText(String)
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
        case setSharePrice(Int)
        case setShareCount(Int)
        case setShareValidity([Bool])
        case setSelectedNum(Int)
        case setCategorySelected([Bool])
        case setDescriptionText(String)
        case setDescriptionLengthText(String)
        case setDescriptionPlaceholderText(String)
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
        var sharePrice: Int = 0
        var shareCount: Int = 0
        var isShareValid: [Bool] = [false, false]
        var isSelectedNum: Int = 0
        var isCategorySelected: [Bool] = [false, false, false, false, false, false]
        var descriptionText: String = ""
        var descriptionLengthText: String = "0/100"
        var descriptionPlaceholderText: String = ""
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
                .just(.setPurchaseValidity(updatePurchaseState(at: 0, isValid: isValidCount(price)))),
                .just(.setPurchasePrice(Int(price) ?? 0))
            ])
            
        case let .updatePurchaseCount(count):
            return .concat([
                .just(.setPurchaseValidity(updatePurchaseState(at: 1, isValid: isValidCount(count)))),
                .just(.setPurchaseCount(Int(count) ?? 0))
            ])
            
        case let .updateSharePrice(price):
            return .concat([
                .just(.setShareValidity(updateShareState(at: 0, isValid: isValidCount(price)))),
                .just(.setSharePrice(Int(price) ?? 0))
            ])
            
        case let .updateShareCount(count):
            return .concat([
                .just(.setShareValidity(updateShareState(at: 1, isValid: isValidCount(count)))),
                .just(.setShareCount(Int(count) ?? 0))
            ])
            
        case .vegetableButtonTap:
            return .concat([
                .just(.setSelectedNum(1)),
                .just(.setCategorySelected([true, false, false, false, false, false]))
            ])
            
        case .fruitButtonTap:
            return .concat([
                .just(.setSelectedNum(2)),
                .just(.setCategorySelected([false, true, false, false, false, false]))
            ])
            
        case .mealKitButtonTap:
            return .concat([
                .just(.setSelectedNum(3)),
                .just(.setCategorySelected([false, false, true, false, false, false]))
            ])
            
        case .meatButtonTap:
            return .concat([
                .just(.setSelectedNum(4)),
                .just(.setCategorySelected([false, false, false, true, false, false]))
            ])
            
        case .seaFoodButtonTap:
            return .concat([
                .just(.setSelectedNum(5)),
                .just(.setCategorySelected([false, false, false, false, true, false]))
            ])
            
        case .etcButtonTap:
            return .concat([
                .just(.setSelectedNum(6)),
                .just(.setCategorySelected([false, false, false, false, false, true]))
            ])
            
        case let .updateDescriptionText(text):
            let maxLength = 100
            let trimmedText = String(text.prefix(maxLength))
            let textLengthText = "\(trimmedText.count)/\(maxLength)"
            return .concat([
                .just(.setDescriptionText(trimmedText)),
                .just(.setDescriptionLengthText(textLengthText)),
                .just(.setDescriptionPlaceholderText(""))
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
            
        case .setSharePrice(let price):
            newState.sharePrice = price
            
        case .setShareCount(let count):
            newState.shareCount = count
            
        case .setShareValidity(let isCheck):
            newState.isShareValid = isCheck
            
        case .setSelectedNum(let num):
            newState.isSelectedNum = num
            
        case .setCategorySelected(let isSelected):
            newState.isCategorySelected = isSelected
            
        case .setDescriptionText(let text):
            newState.descriptionText = text
            
        case .setDescriptionLengthText(let lengthText):
            newState.descriptionLengthText = lengthText
            
        case .setDescriptionPlaceholderText(let placeholder):
            newState.descriptionPlaceholderText = placeholder
        }
        
        return newState
    }
    
}

extension PostReactor {
    private func updatePurchaseState(at index: Int, isValid: Bool) -> [Bool] {
        var isEnabled = currentState.isPurchaseValid
        isEnabled[index] = isValid
        return isEnabled
    }
    
    private func updateShareState(at index: Int, isValid: Bool) -> [Bool] {
        var isEnabled = currentState.isShareValid
        isEnabled[index] = isValid
        return isEnabled
    }
    
    private func isValidCount(_ str: String) -> Bool {
        return str.count >= 1
    }
}
