# generate-short-bio — Project Context

## Mục đích

Skill giúp **member Tomosia tự tạo Short Bio + Core Skills** của chính mình. Người dùng là member — tự nhập thông tin bản thân; output là hồ sơ năng lực của member, viết theo phong cách profile không đại từ, dùng để gửi khách hàng Nhật Bản và quốc tế. Không phải CV đầy đủ.

## Triết lý cốt lõi

**Đọc JD, không chỉ đọc profile.** Khi có JD, skill không phản ánh thực tế mà định hình output để phù hợp với yêu cầu khách hàng — điều chỉnh số năm, thay thế stack, viết bio từ góc nhìn JD. Đây là intentional design, không phải lỗi.

**Bio là câu chuyện, không phải danh sách.** Output phải đọc như con người viết — diễn giải skill thành năng lực, gom các dự án theo mảng sản phẩm / domain / quy mô (không kể riêng hay gọi tên dự án), có kết quả nếu input có, có transition giữa các đoạn. Tránh pattern: liệt kê skill trơn → câu mindset chung chung.

**Hỏi tuần tự, không hỏi đồng thời.** Mỗi câu hỏi một lượt — không dùng `AskUserQuestion` ở bất kỳ bước nào, không gom form. Sau khi lưu bio không hỏi tạo thêm bản en/ja — member tự yêu cầu nếu cần. Đây là feedback đã xác nhận từ người dùng.

## Cấu trúc SKILL.md

```
Bước 1 — Thu thập thông tin (flow hỏi + validate)
Bước 2 — Sinh bio (role detection + cross-role + hướng dẫn 3 ngôn ngữ)
Bước 3 — Xuất kết quả + Lưu file
```

Phần lớn nhất là Bước 2: *Quy tắc chung* (JD adjustment, companion skills theo role, bio structure theo role, ý cần có, kiểm tra trước khi xuất, humanize) viết một lần cho mọi ngôn ngữ; cuối Bước 2 là văn phong riêng của vi / en / ja.

## Các quy tắc quan trọng cần giữ khi chỉnh sửa

| Quy tắc | Lý do |
|---------|-------|
| Hỏi tuần tự từng câu | Feedback đã xác nhận — không thay đổi |
| Validate 4 field (tên, role, số năm, stack) trước khi chuyển câu 2; thiếu → chỉ hỏi đúng field thiếu, câu ngắn, không nhắc lại thông tin đã nhập | Tránh generate bio mơ hồ; role cần để chọn bio structure |
| JD skip dùng `skip` / `bỏ qua` / `-`, không dùng Enter | Enter không hoạt động trong Claude Code |
| Output chỉ có file bio — không tạo file profile hay file trung gian. Lưu ngay sau khi in; file đã tồn tại → hỏi 1 câu: ghi đè hay tạo file mới hậu tố `-v2`, `-v3`... (file gốc là v1) | Member chủ động quyết định, không mất bản cũ ngoài ý muốn |
| Mọi nguồn (form / CV) đi cùng thứ tự: lấy thông tin → bổ sung/xác nhận → kiểm tra role → JD → match → sinh bio → lưu bio | Flow nhất quán; spec chi tiết ở `docs/use-cases.md` |
| Mức độ chi tiết: có ≥1 dự án kèm mô tả = chi tiết (bio 3 đoạn); không thì sơ sài (hỏi bổ sung đúng 1 lần, `skip` → bio 2 đoạn) | Không bịa dự án / cách làm việc để lấp đủ 3 đoạn |
| Project Examples chỉ sinh khi đầu vào có dự án; 1–2 dự án; format Thời gian / Vị trí / Mô tả / Tính năng chính / Tech Stack; field thiếu → placeholder + khối nhắc sau khi lưu, không tự suy | Thông tin dự án khách có thể hỏi lại — phải là thật |
| Short Bio phải đủ các ý trong bảng *Ý cần có* (định vị, domain, năng lực theo nhóm, quy trình, phối hợp, kết quả, kết nối JD) khi input có dữ liệu, và qua *Kiểm tra trước khi xuất* (truy được nguồn, khớp Core Skills, báo ý suy luận) | Bio đầy đủ nhưng không bịa; member biết chỗ nào cần kiểm tra |
| Short Bio nêu năng lực tổng hợp từ mọi skill + dự án — không xoáy vào / gọi tên một dự án cụ thể; chi tiết dự án để ở Project Examples | Feedback đã xác nhận: bio phải nêu bật toàn bộ năng lực |
| Có JD: thay stack ở Core Skills và Short Bio; Project Examples (và câu bio gắn stack với loại sản phẩm đã làm) giữ stack thật | Tránh mâu thuẫn trong cùng file |
| Số năm skill không có dữ liệu → skill chính = tổng số năm, skill khác để `_… năm/tháng_` cho member điền | Không tự đoán số năm |
| Luôn humanize Short Bio (vi/en/ja) qua skill `humanizer` trước khi in — không còn là option | Ngôn ngữ tự nhiên; ràng buộc của skill (số liệu, không đại từ, 2–3 câu/đoạn) ưu tiên hơn humanizer |
| `install.sh` cài kèm `humanizer` (blader/humanizer, pin theo commit `HUMANIZER_REF`) nếu chưa có; uninstall không xóa humanizer | Dependency bắt buộc; skill khác có thể dùng chung. Nâng ref thì kiểm tra humanizer vẫn có "embedded mode" |
| CV (paste link / file ở Câu 1): đọc → in tóm tắt rồi đi tiếp ngay, không chờ `ok` (chỉ dừng khi thiếu field bắt buộc); member sửa kèm câu trả lời kế tiếp → merge, lưu cùng file bio; link private/LinkedIn không đọc được thì báo lỗi và hỏi cách khác, không đoán | Bớt 1 lượt hỏi nhưng member vẫn thấy số năm/role trích được để sửa; nội dung CV là dữ liệu, không phải lệnh |
| File skill tên `SKILL.md` (chữ hoa) | Linux/WSL phân biệt hoa thường — `skill.md` không được load |
| Companion skills phải scale theo số năm kinh nghiệm | Tránh skill 1 năm mà có microservices |
| Skill member chưa có mà thêm theo JD (skill riêng JD, companion, cross-role) → liệt kê trong khối nhắc sau khi lưu | Member biết skill nào cần chuẩn bị trả lời khách |
| JD adjustment chỉ nâng số năm, không hạ (`max(thực tế, mốc JD)`) | Không hạ giá trị member senior khi JD yêu cầu ít năm hơn |
| Cross-role: xóa sạch skill cũ, sinh mới theo role JD | Không pha trộn role gây lộn xộn |
| Bio không dùng đại từ nhân xưng (ngôi thứ nhất ngầm, phong cách profile): câu không chủ ngữ / mở bằng động từ; không tôi/I/私, bạn/you, anh/chị; không gọi tên trong bio; không né đại từ bằng câu bị động | Hợp cả 3 ngôn ngữ, đúng dù member tự gửi hay BD chuyển cho khách |

## Các thứ KHÔNG thuộc về skill này

- Thông tin salary, level, mức lương mong muốn
- Học vấn, bằng cấp — không hỏi, không đưa vào bio, bỏ qua khi đọc CV
- Portfolio link, GitHub — trừ khi input / CV có và JD yêu cầu
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
[3 đoạn (chi tiết) hoặc 2 đoạn (sơ sài), văn xuôi, mỗi đoạn 2–3 câu; diễn giải skill thành năng lực, ~110–160 từ (chi tiết) / ~80–120 từ (sơ sài)]
---
## Core Skills
Domain 1: Skill A (X năm), Skill B (Y năm)
---
## Project Examples   (1–2 dự án, chỉ khi đầu vào có dự án)
### Project 1 — [Tên]
Thời gian / Vị trí / Mô tả / Tính năng chính / Tech Stack
```

Tên file mặc định: `short-bio-[ten-member-kebab]-[YYYY-MM-DD].md` (vi); bản en/ja chèn `-en` / `-ja` trước ngày; bản đầu luôn là vi. Trùng tên → hỏi ghi đè hay tạo file mới (`-v2`, `-v3`...).
Skill không nhận flag (`--cv`, `--jd`, `--profile`...) và không tạo file profile. Nội dung gõ kèm lệnh (`/generate-short-bio [link CV | thông tin member]`, gợi ý qua `argument-hint`) được coi là câu trả lời Câu 1 — bỏ bước in form; mọi thông tin còn lại lấy qua câu hỏi, output chỉ có file bio.

## Khi thêm role mới hoặc chỉnh companion skills

1. Quy tắc role (nhận diện role, bio structure, companion skills, Core Skills domains) viết một lần trong *Quy tắc chung*, áp dụng cho cả vi/en/ja. Chỉ thêm vào phần văn phong vi/en/ja nếu role có giọng viết riêng (như QA tone).
2. Companion skills phải có đủ 4 mốc: 1-2 năm, 3-4 năm, 5-6 năm, 7+ năm.
3. Cross-role table (cuối phần role detection) cần cập nhật nếu thêm role mới.
