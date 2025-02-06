//
//  ReportRequestBody.swift
//  Tteolione
//
//  Created by 전준영 on 1/8/25.
//

import Foundation

struct ReportRequestBody: Encodable {
    
    let content: String?
    let reporteeId: String?
    
}
