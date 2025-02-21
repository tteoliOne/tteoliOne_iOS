//
//  SettingViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/7/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController<SettingView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: SettingCoordinatorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAppDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.getToggleNotification)
        
    }
    
    @objc private func handleAppDidBecomeActive() {
        reactor?.action.onNext(.getToggleNotification)
        DispatchQueue.main.async {
            self.rootView.tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
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
                    reactor.action.onNext(.profileSettingTap)
                case .password:
                    reactor.action.onNext(.profileResetPasswordTap)
                case .address:
                    reactor.action.onNext(.resetAddressTap)
                case .terms:
                    print("이용약관 이동")
                case .privacy:
                    print("개인정보 처리방침 이동")
                case .logout:
                    reactor.action.onNext(.logoutTap)
                case .withdraw:
                    reactor.action.onNext(.withDrawTap)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.rootView.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.toggleNotificationAction = { [weak self] isOn in
            guard let self = self else { return }
            
            let settingsURL = URL(string: UIApplication.openSettingsURLString)!
            
            if isOn {
                self.showAlert(title: "알림 활성화",
                               message: "설정 앱에서 알림을 활성화하시겠습니까?",
                               cancelTitle: "취소") {
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            } else {
                self.showAlert(title: "알림 비활성화",
                               message: "설정 앱에서 직접 변경해야 합니다.",
                               cancelTitle: "취소") {
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            }
        }
    }
    
    func bindState(_ reactor: SettingReactor) {
        reactor.state.map { $0.sections }
            .bind(to: rootView.tableView.rx.items(dataSource: rootView.dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: SettingReactor) {
        reactor.state.map { $0.isProfileSettingTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushProfileSettingView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isProfileResetPasswordTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushProfileResetPasswordView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isResetAddressTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushAddressSettingView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLogoutTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "로그 아웃",
                                message: "로그 아웃 하시겠습니까?",
                                cancelTitle: "취소") {
                    reactor.action.onNext(.logoutCheckTap)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isWithDrawTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushWithdrawSettingView()
            }
            .disposed(by: disposeBag)
        
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
