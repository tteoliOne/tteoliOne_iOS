//
//  PostReceiptViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import UIKit
import ReactorKit
import RxCocoa
import PhotosUI

final class PostReceiptViewController: BaseViewController<PostReceiptView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: PostCoordinatorDelegate?
    
}

extension PostReceiptViewController: View {
    
    func bind(reactor: PostReceiptReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    func bindAction(_ reactor: PostReceiptReactor) {
        if reactor.viewType == .edit, let receiptImage = reactor.initialState.receiptImage {
            reactor.action.onNext(.setReceiptImage(receiptImage))
        }
        
        rootView.photoButton.rx.tap
            .map { PostReceiptReactor.Action.photoButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.registerButton.rx.tap
            .map { PostReceiptReactor.Action.registerButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: PostReceiptReactor) {
        reactor.state.map { $0.receiptImage }
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
    }
    
    func bindNavigation(_ reactor: PostReceiptReactor) {
        reactor.state.map { $0.isRegister }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.delegate?.dismissAndPop()
            }
            .disposed(by: disposeBag)
    }
}

extension PostReceiptViewController: PHPickerViewControllerDelegate {
    
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
                self.rootView.updateImage(image)
                self.reactor?.action.onNext(.imageSelected(image))
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

extension PostReceiptViewController: DelegateOwner {
    typealias Delegate = PostCoordinatorDelegate
}
