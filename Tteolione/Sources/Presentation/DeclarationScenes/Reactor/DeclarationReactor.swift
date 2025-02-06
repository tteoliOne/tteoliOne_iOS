//
//  DeclarationReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import Foundation
import ReactorKit
import RxSwift

final class DeclarationReactor: Reactor {
    
    enum Action {
        case spamTap
        case imageAndViolenceTap
        case informationTap
        case etcTap
    }
    
    enum Mutation {
        case showReportSuccessScreen(Bool)
        case showEtcScreen(Bool)
        case setReportType(ReportCategory)
        case showError(NetworkError)
    }
    
    struct State {
        var productId: Int = 0
        var tableViewItems: [MenuItem] = []
        var isShowReportSuccess: Bool = false
        var isShowEtcScreen: Bool = false
        var reportCategoryType: ReportCategory?
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    var initialState: State = State()
    
    init(networkProvider: NetworkProvider<UserAPI>,
         productId: Int) {
        let menuItems = [
            MenuItem(title: "스팸"),
            MenuItem(title: "이미지 및 언어폭력"),
            MenuItem(title: "거짓정보"),
            MenuItem(title: "기타")
        ]
        self.networkProvider = networkProvider
        self.initialState = State(productId: productId,
                                  tableViewItems: menuItems)
    }
}

extension DeclarationReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .spamTap:
            return .concat([
                .just(.setReportType(.spam)),
                reportPost(reportType: .products,
                           reportCategory: .spam,
                           productId: currentState.productId)
            ])
            
        case .imageAndViolenceTap:
            return .concat([
                .just(.setReportType(.imageViolence)),
                reportPost(reportType: .products,
                           reportCategory: .imageViolence,
                           productId: currentState.productId)
            ])
            
        case .informationTap:
            return .concat([
                .just(.setReportType(.information)),
                reportPost(reportType: .products,
                           reportCategory: .information,
                           productId: currentState.productId)
            ])
            
        case .etcTap:
            return .concat([
                .just(.setReportType(.etc)),
                .just(.showEtcScreen(true)),
                .just(.showEtcScreen(false))
            ])
        }
    }
    
}

extension DeclarationReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .showReportSuccessScreen(let isShow):
            newState.isShowReportSuccess = isShow
            
        case .showEtcScreen(let isShow):
            newState.isShowEtcScreen = isShow
            
        case .setReportType(let type):
            newState.reportCategoryType = type
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
        }
        
        return newState
    }
    
}

extension DeclarationReactor {
    private func reportPost(reportType: ReportType,
                            reportCategory: ReportCategory,
                            productId: Int) -> Observable<Mutation> {
        let query = ReportQueryParameters(reportCategory: reportCategory.rawValue)
        let body = ReportRequestBody(content: nil,
                                     reporteeId: nil)
        return networkProvider.request(.reports(reportType: reportType.rawValue,
                                                id: productId,
                                                query: query,
                                                body: body),
                                       decodingType: ServerResponse<String>.self)
        .asObservable()
        .flatMap { response -> Observable<Mutation> in
            switch handleResponse(response) {
            case .success(_):
                return .concat([
                    .just(.showReportSuccessScreen(true)),
                    .just(.showReportSuccessScreen(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}
