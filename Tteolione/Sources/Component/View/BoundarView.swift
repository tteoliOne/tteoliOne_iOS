//
//  BoundarView.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

class BoundarView: UILabel {
    
    init(_ color: UIColor) {
        super.init(frame: .zero)
        
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
