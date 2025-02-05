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
        case mapViewButtonTap
        case updateLocation(Double, Double)
        case nextButtonTap
        case updateDate(Date)
        case setProductDetail(ProductDetailDTO)
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
        case setMapViewButtonTapped(Bool)
        case setLocation(Double, Double)
        case setDate(Date)
        case updateNextViewShown([Bool])
        case setReceiptImage(UIImage?)
        case setNextViewData(PostViewType, ProductRequestBody, [UIImage], Int?)
        case setProductDetail(ProductDetailDTO)
        case setProductId(Int?)
    }
    
    struct State {
        var productDetail: ProductDetailDTO?
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
        var longitude: Double = 0
        var latitude: Double = 0
        var isMapViewShown: Bool = false
        var selectedDate: Date = Date()
        var nextViewShown: [Bool] = [false, false, false, false, false, false]
        var receiptImage: UIImage? = nil
        var nextViewData: (PostViewType, ProductRequestBody, [UIImage], Int?)? = nil
        var productId: Int?
    }
    
    let viewType: PostViewType
    let productDetail: ProductDetailDTO?
    var initialState: State = State()
    
    init(viewType: PostViewType,
         productDetail: ProductDetailDTO?) {
        self.viewType = viewType
        self.productDetail = productDetail
    }
    
}

extension PostReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setProductDetail(let detail):
            return Observable.create { observer in
                Task {
                    var loadedImages: [UIImage] = []
                    
                    for imageUrl in detail.images {
                        if let url = URL(string: imageUrl),
                           let image = await UIImage.load(from: url) {
                            loadedImages.append(image)
                        }
                    }
                    if let receiptUrl = URL(string: detail.receipt),
                       let receiptImage = await UIImage.load(from: receiptUrl) {
                        observer.onNext(.setReceiptImage(receiptImage))
                    }
                    observer.onNext(.setProductDetail(detail))
                    observer.onNext(.addProductImages(loadedImages))
                    observer.onNext(.setTitle(detail.title))
                    observer.onNext(.setPurchasePrice(detail.buyPrice))
                    observer.onNext(.setPurchaseCount(detail.buyCount))
                    observer.onNext(.setSharePrice(detail.sharePrice))
                    observer.onNext(.setShareCount(detail.shareCount))
                    observer.onNext(.setDescriptionText(detail.description))
                    observer.onNext(.setProductId(detail.productId))
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            
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
            
        case .mapViewButtonTap:
            return .concat([
                .just(.setMapViewButtonTapped(true)),
                .just(.setMapViewButtonTapped(false))
            ])
            
        case .nextButtonTap:
            let productImagesValid = !currentState.productImages.isEmpty
            let titleValid = !currentState.title.isEmpty
            let purchaseValid = currentState.isPurchaseValid.allSatisfy { $0 }
            let shareValid = currentState.isShareValid.allSatisfy { $0 }
            let categoryValid = currentState.isCategorySelected.contains(true)
            let descriptionValid = !currentState.descriptionText.isEmpty
            
            let nextViewShown = [
                productImagesValid,
                titleValid,
                purchaseValid,
                shareValid,
                categoryValid,
                descriptionValid
            ]
            
            let productRequestBody = ProductRequestBody(
                categoryId: currentState.isSelectedNum,
                title: currentState.title,
                buyPrice: currentState.purchasePrice,
                buyCount: currentState.purchaseCount,
                sharePrice: currentState.sharePrice,
                shareCount: currentState.shareCount,
                buyDate: FormatterManager.shared.formattedBuyDate(from: currentState.selectedDate),
                description: currentState.descriptionText,
                longitude: currentState.longitude,
                latitude: currentState.latitude
            )
            
            let productId = currentState.productId
            
            return .concat([
                .just(.updateNextViewShown(nextViewShown)),
                .just(.setNextViewData(viewType,
                                       productRequestBody,
                                       currentState.productImages,
                                       productId)),
                .just(.setReceiptImage(currentState.receiptImage ?? nil))
            ])
            
        case let .updateLocation(latitude, longitude):
            return .just(.setLocation(latitude, longitude))
            
        case let .updateDate(date):
            return .just(.setDate(date))
        }
    }
    
}

extension PostReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProductId(let id):
            newState.productId = id
            
        case .setReceiptImage(let image):
            newState.receiptImage = image
            
        case .setProductDetail(let detail):
            newState.productDetail = detail
            newState.title = detail.title
            newState.purchasePrice = detail.buyPrice
            newState.purchaseCount = detail.buyCount
            newState.sharePrice = detail.sharePrice
            newState.shareCount = detail.shareCount
            newState.descriptionText = detail.description
            newState.longitude = detail.longitude
            newState.latitude = detail.latitude
            newState.selectedDate = FormatterManager.shared.date(from: detail.buyDate) ?? Date()
            
            let maxLength = 20
            let trimmedTitle = String(detail.title.prefix(maxLength))
            newState.titleLengthText = "\(trimmedTitle.count)/\(maxLength)"
            newState.isTitleValid = trimmedTitle.isEmpty
            
            newState.isPurchaseValid = [
                isValidCount("\(detail.buyPrice)"),
                isValidCount("\(detail.buyCount)")
            ]
            
            newState.isShareValid = [
                isValidCount("\(detail.sharePrice)"),
                isValidCount("\(detail.shareCount)")
            ]
            
            newState.isSelectedNum = detail.categoryId
            newState.isCategorySelected = [
                detail.categoryId == 1,
                detail.categoryId == 2,
                detail.categoryId == 3,
                detail.categoryId == 4,
                detail.categoryId == 5,
                detail.categoryId == 6
            ]
            
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
            
        case .setMapViewButtonTapped(let isShown):
            newState.isMapViewShown = isShown
            
        case .updateNextViewShown(let nextViewShown):
            newState.nextViewShown = nextViewShown
            
        case .setNextViewData(let viewType,
                              let requestBody,
                              let photos,
                              let id):
            newState.nextViewData = (viewType, requestBody, photos, id)
            
        case .setLocation(let latitude, let longitude):
            newState.latitude = latitude
            newState.longitude = longitude
            
        case .setDate(let date):
            newState.selectedDate = date
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
