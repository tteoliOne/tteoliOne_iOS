//
//  NetworkProvider.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import Moya
import RxSwift
import RxMoya

final class NetworkProvider<T: TargetType> {
    
    private let provider: MoyaProvider<T>
    
    init(interceptor: RequestInterceptor? = nil) {
        let session = Session(interceptor: interceptor)
//        let plugins: [PluginType] = [NetworkLoggerPlugin()]
        let plugins: [PluginType] = [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        self.provider = MoyaProvider<T>(session: session,
                                        plugins: plugins)
    }
    
    func request<R: Decodable>(_ target: T,
                               decodingType: R.Type,
                               retryCount: Int = 1) -> Single<R> {
        return provider.rx
            .request(target)
            .filterSuccessfulStatusCodes()
            .map(R.self)
            .retry(retryCount)
            .catch { error in
                if let moyaError = error as? MoyaError, let response = moyaError.response {
                    let serverError = NetworkError.serverError(
                        code: response.statusCode,
                        message: String(data: response.data, encoding: .utf8) ?? "알 수 없는 오류"
                    )
                    return Single<R>.error(serverError)
                } else {
                    return Single<R>.error(NetworkError.connectionError)
                }
            }
    }
    
}
