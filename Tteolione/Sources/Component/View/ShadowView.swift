//
//  ShadowView.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit
import SnapKit

class ShadowView: UIView {

    private let roundedView = UIView()

    init(color: UIColor? = .white,
         corner: CGFloat? = 20,
         shadowColor: CGColor? = UIColor.myAppBlack.cgColor,
         borderWidth: CGFloat? = 0,
         borderColor: CGColor? = nil) {
        super.init(frame: .zero)

        backgroundColor = .clear
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3

        roundedView.backgroundColor = color
        roundedView.layer.cornerRadius = corner ?? 20
        roundedView.layer.borderWidth = borderWidth ?? 0
        roundedView.layer.borderColor = borderColor
        roundedView.layer.masksToBounds = true

        addSubview(roundedView)
        roundedView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

