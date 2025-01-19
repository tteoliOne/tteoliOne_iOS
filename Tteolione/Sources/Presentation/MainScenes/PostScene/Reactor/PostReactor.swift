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
    }
    
    enum Mutation {
        case setProductImagePicker(Bool)
        case addProductImages([UIImage])
    }

    struct State {
        var isProductImagePickerShown: Bool = false
        var productImages: [UIImage] = []
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
        }
        
        return newState
    }
    
}

extension PostReactor {
    
    
    
}
