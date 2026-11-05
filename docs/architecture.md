# Kiến trúc nền tảng

## Quyết định

Feature-first + MVVM. Mỗi feature phát sinh theo module gồm domain/, data/, presentation/views/, presentation/view_models/, presentation/widgets/ nếu cần. Không tạo hàng loạt thư mục rỗng, màn giả hoặc model chưa có thiết kế.

Dependency: View → ViewModel → Repository interface; Mock/API repository → Repository interface. Composition root app/app_dependencies.dart tạo và inject implementation. Domain chứa Dart model/contract; không chứa widget hoặc dependency HTTP.
ChangeNotifier/ListenableBuilder đủ cho phạm vi hiện tại. Chưa cần Riverpod/Bloc/provider/service locator/code generator. go_router là runtime package bổ sung duy nhất, sở hữu bởi WorklyApp và dispose cùng ViewModel. Không tạo router trong build().

SessionViewModel có idle/loading/ready/failure, session nullable, chống response cũ ghi đè response mới và chống notify sau dispose. Mock trả dữ liệu xác định, không lưu token/password. Không diễn giải fixture như xác thực thật. Retry đang ở cấp ViewModel, chưa có UI mới.

## Routing

Chỉ có / → /bootstrap và /bootstrap; host này nền trống, không thay thế F01. errorBuilder cũng nền trống tạm thời, phải thay bằng system screen đúng Figma khi module đó được phê duyệt. Chưa có role/auth guard vì chưa có product destination.
Giai đoạn 5 thêm route theo feature (ví dụ /contracts/:contractId/milestones/:milestoneId) sau khi xác minh design, không dựa riêng Fxx. Với tab bar, dùng StatefulShellRoute/indexedStack và hai cấu hình tab đã xác minh trong handoff. Các ví dụ URL là convention kỹ thuật đề xuất, chưa phải flow đã triển khai.

## Theme/assets

Token code hiện chỉ là tập tối thiểu Emerald/Profile/Button có source ID. Full token audit ở docs/figma/tokens.json, không áp một collection lên toàn bộ feature. TextTheme ánh xạ các style Emerald đã đọc. Không tự tạo dark mode.
Plus Jakarta Sans variable TTF đi kèm OFL, từ Google Fonts; FontWeight chọn trục weight trên toolchain hiện tại. Inter và các ảnh/icon còn lại được lấy theo module. Không dùng font qua mạng runtime.
WorklyButton chỉ có 4 style Default đã thấy trong 593:4119. Các shared widget khác tạo khi có consumer thật; không tạo disabled/loading UI chưa được đối chiếu.

## Monorepo và Backend

Flutter giữ ở root; Backend modular monolith nằm trong backend/ với dependencies/config/test/deployment riêng. Chưa chọn framework/database; chưa có runtime BE. Xem backend/README.md và docs/backend/README.md.
Master task FE sau đó nêu hướng Backend dự kiến là Firebase. Đây là hướng adapter cho data layer, chưa phải cấu hình triển khai: chưa kết nối/cài Firebase hoặc sửa backend/ trong task FE.
Thêm API repository, DTO và mapping trong data khi có contract ở docs/api/. Inject client/cấu hình vào composition root. UI dùng model domain và state ViewModel; không truy cập database hoặc provider AI trực tiếp. AI server boundary ở backend/src/modules/ai/, UI theo use case ở lib/features/. Chưa cài dio/http, secure storage, auth provider, payment, KYC hoặc AI SDK.

AuthenticationRepository mở rộng SessionRepository cho signIn/signOut; MockSessionRepository giữ một store in-memory chung cho cả hai contract. AppDependencies inject implementation qua interface; AuthenticationViewModel cung cấp command/validation trước khi nối login UI. Không tạo một store auth thứ hai hoặc dùng Firebase trong view. Các fixture demo và loading/error controls mô tả ở docs/frontend/demo.md.
