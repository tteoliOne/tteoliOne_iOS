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
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.myAppMain,
            .font: Font.Andong20
        ]
        navigationBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: self,
            action: nil
        )
    }

}
