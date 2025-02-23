//
//  BaseViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import UIKit

class BaseViewController<RootView: UIView>: UIViewController, UIGestureRecognizerDelegate {
    
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
        setupKeyboardDismissGesture()
    }
    
    func configureHierarchy() {}
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func configureConstraints() {}
    
    func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        self.navigationController?.view.endEditing(true)
    }
}
