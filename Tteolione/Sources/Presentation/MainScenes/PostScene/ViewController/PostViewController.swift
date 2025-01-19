//
//  PostViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/10/25.
//

import PhotosUI
import ReactorKit
import RxCocoa

final class PostViewController: BaseViewController<PostView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: MainCoordinatorDelegate?
    
}

extension PostViewController: View {
    
    func bind(reactor: PostReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindNavigation(reactor)
    }
    
    private func bindAction(_ reactor: PostReactor) {
        rootView.productPhotoButton.rx.tap
            .map { PostReactor.Action.productPhotoTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: PostReactor) {
        reactor.state.map { $0.isProductImagePickerShown }
            .distinctUntilChanged()
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.showImagePicker()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.productImages }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, images in
                owner.rootView.updatePhotoScrollView(with: images)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation(_ reactor: PostReactor) {
        
    }
    
}

extension PostViewController: PHPickerViewControllerDelegate {
    
    func showImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = max(0, 5 - (reactor?.currentState.productImages.count ?? 0))
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let dispatchGroup = DispatchGroup()
        var loadedImages: [UIImage] = []
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        loadedImages.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if !loadedImages.isEmpty {
                self.reactor?.action.onNext(.imagesSelected(loadedImages))
            }
        }
    }
    
}


extension PostViewController: DelegateOwner {
    typealias Delegate = MainCoordinatorDelegate
}
