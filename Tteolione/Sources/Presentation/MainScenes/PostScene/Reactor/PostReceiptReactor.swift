//
//  PostReceiptReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit
import ReactorKit
import RxSwift

final class PostReceiptReactor: Reactor {
    
    enum Action {
        case photoButtonTap
        case imageSelected(UIImage)
        case registerButtonTap
    }
    
    enum Mutation {
        case setProductImagePicker(Bool)
        case addProductImage(UIImage)
        case setregisterButtonIsEnabled(Bool)
        case setRegisterToNext(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var isProductImagePickerShown: Bool = false
        var productImage: UIImage?
        var isRegisterButtonIsEnabled: Bool = false
        var isRegister: Bool = false
        var errorMessage: String?
        var response: ProductRequestBody?
        var images: [UIImage] = []
    }
    
    private let networkProvider: NetworkProvider<ProductServiceAPI>
    var initialState: State = State()
    
    init(networkProvider: NetworkProvider<ProductServiceAPI>,
         response: ProductRequestBody,
         images: [UIImage]
    ) {
        self.networkProvider = networkProvider
        self.initialState = State(response: response,
                                  images: images)
    }
    
}

extension PostReceiptReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .photoButtonTap:
            return .concat([
                .just(.setProductImagePicker(true)),
                .just(.setProductImagePicker(false))
            ])
            
        case let .imageSelected(image):
            let isValidImage = !currentState.images.isEmpty
            return .concat([
                .just(.addProductImage(image)),
                .just(.setregisterButtonIsEnabled(isValidImage))
            ])
            
        case .registerButtonTap:
            guard currentState.isRegisterButtonIsEnabled,
                  let receiptImage = currentState.productImage else {
                return .empty()
            }
            return .concat([
                postRegisterRequest(receiptImage: receiptImage)
            ])
        }
    }
    
}

extension PostReceiptReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProductImagePicker(let isPickerShown):
            newState.isProductImagePickerShown = isPickerShown
            
        case .addProductImage(let image):
            newState.productImage = image
            
        case .setregisterButtonIsEnabled(let isEnabled):
            newState.isRegisterButtonIsEnabled = isEnabled
            
        case .setRegisterToNext(let isRegistered):
            newState.isRegister = isRegistered
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
        }
        
        return newState
    }
    
}

extension PostReceiptReactor {
    
    private func postRegisterRequest(receiptImage: UIImage) -> Observable<Mutation> {
        let body = ProductRegistRequestBody(
            productRequest: currentState.response ?? ProductRequestBody.defaultValue(),
            photos: currentState.images.compactMap { $0.jpegData(compressionQuality: 0.8) },
            receiptImage: receiptImage.jpegData(compressionQuality: 0.8) ?? Data()
        )
        return networkProvider
            .request(.productRegistration(body: body),
                     decodingType: ServerResponse<RegistDTO>.self)
            .asObservable()
            .flatMap { [weak self] response -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                switch handleResponse(response) {
                case .success(let message):
                    return .concat([
                        .just(.setRegisterToNext(true)),
                        .just(.setRegisterToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
}
