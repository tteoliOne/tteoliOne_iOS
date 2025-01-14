//
//  BaseNavigationViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

import UIKit

class BaseNavigationViewController<RootView: UIView>: BaseViewController<RootView> {
    override var title: String? {
        didSet {
            navigationItem.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
    }
    
    func setNavigation() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .default
        )
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: self,
            action: nil
        )
    }
}
