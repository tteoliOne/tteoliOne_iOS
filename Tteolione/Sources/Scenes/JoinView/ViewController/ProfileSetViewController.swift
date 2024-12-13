//
//  ProfileSetViewController.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import UIKit
import ReactorKit
import RxCocoa

final class ProfileSetViewController: BaseViewController<ProfileSetView> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ProfileSetReactor()
    }
    
}

extension ProfileSetViewController: View {
    
    func bind(reactor: ProfileSetReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: ProfileSetReactor) {
        rootView.profileChangeButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.profilePhotoPicker.delegate = owner
                owner.present(owner.rootView.profilePhotoPicker, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.topBarView.backButton.rx.tap
            .map { ProfileSetReactor.Action.backButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.joinButton.rx.tap
            .map { ProfileSetReactor.Action.joinButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ProfileSetReactor) {
        reactor.state.map { $0.profileImage }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: rootView) { view, image in
                view.profileImage.configure(setImage: image)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: ProfileSetReactor) {
        reactor.backNavigation
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileSetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            reactor?.action.onNext(.imageSelected(image))
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
