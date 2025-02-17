//
//  SettingViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import ReactorKit
import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController<SettingView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: SettingCoordinatorDelegate?
    
}

extension SettingViewController: View {
    
    func bind(reactor: SettingReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: SettingReactor) {
        rootView.backButton.rx.tap
            .map { SettingReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.modelSelected(SettingItem.self)
            .bind { item in
                switch item {
                case .profile:
                    print("프로필 설정 이동")
                case .password:
                    print("비밀번호 변경 이동")
                case .address:
                    print("주소 설정 이동")
                case .terms:
                    print("이용약관 이동")
                case .privacy:
                    print("개인정보 처리방침 이동")
                case .logout:
                    print("로그아웃 처리")
                case .withdraw:
                    print("회원 탈퇴 처리")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: SettingReactor) {
        reactor.state.map { $0.sections }
            .bind(to: rootView.tableView.rx.items(dataSource: rootView.dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: SettingReactor) {
        reactor.state.map { $0.isBackButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.finishView()
            }
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: DelegateOwner {
    typealias Delegate = SettingCoordinatorDelegate
}
