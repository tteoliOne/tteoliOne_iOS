//
//  UpdateMyProfileRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation
import Moya

struct UpdateMyProfileRequestBody: MultipartFormDataConvertible {
    
    let uuid: UUID
    let userProfileRequest: UserProfileRequestBody
    let imageData: Data?
    
    init(userProfileRequest: UserProfileRequestBody, image: Data) {
        self.uuid = UUID()
        self.userProfileRequest = userProfileRequest
        self.imageData = image
    }
    
    func toMultipartFormData() -> [MultipartFormData] {
        var multipartData = [MultipartFormData]()
        
        if let jsonData = try? JSONEncoder().encode(userProfileRequest) {
            multipartData.append(
                MultipartFormData(provider: .data(jsonData),
                                  name: "editUserInfoRequest",
                                  mimeType: "application/json")
            )
        }
        
        if let imageData = imageData {
            multipartData.append(
                MultipartFormData(provider: .data(imageData),
                                  name: "profile",
                                  fileName: "\(uuid).jpeg",
                                  mimeType: "image/jpeg")
            )
        }
        
        return multipartData
    }
    
}
