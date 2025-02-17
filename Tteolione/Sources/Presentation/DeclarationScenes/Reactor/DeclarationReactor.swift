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
        var reportId: Int = 0
        var opponent: Int?
        var tableViewItems: [MenuItem] = []
        var isShowReportSuccess: Bool = false
        var isShowEtcScreen: Bool = false
        var reportCategoryType: ReportCategory?
        var errorMessage: String?
        var reportType: ReportType?
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    var initialState: State = State()
    
    init(networkProvider: NetworkProvider<UserAPI>,
         reportId: Int,
         reportType: ReportType,
         opponent: Int? = nil) {
        let menuItems = [
            MenuItem(title: "스팸"),
            MenuItem(title: "이미지 및 언어폭력"),
            MenuItem(title: "거짓정보"),
            MenuItem(title: "기타")
        ]
        self.networkProvider = networkProvider
        self.initialState = State(reportId: reportId,
                                  opponent: opponent,
                                  tableViewItems: menuItems,
                                  reportType: reportType)
    }
}

extension DeclarationReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .spamTap:
            return .concat([
                .just(.setReportType(.spam)),
                reportPost(reportType: currentState.reportType ?? .chat,
                           reportCategory: .spam,
                           targetId: currentState.reportId,
                           reporteeId: currentState.opponent)
            ])
            
        case .imageAndViolenceTap:
            return .concat([
                .just(.setReportType(.imageViolence)),
                reportPost(reportType: currentState.reportType ?? .chat,
                           reportCategory: .imageViolence,
                           targetId: currentState.reportId,
                           reporteeId: currentState.opponent)
            ])
            
        case .informationTap:
            return .concat([
                .just(.setReportType(.information)),
                reportPost(reportType: currentState.reportType ?? .chat,
                           reportCategory: .information,
                           targetId: currentState.reportId,
                           reporteeId: currentState.opponent)
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
                            targetId: Int,
                            reporteeId: Int? = nil) -> Observable<Mutation> {
        let query = ReportQueryParameters(reportCategory: reportCategory.rawValue)
        let body = ReportRequestBody(content: nil,
                                     reporteeId: reporteeId)
        return networkProvider.request(.reports(reportType: reportType.rawValue,
                                                id: targetId,
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
