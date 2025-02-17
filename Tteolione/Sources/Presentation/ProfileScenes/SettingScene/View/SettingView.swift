//
//  SettingView.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import UIKit
import SnapKit
import RxDataSources

final class SettingView: BaseView {
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<SettingSection>(
        configureCell: { _, tableView, indexPath, item in
            switch item {
            case .chatNotification(let isOn):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingSwitchCell.identifier,
                                                               for: indexPath) as? SettingSwitchCell else {
                    return UITableViewCell()
                }
                cell.configure(title: item.title,
                               isOn: isOn)
                return cell
                
            case .version(let version):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingVersionCell.identifier,
                                                               for: indexPath) as? SettingVersionCell else {
                    return UITableViewCell()
                }
                cell.configure(title: item.title,
                               version: version)
                return cell
                
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier,
                                                               for: indexPath) as? SettingTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(title: item.title)
                return cell
            }
        },
        titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].title
        }
    )
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppText.MyProduct.setting
        label.font = Font.bold20
        label.textColor = .myAppMain
        return label
    }()
    let backButton = BackButton(size: 24)
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingTableViewCell.self,
                           forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.register(SettingSwitchCell.self,
                           forCellReuseIdentifier: SettingSwitchCell.identifier)
        tableView.register(SettingVersionCell.self,
                           forCellReuseIdentifier: SettingVersionCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 52
        return tableView
    }()
    
    override func configureHierarchy() {
        [backButton, titleLabel,
         tableView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
