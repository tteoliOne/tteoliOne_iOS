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
        case setReceiptImage(UIImage)
        case photoButtonTap
        case imageSelected(UIImage)
        case registerButtonTap
    }
    
    enum Mutation {
        case setProductImagePicker(Bool)
        case setReceiptImage(UIImage)
        case setregisterButtonIsEnabled(Bool)
        case setRegisterToNext(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var isProductImagePickerShown: Bool = false
        var isRegisterButtonIsEnabled: Bool = false
        var isRegister: Bool = false
        var errorMessage: String?
        var response: ProductRequestBody?
        var images: [UIImage] = []
        var receiptImage: UIImage?
    }
    
    private let networkProvider: NetworkProvider<ProductServiceAPI>
    private let productId: Int?
    let viewType: PostViewType
    var initialState: State = State()
    
    init(viewType: PostViewType,
         networkProvider: NetworkProvider<ProductServiceAPI>,
         response: ProductRequestBody,
         images: [UIImage],
         receiptImage: UIImage?,
         productId: Int? = nil
    ) {
        self.networkProvider = networkProvider
        self.viewType = viewType
        self.productId = productId
        let isEnabled = viewType == .edit || !images.isEmpty
        self.initialState = State(isRegisterButtonIsEnabled: isEnabled,
                                  response: response,
                                  images: images,
                                  receiptImage: receiptImage)
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
                .just(.setReceiptImage(image)),
                .just(.setregisterButtonIsEnabled(isValidImage))
            ])
            
        case .registerButtonTap:
            print("🔍 isRegisterButtonIsEnabled: \(currentState.isRegisterButtonIsEnabled)")
                print("🔍 receiptImage: \(currentState.receiptImage != nil ? "✅ 존재함" : "❌ 없음")")

            guard currentState.isRegisterButtonIsEnabled,
                  let receiptImage = currentState.receiptImage else {
                return .empty()
            }
            
            let request: Observable<Mutation>
            
            if viewType == .edit,
               let productId = productId {
                request = postUpdateRequest(productId: productId,
                                            receiptImage: receiptImage)
            } else {
                request = postRegisterRequest(receiptImage: receiptImage)
            }
            
            return request
            
        case .setReceiptImage(let image):
            return .just(.setReceiptImage(image))
        }
    }
    
}

extension PostReceiptReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProductImagePicker(let isPickerShown):
            newState.isProductImagePickerShown = isPickerShown
            
        case .setReceiptImage(let image):
            newState.receiptImage = image
            
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
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(_):
                    return .concat([
                        .just(.setRegisterToNext(true)),
                        .just(.setRegisterToNext(false))
                    ])
                case .failure(let error):
                    return .just(.showError(error))
                }
            }
    }
    
    private func postUpdateRequest(productId: Int, receiptImage: UIImage) -> Observable<Mutation> {
        let body = ProductRegistRequestBody(
            productRequest: currentState.response ?? ProductRequestBody.defaultValue(),
            photos: currentState.images.compactMap { $0.jpegData(compressionQuality: 0.8) },
            receiptImage: receiptImage.jpegData(compressionQuality: 0.8) ?? Data()
        )
        return networkProvider
            .request(.editProduct(productId: productId, body: body),
                     decodingType: ServerResponse<RegistDTO>.self)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                switch handleResponse(response) {
                case .success(_):
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
