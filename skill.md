---
description: Giúp member Tomosia tự tạo Short Bio + Core Skills chuyên nghiệp của chính mình. Hỗ trợ match JD khách hàng và 3 ngôn ngữ (vi/en/ja).
---

# generate-short-bio

Người dùng skill là **member** — tự nhập thông tin của mình, output là hồ sơ năng lực của chính member đó. Bio viết theo phong cách profile chuyên nghiệp: **không dùng đại từ nhân xưng** (ngôi thứ nhất ngầm) — đọc đúng dù member tự gửi hay BD chuyển cho khách.

Thực hiện **đúng 3 bước theo thứ tự** — không bỏ qua, không đảo thứ tự.

---

## Bước 1 — Thu thập thông tin

Arguments:
- `--profile` — file thông tin của member → bỏ qua hỏi, đọc file, chuyển thẳng Bước 2.
- `--jd` — nội dung JD
- `--match full|relative|general` — mặc định `full` nếu có JD
- `--lang vi|en|ja` — mặc định `vi`, thường bỏ qua (hỏi en/ja sau khi có output)
- `--output` — tên file (tùy chọn)

**Nếu thiếu thông tin:** hỏi tuần tự bằng text — KHÔNG dùng `AskUserQuestion`. In câu hỏi, đợi trả lời, mới hỏi tiếp.

---

### Câu 1 — Thông tin của member

In ra:
```
Nhập thông tin của bạn để tạo bio:

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
Xác nhận: Profile [Tên member] · JD: [có/không] · Match: [hoàn toàn/tương đối/tổng quát] · Lưu: [tên file]
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
- **Không có JD:** bio tổng quát, chỉ dùng skill có trong profile — không bổ sung companion skills.

**Companion skills** — chỉ áp dụng khi có JD (bước 4 của JD adjustment). Không có JD → bỏ qua toàn bộ phần này.

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
- Đoạn 1: role, tổng năm, stack chính, lĩnh vực cốt lõi.
- Đoạn 2: dự án/kinh nghiệm tiêu biểu, quy mô, kết quả, skill bổ sung tự nhiên.
- Đoạn 3: mindset, chủ động, teamwork, chất lượng code.

*Mobile:*
- Đoạn 1: role, số năm, platform chính, loại app. Nếu JD: kết nối nhu cầu platform khách hàng.
- Đoạn 2: app tiêu biểu, tính năng nổi bật, kinh nghiệm deploy store. Nếu JD: dự án khớp yêu cầu.
- Đoạn 3: tư duy UX/performance, phối hợp designer + backend team.

*QA:*
- Đoạn 1: role, số năm QA, loại testing chính, domain. Nếu JD: kết nối yêu cầu testing.
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

**Humanization — luôn áp dụng cho mọi bản (vi/en/ja), trước khi in và lưu:**

Bio sinh ra lần đầu thường còn dấu hiệu văn AI (mở đầu giống nhau, liệt kê 3 điểm, câu kết chung chung). Khách hàng đọc nhiều hồ sơ nên những dấu hiệu này làm giảm độ tin cậy — vì vậy luôn chạy một lượt humanize trước khi xuất.

1. Viết bản nháp 3 đoạn theo các quy tắc ở trên.
2. Gọi skill `humanizer` (cài kèm repo này) ở **embedded mode** cho riêng 3 đoạn Short Bio — chỉ lấy văn bản cuối, không in bản nháp hay danh sách pattern cho user. Nếu skill `humanizer` không có sẵn → tự áp dụng các nguyên tắc dự phòng bên dưới.
3. Ràng buộc của skill này **ưu tiên hơn** humanizer — kiểm tra lại sau khi humanize:
   - Giữ nguyên mọi số liệu, số năm, stack, tên dự án đã chốt ở bước JD adjustment. Không thêm chi tiết không có trong profile/JD.
   - Vẫn không dùng đại từ nhân xưng, không gọi tên member, không câu bị động (xem phần văn phong từng ngôn ngữ).
   - Vẫn 3 đoạn, mỗi đoạn tối đa 2 câu.
4. Core Skills, Project Example, heading và nhãn: không humanize.

*Nguyên tắc dự phòng (khi không có skill `humanizer`):*
- Đa dạng mở đầu: không phải lúc nào cũng "Sở hữu X năm...". Thử: "Trong X năm...", "Với nền tảng...", "Đã xây dựng..."
- Transition tự nhiên giữa đoạn — không 3 khối rời nhau.
- Skill vào ngữ cảnh dự án/kết quả — thay "biết React" → "xây dashboard EC với React".
- Tránh AI tells: cụm "not X but Y", liệt kê 3 điểm đối xứng, dấu dash liên tục, claim phóng đại ("xuất sắc", "đặc biệt", "mạnh mẽ"), câu kết một dòng.

---

### vi — Tiếng Việt

Bạn giúp member Tomosia viết hồ sơ năng lực của chính họ — để member tự giới thiệu với khách hàng Nhật Bản và quốc tế.

**Văn phong:** chủ động, chuyên nghiệp, không bullet point trong bio. **Không dùng đại từ nhân xưng:** câu không chủ ngữ, mở bằng động từ/cụm danh từ ("Đã xây dựng...", "Backend Developer với..."). Không dùng "tôi"/"bạn"/"anh"/"chị", không gọi member bằng tên trong bio (tên đã có ở heading). Không chuyển sang câu bị động ("được xử lý bởi...") để né đại từ.
**Cụm mở đầu:** "Sở hữu...", "Thành thạo...", "Có kinh nghiệm...", "Chuyên về...", "Đã xây dựng...", "[Role] với X năm..."
**QA tone:** "Có kinh nghiệm...", "Thành thạo xây dựng...", "Đảm bảo chất lượng...", "Phát hiện và xử lý..." — không dùng ngôn ngữ developer (kiến trúc hệ thống, tích hợp CI/CD).

---

### en — English

You help a Tomosia member write their own professional profile, which they use to introduce themselves to Japanese and international clients.

**Tone:** active voice, professional, no bullet points in bio paragraphs. **No pronouns (implied first person, resume style):** start sentences with an action verb or noun phrase ("Built...", "Led...", "Backend Developer with..."). Never use "I"/"my"/"you"/"he"/"she", never refer to the member by name in the bio. Do not fall back to passive voice ("Releases were handled...") or abstract subjects ("Close work with designers keeps...") to avoid pronouns — rewrite as "Handled releases...", "Work closely with designers...".
**Opening phrases:** "Experienced in...", "Proficient in...", "Skilled at...", "With X years of...", "Built...", "Led..."
**QA tone:** "Experienced in building...", "Proficient in ensuring quality...", "Skilled at detecting..." — avoid developer language (coding, architecture, CI/CD setup).

---

### ja — 日本語

あなたはTomosia（ソフトウェア会社）のメンバーが自分自身のプロフィールを作成するのを手伝います。メンバーが日本企業・国際クライアントへ自己紹介するために使います。

**文体:** 能動的・丁寧・自然。BioにBulletは使わない。**人称代名詞を使わない:** 主語を省略した文で書く（「〜を専門としています」「〜を担当しました」）。「私」「あなた」は使わず、Bio内で氏名（〜氏は）を使わない。代名詞を避けるために受動態にしない。
**フレーズ例:** "〜に精通し..."、"〜の経験を持ち..."、"〜を専門とし..."
**QA文体:** "〜のテスト経験を持ち..."、"〜を用いた品質保証..."、"〜を活用したバグ検出..." — developer表現（コーディング、アーキテクチャ、CI/CD構築）は使わない。

---

## Bước 3 — Xuất kết quả + Lưu file

Output theo định dạng chuẩn — giữ nguyên thứ tự, không bỏ section:

```
# [Tên member]

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

**Nhãn theo ngôn ngữ output** — template trên viết bằng tiếng Việt; khi xuất en/ja thì dịch nhãn theo bảng sau, heading `Short Bio` / `Core Skills` / `Project Example` giữ nguyên:

| vi | en | ja |
|----|----|----|
| Vị trí | Position | ポジション |
| Ngày sinh | Date of birth | 生年月日 |
| Stack | Stack | 技術スタック |
| Mô tả | Description | 概要 |
| X năm | X years | X年 |
| _(chưa có — vui lòng bổ sung)_ | _(not provided — please fill in)_ | _（未記入 — ご記入ください）_ |

**Project Example:** tối đa 2 dự án, chọn tiêu biểu nhất (quy mô, kết quả đo được, stack nổi bật). Nếu có JD: ưu tiên khớp JD.
**Placeholder:** thông tin thiếu → `_(chưa có — vui lòng bổ sung)_` (en/ja dùng bản dịch ở bảng trên).

**Lưu file ngay sau khi in — KHÔNG hỏi lại.** Tên file tự sinh theo ngôn ngữ của bản đó (áp dụng cả khi `--lang` truyền từ đầu lẫn khi tạo thêm sau):
- vi: `short-bio-[ten-member-kebab]-[YYYY-MM-DD].md`
- en: `short-bio-[ten-member-kebab]-en-[YYYY-MM-DD].md`
- ja: `short-bio-[ten-member-kebab]-ja-[YYYY-MM-DD].md`

Nếu có `--output`: giữ nguyên tên user đặt (không append ngày); bản ngôn ngữ thêm sau chèn `-en` / `-ja` trước đuôi `.md`.

**Sau khi lưu**, hỏi tiếp bằng text (cùng nguyên tắc hỏi tuần tự ở Bước 1 — không dùng `AskUserQuestion`). Chỉ liệt kê các ngôn ngữ vi/en/ja chưa tạo (bản đầu là en/ja thì vẫn có option `vi`).

In ra (ví dụ sau bản vi):
```
Bạn có muốn tạo thêm bản bằng ngôn ngữ khác không? (nhập 1 số)
1. en — tạo bản tiếng Anh
2. ja — tạo bản tiếng Nhật
3. Xong (không tạo thêm)
```

→ `vi` / `en` / `ja` → gen bản ngôn ngữ đó (có humanize như bản đầu), lưu theo tên file ở trên.
→ Chỉ nhận 1 lựa chọn mỗi lần. Tạo xong bản đó → hỏi lại với các ngôn ngữ còn lại; hết ngôn ngữ thì kết thúc.

---

## Ví dụ gọi skill

# hỏi tuần tự
/generate-short-bio
  → Câu 1: Profile → Câu 2: JD → Câu 3: Match (nếu có JD)
  → Sinh bio vi → humanize → in + lưu → hỏi en/ja/xong
```
