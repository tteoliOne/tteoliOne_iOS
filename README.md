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
      
- Stomp 적용 방식 (소켓 연결 및 화면 구성)
  - 실시간 채팅 구현을 위한 소켓 연결 및 데이터 처리 흐름
  1. 채팅방 입장 시 Stomp 연결 및 Topic 구독
  2. SwiftData에서 채팅 내역 로드 (기존 데이터 존재 여부 확인)
     - 데이터 있음 → SwiftData에서 즉시 UI 업데이트
     - 데이터 없음 → 서버 API 호출 후 SwiftData에 저장
  3. 마지막 메시지 날짜 혹은 안 읽은 메시지의 첫 번째 날짜를 API로 전송하여 서버에서 필터링된 데이터 수신
  4. 서버 Response를 받아 SwiftData에 저장하고 UI 업데이트
     -> Stomp 연결 성공 후, 기존 데이터를 즉시 화면에 렌더링한 뒤 서버 데이터를 동기화하여 성능 최적화
     
- 메시지 송수신 (Send & Receive)
  - 메시지 전송 흐름
    1. 사용자가 메시지를 입력하고 Send 요청
    2. Stomp를 통해 서버로 메시지 전송
    3. CallBack API를 통해 메시지 전송 성공 여부 확인
    4. 성공 시 SwiftData에 저장 및 UI 업데이트
  - 메시지 수신 흐름
    1. Stomp 구독을 통해 서버에서 실시간 메시지 수신
    2. 메시지 수신 즉시 뷰에 반영 후 SwiftData에 저장
    3. 상대방이 오프라인 상태라면 CallBack API를 통해 FCM을 트리거하여 푸시 알림 전송
 
> ### Remote 알림 (실시간 채팅 알림 - FCM)

- Firebase Cloud Messaging(FCM) 토큰을 기반으로 푸시 알림을 구현.
- 서버가 FCM을 통해 채팅 메시지를 푸시로 전송, 사용자에게 실시간 알림 제공.
- 앱 실행 시 FCM 토큰을 가져와 UserDefaults에 저장한 후, 로그인 시 서버로 전송하여 저장.

> ### SwiftData

- iOS 17부터 제공되는 SwiftData를 활용하여 메시지 저장 및 관리.
- 실시간 채팅 데이터 관리 및 오프라인 상태에서도 메시지 조회 가능하도록 구성.

> ### 이미지 캐싱

- 이미지를 반복해서 호출하는 리소스를 줄이기 위해 메모리 캐시와 FileManager를 조합하여 이미지 캐싱 시스템을 구현

> ### 위치 기반 시스템 (Location-Based System) 구현

- CoreLocation과 MapKit을 활용하여 사용자 위치를 기반으로 장소 검색 및 추천 시스템 구현
- MKLocalSearchCompletion을 통해 사용자가 입력한 키워드에 맞춰 자동완성된 장소 목록 제공
- 선택한 장소를 기준으로 가장 가까운 순으로 정렬하여, 서버와 협업하여 카테고리별로 가까운 순으로 메인 화면에 반영

> ### RxMoya & 라우터 패턴을 활용한 네트워크 구조화

- RxMoya를 활용하여 네트워크 요청을 RxSwift 기반으로 처리.
- 라우터 패턴을 적용하여 API 요청을 명확하게 정의하고, 네트워크 레이어를 모듈화.


## 트러블슈팅
### 1. 인증 시간
### 문제 원인
사용자에게 인증 번호를 입력받는 화면에서, 3분 타이머가 동작하고 있었고, 시간이 다 되면 자동으로 뒤로 가기가 발생하도록 설계돼 있었습니다.
하지만 문제는, 3분이 되기 전에 인증을 성공했음에도 불구하고 타이머가 계속 흘러가면서, 결국 시간이 다 되자 화면이 강제로 뒤로 이동해버렸습니다!

### 해결과정
처음엔 단순히 인증 버튼을 눌렀을 때 stopTimer()를 호출하면 타이머 스트림이 멈출 거라고 생각했습니다
~~~swift

case .authCheckButtonTap:
    stopTimer()

private func stopTimer() {
    stopTimerSubject.onNext(())
}
~~~

하지만 이 방식은 타이머 스트림이 완전히 종료되는 게 아니라, stopTimerSubject는 여전히 살아있고 타이머의 구독 스트림도 dispose 되지 않았기 때문에 타이머는 계속 돌아가고 있었습니다.

심지어 내가 놓쳤던 건, 타이머가 매번 startTimer()를 호출할 때마다 새로운 Observable을 리턴하고 있었고,
내부적으로 Disposable을 따로 저장하거나 구독을 관리하지 않으니 타이머가 겹겹이 중첩되는 상황도 발생했습니다

그래서 아래처럼 명시적으로 스트림을 종료하도록 onCompleted()까지 호출하고, 제대로 초기화 했습니다.

~~~swift

private func stopTimer() {
    stopTimerSubject.onNext(())
    stopTimerSubject.onCompleted()
}

~~~

~~~swift
private func startTimer() -> Observable<Mutation> {
    guard timerDisposable == nil else { return .empty() }

    let stream = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        .take(totalSeconds + 1)
        .take(until: stopTimerSubject)
        .map { [weak self] elapsedSeconds in
            ...
        }
        .do(onSubscribe: { print("타이머 시작") },
            onDispose: { [weak self] in
                self?.resetTimerState()
            })

    timerDisposable = stream.subscribe()
    return .empty()
}
~~~

### 결과
인증 성공 시 타이머가 즉시 멈추고, 더 이상 시간이 지나도 자동으로 뒤로 가지 않으며, 불필요한 navigateBack 트리거가 발생하지 않게 되었습니다.

--- 

### 2. Coordinator가 해제되지 않던 문제
### 문제 원인
Coordinator 패턴을 적용하면서, 뷰를 닫을 때 popVC() 또는 dismissVC()만 호출하면 화면은 정상적으로 닫히는데,
해당 Coordinator의 deinit이 호출되지 않는 문제가 있었습니다.

원인을 분석해보니 Coordinator의 childCoordinators 배열에서 자식 Coordinator를 직접 제거해주지 않았기 때문이었습니다.

### 해결 과정
Coordinator는 화면을 push하거나 present할 때 자식 Coordinator를 childCoordinators에 추가하고,
나중에 직접 제거해줘야 deinit이 제대로 호출된다고 생각했습니다!
~~~swift
func addChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators.append(coordinator)
}
~~~

하지만 단순히 popVC()만 호출하면 Coordinator의 생명주기엔 영향이 없기 때문에
childCoordinators 배열에 계속 남아 있게 되고, ARC가 메모리를 해제하지 못하게 되는 거죠.

그래서 화면을 닫을 때는 꼭 finish()를 함께 호출해주는 finshView()를 만들고 사용하도록 구조를 정리했습니다.

~~~swift
func finshView() {
    finishAllChildren() // 자식부터 정리
    popVC()             // 화면 닫기
}
~~~

finishAllChildren() 안에서는 모든 자식 Coordinator에 대해 finish()를 호출하고
스스로도 부모 Coordinator에 알려서 childCoordinators에서 제거되도록 처리합니다.
~~~swift
func finishAllChildren() {
    for child in childCoordinators {
        child.finishAllChildren()
    }
    childCoordinators.removeAll()
    finish() // 나도 제거 요청
}
~~~

### 결과
뷰를 닫을 때 finshView()를 사용하니 자식 Coordinator가 parent로부터 제거되고,
deinit이 정상적으로 호출되어 메모리 누수가 발생하지 않게 되었습니다.

## 회고
이번 프로젝트에선 Coordinator + ReactorKit 구조를 도입해 아키텍처는 만족스러웠지만,
UI/UX 디자인이 상대적으로 미흡했던 점이 아쉬웠습니다.
앞으로는 디자인 퀄리티까지 신경 쓰는 방향으로 보완해나갈 예정입니다.





