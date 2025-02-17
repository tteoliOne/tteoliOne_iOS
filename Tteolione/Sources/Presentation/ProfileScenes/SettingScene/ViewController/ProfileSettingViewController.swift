//
//  ProfileSettingViewController.swift
//  Tteolione
//
//  Created by 전준영 on 2/17/25.
//

import ReactorKit
import RxSwift
import RxCocoa
import PhotosUI
import Toast

final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: SettingCoordinatorDelegate?
    
}

extension ProfileSettingViewController: View {
    
    func bind(reactor: ProfileSettingReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: ProfileSettingReactor) {
        reactor.action.onNext(.fetchProfile)
        
        rootView.setButton.rx.tap
            .map { ProfileSettingReactor.Action.resetProfileButtonTap }
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
            .map { ProfileSettingReactor.Action.updateNickname($0) }
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
            .map { ProfileSettingReactor.Action.updateIntro($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.profileSetButton.rx.tap
            .map { ProfileSettingReactor.Action.photoButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.backButton.rx.tap
            .map { ProfileSettingReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ProfileSettingReactor) {
        reactor.state.map { $0.profileImage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView) { owner, image in
                owner.updateImage(image)
            }
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
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, errorMessage in
                owner.view.makeToast(errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    func bindNavigation(_ reactor: ProfileSettingReactor) {
        reactor.state.map { $0.isProductImagePickerShown }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.showImagePicker()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.backButtonTapped }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.popVC()
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileSettingViewController: PHPickerViewControllerDelegate {
    
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

extension ProfileSettingViewController: DelegateOwner {
    typealias Delegate = SettingCoordinatorDelegate
}
