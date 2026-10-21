# generate-short-bio

Claude Code skill — Giúp member tự tạo **Short Bio + Core Skills** chuyên nghiệp của chính mình (viết như member tự giới thiệu), hỗ trợ tối ưu theo JD khách hàng và 3 ngôn ngữ output.

---

## Tính năng

- **Match theo JD** — điều chỉnh số năm kinh nghiệm, thay thế ngôn ngữ BE, sinh skill đi kèm phù hợp cấp độ
- **3 mức độ match** — Hoàn toàn / Tương đối / Tổng quát
- **3 ngôn ngữ output** — Tiếng Việt / English / 日本語
- **Văn phong tự nhiên** — Short Bio luôn được chạy qua skill [humanizer](https://github.com/blader/humanizer) trước khi xuất
- **Đọc thông tin từ CV** — paste link CV (Google Docs / Sheets / Drive / PDF) hoặc file CV thay vì nhập tay
- **Tự động lưu file** — đặt tên theo member + ngày (không ghi đè bản cũ cùng ngày) hoặc tuỳ chỉnh

---

## Yêu cầu

- [Claude Code](https://claude.ai/code) đã cài đặt

---

## Cài đặt

```bash
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash
```

Đang phát triển skill? Clone repo rồi chạy `bash install.sh` trong thư mục repo — script symlink `SKILL.md` của repo vào `~/.claude/skills/generate-short-bio/` thay vì download, sửa `SKILL.md` có hiệu lực ngay. Khi đã là symlink, script không ghi đè repo; cập nhật bằng `git pull`.

Script cũng tự cài skill **humanizer** vào `~/.claude/skills/humanizer/` nếu máy chưa có (đã có thì giữ nguyên). Bản humanizer được pin theo commit để không bị ảnh hưởng khi upstream thay đổi.

Khởi động lại Claude Code sau khi cài.

---

## Cập nhật

```bash
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash
```

---

## Cách dùng

### Chạy skill

```
/generate-short-bio
```

Claude sẽ hỏi tuần tự từng câu một bằng text:

1. **Thông tin của bạn** — tên, role, số năm kinh nghiệm, tech stack (bắt buộc) + email, ngày sinh, domain, dự án (tùy chọn). Có thể paste link CV (Google Docs / Sheets / Drive / PDF) hoặc đường dẫn file CV thay vì gõ tay (link phải bật chia sẻ "Anyone with the link"; LinkedIn cần đăng nhập nên không đọc được) — Claude đọc CV, in thông tin trích được rồi đi tiếp luôn (cần sửa thì nhắn kèm câu trả lời tiếp theo). Học vấn không được dùng. Nếu thông tin sơ sài (chưa có dự án kèm mô tả), Claude hỏi bổ sung một lần — gõ `skip` để bỏ qua.
2. **JD khách hàng** — paste nội dung, link hoặc đường dẫn file JD nếu có, hoặc gõ `skip` để bỏ qua
3. **Mức độ match** — chỉ hỏi nếu có JD (1/2/3)

Bio tiếng Việt được in ra và lưu vào `short-bio-[ten]-[YYYY-MM-DD].md` ở thư mục hiện tại (file đã tồn tại thì Claude hỏi ghi đè hay tạo file mới `-2`, `-3`...). Nếu file còn thông tin thiếu, Claude liệt kê để bạn bổ sung trước khi gửi khách, sau đó hỏi có muốn tạo thêm bản en / ja không.

---

## Logic match JD

### Hoàn toàn khớp (`full`)
- Số năm = max(thực tế, yêu cầu JD) — chỉ nâng, không hạ số năm của member
- Thay thế stack nếu JD yêu cầu khác cùng danh mục (Ruby → PHP/Laravel, React → Vue...)
- Sinh skill đi kèm theo cấp độ kinh nghiệm (7 năm Java → Spring Cloud, Kafka, JPA...)
- Core Skills: chỉ liệt kê domain khớp JD

### Tương đối khớp (`relative`)
- Số năm = max(thực tế, 80–90% yêu cầu JD)
- Giữ toàn bộ điểm mạnh, highlight skill khớp JD lên đầu
- Core Skills: domain khớp JD trước, liệt kê đầy đủ tất cả domain

### Tổng quát theo JD (`general`)
- Giữ nguyên số năm thực tế
- Dùng JD làm gợi ý nhẹ
- Core Skills: liệt kê đầy đủ

---

## Cấu trúc output

```markdown
# [Tên member]

**Vị trí:** [Role]
**Email:** [...]
**Ngày sinh:** [...]

---

## Short Bio

[Đoạn 1 — Role, số năm, stack chính]

[Đoạn 2 — Dự án tiêu biểu, kết quả]

[Đoạn 3 — Cách làm việc]   ← thông tin sơ sài chỉ có 2 đoạn

---

## Core Skills

Backend / Framework: Laravel (5 năm), PHP (5 năm)
Database: MySQL (4 năm), Redis (3 năm)

---

## Project Examples   ← chỉ có khi đầu vào có dự án (1–2 dự án)

### Project 1 — Labofi
**Thời gian:** 8 tháng
**Vị trí:** Frontend Developer
**Mô tả:** [...]
**Tính năng chính:**
- [...]
**Tech Stack:** Next.js, Apollo GraphQL, MUI, Tailwind CSS
```

Thông tin thiếu được để placeholder `_(chưa có — vui lòng bổ sung)_` và liệt kê lại sau khi lưu file. Chi tiết từng use case: [`docs/use-cases.md`](docs/use-cases.md).

Bio viết theo phong cách profile, không dùng đại từ nhân xưng (không tôi/I/私), không gọi tên trong bio. Hỗ trợ role: Backend, Frontend, Fullstack, Mobile, QA.

---

## Gỡ cài đặt

```bash
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash -s -- --uninstall
```

> Skill `humanizer` không bị xóa khi gỡ (có thể skill khác đang dùng). Gỡ thủ công nếu không cần: `rm -rf ~/.claude/skills/humanizer`
