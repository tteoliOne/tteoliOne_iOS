//
//  ServerResponse.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import Foundation

struct ServerResponse<T: Decodable>: Decodable {
    let success: Bool
    let code: Int
    let message: String?
    let data: T?
}

func handleResponse<T: Decodable>(_ response: ServerResponse<T>) -> Result<T, NetworkError> {
    if response.success, let data = response.data {
        return .success(data)
    } else {
        return .failure(.fromServerResponse(success: response.success,
                                            code: response.code,
                                            message: response.message))
    }
}
