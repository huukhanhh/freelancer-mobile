# Kiểm tra môi trường — 05/11/2026

| Mục | Kết quả |
|---|---|
| OS | Windows 11 25H2, build 26200.9711 |
| Git | 2.43.0.windows.1; đã có danh tính commit cấu hình |
| Workspace ban đầu | .git trên nhánh master chưa có commit, không remote; nhiều tệp thiết kế untracked; không pubspec.yaml |
| GitHub ban đầu | git ls-remote thành công, không có ref/branch trả về (repository trống) |
| Flutter ban đầu | Không tìm thấy trên PATH/các vị trí đã kiểm tra |
| Flutter hiện tại | SDK cục bộ .tools/flutter, stable 3.47.9, revision c197ca5199 |
| Dart | 3.13.7 đi kèm Flutter |
| Android SDK | C:/Users/ADMIN/AppData/Local/Android/sdk; SDK 36.1.0; platforms 34/35/36 có sẵn |
| Android command-line tools | Thiếu cmdline-tools/sdkmanager |
| License Android | flutter doctor chưa xác định được trạng thái |
| Java | JAVA_HOME trỏ JDK 21; Android Gradle target scaffold Java 17; chưa xác minh Gradle build |
| adb trên PATH | Bản scrcpy ở C:/scrcpy-win64-v3.2/adb.exe; SDK cũng có platform-tools/adb.exe |
| GitHub CLI | gh chưa có trên PATH; Git HTTPS dùng credential manager hiện có |
| Thiết bị | doctor thấy Chrome, Edge, Windows; chưa thấy Android device/emulator đang chạy |
| Visual Studio C++ | Thiếu; chỉ cần nếu sau này nhắm Windows desktop |
| Network | flutter doctor network resources đạt |

Không đổi PATH, JAVA_HOME, ANDROID_HOME, Git global config hoặc cài Android/system tools. Flutter/Dart đặt trong dự án; các cache công cụ có thể được Flutter/Pub tạo tự động. Clone SDK gặp checkout đường dẫn dài trên Windows, đã hoàn tất bằng core.longpaths=true theo từng lệnh chỉ cho .tools/flutter. Bootstrap SDK có retry khóa Dart khi chuẩn bị; lần kiểm tra cuối SDK đã chạy được.
Dự án tạo bằng flutter create --project-name workly --org com.example --platforms android,web --no-pub ., sau khi xác minh không có Flutter project trước đó.

## Cấu hình còn cần người dùng thực hiện

1. Android Studio → SDK Manager → SDK Tools → Android SDK Command-line Tools (latest) → Apply. Đây là thay đổi ngoài dự án, chưa tự thực hiện.
2. Chạy .\\scripts\\flutter.ps1 doctor --android-licenses, đọc và tự chấp thuận điều khoản.
3. Chạy .\\scripts\\flutter.ps1 doctor -v, mở emulator hoặc kết nối Android để kiểm tra flutter devices.
4. Có thể dùng SDK cục bộ qua wrapper; nếu muốn cài SDK ở đường dẫn không có khoảng trắng, làm theo [Flutter install](https://docs.flutter.dev/install/manual). Không bắt buộc sửa PATH để kiểm tra dự án hiện tại.

[Hướng dẫn Android chính thức](https://docs.flutter.dev/platform-integration/android/setup). Chưa xác nhận Android build/launch. Không tự chấp thuận license hoặc cấu hình ký release.
