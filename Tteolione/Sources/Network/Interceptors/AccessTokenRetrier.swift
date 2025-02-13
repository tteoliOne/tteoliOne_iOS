//
//  AccessTokenRetrier.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import Foundation
import Alamofire
import RxSwift
import Moya

final class AccessTokenRetrier: RequestInterceptor {
    
    let retryLimit = 3
    let retryDelay: TimeInterval = 1
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue(Header.authorization.value, forHTTPHeaderField: Header.authorization.key)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print("Retry")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        refreshAccessToken { [weak self] isSuccess in
            guard let self = self else {
                completion(.doNotRetry)
                return
            }
            
            if isSuccess {
                if request.retryCount < self.retryLimit {
                    completion(.retryWithDelay(self.retryDelay))
                } else {
                    completion(.doNotRetry)
                }
            } else {
                completion(.doNotRetry)
            }
        }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<TokenAPI>()
        let body = ReissueTokenRequestBody(accessToken: UserDefaultsStorage.token,
                                           refreshToken: UserDefaultsStorage.refreshToken,
                                           targetToken: nil)
        provider.request(.reissueToken(body: body)) { result in
            switch result {
            case .success(let response):
                do {
                    let tokenDTO = try JSONDecoder().decode(ServerResponse<TokenDTO>.self, from: response.data)
                    UserDefaultsStorage.token = tokenDTO.data?.accessToken ?? ""
                    UserDefaultsStorage.refreshToken = tokenDTO.data?.refreshToken ?? ""
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
            }
        }
    }
}
