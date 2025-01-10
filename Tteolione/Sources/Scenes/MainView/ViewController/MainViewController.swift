//
//  MainViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/9/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class MainViewController: BaseViewController<MainView> {
    
    var disposeBag = DisposeBag()
    
    private let dummyCategories = [
        "Category 1",
        "Category 2",
        "Category 3",
        "Category 4",
        "Category 5",
        "Category 6"
    ]
    
    private let dummyProducts = [
        [
            Product(name: "Onion", price: 4000, distance: "35m 도보 5분"),
            Product(name: "Tomato", price: 3000, distance: "100m 도보 10분"),
            Product(name: "Apple", price: 5000, distance: "50m 도보 8분"),
            Product(name: "Banana", price: 2000, distance: "80m 도보 15분"),
            Product(name: "Carrot", price: 2500, distance: "20m 도보 3분")
        ],
        [
            Product(name: "Milk", price: 2500, distance: "40m 도보 7분"),
            Product(name: "Bread", price: 1500, distance: "20m 도보 5분"),
            Product(name: "Cheese", price: 3500, distance: "70m 도보 12분")
        ],
        [
            Product(name: "Potato", price: 1500, distance: "60m 도보 12분")
        ],
        [
            Product(name: "Cabbage", price: 2200, distance: "30m 도보 6분")
        ],
        [
            Product(name: "Lettuce", price: 1800, distance: "25m 도보 5분")
        ],
        [
            
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = Observable.just(
            zip(dummyCategories, dummyProducts)
                .map { MainSectionModel(category: $0, products: $1) }
        )
        
        dataSource
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: MainTableViewCell.identifier,
                cellType: MainTableViewCell.self
            )) { index, section, cell in
                cell.configure(category: section.category, products: section.products)
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            rootView.tableView.rx.contentOffset.map { $0.y }
        )
        .bind(with: self) { owner, offset in
            owner.rootView.adjustButtonShape(forScrollOffset: offset)
        }
        .disposed(by: disposeBag)
    }
    
}
