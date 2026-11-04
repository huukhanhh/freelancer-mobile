# Workly — Flutter frontend

Nền tảng Flutter cho [freelancer-mobile](https://github.com/huukhanhh/freelancer-mobile), từ [Figma page ALL SCREENS • Client & Freelancer](https://www.figma.com/design/LdYars6BFgIu9VdgWeP9dT/FreelancerV1?node-id=579-228).

## Trạng thái

Đã khởi tạo kiến trúc, go_router, theme/token Emerald, shared button, font Plus Jakarta Sans cục bộ, repository abstraction và session mock/ViewModel. **Chưa triển khai màn sản phẩm.**
Ứng dụng mở route kỹ thuật /bootstrap với nền trống có chủ đích để chờ duyệt cấu trúc; đây không phải F01. Flutter launcher icon/web icon hiện là template SDK, phải thay bằng asset Figma đúng nguồn trong module khởi động.
Android applicationId com.example.workly là placeholder phát triển, chưa dùng để phát hành. Chưa có backend, auth thật, thanh toán, camera/KYC hoặc upload thật.

## Công cụ

Toolchain kiểm tra: Flutter 3.47.9 stable / Dart 3.13.7 / Git 2.43.0.windows.1; phiên bản Flutter ở .flutter-version. .tools/flutter là SDK cục bộ, không commit.
Dùng Flutter cùng phiên bản cho cộng tác; .flutter-version là ghi nhận phiên bản, không tự cài SDK.

PowerShell, tại root repository:

```powershell
.\scripts\flutter.ps1 pub get
.\scripts\flutter.ps1 run -d chrome
.\scripts\check.ps1
```

Nếu SDK cục bộ chưa có, cài Flutter theo [hướng dẫn chính thức](https://docs.flutter.dev/install/manual), thêm bin vào PATH theo lựa chọn của bạn; wrapper sẽ tìm flutter trên PATH. Không có script tự sửa PATH/cài công cụ hệ thống.
Android SDK đã có, nhưng cần cài Android SDK Command-line Tools (latest) bằng Android Studio SDK Manager → SDK Tools, sau đó đọc/chấp thuận license bằng flutter doctor --android-licenses và kiểm tra flutter doctor -v. Xem [thiết lập Android](https://docs.flutter.dev/platform-integration/android/setup). Chưa cần Visual Studio C++ cho Android/Web. iOS cần máy macOS/Xcode và chưa được tạo/kiểm tra trong phạm vi Windows này.

## Cấu trúc

```text
lib/
  app/                       composition root, app lifecycle
    router/                  go_router
  core/
    theme/                   tokens có nguồn Figma, light theme
    widgets/                 shared UI đã đối chiếu nguồn
  features/
    foundation/presentation/views/   host trống chờ duyệt
    session/
      domain/                UserSession, UserRole, SessionRepository
      data/                  MockSessionRepository
      presentation/view_models/     SessionViewModel
assets/fonts/                font variable và OFL license
test/                        bootstrap integration và session lifecycle
docs/figma/                  inventory, token, styles, navigation evidence
scripts/                     Flutter wrapper và quality gate
android/, web/               platform scaffold
```

Views nghe ViewModel bằng ListenableBuilder. ViewModel gọi repository interface; AppDependencies.mock() nối mock implementation. Khi có backend, thêm implementation/DTO mapping trong data và thay ở composition root; không đổi view để gọi HTTP trực tiếp.
Mock mặc định anonymous; fixtures Client/Freelancer có ID mock-client-001/mock-freelancer-001. State kỹ thuật idle/loading/ready/failure đã có, UI tương ứng chờ nguồn thiết kế.
go_router là package runtime bổ sung duy nhất; state management dùng Flutter SDK. pubspec.lock phải commit cho ứng dụng. [Tài liệu go_router](https://pub.dev/packages/go_router).

## Tài liệu và Git

- [Design handoff](docs/design-handoff.md)
- [Kiến trúc](docs/architecture.md)
- [Kế hoạch module, branch và nghiệm thu](docs/implementation-plan.md)
- [Môi trường](docs/environment-report.md)
- [Kết quả kiểm tra](docs/verification.md)
- [Quy tắc agent](AGENTS.md)

main/develop là baseline khởi tạo, không tự merge foundation vào main. Thực hiện module theo branch riêng sau khi duyệt foundation. Các tệp Figma có sẵn ở root được giữ nguyên và không đưa vào commit ứng dụng. Không dùng git add . ở workspace này.
