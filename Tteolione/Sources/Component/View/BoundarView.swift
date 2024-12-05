//
//  BoundarView.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

class BoundarView: UILabel {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .myAppDarkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
