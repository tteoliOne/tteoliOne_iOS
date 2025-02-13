//
//  SignUpProfileImageRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 12/15/24.
//

import Foundation
import Moya

struct SignUpProfileImageRequestBody: MultipartFormDataConvertible {
    
    let uuid: UUID
    let signUpRequest: JoinRequestBody
    let imageData: Data
    
    init(signUpRequest: JoinRequestBody, image: Data) {
        self.uuid = UUID()
        self.signUpRequest = signUpRequest
        self.imageData = image
    }
    
    func toMultipartFormData() -> [MultipartFormData] {
        var multipartData = [MultipartFormData]()
        
        if let jsonData = try? JSONEncoder().encode(signUpRequest) {
            multipartData.append(
                MultipartFormData(provider: .data(jsonData),
                                  name: "signUpRequest",
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
