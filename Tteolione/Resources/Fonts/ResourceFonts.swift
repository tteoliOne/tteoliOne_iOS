//
//  ResourceFonts.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

//MARK: - 앱에서 사용할 폰트
struct FontNames {
    static let andong = "AndongKaturiOTF"
}

enum Font {
    
    case regular(CGFloat)
    case bold(CGFloat)
    case custom(String, CGFloat)
    
    func font() -> UIFont {
        switch self {
        case .regular(let size):
            return UIFont.systemFont(ofSize: size)
        case .bold(let size):
            return UIFont.boldSystemFont(ofSize: size)
        case .custom(let fontName, let size):
            return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}

extension Font {
    static let regular13 = Font.regular(13).font()
    static let regular14 = Font.regular(14).font()
    static let regular15 = Font.regular(15).font()
    static let regular16 = Font.regular(16).font()
    static let regular17 = Font.regular(17).font()
    
    static let bold13 = Font.bold(13).font()
    static let bold14 = Font.bold(14).font()
    static let bold15 = Font.bold(15).font()
    static let bold16 = Font.bold(16).font()
    static let bold17 = Font.bold(17).font()
    static let bold18 = Font.bold(18).font()
    static let bold20 = Font.bold(20).font()
    
    static let Andong11 = Font.custom(FontNames.andong, 11).font()
    static let Andong13 = Font.custom(FontNames.andong, 13).font()
    static let Andong15 = Font.custom(FontNames.andong, 15).font()
    static let Andong16 = Font.custom(FontNames.andong, 16).font()
    static let Andong18 = Font.custom(FontNames.andong, 18).font()
    static let Andong30 = Font.custom(FontNames.andong, 30).font()
    static let Andong60 = Font.custom(FontNames.andong, 60).font()
    
    static let bold25 = Font.bold(25).font()
}
