# CollaTalk - 협업 소통 앱

<p>
    <img src="https://github.com/user-attachments/assets/bebf7eb2-75bb-4b6a-b04d-1778ca03a28a" align="center" width="100%"/>
</p>

<br/>

## CollaTalk

- 서비스 소개: 협업 소통 앱
- 개발 인원: 1인
- 개발 기간: 24.07.05 ~ 24.08.07(총 한달)
- 개발 환경
  - 최소버전: iOS 16
  - Portrait Orientation 지원
  - 라이트 모드 지원
- 사용 협업 툴
  - Jira, Swagger, Figma

<br/>

## 💪 주요 기능

- 회원 인증
  - 회원 가입
  - 로그인 / 소셜 로그인(카카오 / 애플)
  - 로그아웃
- 워크스페이스 기능
  - 워크스페이스 생성 / 조회 / 편집 / 삭제
  - 워크스페이스 관리자 변경
  - 워크스페이스 퇴장
  - 멤버 초대
- 채널 기능
  - 채널 생성 / 조회 / 탐색 / 편집 / 삭제
  - 채널 관리자 변경
  - 채널 퇴장
  - 채널 채팅 생성
- DM 기능
  - 채팅 생성
  - 실시간 채팅 응답
- 프로필 조회 / 편집
- 코인 결제 기능

<br/>

## 📱 동작 화면

|회원가입|로그인|로그아웃|소셜로그인 - 애플|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/021145fe-7d20-4c43-be6c-9d9471b54432" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/69772077-6ad2-4b4a-a4c8-618621acac26" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/97aef174-874e-4eba-bb67-720a6de08015" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/7d33b077-6a4e-4a26-80b0-b602ac8734d8" width="200" height="390"/>|

|워크스페이스 생성|워크스페이스 편집|워크스페이스 관리자 변경|워크스페이스 삭제|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/522e1466-5ed5-45e3-a3f3-8846995b0eb1" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/25738d71-e443-4a29-bacd-6475dac925be" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/2c280bd3-49af-48c3-abc0-859af9875d49" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/0cfc70ac-0f8f-4c34-b4eb-94d8cc97c301" width="200" height="390"/>|

|워크스페이스 퇴장|멤버 초대|
|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/c5852479-1fc8-4570-8f96-96f7d1681e35" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/56d87f2a-7a50-43c5-8c48-38c0a4f4f9be" width="200" height="390"/>|

|채널 생성|채널 편집|채널 관리자 변경|채널 삭제|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/e118f1fe-b384-4b4a-8a62-fedbf6a71cdb" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/8e3bcdb1-d093-4534-b1db-b230f9db0f12" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/e7c8729d-cb2a-486d-a5bb-d1899b1995b1" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/f6bba4e0-7a8e-49bc-8d80-2ed1a23ec30f" width="200" height="390"/>|

|채널 퇴장|채널 탐색 + 채널 채팅 입장|
|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/dcf66363-54b4-4dd2-b68f-2343ea59ad88" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/a8d93dd4-679b-4511-9478-8fb275245a7a" width="200" height="390"/>|

|DM 채팅 생성|DM 실시간 채팅|
|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/89ea334e-b1ae-4ebd-9cfc-763b03c67a5f" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/4b44da86-efd3-4720-af30-81c675785c06" width="400" height="390"/>|

|프로필 수정|코인 결제|
|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/68373f3f-2182-4ae2-874f-8addb1445ec5" width="200" height="390"/>|<img src="https://github.com/user-attachments/assets/eca668f4-c16c-4238-b142-2796b8db81b4" width="200" height="390"/>|

<br/>

## 🛠 기술 소개

- SwiftUI, Swift Concurrency, Combine
- Redux Pattern, Router / Coordinator Pattern, Repository Pattern
- Moya, LocalizedError, NSCache
- Realm, IAMPort, SocketIO, UserDefaults
- KakaoOpenSDK(Kakao Login) / AuthenticationServices(Apple Login)

<br/>

## 💻 기술 적용

- **Redux** 패턴을 통해 중앙 집중화된 상태 관리와 예측 가능한 단방향 데이터 흐름으로 확장성과 유지 보수성을 확보
- **NSCache**를 활용하여 메모리 효율적인 이미지 데이터 캐싱과 불필요한 이미지 데이터 재 다운로드 방지
- **LocalizedError** 프로토콜 준수를 통한 직관적이고 현지화된 네트워크 오류 메시지 제공
- **Coordinator** 패턴을 활용한 소셜 로그인 구현으로 책임 분리
- **Realm**을 활용한 채팅 내역 저장 DB 구현
- 여러 결제 대행사(PG) 및 간편결제 로직을 WebView 기반으로 구현하여 **결제 기능** 도입
- Navigation Stack을 **Router**로 구현하여 화면 전환 관리
- **Moya**의 **Router** 패턴 구현으로 네트워크 통신 모듈화
- **PluginType** 프로토콜 준수하는 Plugin 구성으로 네트워크 Logging 구현
- Realm의 **Repository** 패턴 구성으로 데이터 접근 로직 추상화

<br/>

## ⚙️ 아키텍처

<img src="https://github.com/user-attachments/assets/203197fe-2719-4afc-9277-905cd1952a38" align="image" width="100%"/>

<br/>

## 💾 Realm DB 구조

<img src="https://github.com/user-attachments/assets/bbb4d58c-0958-4222-ae0a-4c3124f2c5a2" align="image" width="100%"/>

<br/>

## 🔥 트러블 슈팅

### 1. 이미지 다운로드 시, 토큰 만료 추적을 위한 갱신 로직 직접 구현

문제상황

- Kingfisher로 이미지로 다운로드 시, Header에 토큰 추가는 가능하나 토큰 갱신 로직 추가는 Kingfisher 라이브러리 구조상 추가하기 불편함을 느낌

- 이에 이미지 다운로드 로직을 직접 구현함

<br/>

해결방법

- 방법1: 토큰 갱신하는 모듈을 따로 두어 관리

  - 이렇게 독립적인 모듈로서 관리된다면 유지보수 관점에서 상당히 큰 이점을 누릴 수 있지만 개인적인으로 생각했을 때 타이머를 이용해 **Background에서 주기적으로 토큰 만료를 모니터링하여 불필요한 자원이 낭비**되고, 또, 토큰 갱신 요청 시점이 API 요청 시점에 종속적이지 않아 **정확한 시점에 토큰이 갱신되지 않을 것** 같아 해당 방법은 배제

- 방법2: 다른 API 요청 시 토큰 만료 추적 및 갱신 로직과 통합 구현

  - 이렇게 구현하면 **방법1**에서 언급되었던 **자원 낭비 문제**와 **부정확한 토큰 갱신 시점 문제**를 해결 가능

    - **자원 낭비 문제 해결**: 타이머를 이용해 항시 토큰 만료 여부를 모니터링하지 않아도 됨
    - **부정확한 토큰 갱신 시점 문제 해결**: **API 요청 -> 토큰 만료 여부 확인** 순으로 네트워크 요청이 이루어지기 때문에 정확한 시점에 토큰 갱신이 가능

  <br/>

  <details>
  <summary><b>토큰 갱신 코드</b></summary>
  <div markdown="1">

  ```swift
  func performRequest<DecodedType: Decodable, ErrorType: RawRepresentable & Error>(
      _ target: Target,
      errorType: ErrorType.Type,
      retryCount: Int = 3,
      decodingHandler: (Data) throws -> DecodedType?
  ) async throws -> DecodedType? where ErrorType.RawValue == String {
      do {
          let response = try await request(target)
          switch response.statusCode {
          case 200:
              return try decodingHandler(response.data)
          case 400...500:
              let errorCode = try decode(response.data, as: ErrorCode.self)
              if let commonError = CommonError(rawValue: errorCode.errorCode) {
                  /// 토큰 갱신 로직 - 재귀문을 통해 최대 3번까지 토큰 갱신 요청
                  if commonError == CommonError.expiredAccessToken {
                      if retryCount > 0 {
                          try await RefreshTokenProvider.shared.refreshToken()
                          
                          return try await performRequest(target, errorType: errorType, retryCount: retryCount - 1, decodingHandler: decodingHandler)
                      }
                  } else {
                      throw commonError
                  }
              } else if let specifiicError = ErrorType(rawValue: errorCode.errorCode) {
                  /// Refresh 토큰 만료 로직 - Refresh 토큰 만료 시 유저를 사용자를 로그인 화면으로 유도
                  if let specifiicError = specifiicError as? RefreshTokenError,
                      specifiicError == RefreshTokenError.expiredRefreshToken {
                      
                      UserDefaultsManager.removeObject(forKey: .userInfo)
                      UserDefaultsManager.removeObject(forKey: .selectedWorkspace)
                      
                      NotificationCenter.default.post(name: .gobackToRootView, object: nil, userInfo: [NotificationNameKey.gobackToRootView: true])
                  } else {
                      throw specifiicError
                  }
              }
          default: break
          }
      } catch {
          throw error
      }
      return nil
  } 
  ```

  </div>
  </details>


<br/>

### 2. window 계층을 활용한 토스트 메시지 구현

문제상황

- 토스트 메세지 구현 시 sheet로 새로운 뷰를 띄우거나 화면 전환 시 토스트 메세지가 가려짐

<br/>

문제 원인 파악

- 일정한 뷰 계층에서만 토스트 메세지가 해당 해당 뷰에만 종속되어 문제 발생

<br/>

해결방법

- Alert창처럼 새로운 상위 계층의 window를 생성하여 어느 화면이던 토스트 메세지 창이 일정하게 표시되도록 구현

  <details>
    <summary><b>코드</b></summary>
    <div markdown="1">

  ```swift
  final class WindowProvider: ObservableObject {

      private var toastMessageWindow: UIWindow?

      /// 토스트 메세지 표시 함수
      func showToast(message: String, duration: Double = 2.5) {
          if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
              toastMessageWindow = UIWindow(windowScene: scene)
              toastMessageWindow?.windowLevel = .statusBar
          }

          guard let toastMessageWindow = toastMessageWindow else { return }

          /// 토스트 메세지 window 생성
          let hostingController = UIHostingController(rootView: ToastView(message: message))
          hostingController.view.backgroundColor = .clear

          toastMessageWindow.rootViewController = hostingController
          toastMessageWindow.makeKeyAndVisible()

          /// 토스트 메세지 크기에 따른 window 크기 동적 변화
          let targetSize = hostingController.sizeThatFits(
              in: CGSize(
                  width: UIScreen.main.bounds.width - 40,
                  height: CGFloat.greatestFiniteMagnitude
              )
          )

          toastMessageWindow.frame = CGRect(
              x: (UIScreen.main.bounds.width - targetSize.width) / 2,
              y: UIScreen.main.bounds.height - targetSize.height - 80,
              width: targetSize.width,
              height: targetSize.height
          )

          DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
              guard let self else { return }
              dismissToast()
          }
      }

      /// 토스트 메세지 닫는 함수
      private func dismissToast() {
          toastMessageWindow?.isHidden = true
          toastMessageWindow = nil
      }
  }
  ```

    </div>

  </details>

   <details>
  <summary><b>해결화면</b></summary>
  <div markdown="1">

  <img src="https://github.com/user-attachments/assets/88a8aafa-68ee-401b-9278-6336a357c3ef" align="center" width="300"/>

  </div>
  </details>

<br/>

### 3. SwiftUI 버전 대응 - onChange, cornerRadius Modifier

문제상황

- 프로젝트 타켓 최소 버전 iOS16 구성으로 onChange Modifier와 cornerRadius Modifier의 사용이 불편

  - iOS17 기준으로 onChange Modifier의 파라미터가 다름

    ```swift
    // iOS17이상
    func onChange<V>(
      of value: V,
      initial: Bool = false,
      _ action: @escaping (V, V) -> Void
    ) -> some View where V : Equatable

    // iOS17이하
    func onChange<V>(
      of value: V,
      perform action: @escaping (V) -> Void
    ) -> some View where V : Equatable
    ```

  <br/>

  - cornerRadius Modifier는 iOS18부터 deprecated 됨

  <br/>

문제 원인 파악

- 각 버전에 맞는 onChange Modifier와 cornerRadius Modifier의 재구성 필요

<br/>

해결방법

- onChange Modifier 버전별 대응

  <details>
    <summary><b>코드</b></summary>
    <div markdown="1">

  ```swift
  struct OnChangeModifier<Value: Equatable>: ViewModifier {

    let value: Value
    let action: (Value) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            // iOS17이상 대응
            content
                .onChange(of: value) { _, newValue in
                    action(newValue)
                }
        } else {
            // iOS17이하 대응
            content
                .onChange(of: value, perform: { newValue in
                    action(newValue)
                })
        }
    }
  }

  extension View {
      func onChange<Value: Equatable>(
          of value: Value,
          action: @escaping (Value) -> Void
      ) -> some View {
          modifier(OnChangeModifier(value: value, action: action))
      }
  }
  ```

  </div>
  </details>

- 모든 버전 대응 가능한 cornerRadius Modifier 구현

  <details>
    <summary><b>코드</b></summary>
    <div markdown="1">

  ```swift
  struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        return Path(path.cgPath)
    }
  }

  extension View {
      func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
          clipShape(RoundedCorner(radius: radius, corners: corners))
      }
  }
  ```

  </div>
  </details>
