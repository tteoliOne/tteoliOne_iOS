//
//  ReuseIdentifierProtocol.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit

protocol ReuseIdentifierProtocol {
    
    static var identifier: String { get }
    
}

extension UITableViewCell: ReuseIdentifierProtocol {
    static var identifier: String {
        String(describing: self)
    }
}

extension UICollectionViewCell: ReuseIdentifierProtocol {
    static var identifier: String {
        String(describing: self)
    }
}
