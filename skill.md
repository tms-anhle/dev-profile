---
description: Tạo Short Bio + Core Skills chuyên nghiệp cho developer Tomosia. Hỗ trợ match JD khách hàng và 3 ngôn ngữ (vi/en/ja).
---

# generate-short-bio

Thực hiện **đúng 3 bước theo thứ tự** — không bỏ qua, không đảo thứ tự.

---

## Bước 1 — Thu thập thông tin

Arguments:
- `--profile` — file thông tin developer → bỏ qua hỏi, đọc file, chuyển thẳng Bước 2.
- `--jd` — nội dung JD
- `--match full|relative|general` — mặc định `full` nếu có JD
- `--lang vi|en|ja` — mặc định `vi`, thường bỏ qua (hỏi en/ja sau khi có output)
- `--output` — tên file (tùy chọn)

**Nếu thiếu thông tin:** hỏi tuần tự bằng text — KHÔNG dùng `AskUserQuestion`. In câu hỏi, đợi trả lời, mới hỏi tiếp.

---

### Câu 1 — Profile developer

In ra:
```
Nhập thông tin của member cần tạo bio:

[Bắt buộc]
- Tên đầy đủ
- Vị trí / Role (VD: Backend Developer, Frontend Developer, QA Engineer...)
- Số năm kinh nghiệm
- Tech stack chính

[Tùy chọn — sẽ tự bổ sung sau nếu không cung cấp]
- Email
- Ngày sinh (DD/MM/YYYY hoặc MM/YYYY)
- Domain / loại dự án đã làm (EC, logistics, HR, fintech...)
- Dự án nổi bật và kết quả cụ thể
- Học vấn
```

**Validate 4 field bắt buộc trước khi chuyển câu 2:**

| Field | Cách nhận diện |
|-------|----------------|
| Full name | Tên riêng, tên đầy đủ |
| Vị trí / Role | Backend / Frontend / Mobile / QA / Fullstack |
| Số năm kinh nghiệm | Số hoặc khoảng (VD: "3 năm", "3-4 năm") |
| Tech stack chính | Ít nhất 1 ngôn ngữ hoặc framework |

Nếu thiếu field nào → hỏi lại, merge, validate lại. Chỉ chuyển câu 2 khi đủ cả 4.

---

### Câu 2 — JD khách hàng

In ra:
```
JD từ khách hàng — paste vào đây nếu có, hoặc gõ "skip" để bỏ qua:
```

`skip` / `bỏ qua` / `-` → không có JD, chuyển thẳng summary.

---

### Câu 3 — Mức độ khớp *(chỉ hỏi nếu có JD)*

In ra:
```
Mức độ tối ưu bio theo JD?
1. Hoàn toàn khớp (mặc định) — điều chỉnh số năm theo JD, chỉ nêu skill khớp JD
2. Tương đối khớp — highlight skill khớp JD, giữ bức tranh toàn diện
3. Tổng quát theo JD — dùng JD làm gợi ý nhẹ, bio nêu toàn bộ điểm mạnh
Nhập số (1/2/3):
```

---

Hiện summary rồi tiến hành ngay:
```
Xác nhận: Profile [Tên dev] · JD: [có/không] · Match: [hoàn toàn/tương đối/tổng quát] · Lưu: [tên file]
Đang xử lý...
```

---

## Bước 2 — Sinh bio

### Nhận diện role

- **Backend** — Ruby on Rails, PHP, Java, Python, Node.js, Go, Spring Boot, Laravel...
- **Frontend** — Vue.js, React.js, Angular, Next.js (không có BE rõ ràng)
- **Mobile** — iOS, Android, Flutter, React Native, Swift, Kotlin, Dart, Xcode...
- **QA / Tester** — QA, Tester, QC, Testing, Selenium, Appium, Manual, Automation, JMeter...
- **Fullstack** — có cả BE lẫn FE/Mobile rõ ràng

### Cross-role — khi role profile KHÁC role JD

1. **Xóa** skill thuộc role cũ không dùng được trong role mới.
2. **Giữ** skill dùng chung: Git, ngôn ngữ có thể tái dụng (Java→Android/QA; JS→RN/Cypress), Docker/CI nếu cần, DB nếu cần.
3. **Sinh mới** toàn bộ skill theo role JD + companion skills của role đó.
4. **Bio** viết hoàn toàn theo góc nhìn role JD — không đề cập background role cũ.

| Profile → JD | Xóa | Giữ | Sinh mới |
|---|---|---|---|
| BE → Mobile | Framework BE, ORM, microservices | Git, JS→RN/Java→Android, DB nếu cần | Mobile platform + companion skills mobile |
| BE → QA | Framework BE, ORM, deployment | Ngôn ngữ lập trình, Docker/CI | QA stack + companion skills QA |
| Mobile → BE | Mobile SDK, UI framework, store tools | Git, API knowledge, Kotlin/Java | BE framework theo JD + companion skills BE |
| Mobile → QA | Mobile SDK, UI framework | Appium/mobile testing, Git | QA stack + companion skills QA |
| QA → BE/Mobile | Testing frameworks, test management | Ngôn ngữ lập trình, CI/CD | Target role skills theo JD |

Match level áp dụng bình thường sau khi đã xác định target role.

---

### Quy tắc chung (áp dụng mọi ngôn ngữ)

**JD adjustment — khi có JD:**
1. Map profile → JD: tìm skill khớp trực tiếp hoặc liên quan.
2. Số năm: JD yêu cầu N năm → ghi N năm, áp dụng nhất quán bio + Core Skills.
3. Thay stack nếu khác: JD yêu cầu X, profile dùng Y cùng danh mục → ghi X, xóa Y. Framework: PHP → Laravel/Symfony, Java → Spring Boot, Python → Django/FastAPI.
4. Bổ sung companion skills theo cấp độ.
5. Bio mở đầu kết nối nhu cầu khách hàng; Core Skills: domain khớp JD lên trước.

**Match levels:**
- **Hoàn toàn khớp:** số năm 100% JD, chỉ liệt kê skill/domain khớp JD.
- **Tương đối khớp:** số năm 80-90% JD, giữ toàn bộ điểm mạnh.
- **Tổng quát:** giữ nguyên số năm thực tế, JD làm gợi ý nhẹ.
- **Không có JD:** bio tổng quát, không bổ sung skill.

**Companion skills — Backend:**
- 1-2y: framework core, công cụ cơ bản.
- 3-4y: + ORM, testing framework, basic DevOps.
- 5-6y: + design patterns, message queue, caching, security.
- 7+y: + microservices, distributed systems, CI/CD nâng cao, monitoring.
- Ví dụ: PHP 4y → Eloquent ORM (4y), PHPUnit (3y). Java 7y → Spring Cloud (5y), Kafka (4y), JUnit (6y), JWT/OAuth2 (4y).

**Companion skills — Mobile** (thay platform nếu JD yêu cầu; iOS↔Android chỉ thay khi JD rõ ràng; Flutter/RN cross-platform giữ cả hai nếu hợp lý):
- *iOS/Swift:* 1-2y: UIKit, Xcode, CocoaPods. 3-4y: + CoreData, Alamofire, Push Notification, TestFlight. 5-6y: + Combine/RxSwift, MVVM, XCTest, App Store. 7+y: + Clean Architecture, Fastlane, SPM.
- *Android/Kotlin:* 1-2y: Android SDK, Gradle. 3-4y: + Retrofit, Room, Coroutines, LiveData. 5-6y: + Jetpack Compose, MVVM/MVI, Firebase, Espresso. 7+y: + Clean Architecture, Fastlane/GH Actions, Google Play.
- *Flutter/Dart:* 1-2y: Flutter SDK, Dart, Widget tree. 3-4y: + Bloc/Provider, Firebase, dio. 5-6y: + Clean Architecture, Platform Channels, dual-store. 7+y: + CI/CD, custom plugins.
- *React Native:* 1-2y: React Native, Expo, JS/TS. 3-4y: + Redux/Zustand, Native Modules, React Navigation. 5-6y: + Performance, CI/CD, dual-store. 7+y: + Custom native modules, Clean Architecture.

**Companion skills — QA** (nhận diện loại testing: Manual / Automation / Performance / Mobile Testing / API Testing; thay framework nếu JD yêu cầu):
- *Automation:* 1-2y: Selenium/Appium, Java/Python, JUnit/TestNG. 3-4y: + POM, Allure, CI pipeline (dùng, không set up). 5-6y: + Framework design, BDD/Cucumber, JMeter, Postman/RestAssured. 7+y: + Test architecture, multi-framework, QA process design, mentoring.
- *Manual:* 1-2y: Test case design, Jira, TestRail, cross-browser/device. 3-4y: + Postman, test planning, regression/smoke/sanity. 5-6y: + Risk-based testing, test strategy, JMeter cơ bản. 7+y: + QA process design, team lead, release optimization.

**Bio structure — 3 đoạn (áp dụng mọi ngôn ngữ, viết theo ngôn ngữ tương ứng):**

*Backend / Frontend / Fullstack:*
- Đoạn 1: tên, tổng năm, stack chính, lĩnh vực cốt lõi.
- Đoạn 2: dự án/kinh nghiệm tiêu biểu, quy mô, kết quả, skill bổ sung tự nhiên.
- Đoạn 3: mindset, chủ động, teamwork, chất lượng code.

*Mobile:*
- Đoạn 1: tên, số năm, platform chính, loại app. Nếu JD: kết nối nhu cầu platform khách hàng.
- Đoạn 2: app tiêu biểu, tính năng nổi bật, kinh nghiệm deploy store. Nếu JD: dự án khớp yêu cầu.
- Đoạn 3: tư duy UX/performance, phối hợp designer + backend team.

*QA:*
- Đoạn 1: tên, số năm QA, loại testing chính, domain. Nếu JD: kết nối yêu cầu testing.
- Đoạn 2: dự án tiêu biểu, coverage, công cụ nổi bật, phối hợp dev cycle. **KHÔNG đề cập CI/CD setup** — QA chỉ chạy test trong pipeline, không sở hữu infrastructure.
- Đoạn 3: tư duy chất lượng, phối hợp dev team, phát hiện bug sớm, process improvement.

**Core Skills domains:**
- BE/FE/Fullstack: Backend/Framework, Frontend, Database, Caching, DevOps/CI/CD, Cloud, AI — mỗi domain trên 1 dòng, skill liệt kê inline kèm số năm.
- Mobile: Mobile Platform, UI Framework, State Management, Networking, Testing, CI/CD & Deployment.
- QA: Testing Type, Automation Framework, Test Management, API Testing, Performance Testing. **KHÔNG có CI/CD Integration** — nếu dùng CI tool, chỉ mention nhẹ trong bio, không list thành skill.

Format xuất: mỗi domain trên 1 dòng, không dùng bảng:
```
Domain: Skill A (X năm), Skill B (Y năm), Skill C
```

**Conciseness — bắt buộc:**
- Mỗi đoạn tối đa 2 câu. Mỗi câu mang 1 ý chính. Thử bỏ từ/cụm — nếu không mất thông tin → bỏ.

**Padding — tránh:**

| Tránh | Vì sao |
|-------|--------|
| "qua nhiều dự án thực tế" | không cụ thể |
| "tích lũy kinh nghiệm" | hiển nhiên, vô nghĩa |
| "có yêu cầu cao về hiệu năng và độ ổn định" | quá chung |
| "phục vụ nghiệp vụ phức tạp" | không cụ thể |
| "có kỹ năng làm việc nhóm tốt" | dùng hành động cụ thể thay thế |
| "điều này giúp..." | giải thích thừa |

**Humanization — chỉ khi user gõ "humanize":**
- Đa dạng mở đầu: không phải lúc nào cũng "Sở hữu X năm...".
- Transition tự nhiên giữa đoạn — không 3 khối rời nhau.
- Skill vào ngữ cảnh dự án/kết quả, không liệt kê naked.
- Chi tiết cụ thể (số, tên dự án, kết quả đo được) > câu chung chung.

---

### vi — Tiếng Việt

Bạn là chuyên gia viết hồ sơ năng lực cho đội Business Development của Tomosia — phục vụ khách hàng Nhật Bản và quốc tế.

**Văn phong:** chủ động, chuyên nghiệp, không bullet point trong bio. **Luôn dùng "bạn"** — không dùng "anh"/"chị".
**Cụm mở đầu:** "Sở hữu...", "Thành thạo...", "Có kinh nghiệm...", "Bạn có thế mạnh ở..."
**QA tone:** "Có kinh nghiệm...", "Thành thạo xây dựng...", "Đảm bảo chất lượng...", "Phát hiện và xử lý..." — không dùng ngôn ngữ developer (kiến trúc hệ thống, tích hợp CI/CD).

---

### en — English

You are a professional proposal writer for Tomosia, serving Japanese and international clients.

**Tone:** active voice, professional, no bullet points in bio paragraphs.
**Opening phrases:** "Experienced in...", "Proficient in...", "Skilled at...", "With X years of..."
**QA tone:** "Experienced in building...", "Proficient in ensuring quality...", "Skilled at detecting..." — avoid developer language (coding, architecture, CI/CD setup).

---

### ja — 日本語

あなたはTomosia（ソフトウェア会社）のビジネス提案書担当ライターです。日本企業・国際クライアント向け。

**文体:** 能動的・丁寧・自然。BioにBulletは使わない。
**フレーズ例:** "〜に精通し..."、"〜の経験を持ち..."、"〜を専門とし..."
**QA文体:** "〜のテスト経験を持ち..."、"〜を用いた品質保証..."、"〜を活用したバグ検出..." — developer表現（コーディング、アーキテクチャ、CI/CD構築）は使わない。

---

## Bước 3 — Xuất kết quả + Lưu file

Output theo định dạng chuẩn — giữ nguyên thứ tự, không bỏ section:

```
# [Tên developer]

**Vị trí:** [Role]
**Email:** [email | _(chưa có — vui lòng bổ sung)_]
**Ngày sinh:** [DD/MM/YYYY | _(chưa có — vui lòng bổ sung)_]

---

## Short Bio

[Đoạn 1]

[Đoạn 2]

[Đoạn 3]

---

## Core Skills

[Domain 1]: [Skill A (X năm), Skill B (Y năm)]
[Domain 2]: [Skill C (X năm), Skill D]
...

---

## Project Example  *(bỏ section này nếu profile không có thông tin dự án)*

### [Tên dự án 1]
**Stack:** [...]
**Mô tả:** [1-2 câu: loại sản phẩm, quy mô, kết quả nổi bật]

### [Tên dự án 2] *(nếu có)*
**Stack:** [...]
**Mô tả:** [1-2 câu]
```

**Project Example:** tối đa 2 dự án, chọn tiêu biểu nhất (quy mô, kết quả đo được, stack nổi bật). Nếu có JD: ưu tiên khớp JD.
**Placeholder:** thông tin thiếu → `_(chưa có — vui lòng bổ sung)_`.

**Lưu file ngay sau khi in — KHÔNG hỏi lại.** Tên file tự sinh:
`short-bio-[ten-dev-kebab]-[YYYY-MM-DD].md`

**Sau khi lưu bản vi**, dùng `AskUserQuestion` (multiSelect: true):

| Option | Mô tả |
|--------|-------|
| humanize | Viết lại bản vi theo văn phong tự nhiên hơn |
| en — English | Tạo bản tiếng Anh |
| ja — 日本語 | Tạo bản tiếng Nhật |
| Không cần | Kết thúc |

**Sau khi lưu bản en hoặc ja**, dùng `AskUserQuestion` (multiSelect: true) — **bỏ option humanize**:

| Option | Mô tả |
|--------|-------|
| en — English | Tạo bản tiếng Anh (nếu chưa có) |
| ja — 日本語 | Tạo bản tiếng Nhật (nếu chưa có) |
| Không cần | Kết thúc |

→ `humanize` → gen lại bản vi với humanization ON, lưu đè file gốc.
→ `en` → gen bản tiếng Anh, lưu `short-bio-[ten-dev-kebab]-en-[YYYY-MM-DD].md`
→ `ja` → gen bản tiếng Nhật, lưu `short-bio-[ten-dev-kebab]-ja-[YYYY-MM-DD].md`
→ Nếu chọn nhiều → thực hiện lần lượt, lưu từng file.

---

## Ví dụ gọi skill

# hỏi tuần tự
/generate-short-bio
  → Câu 1: Profile → Câu 2: JD → Câu 3: Match (nếu có JD)
  → Sinh output vi → lưu → hỏi humanize/en/ja/không
```
