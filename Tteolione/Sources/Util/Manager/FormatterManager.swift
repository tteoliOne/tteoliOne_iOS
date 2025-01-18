//
//  FormatterManager.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import Foundation

final class FormatterManager {
    
    static let shared = FormatterManager()
    
    private init() { }
    
    func numberFormatter(_ data: Int) -> String {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        return format.string(from: NSNumber(value: data)) ?? "\(data)"
    }
    
}
