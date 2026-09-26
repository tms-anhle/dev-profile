# generate-short-bio

Claude Code skill — Tạo **Short Bio + Core Skills** chuyên nghiệp cho developer, hỗ trợ tối ưu theo JD khách hàng và 3 ngôn ngữ output.

---

## Tính năng

- **Match theo JD** — điều chỉnh số năm kinh nghiệm, thay thế ngôn ngữ BE, sinh skill đi kèm phù hợp cấp độ
- **3 mức độ match** — Hoàn toàn / Tương đối / Tổng quát
- **3 ngôn ngữ output** — Tiếng Việt / English / 日本語
- **Tự động lưu file** — đặt tên theo developer hoặc tuỳ chỉnh

---

## Yêu cầu

- [Claude Code](https://claude.ai/code) đã cài đặt

---

## Cài đặt

**Cách 1 — Download thẳng từ GitHub** (cài vào `~/.claude/skills/generate-short-bio/`):

```bash
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash
```

**Cách 2 — Clone về máy rồi symlink** (tiện cho việc tự chỉnh sửa skill):

```bash
git clone https://github.com/tms-anhle/dev-profile <thư-mục-tuỳ-chọn>
cd <thư-mục-tuỳ-chọn>
bash install.sh
```

Script tự phát hiện `skill.md` trong thư mục hiện tại và tạo symlink thay vì download.

Khởi động lại Claude Code sau khi cài.

---

## Cập nhật

```bash
# Nếu cài theo Cách 1
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash

# Nếu cài theo Cách 2 (clone)
cd <thư-mục-đã-clone> && git pull
```

---

## Cách dùng

### Chế độ interactive (không có args)

```
/generate-short-bio
```

Claude sẽ hỏi tuần tự từng câu một bằng text:

1. **Thông tin member** — nhập tên, số năm kinh nghiệm, tech stack
2. **JD khách hàng** — paste JD vào nếu có, hoặc Enter để bỏ qua
3. **Mức độ match** — chỉ hỏi nếu có JD (1/2/3)
4. **Ngôn ngữ & tên file** — chọn vi/en/ja và tên file output

---

## Logic match JD

### Hoàn toàn khớp (`full`)
- Số năm = 100% yêu cầu JD
- Thay thế ngôn ngữ BE nếu JD yêu cầu khác (Ruby → PHP/Laravel, Ruby → Java/Spring Boot...)
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
## Short Bio — [Tên developer]

[Đoạn 1 — Nền tảng kỹ thuật]

[Đoạn 2 — Điểm phù hợp / dự án tiêu biểu]

[Đoạn 3 — Kỹ năng mềm]

---

## Core Skills

Backend / Framework : ... 
Database : ... 
```

---

## Gỡ cài đặt

**Cách 1 — Dùng script:**

```bash
curl -fsSL https://raw.githubusercontent.com/tms-anhle/dev-profile/master/install.sh | bash -s -- --uninstall
```

**Cách 2 — Thủ công:**

```bash
rm -rf ~/.claude/skills/generate-short-bio
```

> Nếu cài theo clone, lệnh trên chỉ xóa symlink — source code tại thư mục clone vẫn còn nguyên.
