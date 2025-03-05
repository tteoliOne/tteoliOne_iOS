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
- 기술 스택
    - 개발 환경 
       - iOS : Swift 6.0, Xcode 16.2
       - 서버 : [떠리원 서버](https://github.com/tteoliOne/tteoliOne-Server)  
    - 라이브러리 
       - iOS : UIKit, RxSwift, RxGesture, RxDataSources, RectorKit, Firebase, Moya, RxKakaoOpenSDK, IQKeyboardManagerSwift, SnapKit, Toast
       - Pods : StompClientLib
    - Deployment Target : iOS 17.0


## 📱 주요 화면

| 로그인 화면 | 메인 화면 | 상세 화면 | 채팅리스트 화면 |
|---------------|---------------|---------------|---------------|
| <img src="https://github.com/user-attachments/assets/d1e6c0e7-8a07-4be3-9ac6-c16df19955c1" width="200"> | <img src="https://github.com/user-attachments/assets/31d6516a-04d9-4d20-8719-74a0be492999" width="200"> | <img src="https://github.com/user-attachments/assets/b4fb4cc6-5b24-4520-bfb1-5c0ec94fb6b4" width="200"> | <img src="https://github.com/user-attachments/assets/889b000b-157a-400e-9c6d-a7ccf2b706bc" width="200"> |
| 채팅 화면 | 내 프로필 화면 | 상대방 프로필 화면 | 설정 화면 |
| <img src="https://github.com/user-attachments/assets/eb301f80-133e-450a-9e50-ce7a6574dc88" width="200"> | <img src="https://github.com/user-attachments/assets/dbbe4c2a-e6b5-4cfb-b80f-613e6d6022b9" width="200"> | <img src="https://github.com/user-attachments/assets/261fc9f8-a38c-4a0e-85b8-fe504a291c4a" width="200"> | <img src="https://github.com/user-attachments/assets/6bb75512-eafe-43a9-8085-fe3e79fb3e47" width="200"> |

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

## 프로젝트 구조
### 아키텍처(Architecture)
<p align="center">
    <img src="https://github.com/user-attachments/assets/c96a92a2-9494-460e-8b4e-65815d43ef1d" width="800">
</p>

- ReactorKit을 활용하여 View와 비즈니스 로직을 분리.
- View → Action → mutate() → reduce() → State → View 형태의 단방향 데이터 플로우 유지.
- Moya를 활용하여 API 요청을 구조화하고, RxMoya를 이용해 RxSwift 기반으로 비동기 네트워크 처리를 최적화.
- 채팅 및 실시간 데이터 전송을 위해 StompClientLib을 활용하여 WebSocket 통신을 적용.
- SwiftData & UserDefaults를 활용한 데이터 관리
- RxSwift를 활용한 반응형 데이터 처리 & 비동기 처리

> ## ReactorKit 기반 아키텍처 설계

- ReactorKit을 도입한 이유
    - 비즈니스 로직과 UI의 명확한 역할 분리함.
    - ReactorKit은 RxSwift 기반으로 동작하며, Observable을 활용한 비동기 이벤트 처리에 최적화됨.
    - 데이터 흐름을 단방향 데이터 플로우 유지함.
- View
    - View 프로토콜을 적용해야하며, DisposeBag와 bind(reactor:) 메서드를 정의해야 함.
    - bind 내부에는, Reactor로 보낼 Action과, Reactor로부터 수신할 State를 작성하면 됨.
- Reactor
  - Reactor는 View로 부터 Action Stream을 전달 받아, 내부에서 mutate()와 reduce() 과정을 거쳐서 State Stream으로 바꾸어 다시 View로 전달해주는 역할.
  - State의 초기값을 설정하기 위해 initialState가 필요.
  - mutate() 함수는 Action 스트림을 Mutation 스트림으로 변환하고, 변환된 Mutation 스트림은 reduce() 함수로 전달.
  - reduce() 함수는 이전 State와 Mutation을 활용하여 새로운 State를 반환하고, 이 State를 View에서 구독을 하고 있었다면, State가 변경되어 UI가 업데이트 됨.

> ## Coordinator 설계

<p align="center">
    <img src="https://github.com/user-attachments/assets/dd25d874-7785-4fa2-ad24-aa34efab6fbe" width="800" height="400">
</p>

- 도입 배경
    - 기존에는 ViewController가 직접 화면 전환을 처리하여 다른 ViewController와 강한 결합도를 가짐.
    - 화면 전환 로직이 ViewController 내부에 혼재되면서 코드가 복잡해지고 유지보수성이 낮아지는 문제 발생.
- Coordinator의 적용
    - Coordinator는 화면 전환과 관련된 모든 데이터 전달을 담당하며, 각 ViewController에 필요한 데이터와 Reactor를 생성하여 주입.
    - 화면 전환 시 필요한 인자를 Coordinator에서 관리하여, ViewController 내부에서 데이터 설정 로직이 혼재되지 않도록 설계.

## 핵심 주요기술
> ### StompClientLib을 활용한 실시간 양방향 통신

- Stomp 프로토콜을 활용한 WebSocket 기반 메시징 시스템 구현
    - Stomp는 텍스트 기반의 메시징 프로토콜로, 가볍고 효율적인 방식으로 메시지를 전송할 수 있음.
    - (Topic - 방번호) 구조로 채팅방을 구독하여 실시간 메시지 송수신을 관리하며, 특정 사용자가 채팅방에 입장하면 자동으로 해당 Topic을 구독함.
- 채팅방 생성 및 구독 흐름 최적화
    - 사용자가 채팅방에 입장하면 해당 Topic을 구독하여 이전 메시지 및 실시간 메시지를 수신.
    - 채팅방에서 퇴장하면 자동으로 Topic 구독 해제하여 불필요한 네트워크 리소스 사용을 방지.
- Foreground / Background 상태 전환에 따른 소켓 연결 최적화
    - 앱이 Background로 진입하면 소켓 연결을 해제하여 네트워크 리소스를 절약하고,
    - 다시 Foreground로 전환될 때 자동으로 Stomp 연결을 복구하여 원활한 사용자 경험을 제공.
    - NotificationCenter를 활용하여 앱의 라이프사이클 변화 감지 후 소켓을 자동으로 재연결.
- SwiftData와 결합하여 실시간 메시지 저장 및 상태 관리
    - 실시간으로 수신된 메시지는 SwiftData를 활용하여 로컬 DB에 저장하여, 빠른 메시지 로딩이 가능하도록 최적화.
- ReactorKit과 결합한 상태 관리
    - 불필요한 UI 리렌더링을 방지하기 위해 distinctUntilChanged() 적용, 동일한 데이터가 중복 업데이트되지 않도록 최적화.
 
> ### Remote 알림 (실시간 채팅 알림 - FCM)

- Firebase Cloud Messaging(FCM) 토큰을 기반으로 푸시 알림을 구현.
- 서버가 FCM을 통해 채팅 메시지를 푸시로 전송, 사용자에게 실시간 알림 제공.
- 앱 실행 시 FCM 토큰을 가져와 UserDefaults에 저장한 후, 로그인 시 서버로 전송하여 저장.

> ### SwiftData

- iOS 17부터 제공되는 SwiftData를 활용하여 메시지 저장 및 관리.
- 실시간 채팅 데이터 관리 및 오프라인 상태에서도 메시지 조회 가능하도록 구성.

> ### 이미지 캐싱

- 이미지를 반복해서 호출하는 리소스를 줄이기 위해 메모리 캐시와 FileManager를 조합하여 이미지 캐싱 시스템을 구현

> ### RxMoya & 라우터 패턴을 활용한 네트워크 구조화

- RxMoya를 활용하여 네트워크 요청을 RxSwift 기반으로 처리.
- 라우터 패턴을 적용하여 API 요청을 명확하게 정의하고, 네트워크 레이어를 모듈화.
