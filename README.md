# generate-short-bio

Claude Code skill — Tạo **Short Bio + Core Skills** chuyên nghiệp cho developer, hỗ trợ tối ưu theo JD khách hàng và 3 ngôn ngữ output.

---

## Tính năng

- **Match theo JD** — điều chỉnh số năm kinh nghiệm, thay thế ngôn ngữ BE, sinh skill đi kèm phù hợp cấp độ
- **3 mức độ match** — Hoàn toàn / Tương đối / Tổng quát
- **3 ngôn ngữ output** — Tiếng Việt / English / 日本語
- **Tự động lưu file** — đặt tên theo developer hoặc tuỳ chỉnh
- **Hỗ trợ cả 2 chế độ** — interactive form hoặc CLI args

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
git clone https://github.com/tms-anhle/dev-profile ~/Documents/Projects/generate-short-bio
cd ~/Documents/Projects/generate-short-bio
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
cd ~/Documents/Projects/generate-short-bio && git pull
```

---

## Cách dùng

### Chế độ interactive (không có args)

```
/generate-short-bio
```

Claude sẽ hỏi lần lượt: Profile → JD → Match Level → Ngôn ngữ & tên file.

### Chế độ CLI (có args)

```
/generate-short-bio --profile <path> [--jd <path|text>] [--match full|relative|general] [--lang vi|en|ja] [--output <filename>]
```

| Argument | Mô tả | Mặc định |
|----------|-------|---------|
| `--profile` | Path đến file profile developer (bắt buộc) | — |
| `--jd` | Path hoặc nội dung JD khách hàng | Không có |
| `--match` | Mức độ khớp JD: `full` / `relative` / `general` | `full` nếu có JD |
| `--lang` | Ngôn ngữ output: `vi` / `en` / `ja` | `vi` |
| `--output` | Tên file lưu kết quả | Auto: `short-bio-[ten-dev].md` |

### Ví dụ

```bash
# Interactive — không cần args
/generate-short-bio

# Có profile, không JD — bio tổng quát
/generate-short-bio --profile profiles/nguyen-van-an.md

# Có JD, hoàn toàn khớp, tiếng Việt
/generate-short-bio --profile profiles/an.md --jd jd-php.md --match full --lang vi

# JD tương đối khớp, output tiếng Anh, lưu file tuỳ chỉnh
/generate-short-bio --profile profiles/an.md --jd jd-java.md --match relative --lang en --output bio-an-java.md
```

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

| Domain | Kỹ năng & Kinh nghiệm |
|--------|----------------------|
| Backend / Framework | ... |
| Database | ... |
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
