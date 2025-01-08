//
//  ProductServiceAPI.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

enum ProductServiceAPI {
    case productRegistration(body: ProductRegistRequestBody)
    case getMainProduct(longitude: Double,
                        latitude: Double)
    case likeProduct(productId: Int)
    case likeMyProductList
    case getDetailProduct(productId: Int)
    case deleteProduct(productId: Int)
    case getListSpecificProductList(query: ProductQueryParameters)
    case editProduct(productId: Int,
                     body: ProductRegistRequestBody)
    case searchProduct(query: ProductQueryParameters)
}

extension ProductServiceAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIURL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .productRegistration:
            return "/api/products"
            
        case let .getMainProduct(longitude, latitude):
            return "/api/products/simple?longitude=\(longitude)&latitude=\(latitude)"
            
        case let .likeProduct(productId):
            return "/api/products/\(productId)/likes"
            
        case .likeMyProductList:
            return "/api/products/saved"
            
        case let .getDetailProduct(productId):
            return "/api/products/\(productId)"
            
        case let .deleteProduct(productId):
            return "/api/products/\(productId)"
            
        case let .getListSpecificProductList(query):
            var components = URLComponents(string: "/api/products")!
            components.queryItems = query.asQueryItems()
            return components.url!.path
            
        case let .editProduct(productId, _):
            return "/api/products/\(productId)"
            
        case let .searchProduct(query):
            var components = URLComponents(string: "/api/search")!
            components.queryItems = query.asQueryItems()
            return components.url!.path
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .productRegistration, .getMainProduct,
                .likeProduct:
            return .post
            
        case .likeMyProductList, .getDetailProduct,
                .getListSpecificProductList, .searchProduct:
            return .get
            
        case .deleteProduct:
            return .delete
            
        case .editProduct:
            return .put
        }
    }
    
    var task: Task {
        switch self {  
        case let .productRegistration(body),
            let .editProduct(_, body):
            return .uploadMultipart(body.toMultipartFormData())
            
        case .getMainProduct, .likeProduct,
                .likeMyProductList, .getDetailProduct,
                .deleteProduct, .getListSpecificProductList,
                .searchProduct:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getMainProduct, .likeProduct,
                .likeMyProductList, .getDetailProduct,
                .deleteProduct, .getListSpecificProductList,
                .searchProduct:
            return [Header.contentTypeJson.key: Header.contentTypeJson.value,
                    Header.authorization.key: Header.authorization.value]
            
        case .productRegistration, .editProduct:
            return [Header.contentTypeMulti.key: Header.contentTypeMulti.value,
                    Header.authorization.key: Header.authorization.value]
        }
    }
}
