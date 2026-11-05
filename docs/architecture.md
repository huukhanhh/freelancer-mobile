# Kiến trúc nền tảng

## Quyết định

Feature-first + MVVM. Mỗi feature phát sinh theo module gồm domain/, data/, presentation/views/, presentation/view_models/, presentation/widgets/ nếu cần. Không tạo hàng loạt thư mục rỗng, màn giả hoặc model chưa có thiết kế.

Dependency: View → ViewModel → Repository interface; Mock/API repository → Repository interface. Composition root app/app_dependencies.dart tạo và inject implementation. Domain chứa Dart model/contract; không chứa widget hoặc dependency HTTP.
ChangeNotifier/ListenableBuilder đủ cho phạm vi hiện tại. Chưa cần Riverpod/Bloc/provider/service locator/code generator. go_router sở hữu routing; flutter_svg render SVG local từ Figma. WorklyApp sở hữu và dispose router cùng ViewModel. Không tạo router trong build().

SessionViewModel có idle/loading/ready/failure, session nullable, chống response cũ ghi đè response mới và chống notify sau dispose. Mock trả dữ liệu xác định; chỉ giữ mật khẩu demo tổng hợp trong bộ nhớ, không lưu token hoặc dữ liệu thật. Không diễn giải fixture như xác thực thật. UI auth đã nối với command/validation và session owner chung.

## Routing

App bắt đầu /auth/splash → onboarding/login hoặc home theo session. AuthFlowViewModel phối hợp AuthenticationViewModel và SessionViewModel trên cùng repository. Router refresh theo hai owners, kiểm tra session/role/profile completion cho home/setup. Form chỉ gọi command ViewModel. Các state OTP success/new-password dùng lại view thay vì route trùng.
Hai home theo role có composition/fixtures/carousel; callback tới discovery/tab chưa nối và được ghi partial. /bootstrap/errorBuilder còn là host kỹ thuật trống, phải thay errorBuilder bằng system screen Figma khi tới module; không tính là product UI.

## Theme/assets

Token code hiện chỉ là tập tối thiểu Emerald/Profile/Button có source ID. Full token audit ở docs/figma/tokens.json, không áp một collection lên toàn bộ feature. TextTheme ánh xạ các style Emerald đã đọc. Không tự tạo dark mode.
Plus Jakarta Sans variable TTF đi kèm OFL, từ Google Fonts; FontWeight chọn trục weight trên toolchain hiện tại. Inter và các ảnh/icon còn lại được lấy theo module. Không dùng font qua mạng runtime.
WorklyButton chỉ có 4 style Default đã thấy trong 593:4119. Các shared widget khác tạo khi có consumer thật; không tạo disabled/loading UI chưa được đối chiếu.

## Monorepo và Backend

Flutter giữ ở root; Backend modular monolith nằm trong backend/ với dependencies/config/test/deployment riêng. Chưa chọn framework/database; chưa có runtime BE. Xem backend/README.md và docs/backend/README.md.
Master task FE sau đó nêu hướng Backend dự kiến là Firebase. Đây là hướng adapter cho data layer, chưa phải cấu hình triển khai: chưa kết nối/cài Firebase hoặc sửa backend/ trong task FE.
Thêm API repository, DTO và mapping trong data khi có contract ở docs/api/. Inject client/cấu hình vào composition root. UI dùng model domain và state ViewModel; không truy cập database hoặc provider AI trực tiếp. AI server boundary ở backend/src/modules/ai/, UI theo use case ở lib/features/. Chưa cài dio/http, secure storage, auth provider, payment, KYC hoặc AI SDK.

AuthenticationRepository mở rộng SessionRepository cho signIn/signOut; MockSessionRepository giữ một store in-memory chung cho cả hai contract. AppDependencies inject implementation qua interface; AuthenticationViewModel đã nối command/validation vào login UI. Không tạo store auth thứ hai hoặc dùng Firebase trong view. Các fixture demo và loading/error controls mô tả ở docs/frontend/demo.md. http chỉ có ở dependency transitive của công cụ vector graphics; ứng dụng không dùng HTTP client hay repository API.

AccountSetupRepository mở rộng auth boundary cho register/OTP/resend/Google mock/profile/recovery. MockSessionRepository giữ account/session/profile chung; validation/flow đi qua AuthFlowViewModel, các view chỉ giữ form draft. AppDependencies inject marketplace và account repository; domain không import Flutter widgets/provider SDK. Toàn bộ assets auth/home lấy từ source MCP, dùng flutter_svg cho vector và decoder ảnh local; không HTTP tại runtime. Định nghĩa riêng AuthAction giữ đúng Material variant trong auth thay vì đổi gradient WorklyButton cũ.

DiscoveryViewModel nhận JobRepository.fetchJobs qua composition root, quản lý query/history/saved IDs và filter draft/applied trong bộ nhớ. Loading/retry có generation guard cho response cũ/disposal. Session owner đổi viewer sẽ xóa trạng thái cá nhân; durable saved/history storage còn để adapter tương lai. MockJobRepository cung cấp 24 fixture IDs nhất quán với home. RoleBottomBar dùng chung các root đã có, chỉ nối Home/Find work của Freelancer; không tạo shell giả cho module chưa triển khai. F13/F16 còn partial vì card detail chưa có.
