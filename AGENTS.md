# generate-short-bio — Project Context

## Mục đích

Skill giúp **member Tomosia tự tạo Short Bio + Core Skills** của chính mình. Người dùng là member — tự nhập thông tin bản thân; output là hồ sơ năng lực của member, viết theo phong cách profile không đại từ, dùng để gửi khách hàng Nhật Bản và quốc tế. Không phải CV đầy đủ.

## Triết lý cốt lõi

**Đọc JD, không chỉ đọc profile.** Khi có JD, skill không phản ánh thực tế mà định hình output để phù hợp với yêu cầu khách hàng — điều chỉnh số năm, thay thế stack, viết bio từ góc nhìn JD. Đây là intentional design, không phải lỗi.

**Bio là câu chuyện, không phải danh sách.** Output phải đọc như con người viết — có context dự án, có kết quả cụ thể, có transition giữa các đoạn. Tránh pattern: liệt kê skill → liệt kê dự án → câu mindset chung chung.

**Hỏi tuần tự, không hỏi đồng thời.** Mỗi câu hỏi một lượt — không dùng `AskUserQuestion` ở bất kỳ bước nào (kể cả câu hỏi humanize/en/ja sau khi lưu), không gom form. Đây là feedback đã xác nhận từ người dùng.

## Cấu trúc SKILL.md

```
Bước 1 — Thu thập thông tin (flow hỏi + validate)
Bước 2 — Sinh bio (role detection + cross-role + hướng dẫn 3 ngôn ngữ)
Bước 3 — Xuất kết quả + Lưu file
```

Phần lớn nhất là Bước 2, chia theo ngôn ngữ (vi → en → ja), mỗi ngôn ngữ chia theo role (BE/FE/Fullstack → Mobile → QA).

## Các quy tắc quan trọng cần giữ khi chỉnh sửa

| Quy tắc | Lý do |
|---------|-------|
| Hỏi tuần tự từng câu | Feedback đã xác nhận — không thay đổi |
| Validate 4 field (tên, role, số năm, stack) trước khi chuyển câu 2 | Tránh generate bio mơ hồ; role cần để chọn bio structure |
| JD skip dùng `skip` / `bỏ qua` / `-`, không dùng Enter | Enter không hoạt động trong Claude Code |
| Luôn lưu file sau khi in — không hỏi lại | Đã ghi rõ trong Bước 3 |
| Luôn humanize Short Bio (vi/en/ja) qua skill `humanizer` trước khi in — không còn là option | Ngôn ngữ tự nhiên; ràng buộc của skill (số liệu, không đại từ, 2 câu/đoạn) ưu tiên hơn humanizer |
| `install.sh` cài kèm `humanizer` (blader/humanizer) nếu chưa có; uninstall không xóa humanizer | Dependency bắt buộc; skill khác có thể dùng chung |
| File skill tên `SKILL.md` (chữ hoa) | Linux/WSL phân biệt hoa thường — `skill.md` không được load |
| Companion skills phải scale theo số năm kinh nghiệm | Tránh skill 1 năm mà có microservices |
| Cross-role: xóa sạch skill cũ, sinh mới theo role JD | Không pha trộn role gây lộn xộn |
| Bio không dùng đại từ nhân xưng (ngôi thứ nhất ngầm, phong cách profile): câu không chủ ngữ / mở bằng động từ; không tôi/I/私, bạn/you, anh/chị; không gọi tên trong bio; không né đại từ bằng câu bị động | Hợp cả 3 ngôn ngữ, đúng dù member tự gửi hay BD chuyển cho khách |

## Các thứ KHÔNG thuộc về skill này

- Thông tin salary, level, mức lương mong muốn
- Portfolio link, GitHub — trừ khi profile có và JD yêu cầu
- CI/CD setup cho QA — QA chỉ chạy test, không sở hữu infrastructure

## Output format

Template đầy đủ nằm ở Bước 3 của `SKILL.md`. Tóm tắt:

```markdown
# [Tên member]
**Vị trí:** [Role]
**Email:** [...]
**Ngày sinh:** [...]
---
## Short Bio
[3 đoạn văn xuôi, không bullet point, mỗi đoạn tối đa 2 câu]
---
## Core Skills
Domain 1: Skill A (X năm), Skill B (Y năm)
---
## Project Example   (tối đa 2, bỏ nếu không có)
```

Tên file mặc định: `short-bio-[ten-member-kebab]-[YYYY-MM-DD].md` (vi); bản en/ja chèn `-en` / `-ja` trước ngày — kể cả khi `--lang` truyền từ đầu.
Nếu user đặt tên thủ công: giữ nguyên tên đó (không append ngày).

Profile member nhập tay được lưu vào `profile-[ten-member-kebab].md` (chưa qua JD adjustment) để dùng lại với `--profile`.

## Khi thêm role mới hoặc chỉnh companion skills

1. Thêm vào cả 3 ngôn ngữ (vi, en, ja) — không để lệch nhau.
2. Companion skills phải có đủ 4 mốc: 1-2 năm, 3-4 năm, 5-6 năm, 7+ năm.
3. Cross-role table (cuối phần role detection) cần cập nhật nếu thêm role mới.
