//
//  ProfileViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/13/25.
//

import UIKit
import ReactorKit
import RxCocoa
import PhotosUI

final class ProfileViewController: BaseViewController<ProfileView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: ProfileCoordinatorDelegate?
    
}

extension ProfileViewController: View {
    
    func bind(reactor: ProfileReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ProfileReactor) {
//        reactor.action.onNext(.fetchProfile)
        self.rx.viewWillAppear
            .map { _ in ProfileReactor.Action.fetchProfile }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.setButton.rx.tap
            .map { ProfileReactor.Action.resetProfileButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.setNicknameTextField.rx.text.orEmpty
            .map { $0.count <= 10 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
                if !isEditable {
                    self?.rootView.setNicknameTextField.text = String(self?.rootView.setNicknameTextField.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        rootView.setNicknameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { ProfileReactor.Action.updateNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.setIntroTextField.rx.text.orEmpty
            .map { $0.count <= 20 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
                if !isEditable {
                    self?.rootView.setIntroTextField.text = String(self?.rootView.setIntroTextField.text?.dropLast() ?? "")
                }
            })
            .disposed(by: disposeBag)
        
        rootView.setIntroTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { ProfileReactor.Action.updateIntro($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.profileSetButton.rx.tap
            .map { ProfileReactor.Action.photoButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.gearButton.rx.tap
            .map { ProfileReactor.Action.gearButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.logOutButton.rx.tap
            .map { ProfileReactor.Action.logoutButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .map { indexPath in
                return indexPath.row
            }
            .subscribe(onNext: { selectedIndex in
                switch selectedIndex {
                case 0:
                    reactor.action.onNext(.myShareTap(.eNew))
                case 1:
                    reactor.action.onNext(.myShareTap(.eSoldOut))
                case 2:
                    reactor.action.onNext(.myShareTap(.saved))
                case 3:
                    reactor.action.onNext(.myReviewTap)
                case 4:
                    reactor.action.onNext(.resetProfileListTap)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ProfileReactor) {
        reactor.state.map { $0.tableViewItems }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: ProfileListTableViewCell.identifier,
                cellType: ProfileListTableViewCell.self
            )) { _, item, cell in
                cell.selectionStyle = .none
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profile }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView, onNext: { owner, value in
                owner.setupViews(with: value)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isFailure }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView) { owner, _ in
                owner.resetProfile()
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ProfileReactor) {
        reactor.state
            .map { ($0.isMyProductScreen, $0.selectedStatus) }
            .filter { $0.0 }
            .compactMap { $0.1 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, status in
                owner.delegate?.pushMyProductViewController(status: status)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isResetProfileListTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView) { owner, _ in
                owner.resetProfileField()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.nickname }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.nickname.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.intro }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.oneLinerLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.nickname }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.setNicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.intro }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.setIntroTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.introLengthText }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.remainCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileImage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView) { owner, image in
                owner.updateImage(image)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isProductImagePickerShown }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.showImagePicker()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isGearButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.showSettingView()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isReviewScreen }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.pushMyReviewViewController()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLogoutButtonTapped }
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
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func showImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        Task {
            if let image = await loadImage(from: result) {
                self.reactor?.action.onNext(.imageSelected(image))
                self.rootView.updateImage(image)
            }
        }
    }
    
    private func loadImage(from result: PHPickerResult) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        continuation.resume(returning: image)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
}

extension ProfileViewController: DelegateOwner {
    typealias Delegate = ProfileCoordinatorDelegate
}
