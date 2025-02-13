//
//  ProductRegistRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

struct ProductRegistRequestBody: MultipartFormDataConvertible {
    
    let uuid: UUID
    let productRequest: ProductRequestBody
    let photos: [Data]
    let receiptImage: Data
    
    init(productRequest: ProductRequestBody,
         photos: [Data], receiptImage: Data) {
        self.uuid = UUID()
        self.productRequest = productRequest
        self.photos = photos
        self.receiptImage = receiptImage
    }
    
    func toMultipartFormData() -> [MultipartFormData] {
        var multipartData = [MultipartFormData]()
        
        if let jsonData = try? JSONEncoder().encode(productRequest) {
            multipartData.append(
                MultipartFormData(provider: .data(jsonData),
                                  name: "request",
                                  mimeType: "application/json")
            )
        }
        
        for (index, fileData) in photos.enumerated() {
            multipartData.append(
                MultipartFormData(provider: .data(fileData),
                                  name: "photos",
                                  fileName: "\(uuid)-\(index).jpeg",
                                  mimeType: "image/jpeg")
            )
        }
        
        multipartData.append(
            MultipartFormData(provider: .data(receiptImage),
                              name: "receipt",
                              fileName: "\(uuid).jpeg",
                              mimeType: "image/jpeg")
        )
        
        return multipartData
    }
    
}
