//
//  NetworkProvider.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import Moya
import RxSwift
import RxMoya
import Foundation

final class NetworkProvider<T: TargetType> {
    
    private let provider: MoyaProvider<T>
    private let tokenRetrier = AccessTokenRetrier()
    
    init(interceptor: RequestInterceptor? = nil) {
        let session = Session(interceptor: tokenRetrier)
        let plugins: [PluginType] = [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        self.provider = MoyaProvider<T>(session: session,
                                        plugins: plugins)
    }
    
    func request<R: Decodable>(_ target: T,
                               decodingType: R.Type,
                               retryCount: Int = 1) -> Single<R> {
        return provider.rx
            .request(target)
            .map(R.self)
            .retry(retryCount)
            .catch { error in
                if let moyaError = error as? MoyaError, let response = moyaError.response {
                    let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    let errorMessage = json?["message"] as? String ?? "알 수 없는 오류"
                    let serverError = NetworkError.serverError(
                        code: response.statusCode,
                        message: errorMessage
                    )
                    print("📌 네트워크 요청 실패: \(serverError)")
                    return Single<R>.error(serverError)
                } else {
                    return Single<R>.error(NetworkError.connectionError)
                }
            }
    }
    
}

extension TargetType {
    var validationType: ValidationType {
        return .successCodes
    }
}
