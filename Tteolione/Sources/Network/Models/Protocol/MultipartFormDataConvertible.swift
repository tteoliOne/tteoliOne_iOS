//
//  MultipartFormDataConvertible.swift
//  Tteolione
//
//  Created by 전준영 on 12/15/24.
//

import Foundation
import Moya

protocol MultipartFormDataConvertible {
    func toMultipartFormData() -> [MultipartFormData]
}
