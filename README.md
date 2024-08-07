# CollaTalk - 협업 소통 앱(개발 진행중)

<p>
    <img src="https://github.com/user-attachments/assets/bebf7eb2-75bb-4b6a-b04d-1778ca03a28a" align="center" width="100%"/>
</p>

<br/>

## CollaTalk

- 서비스 소개: 협업 소통 앱
- 개발 인원: 1인
- 개발 기간: 24.07.05 ~ **(진행중)**
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

<img src="https://github.com/user-attachments/assets/8c17a6f0-39e8-4800-bcba-18453884d6a5" align="image" width="100%"/>

<br/>

<br/>

## 🔥 트러블 슈팅

### 1. window 계층을 활용한 토스트 메시지 구현

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

<br/>

### 2. SwiftUI 버전 대응 - onChange, cornerRadius Modifier

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
