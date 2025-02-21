//
//  SettingSwitchCell.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import UIKit
import RxSwift
import SnapKit

final class SettingSwitchCell: BaseTableViewCell {
    
    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func configureHierarchy() {
        [titleLabel, toggleSwitch].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(title: String, isOn: Bool, toggleAction: @escaping (Bool) -> Void) {
        titleLabel.text = title
        toggleSwitch.isOn = isOn
        
        toggleSwitch.rx.controlEvent(.valueChanged)
            .bind { [weak self] in
                guard let self = self else { return }
                let newValue = self.toggleSwitch.isOn
                toggleAction(newValue)
            }
            .disposed(by: disposeBag)
    }
}
