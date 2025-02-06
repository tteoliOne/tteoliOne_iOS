//
//  Encodable+Extension.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
}
