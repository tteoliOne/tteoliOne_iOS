//
//  SearchBar.swift
//  Tteolione
//
//  Created by 전준영 on 1/28/25.
//

import UIKit

class SearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupSearchBar() {
        self.placeholder = "검색하기"
        
        if let searchTextField = self.value(forKey: "searchField") as? UITextField {
            self.tintColor = UIColor(red: 0x58/255.0, green: 0x8F/255.0, blue: 0x11/255.0, alpha: 1.0)
            searchTextField.backgroundColor = .white
            searchTextField.layer.cornerRadius = 15
            searchTextField.layer.borderWidth = 1.0
            searchTextField.layer.borderColor = UIColor(red: 0.8255520463, green: 0.835944593, blue: 0.8357618451, alpha: 1).cgColor
        }
    }
    
}
