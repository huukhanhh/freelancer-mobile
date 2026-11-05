# Workly — Flutter + Backend monorepo

Monorepo [freelancer-mobile](https://github.com/huukhanhh/freelancer-mobile): Flutter ở root, Backend trong backend/, API contract dùng chung ở docs/api/. Nguồn UI: [Figma page ALL SCREENS • Client & Freelancer](https://www.figma.com/design/LdYars6BFgIu9VdgWeP9dT/FreelancerV1?node-id=579-228).

## Trạng thái

Đã triển khai nhóm 13 frame khởi động/xác thực theo Figma: onboarding, đăng ký/OTP, đăng nhập, Google mock, chọn vai trò, hồ sơ Client/Freelancer và khôi phục mật khẩu. App mở /auth/splash. Hai trang chủ đã có UI/assets/fixtures/carousel; search/filter/listing và các tab nghiệp vụ còn chờ module tương ứng. **FE chưa hoàn thiện: 13 frame đã nối, 2 partial, 128 chưa triển khai.**
Xem [tiến độ](docs/frontend/progress.md), [hướng dẫn demo](docs/frontend/demo.md), [auth handoff](docs/frontend/auth-handoff.md) và [kiểm tra](docs/verification.md). Launcher/web icon vẫn là template SDK; /bootstrap chỉ còn là route kỹ thuật phụ.
Android applicationId com.example.workly là placeholder phát triển, chưa dùng để phát hành. Backend hiện có khung thư mục/tài liệu, chưa có runtime, database hoặc API. Chưa có auth thật, thanh toán, camera/KYC hoặc upload thật.

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
    auth/                      onboarding, forms, role/profile setup, recovery
    home/                      role home UI và marketplace fixtures (partial)
    foundation/presentation/views/   host kỹ thuật phụ
    session/
      domain/                UserSession, UserRole, SessionRepository
      data/                  MockSessionRepository
      presentation/view_models/     SessionViewModel
assets/fonts/                font variable và OFL license
assets/auth/, assets/home/   ảnh/SVG Figma local; provenance trong docs/frontend/assets.json
test/                        auth flows, role guards, forms/layout và session lifecycle
docs/figma/                  inventory, token, styles, navigation evidence
scripts/                     Flutter wrapper và quality gate
android/, web/               platform scaffold
backend/                    Backend độc lập; chưa chọn framework/database
  src/modules/ai/           ranh giới AI phía server, chưa tích hợp provider
  src/common/               tiện ích kỹ thuật BE
  src/config/               cấu hình BE
  src/database/             hạ tầng lưu trữ BE
  migrations/, tests/       quy tắc migration/test khi có runtime
docs/frontend/              mục lục tài liệu FE hiện có
docs/backend/               tài liệu Backend
docs/api/                   API contract dùng chung, chưa có endpoint
.github/workflows/          CI Flutter; CI BE thêm khi có runtime
```

Views nghe ViewModel bằng ListenableBuilder. ViewModel gọi repository interface; AppDependencies.mock() nối mock implementation. Khi có backend, thêm implementation/DTO mapping trong data và thay ở composition root; không đổi view để gọi HTTP trực tiếp.
Mock mặc định anonymous; fixtures Client/Freelancer có ID mock-client-001/mock-freelancer-001. State kỹ thuật idle/loading/ready/failure đã có, UI tương ứng chờ nguồn thiết kế.
Nhóm auth đã nối UI, navigation và mock trên cùng repository; tài khoản/cách thử trong docs/frontend/demo.md. Android debug APK build đạt; trạng thái emulator/điện thoại và các cảnh báo SDK được ghi riêng trong docs/verification.md.
go_router quản lý routing; flutter_svg render SVG Figma local; state management dùng Flutter SDK. pubspec.lock được commit cho ứng dụng. [Tài liệu go_router](https://pub.dev/packages/go_router).

## Backend và AI

[Backend README](backend/README.md) mô tả modular monolith và module map. Dependencies, lockfile, cấu hình và lệnh chạy BE đặt trong backend/ sau khi chọn stack; không dùng chung pubspec.yaml với Flutter. Hiện không có lệnh start/test BE vì chưa có runtime.
FE gọi Backend API theo [contract](docs/api/README.md); Backend truy cập database và gọi provider AI. Giao diện AI nằm trong lib/features/ theo use case, provider/key/logic phía server nằm trong backend/src/modules/ai/. Chưa triển khai AI hoặc tự tạo API giả.

## Tài liệu và Git

- [Design handoff](docs/design-handoff.md)
- [Kiến trúc](docs/architecture.md)
- [Kế hoạch module, branch và nghiệm thu](docs/implementation-plan.md)
- [Môi trường](docs/environment-report.md)
- [Kết quả kiểm tra](docs/verification.md)
- [Quy tắc agent](AGENTS.md)
- [Tài liệu FE](docs/frontend/README.md), [BE](docs/backend/README.md), [API](docs/api/README.md)
- [Tiến độ master task FE](docs/frontend/progress.md), [inventory 143 màn](docs/frontend/screen-inventory.md), [tài khoản demo](docs/frontend/demo.md)
- [Quy trình PR và tự merge sau kiểm tra](docs/git-workflow.md)

Master task FE mới: tiếp tục commit/push trực tiếp develop sau kiểm tra, không tạo PR từng màn và không merge main. Quy trình PR trước đó được lưu trong docs/git-workflow.md nhưng không áp vào task FE hiện tại. Lịch sử phản ánh thay đổi thật, không tạo commit rỗng/PR giả để tăng số lượng. Các tệp Figma có sẵn ở root được giữ nguyên và không đưa vào commit ứng dụng. Không dùng git add . ở workspace này.
