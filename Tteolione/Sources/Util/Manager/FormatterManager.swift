//
//  FormatterManager.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import Foundation

final class FormatterManager {
    
    static let shared = FormatterManager()
    private let inputDateFormatter: DateFormatter
    private let outputDateFormatter: DateFormatter
    private let buyDateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    private init() {
        self.inputDateFormatter = DateFormatter()
        self.inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.inputDateFormatter.timeZone = TimeZone.current
        
        self.outputDateFormatter = DateFormatter()
        self.outputDateFormatter.dateFormat = "yyyy.MM.dd(E)"
        self.outputDateFormatter.timeZone = TimeZone.current
        self.outputDateFormatter.locale = Locale(identifier: "ko_KR")
        
        self.buyDateFormatter = DateFormatter()
        self.buyDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.buyDateFormatter.timeZone = TimeZone.current
        
        self.timeFormatter = DateFormatter()
        self.timeFormatter.dateFormat = "a h:mm"
        self.timeFormatter.locale = Locale(identifier: "ko_KR")
    }
    
    func date(from dateString: String) -> Date? {
        return inputDateFormatter.date(from: dateString)
    }
    
    func numberFormatter(_ data: Int) -> String {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        return format.string(from: NSNumber(value: data)) ?? "\(data)"
    }
    
    func formattedDate(from dateString: String) -> String {
        if let date = inputDateFormatter.date(from: dateString) {
            return outputDateFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    func formattedBuyDate(from date: Date) -> String {
        return buyDateFormatter.string(from: date)
    }
    
    func getChatTimeFormat() -> String {
        return timeFormatter.string(from: Date())
    }
    
    func getChatTimeFormat(from timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        return timeFormatter.string(from: date)
    }
}
