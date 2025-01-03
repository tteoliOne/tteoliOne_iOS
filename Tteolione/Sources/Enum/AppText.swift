//
//  AppText.swift
//  Tteolione
//
//  Created by 전준영 on 12/5/24.
//

import Foundation

enum AppText {
    
    enum Logo {
        static let tteoliOneNumber = "31"
        static let tteoliOneText = "떠리원"
    }
    
    enum Login {
        static let id = "아이디"
        static let password = "비밀번호"
        static let passwordShow = "표시"
        static let slash = "|"
        static let orText = "또는"
    }
    
    enum Join {
        static let join = "회원가입"
        static let joinEmail = "이메일 주소"
        static let joinEmailExplain = "반드시 이메일 형식에 맞게 입력해 주세요"
        
        static let joinAuthNum = "인증번호"
        static let joinAuthTime = "남은시간 3:00"
        
        static let joinUserName = "이름"
        static let joinUserNameExplain = "자신의 이름을 적으세요"
        
        static let joinID = "아이디"
        static let joinIDExplain = "6~20자리 소문자 하나이상 포함"
        
        static let joinPassword = "비밀번호"
        
        static let joinNickname = "닉네임"
        static let joinNicknameExplain = "한글, 영문, 숫자만 사용가능(2 ~ 10자리)\n닉네임은 커뮤니티 활동할 때 표시됩니다\n닉네임은 사용자 설정에서 변경이 가능합니다"
        
        static let joinProfile = "프로필 설정"
        static let joinProfileExplain = "프로필 변경하지 않을시 기본이미지로 설정됩니다"
        
        static let joinFinsh = "반갑습니다\n떠리원에 오신것을\n환영합니다"
    }
    
    enum Account {
        static let findId = "아이디 찾기"
        static let findIDExplain = "회원가입에 인증한 이메일 주소와 입력한 이메일 주소가 같아야합니다"
        static let findResult = "회원님이 찾으시는 아이디입니다"
        static let findResultID = "ID:"
        
        static let resetPassword = "비밀번호 변경"
    }
    
}
