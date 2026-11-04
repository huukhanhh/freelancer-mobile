# Giai đoạn 5 — Kế hoạch frontend

Trạng thái: người dùng đã duyệt cấu trúc monorepo (Flutter root + backend/). Cập nhật hiện tại chỉ tổ chức thư mục/tài liệu/CI; chưa bắt đầu batch màn hình.
Màn chuẩn: docs/figma/screen-inventory.json, page 579:228; 143 màn sản phẩm hiển thị. Từng module chia batch nhỏ theo flow, mặc định 2–4 màn liên quan; đọc lại thiết kế trực tiếp trước mỗi batch.

## Branch và phụ thuộc

Các branch module dưới đây là kế hoạch; chỉ tạo khi bắt đầu module từ develop hiện tại. Foundation đã được đưa vào main qua PR #1 và develop đã đồng bộ fast-forward. Người dùng cho phép tự tạo/merge PR sau khi các kiểm tra đạt, theo work branch -> develop -> main; không cần chờ accept thủ công. Không tạo lịch sử hoạt động giả.

| Thứ tự | Module / section | Branch riêng | Phụ thuộc | Tiêu chí nghiệm thu riêng |
|---|---|---|---|---|
| 0 | Foundation/shared | codex/chore/flutter-foundation | MCP/env | structure, token, router, mock, format/analyze/test đạt |
| 1 | Auth/onboarding (01) | codex/feat/auth-onboarding | 0 | F01–F10, F02b/c, F05C; role/consent/OTP/recovery, back và điều kiện từ hotspot; mock không auth thật |
| 2 | Home/discovery (02) | codex/feat/discovery | 1 | 2 home/tab theo role, search/filter/saved/empty, B08/B09 và chi tiết đúng flow |
| 3 | Profile/portfolio (03) | codex/feat/profile-portfolio | 1, 2 navigation | Freelancer edit/preview, skills/portfolio; Client independent/linked và company form required state |
| 4 | Client projects (04) | codex/feat/client-projects | 2, 3 | wizard/draft/attachments/preview/success; vai trò tuyển và contracts theo project |
| 5 | Proposal (05) | codex/feat/proposals | 2, 3, 4 | chọn vị trí, thư/giá/thời gian/preview, sent/received/detail/decision; loại Archive F45 |
| 6 | Offer/invitation (06) | codex/feat/offers | 5 | sửa/rút/mời/offer/negotiation/filter/quick profile; state over budget/pending/declined/expired theo nguồn |
| 7 | Contracts/milestones (07) | codex/feat/contracts-milestones | 5, 6 | tạo contract, phân bổ ngân sách, branch tuyển theo vai trò, milestone/progress, ownership Client/Freelancer |
| 8 | Wallet/escrow (08) | codex/feat/wallet-escrow | 7 | top-up mock, phương thức, processing/success/insufficient, escrow/history/detail; không payment thật |
| 9 | Delivery/approval (10) | codex/feat/delivery-approval | 7, 8 | upload mock/preview/submit, Client approve/revision, Freelancer resubmit/chờ giải ngân; state đồng bộ contract |
| 10 | Withdrawal/KYC/receipt (09) | codex/feat/withdrawal-kyc | 8, 9 | bank empty/data, withdrawal verify/process, KYC 5 bước mock, phí/receipt/refund; không PII thật |
| 11 | Messaging/notifications (11) | codex/feat/messaging | 5, 7, 9 | cá nhân/nhóm project, file/member/milestone panel, notification destination/return, dữ liệu mock |
| 12 | Completion/reviews (12) | codex/feat/completion-reviews | 7, 8, 9 | milestone complete, contract close, cả hai role rating, review detail, state nhất quán |
| 13 | Settings/support/system (13) | codex/feat/settings-support | 1, 3 | account/security, personal/password mock, help/complaint/connection error; không admin từ page nháp |

Messaging primitives có thể được làm sớm khi proposal cần consumer, nhưng vẫn nằm trong branch module riêng và scope nhỏ; thứ tự trên là thứ tự tích hợp đề xuất. System error có thể đưa thành batch đầu module 13 khi cần xử lý lỗi, phải có thiết kế thật.

## Gate chung cho từng batch/module

1. Ghi node ID, role, reusable component, token collection, asset và trạng thái vào handoff module.
2. Đọc get_design_context + screenshot và reaction/variable/guard gốc. Xử lý hai đích ngoài page đã nêu trong handoff khi tới module, không tự lấy draft.
3. Implement views/ViewModels/repository fixtures của batch; routes/back/overlay/scroll đúng flow. Không HTTP/backend, không mở tính năng thiếu thiết kế.
4. Đối chiếu layout tại 390 × 844, viewport hẹp, safe area, keyboard và chữ tiếng Việt; không dùng screenshot làm UI.
5. Test hành vi có ý nghĩa: state chuyển tiếp, validation/budget, stale async response, routing/role/back. Kiểm tra UI đủ trạng thái đã có thiết kế, không test chỉ phản chiếu implementation.
6. dart format --set-exit-if-changed, flutter analyze và flutter test phải đạt; báo Android/device/UI/golden/integration còn chưa chạy.
7. Review staged diff/secrets/build files, Conventional Commit rồi push branch. Tạo PR vào develop, kiểm tra diff/CI rồi tự merge theo quyền đã cấp; khi cập nhật main, tạo PR develop -> main và kiểm tra trước khi merge. Không bypass branch protection hoặc báo review giả.

## Checkpoint ngay sau lượt hiện tại

Cấu trúc monorepo đã được duyệt. Sau cập nhật này, task tiếp theo cần chốt framework/database nếu làm BE hoặc chọn batch Auth đầu tiên nếu làm FE. Không tự triển khai các module trong task tổ chức cấu trúc. BE/AI hiện chỉ có ranh giới và tài liệu, không có runtime/test được giả định là đã chạy.
