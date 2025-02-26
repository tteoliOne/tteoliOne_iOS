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
        let fcmToken = UserDefaultsStorage.fcmToken
        let body = ReissueTokenRequestBody(accessToken: UserDefaultsStorage.token,
                                           refreshToken: UserDefaultsStorage.refreshToken,
                                           targetToken: fcmToken)

        provider.request(.reissueToken(body: body)) { result in
            switch result {
            case .success(let response):
                do {
                    let tokenResponse = try JSONDecoder().decode(ServerResponse<TokenDTO>.self, from: response.data)
                    let statusCode = tokenResponse.code
                    switch statusCode {
                    case 112:
                        NotificationCenter.default.post(name: .logout, object: nil)
                        completion(false)
                    case 113:
                        NotificationCenter.default.post(name: .logout, object: nil)
                        completion(false)
                    case 114:
                        NotificationCenter.default.post(name: .logout, object: nil)
                        completion(false)
                    default:
                        if let tokenDTO = tokenResponse.data {
                            UserDefaultsStorage.token = tokenDTO.accessToken ?? ""
                            UserDefaultsStorage.refreshToken = tokenDTO.refreshToken ?? ""
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                    
                } catch {
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
        }
    }

}
