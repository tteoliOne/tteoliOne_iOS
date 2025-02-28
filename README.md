![iOS 17.0](https://img.shields.io/badge/iOS-17.0-lightgrey?style=flat&color=181717)
[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-F05138.svg?style=flat&color=F05138)](https://swift.org/download/) [![Xcode 16.2](https://img.shields.io/badge/Xcode-16.2-147EFB.svg?style=flat&color=147EFB)](https://apps.apple.com/kr/app/xcode/id497799835?mt=12)

# 떠리원
<img src="https://github.com/user-attachments/assets/4598471c-f4d7-4cb9-b8e3-7c8a35d7b061" alt="myAppIcon" width="200"/>

## 프로젝트 소개
떠리원은 자취생들을 위한 공동 식자재 구매 및 나눔 플랫폼입니다.
혼자서 대량으로 구매하기 부담스러운 식자재를 함께 사고, 필요 없는 재료는 채팅을 통해 쉽게 공유할 수 있습니다.

- 인원 : iOS 1명, Android 1명, 서버 1명
- 진행 기간
    - 기획 : 2024.12.01 ~ 2024.12.14
    - 개발 : 2024.12.15 ~ 2025.02.26
    - 출시 : 2025.02.27
- 기술 스택
    - 개발 환경 
       - iOS : Swift 6.0, Xcode 16.2
       - 서버 : [떠리원 서버](https://github.com/tteoliOne/tteoliOne-Server)  
    - 라이브러리 
       - iOS : UIKit, RxSwift, RxGesture, RxDataSources, RectorKit, Firebase, Moya, RxKakaoOpenSDK, IQKeyboardManagerSwift, SnapKit, Toast
       - Pods : StompClientLib
    - Deployment Target : iOS 17.0


## 📱 주요 화면

> **로그인 화면**

<img src="https://github.com/user-attachments/assets/d1e6c0e7-8a07-4be3-9ac6-c16df19955c1" width="200">

---

> **메인화면** 및 **상세 화면**

<img src="https://github.com/user-attachments/assets/31d6516a-04d9-4d20-8719-74a0be492999" width="200"> <img src="https://github.com/user-attachments/assets/b4fb4cc6-5b24-4520-bfb1-5c0ec94fb6b4" width="200">

---

> **채팅 리스트** 및 **채팅 화면**

<img src="https://github.com/user-attachments/assets/889b000b-157a-400e-9c6d-a7ccf2b706bc" width="200"> <img src="https://github.com/user-attachments/assets/eb301f80-133e-450a-9e50-ce7a6574dc88" width="200">

---

> **내 프로필** 및 **상대방 프로필**

<img src="https://github.com/user-attachments/assets/dbbe4c2a-e6b5-4cfb-b80f-613e6d6022b9" width="200"> <img src="https://github.com/user-attachments/assets/261fc9f8-a38c-4a0e-85b8-fe504a291c4a" width="200">

## 주요 키워드
- 패턴 & 아키텍처
    - ReactorKit: 단방향 데이터 플로우를 기반으로 한 상태 관리.
    - 코디네이터(Coordinator) 패턴: 화면 전환 및 흐름 제어.
- 소켓 & 네트워크
    - StompClientLib: WebSocket을 활용한 실시간 소켓 통신.
    - RxMoya: RxSwift 기반의 네트워크 요청 및 응답 처리.
    - Firebase: 서버를 통한 푸시 알림 및 사용자 인증 (FCM, Firebase Auth).
- 데이터 관리
    - SwiftData: 채팅관련 데이터 저장.
    - UserDefaults: 사용자 관련된 데이터 및 최근 검색어 저장.
- 소셜 로그인
    - RxKakaoOpenSDK: 카카오 로그인 및 사용자 정보 관리.
- UI & UX
    - RxGesture: 제스처 이벤트 처리.
    - RxDataSources: 반응형 UI 데이터 관리.
    - SnapKit: 오토레이아웃 코드 작성.
    - Toast: 사용자 알림 메시지.
    - UIKeyboardLayoutGuide: 키보드 대응 UI 레이아웃.
- Reactive Programming
    - RxSwift: 반응형 프로그래밍을 통한 데이터 흐름 제어.
    - RxCocoa: UIKit 바인딩.

## 브랜치 전략 (Branch Strategy)
- 프로젝트의 효율적인 작업 관리를 위해 PR 활용
- Git Flow 브랜치 전략을 기반으로 개발 및 배포 진행

> Git Flow 브랜치 전략

**main (배포 브랜치)**
- 항상 배포 가능한 상태를 유지해야 하는 브랜치
- 모든 개발 작업이 완료된 후 develop에서 병합하여 배포
- 긴급한 버그 수정 (hotfix) 발생 시 직접 반영 가능

**develop (개발 브랜치)**
- 최신 개발 코드가 포함된 브랜치
- feature브랜치에서 개발된 기능을 PR을 통해 머지
- 안정적인 상태에서 main 브랜치로 병합 후 배포

**feature (기능 개발 브랜치)**
- 새로운 기능을 개발하는 브랜치
- 컨벤션을 준수하여 브랜치명 지정
- 개발 완료 후, PR을 통해 develop 브랜치로 병합

**hotfix (긴급 수정 브랜치)**
- 배포 후 발생한 긴급한 버그를 수정하는 브랜치
- main 브랜치를 기준으로 생성하며, 빠르게 수정 후 즉시 배포












