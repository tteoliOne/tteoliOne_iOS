//
//  CustomSegmentedControl.swift
//  Tteolione
//
//  Created by 전준영 on 2/16/25.
//

import UIKit
import SnapKit

final class CustomSegmentedControl: BaseView {
    
    private let items: [String]
    private var buttons: [UIButton] = []
    private let stackView = UIStackView()
    
    var selectedIndex: Int = 0 {
        didSet {
            updateButtonStates()
        }
    }
    
    var selectionChanged: ((Int) -> Void)?
    
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(stackView)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        setupButtons()
        updateButtonStates()
    }
    
    private func setupButtons() {
        for (index, title) in items.enumerated() {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Font.regular16
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.backgroundColor = .white
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            
            let shadowView = ShadowView()
            shadowView.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            buttons.append(button)
            stackView.addArrangedSubview(shadowView)
            
            button.tag = index
        }
    }
    
    private func updateButtonStates() {
        for (index, button) in buttons.enumerated() {
            let isSelected = index == selectedIndex
            button.isSelected = isSelected
            button.backgroundColor = isSelected ? .myAppMain : .white
            button.setTitleColor(isSelected ? .white : .black, for: .normal)
            button.layer.borderColor = isSelected ? UIColor.myAppMain.cgColor : UIColor.gray.cgColor
        }
    }
    
    @objc private func segmentTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        selectionChanged?(selectedIndex)
    }
}
