# generate-short-bio

Claude Code skill — Giúp member tự tạo **Short Bio + Core Skills** chuyên nghiệp của chính mình (viết như member tự giới thiệu), hỗ trợ tối ưu theo JD khách hàng và 3 ngôn ngữ output.

---

## Tính năng

- **Match theo JD** — điều chỉnh số năm kinh nghiệm, thay thế ngôn ngữ BE, sinh skill đi kèm phù hợp cấp độ
- **3 mức độ match** — Hoàn toàn / Tương đối / Tổng quát
- **3 ngôn ngữ output** — Tiếng Việt / English / 日本語
- **Văn phong tự nhiên** — Short Bio luôn được chạy qua skill [humanizer](https://github.com/blader/humanizer) trước khi xuất
- **Tự động lưu file** — đặt tên theo developer hoặc tuỳ chỉnh

---

## Yêu cầu

- [Claude Code](https://claude.ai/code) đã cài đặt

---

## Cài đặt

```bash
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash
```

Đang phát triển skill? Clone repo rồi chạy `bash install.sh` trong thư mục repo — script tạo symlink tới repo thay vì download, sửa `SKILL.md` có hiệu lực ngay. Khi đã là symlink, script không ghi đè repo; cập nhật bằng `git pull`.

Script cũng tự cài skill **humanizer** vào `~/.claude/skills/humanizer/` nếu máy chưa có (đã có thì giữ nguyên).

Khởi động lại Claude Code sau khi cài.

---

## Cập nhật

```bash
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash
```

---

## Cách dùng

### Chế độ interactive (không có args)

```
/generate-short-bio
```

Claude sẽ hỏi tuần tự từng câu một bằng text:

1. **Thông tin của bạn** — tên, role, số năm kinh nghiệm, tech stack (bắt buộc) + email, ngày sinh, domain, dự án, học vấn (tùy chọn). Thông tin được lưu vào `profile-[ten].md` để dùng lại.
2. **JD khách hàng** — paste JD vào nếu có, hoặc gõ `skip` để bỏ qua
3. **Mức độ match** — chỉ hỏi nếu có JD (1/2/3)

Bio tiếng Việt được in ra và lưu vào `short-bio-[ten]-[YYYY-MM-DD].md`, sau đó Claude hỏi có muốn tạo thêm bản en / ja không.

### Dùng lại profile cho JD mới

```
/generate-short-bio --profile profile-nguyen-van-an.md --jd jd-client-a.txt
```

| Argument | Ý nghĩa |
|----------|---------|
| `--profile` | File profile (bỏ qua câu 1) |
| `--jd` | Nội dung JD hoặc đường dẫn file JD |
| `--match full\|relative\|general` | Mức độ match (mặc định `full` khi có JD) |
| `--lang vi\|en\|ja` | Ngôn ngữ bản đầu (mặc định `vi`) |
| `--output` | Tên file output tùy chỉnh |

---

## Logic match JD

### Hoàn toàn khớp (`full`)
- Số năm = 100% yêu cầu JD
- Thay thế stack nếu JD yêu cầu khác cùng danh mục (Ruby → PHP/Laravel, React → Vue...)
- Sinh skill đi kèm theo cấp độ kinh nghiệm (7 năm Java → Spring Cloud, Kafka, JPA...)
- Core Skills: chỉ liệt kê domain khớp JD

### Tương đối khớp (`relative`)
- Số năm = 80–90% yêu cầu JD
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

[Đoạn 3 — Cách làm việc]

---

## Core Skills

Backend / Framework: Laravel (5 năm), PHP (5 năm)
Database: MySQL (4 năm), Redis (3 năm)

---

## Project Example

### [Tên dự án]
**Stack:** [...]
**Mô tả:** [...]
```

Bio viết theo phong cách profile, không dùng đại từ nhân xưng (không tôi/I/私), không gọi tên trong bio. Hỗ trợ role: Backend, Frontend, Fullstack, Mobile, QA.

---

## Gỡ cài đặt

```bash
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash -s -- --uninstall
```

> Skill `humanizer` không bị xóa khi gỡ (có thể skill khác đang dùng). Gỡ thủ công nếu không cần: `rm -rf ~/.claude/skills/humanizer`
