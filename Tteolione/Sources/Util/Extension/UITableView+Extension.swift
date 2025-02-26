//
//  UITableView+Extension.swift
//  Tteolione
//
//  Created by 전준영 on 2/18/25.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let numberOfSections = self.numberOfSections
            guard numberOfSections > 0 else { return }
            
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            guard numberOfRows > 0 else { return }
            
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
}
