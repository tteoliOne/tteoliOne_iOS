//
//  EtcReportReactor.swift
//  Tteolione
//
//  Created by 전준영 on 2/6/25.
//

import Foundation
import ReactorKit
import RxSwift

final class EtcReportReactor: Reactor {
    
    enum Action {
        case updateReportText(String)
        case reportButtonTap
    }
    
    enum Mutation {
        case setReportText(String)
        case setReportLengthText(String)
        case isReport(Bool)
        case showError(NetworkError)
    }
    
    struct State {
        var productId: Int = 0
        var reportText: String = ""
        var reportLengthText: String = "0/100"
        var isReport: Bool = false
        var reportCategoryType: ReportCategory?
        var errorMessage: String?
    }
    
    private let networkProvider: NetworkProvider<UserAPI>
    var initialState: State = State()
    
    init(networkProvider: NetworkProvider<UserAPI>,
         productId: Int) {
        self.networkProvider = networkProvider
        self.initialState = State(productId: productId)
    }
}

extension EtcReportReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .updateReportText(let text):
            let maxLength = 100
            let trimmedText = String(text.prefix(maxLength))
            let textLengthText = "\(trimmedText.count)/\(maxLength)"
            return .concat([
                .just(.setReportText(trimmedText)),
                .just(.setReportLengthText(textLengthText))
            ])
            
        case .reportButtonTap:
            return reportPost(reportType: .products,
                              reportCategory: .etc,
                              productId: currentState.productId,
                              content: currentState.reportText)
        }
    }
    
}

extension EtcReportReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setReportText(let text):
            newState.reportText = text
            
        case .setReportLengthText(let lengthText):
            newState.reportLengthText = lengthText
            
        case .isReport(let isReport):
            newState.isReport = isReport
            
        case .showError(let error):
            newState.errorMessage = error.localizedDescription
        }
        
        return newState
    }
    
}

extension EtcReportReactor {
    private func reportPost(reportType: ReportType,
                            reportCategory: ReportCategory,
                            productId: Int,
                            content: String) -> Observable<Mutation> {
        let query = ReportQueryParameters(reportCategory: reportCategory.rawValue)
        let body = ReportRequestBody(content: content,
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
                    .just(.isReport(true)),
                    .just(.isReport(false))
                ])
            case .failure(let error):
                return .just(.showError(error))
            }
        }
    }
}
