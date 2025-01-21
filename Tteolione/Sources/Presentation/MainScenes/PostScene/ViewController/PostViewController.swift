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
        
        rootView.titleTextField.rx.text.orEmpty
            .map { $0.count <= 20 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
              if !isEditable {
                self?.rootView.titleTextField.text = String(self?.rootView.titleTextField.text?.dropLast() ?? "")
              }
            })
            .disposed(by: disposeBag)

        rootView.titleTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { PostReactor.Action.updateTitle($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.purchasePriceTextField.rx.text.orEmpty
            .map { $0.count <= 9 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
              if !isEditable {
                self?.rootView.purchasePriceTextField.text = String(self?.rootView.purchasePriceTextField.text?.dropLast() ?? "")
              }
            })
            .disposed(by: disposeBag)
        
        rootView.purchasePriceTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { PostReactor.Action.updatePurchasePrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.purchaseCountTextField.rx.text.orEmpty
            .map { $0.count <= 9 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
              if !isEditable {
                self?.rootView.purchaseCountTextField.text = String(self?.rootView.purchaseCountTextField.text?.dropLast() ?? "")
              }
            })
            .disposed(by: disposeBag)
        
        rootView.purchaseCountTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { PostReactor.Action.updatePurchaseCount($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.sharePriceTextField.rx.text.orEmpty
            .map { $0.count <= 9 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
              if !isEditable {
                self?.rootView.sharePriceTextField.text = String(self?.rootView.sharePriceTextField.text?.dropLast() ?? "")
              }
            })
            .disposed(by: disposeBag)
        
        rootView.sharePriceTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { PostReactor.Action.updatePurchaseCount($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.shareCountTextField.rx.text.orEmpty
            .map { $0.count <= 9 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
              if !isEditable {
                self?.rootView.shareCountTextField.text = String(self?.rootView.shareCountTextField.text?.dropLast() ?? "")
              }
            })
            .disposed(by: disposeBag)
        
        rootView.shareCountTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { PostReactor.Action.updatePurchaseCount($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.vegetableButton.rx.tap
            .map { PostReactor.Action.vegetableButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.fruitButton.rx.tap
            .map { PostReactor.Action.fruitButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.mealKitButton.rx.tap
            .map { PostReactor.Action.mealKitButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.meatButton.rx.tap
            .map { PostReactor.Action.meatButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.seaFoodButton.rx.tap
            .map { PostReactor.Action.seaFoodButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.etcButton.rx.tap
            .map { PostReactor.Action.etcButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.descriptionTextView.rx.text.orEmpty
            .map { $0.count <= 100 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEditable in
              if !isEditable {
                self?.rootView.descriptionTextView.text = String(self?.rootView.descriptionTextView.text?.dropLast() ?? "")
              }
            })
            .disposed(by: disposeBag)
        
        rootView.descriptionTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { PostReactor.Action.updateDescriptionText($0) }
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
        
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.titleLengthText }
            .distinctUntilChanged()
            .bind(to: rootView.titleWordCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { !$0.isTitleValid }
            .distinctUntilChanged()
            .bind(to: rootView.titleSpaceWarningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPurchaseValid }
            .distinctUntilChanged()
            .bind(with: rootView) { owner, isValid in
                let isAll = isValid.allSatisfy { $0 }
                owner.purchaseSpaceWarningLabel.isHidden = isAll
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShareValid }
            .distinctUntilChanged()
            .bind(with: rootView) { owner, isValid in
                let isAll = isValid.allSatisfy { $0 }
                owner.shareSpaceWarningLabel.isHidden = isAll
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isCategorySelected }
            .distinctUntilChanged()
            .bind(with: rootView) { owner, isValid in
                owner.setCategoryButton(isValid)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.descriptionPlaceholderText }
            .distinctUntilChanged()
            .bind(to: rootView.descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.descriptionLengthText }
            .distinctUntilChanged()
            .bind(to: rootView.remainCountLabel.rx.text)
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
