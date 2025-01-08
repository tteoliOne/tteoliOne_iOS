//
//  SocialProfileImageRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

struct SocialProfileImageRequestBody: MultipartFormDataConvertible {
    
    let uuid: UUID
    let socialRequest: SocialRequestBody
    let imageData: Data
    private let requestName: String
    
    init(socialRequest: SocialRequestBody, image: Data, requestName: String) {
        self.uuid = UUID()
        self.socialRequest = socialRequest
        self.imageData = image
        self.requestName = requestName
    }
    
    func toMultipartFormData() -> [MultipartFormData] {
        var multipartData = [MultipartFormData]()
        
        if let jsonData = try? JSONEncoder().encode(socialRequest) {
            multipartData.append(
                MultipartFormData(provider: .data(jsonData),
                                  name: requestName,
                                  mimeType: "application/json")
            )
        }
        
        multipartData.append(
            MultipartFormData(provider: .data(imageData),
                              name: "profile",
                              fileName: "\(uuid).jpeg",
                              mimeType: "image/jpeg")
        )
        
        return multipartData
    }
    
}
