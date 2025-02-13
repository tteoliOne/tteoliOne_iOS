//
//  NetworkError.swift
//  Tteolione
//
//  Created by 전준영 on 12/13/24.
//

import Foundation

public enum NetworkError: LocalizedError,Equatable {
    
    case connectionError // 네트워크 연결 문제
    case serverError(code: Int, message: String?) // 서버에서 반환한 에러
    case decodingFailure // JSON 디코딩 실패
    case notModified // Not Modified
    case unknownError // 알 수 없는 에러
    case invalidInputImage // 이미지 입력 실패
    case invalidRefreshToken // 리프레시 토큰 유효성 실패 (추가)
    
    public var errorDescription: String? {
        switch self {
        case .connectionError:
            return "네트워크 연결에 문제가 있습니다. 인터넷 연결을 확인해주세요."
            
        case let .serverError(_, message):
            return message ?? "서버에서 알 수 없는 오류가 발생했습니다."
            
        case .decodingFailure:
            return "응답 데이터를 처리하는 데 실패했습니다."
            
        case .notModified:
            return "Not Modified"
            
        case .unknownError:
            return "알 수 없는 문제가 발생했습니다."
            
        case .invalidInputImage:
            return "이미지가 잘못되었습니다."
            
        case .invalidRefreshToken:
            return "유효하지 않은 리프레시 토큰입니다. 다시 로그인해주세요."
        }
    }
    
    public var isInvalidRefreshToken: Bool {
        if case .invalidRefreshToken = self {
            return true
        }
        if case let .serverError(code, _) = self, code == 112 {
            return true
        }
        return false
    }
    
}

extension NetworkError {
    
    private static func descriptionForErrorCode(_ code: Int) -> String {
        switch code {
        case 400: return "잘못된 요청입니다. 요청 파라미터를 확인해주세요."
        case 401: return "인증이 필요합니다. 다시 로그인해주세요."
        case 403: return "권한이 없습니다."
        case 404: return "요청한 리소스를 찾을 수 없습니다."
        case 500: return "서버 내부 오류가 발생했습니다."
        case 503: return "서버가 점검 중입니다. 잠시 후 다시 시도해주세요."
        default: return "등록되지 않은 오류 코드: \(code)"
        }
    }
    
    static func fromServerResponse(success: Bool,
                                   code: Int,
                                   message: String?) -> NetworkError {
        if code == 112 {
            return .invalidRefreshToken
        }
        if success {
            return .unknownError
        } else {
            return .serverError(code: code,
                                message: message)
        }
    }
    
}
