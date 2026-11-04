# Design handoff — Workly

Ngày kiểm kê: 05/11/2026 (Asia/Bangkok). Nguồn duy nhất: [ALL SCREENS • Client & Freelancer](https://www.figma.com/design/LdYars6BFgIu9VdgWeP9dT/FreelancerV1?node-id=579-228), page `579:228`. Figma MCP chỉ đọc; không sửa thiết kế.

## Phạm vi đã xác minh

143 frame sản phẩm đang hiển thị, 1 frame archive ẩn và 3 frame prototype, tổng 147 frame được kiểm kê. Kích thước frame tham chiếu 390 × 844. Đây là mốc đối chiếu, không khóa toàn bộ layout Flutter.
Không dùng các page Design System, A–K hoặc Low Frame làm nguồn triển khai. Chỉ đọc định nghĩa token/text style được tham chiếu trực tiếp từ page nguồn; không duyệt nội dung page nháp.

| Nhóm | Màn hiển thị | Section ID |
|---|---:|---|
| 01 · KHỞI ĐỘNG & XÁC THỰC  | 13 | `610:3556` |
| 02 · TRANG CHỦ & KHÁM PHÁ  | 12 | `612:3560` |
| 03 · HỒ SƠ & PORTFOLIO  | 10 | `612:3565` |
| 04 · ĐĂNG & QUẢN LÝ DỰ ÁN  | 10 | `612:3570` |
| 05 · PROPOSAL — LUỒNG CHÍNH  | 10 | `612:3575` |
| 06 · QUẢN LÝ & TRAO ĐỔI ĐỀ XUẤT  | 13 | `612:3580` |
| 07 · HỢP ĐỒNG & MILESTONE  | 18 | `612:3585` |
| 08 · VÍ, KÝ QUỸ & THANH TOÁN  | 12 | `612:3590` |
| 09 · RÚT TIỀN, KYC & CHỨNG TỪ  | 16 | `612:3595` |
| 10 · BÀN GIAO & PHÊ DUYỆT  | 11 | `612:3600` |
| 11 · TIN NHẮN & THÔNG BÁO  | 7 | `612:3605` |
| 12 · HOÀN THÀNH & ĐÁNH GIÁ  | 6 | `612:3610` |
| 13 · CÀI ĐẶT, HỖ TRỢ & HỆ THỐNG  | 5 | `612:3615` |

[screen-inventory.json](figma/screen-inventory.json) có node ID chính xác. Nhãn F69–F81 bị lặp giữa ví/rút tiền/bàn giao/chat: route và model phải dùng feature cùng node ID, không dùng riêng Fxx.
`585:7721` (Archive / F45 - So sánh Proposal) đang ẩn, chưa thuộc backlog. Section 05 có 11 frame kể cả archive, 10 màn hiển thị.
Header prototype còn nhãn “141”; kiểm kê thực tế là 143 màn sản phẩm.

## Components và tokens

Có 112 component/component set trong section 14, gồm 19 component set; nhãn “15 COMPONENT SETS” trên canvas đã cũ. Xem [component-inventory.json](figma/component-inventory.json) và [component-details.json](figma/component-details.json).

Ưu tiên dùng lại button Primary/Warm/Secondary/Dark, category chip Default/Selected, integrated header Context/Title/Back only, bottom navigation theo vai trò, profile identity/company affiliation, portfolio card, creation stepper, attachment row, proposal summary/confirmation, milestone Planned/Active/Complete, message bubble/thread/notification, review selector và settings row.
Bottom bar Freelancer: Home, Discover, Work, Messages, Profile. Client: Home, Projects, Talent, Messages, Profile.

[tokens.json](figma/tokens.json) là visual token resolve trong ngữ cảnh `585:4320` trên page nguồn, không bao gồm tất cả mode. [variable-inventory.json](figma/variable-inventory.json) có 364 biến nội bộ được tham chiếu; ID library remote ghi trong screen inventory nhưng chưa resolve. Chưa đánh giá mọi mode/theme; không suy diễn dark theme từ nút Dark.
Các bộ token cùng tên có giá trị khác theo collection; không gộp theo tên đơn thuần.

Emerald: background #F4FBF8, surface #FFFFFF, subtle #ECFDF5, primary #10B981, primary dark #047857, text #0F1F1A, text secondary #5B6B65. Profile border #DCEBE3; inset 16, gap 12, page padding 20, radius 20. Button cao 52, radius 18, font 15 Bold; gradient Primary #10B981 → #14B8A6, Warm #FF8A4C → #FBBF24, Dark #064E3B → #059669.
Typography chủ đạo Plus Jakarta Sans, 9 text node Inter cần xử lý riêng khi tới module. [typography.json](figma/typography.json) lưu 15 text styles. Display 32/700, headings 25/21/18/700, body 14/400, label 13/500, caption 11/400; line height 140%. Navigation label 11/16, title 16/24.

## Prototype và state

5 điểm khởi đầu: PROTO-START `923:7164`, đăng ký `584:259`, Client `585:4563`, Freelancer `585:4476`, mục lục `923:7180`.
[prototype-navigation.json](figma/prototype-navigation.json) tổng hợp 935 liên kết đích khác nhau từ 1462 node có reaction trong screen/prototype, gồm nhánh điều kiện. Action: NODE, CONDITIONAL, SET_VARIABLE, BACK, CLOSE; trigger: click/hover/press/timeout.
Đồ thị giữ source/target, navigation, trigger và số lần; **không giữ biểu thức điều kiện, thứ tự action, giá trị set variable, duration/easing hoặc thời gian timeout**. Trước khi triển khai flow phải đọc hotspot/reactions gốc của module. Chưa chạy thử toàn bộ prototype trong Presentation mode.

Luồng quan sát để chia backlog: khởi động phân nhánh onboarding/đăng nhập/home theo state; chọn vai trò dẫn tới hồ sơ tương ứng; Client tạo dự án → proposal/offer → contract/milestone → escrow → duyệt bàn giao → hoàn tất/đánh giá; Freelancer khám phá/ứng tuyển → nhận offer → contract → bàn giao/chỉnh sửa → nhận tiền/rút tiền. Không thay thế guard và state machine từng hotspot bằng mô tả này.

State đã có qua frame/variant/biến: role/consent, OTP/resend/recovery, Client độc lập/liên kết công ty, company required error, rỗng/kết quả tìm kiếm, proposal draft/sent/withdrawn, offer over budget/declined/expired, milestone planned/active/complete, xử lý/thành công/thiếu số dư, ngân hàng có dữ liệu/form trống, KYC 5 bước, bàn giao chờ duyệt/chỉnh sửa/chờ giải ngân, chat/tệp/thông báo, rating và lỗi kết nối.

Hai đích NAVIGATE `505:3489`, `494:2934` ngoài inventory screen được phê duyệt. Không truy cập page khác để triển khai thay thế; kiểm tra hotspot nguồn và xác nhận ý nghĩa khi tới module. CHANGE_TO ngoài inventory thường là variant master/library, không phải màn mới. Không đưa màn admin/tranh chấp từ page nháp vào phạm vi; chỉ support/khiếu nại đã có trên page nguồn.

## Asset và nghiệm thu

Chưa triển khai screen hoặc xuất hàng loạt ảnh/logo. Button đã đọc bằng get_design_context kèm screenshot, không có static image asset. Font phải đóng gói cục bộ kèm license. Ảnh avatar, portfolio, logo thanh toán, illustration, icon và Inter chỉ lấy đúng node/asset khi thực hiện module; không tự lấy tệp thiết kế cũ trong workspace làm nguồn.
Không dùng Figma screenshot làm ảnh nền screen; không dùng URL asset tạm thời trong runtime.

Mỗi batch: đọc get_design_context đầy đủ cùng screenshot; đọc guard/biến/reaction; map token đúng collection; triển khai layout co giãn/SafeArea; đối chiếu 390 × 844 và thiết bị hẹp, tiếng Việt/keyboard/back/scroll; kiểm tra state/vai trò; format/analyze/test; rồi mới commit/push.
Loading/error kỹ thuật có thể cần khi tích hợp sau; không tự vẽ thêm UI nếu chưa có thiết kế.
