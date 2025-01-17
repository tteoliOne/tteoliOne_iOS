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
    case getMainProduct(query: ProductQueryParameters)
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
            
        case .getMainProduct:
            return "/api/products/simple"
            
        case let .likeProduct(productId):
            return "/api/products/\(productId)/likes"
            
        case .likeMyProductList:
            return "/api/products/saved"
            
        case let .getDetailProduct(productId):
            return "/api/products/\(productId)"
            
        case let .deleteProduct(productId):
            return "/api/products/\(productId)"
            
        case .getListSpecificProductList:
            return "/api/products"
            
        case let .editProduct(productId, _):
            return "/api/products/\(productId)"
            
        case .searchProduct:
            return "/api/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .productRegistration, .likeProduct:
            return .post
            
        case .likeMyProductList, .getMainProduct,
                .getDetailProduct, .getListSpecificProductList,
                .searchProduct:
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
            
        case .getMainProduct(let query),
                .getListSpecificProductList(let query),
                .searchProduct(let query):
            return .requestParameters(parameters: query.asQueryItems(),
                                      encoding: URLEncoding.queryString)
            
        case .likeProduct, .likeMyProductList,
                .getDetailProduct, .deleteProduct:
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
