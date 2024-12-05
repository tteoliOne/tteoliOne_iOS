//
//  BaseViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

class BaseViewController<RootView: UIView>: UIViewController {
    
    let rootView: RootView
    
    init() {
        self.rootView = RootView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func configureConstraints() {
        
    }
    
}
