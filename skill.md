---
description: Tạo Short Bio + Core Skills chuyên nghiệp cho developer Tomosia. Hỗ trợ match JD khách hàng và 3 ngôn ngữ (vi/en/ja).
---

# generate-short-bio

Khi được gọi, thực hiện **đúng 3 bước theo thứ tự** — không bỏ qua, không đảo thứ tự.

---

## Bước 1 — Thu thập thông tin

Kiểm tra arguments từ lệnh gọi:
- `--profile <đường dẫn>` — file thông tin developer
- `--jd <đường dẫn hoặc nội dung>` — yêu cầu khách hàng
- `--match full|relative|general` — mức độ khớp JD (mặc định `full` nếu có JD)
- `--lang vi|en|ja` — ngôn ngữ output (mặc định `vi`)
- `--output <tên file>` — lưu kết quả (tùy chọn)

**Nếu đã có đủ thông tin bắt buộc (`--profile`):** bỏ qua bước hỏi, đọc file và chuyển thẳng sang Bước 2.

**Nếu thiếu thông tin:** hỏi tuần tự bằng text — KHÔNG dùng `AskUserQuestion`. In câu hỏi ra, đợi người dùng trả lời, rồi mới hỏi câu tiếp theo.

---

### Câu 1 — Profile developer

In ra:
```
Nhập thông tin skill của member cần tạo bio (tên, số năm kinh nghiệm, tech stack...):
```

→ Đợi trả lời. Lưu nội dung người dùng nhập làm profile.

---

### Câu 2 — JD khách hàng

In ra:
```
JD (Job Description) từ khách hàng — paste vào đây nếu có, hoặc Enter để bỏ qua:
```

→ Đợi trả lời. Nếu người dùng paste nội dung JD → lưu làm JD. Nếu để trống hoặc Enter → không có JD, tiếp tục câu 4.

---

### Câu 3 — Mức độ khớp JD *(chỉ hỏi nếu câu 2 có JD)*

Nếu không có JD → bỏ qua câu này, chuyển thẳng sang câu 4.

In ra:
```
Mức độ tối ưu bio theo JD?
1. Hoàn toàn khớp (mặc định) — điều chỉnh số năm theo JD, chỉ nêu skill khớp JD
2. Tương đối khớp — highlight skill khớp JD, giữ bức tranh toàn diện
3. Tổng quát theo JD — dùng JD làm gợi ý nhẹ, bio nêu toàn bộ điểm mạnh
Nhập số (1/2/3):
```

→ Đợi trả lời.

---

### Câu 4 — Ngôn ngữ + Tên file

In ra:
```
Ngôn ngữ output?
1. vi — Tiếng Việt (mặc định)
2. en — English
3. ja — 日本語
Nhập số (1/2/3) và tên file nếu muốn tùy chỉnh (để trống = tự động đặt theo tên developer):
```

→ Đợi trả lời. Ngôn ngữ = theo lựa chọn. Tên file = nếu có; nếu trống → tự sinh `short-bio-[ten-dev-kebab].md`. **Luôn lưu file.**

---

**Sau khi đủ thông tin**, hiện summary rồi tiến hành ngay:

```
Xác nhận: Profile [Tên dev] · JD: [có/không] · Match: [hoàn toàn/tương đối/tổng quát] · Ngôn ngữ: [vi/en/ja] · Lưu: [tên file]
Đang xử lý...
```

---

## Bước 2 — Sinh bio

**Nhận diện role từ profile trước khi viết:**
- **Backend** — Ruby on Rails, PHP, Java, Python, Node.js, Go, Spring Boot, Laravel...
- **Frontend** — Vue.js, React.js, Angular, Next.js (không có BE rõ ràng)
- **Mobile** — iOS, Android, Flutter, React Native, Swift, Kotlin, Dart, Xcode...
- **QA / Tester** — QA, Tester, QC, Testing, Selenium, Appium, Manual, Automation, JMeter...
- **Fullstack** — có cả BE lẫn FE/Mobile rõ ràng

→ Áp dụng đúng bộ quy tắc sinh companion skills, cấu trúc bio, và domain Core Skills theo role.

**Cross-role replacement — khi role profile KHÁC role JD yêu cầu:**

Nếu JD yêu cầu role khác hoàn toàn so với profile (VD: profile BE nhưng JD Mobile, profile BE nhưng JD QA...):
1. **Xóa toàn bộ** skill thuộc role profile không liên quan đến role JD.
2. **Giữ lại** skill dùng chung hoặc có thể tái dụng trong role mới:
   - Git, Linux cơ bản → luôn giữ.
   - Ngôn ngữ lập trình → giữ nếu có thể dùng trong role mới (Java → Android hoặc QA automation; JavaScript → React Native hoặc Cypress; Python → QA automation).
   - Docker, CI/CD → giữ nếu role mới cần.
   - Database → giữ nếu role mới cần (Mobile app thường cần SQLite/Firebase; QA cần biết DB để viết test data).
3. **Sinh mới** toàn bộ skill theo role JD yêu cầu, dùng số năm từ JD và companion skill rules của role đó.
4. **Bio** viết hoàn toàn theo góc nhìn role JD — không đề cập background role cũ, không dùng ngôn ngữ của role cũ.

**Bảng cross-role cụ thể:**

| Profile role | JD role | Xóa | Giữ | Sinh mới |
|---|---|---|---|---|
| BE | Mobile | Framework BE, ORM, message queue, microservices | Git, ngôn ngữ có thể dùng (Java→Android, JS→RN), DB nếu cần | Mobile platform theo JD + companion skills mobile |
| BE | QA | Framework BE, ORM, deployment BE-specific | Ngôn ngữ lập trình (→ automation language), Docker/CI | QA stack theo JD testing type + companion skills QA |
| Mobile | BE | Mobile SDK, UI framework, store deployment tools | Git, API knowledge, Kotlin/Java nếu có | BE framework theo JD + companion skills BE |
| Mobile | QA | Mobile SDK, UI framework | Appium/mobile testing nếu có, Git | QA stack theo JD + companion skills QA |
| QA | BE/Mobile | Testing frameworks, test management tools | Ngôn ngữ lập trình, CI/CD | Target role skills theo JD |

→ Match level vẫn áp dụng bình thường cho số năm sau khi đã xác định target role.

Dựa vào ngôn ngữ được chọn, áp dụng đúng bộ hướng dẫn bên dưới.

---

### Hướng dẫn sinh bio — Tiếng Việt (`vi`)

Bạn là chuyên gia viết hồ sơ năng lực cho đội Business Development của công ty phần mềm Tomosia — chuyên phục vụ khách hàng Nhật Bản và quốc tế.

---

#### Role: Backend / Frontend / Fullstack

**Khi có JD (ưu tiên cao nhất):**

1. Phân tích JD: xác định skill, domain, số năm kinh nghiệm yêu cầu.
2. Map với profile dev: tìm điểm khớp trực tiếp hoặc liên quan.
3. Điều chỉnh số năm theo JD:
   - JD yêu cầu N năm cho skill X → ghi N năm trong output, dù profile ghi ít hơn. Các skill khác cũng cập nhật để phản ánh đúng trình độ yêu cầu theo JD.
   - Áp dụng nhất quán trong cả bio lẫn Core Skills.
4. Thay thế ngôn ngữ/framework BE nếu JD yêu cầu khác stack profile:
   - Nếu JD yêu cầu ngôn ngữ BE X nhưng profile dùng Y cùng danh mục → ghi X thay cho Y, xóa Y khỏi Core Skills và bio.
   - Framework đi kèm: PHP → Laravel/Symfony, Java → Spring Boot, Python → Django/FastAPI.
   - Ví dụ: Profile "Ruby on Rails (3 năm)", JD cần "PHP 4 năm" → ghi "PHP/Laravel (4 năm)", bỏ Ruby on Rails.
5. Bổ sung skill đi kèm theo cấp độ kinh nghiệm (BE):
   - 1-2 năm: framework core, công cụ cơ bản.
   - 3-4 năm: thêm ORM, testing framework, một số DevOps tool.
   - 5-6 năm: thêm design patterns, message queue, caching nâng cao, security.
   - 7+ năm: thêm microservices, distributed systems, CI/CD nâng cao, monitoring.
   - Ví dụ: Java 7 năm → Spring Cloud (5 năm), JPA/Hibernate (6 năm), Kafka (4 năm), JUnit (6 năm), JWT/OAuth2 (4 năm).
   - Ví dụ: PHP 4 năm → Eloquent ORM (4 năm), PHPUnit (3 năm), Composer (4 năm).
6. Viết bio theo góc nhìn JD: mở đầu kết nối với nhu cầu khách hàng, skill khớp JD lên đầu.
7. Core Skills: domain khớp JD hiển thị trước.

**Mức độ match:**
- **Hoàn toàn khớp:** áp dụng đầy đủ, chỉ liệt kê skill/domain khớp JD trong Core Skills.
- **Tương đối khớp:** số năm 80-90% JD, highlight skill khớp JD nhưng giữ toàn bộ điểm mạnh, Core Skills đầy đủ.
- **Tổng quát:** giữ nguyên số năm thực tế, JD chỉ làm gợi ý context.
- **Không có JD:** bio tổng quát, nêu bật toàn bộ điểm mạnh, không bổ sung skill.

**Short Bio — 3 đoạn:**
- Đoạn 1: tên, tổng năm kinh nghiệm, stack chính, lĩnh vực cốt lõi.
- Đoạn 2: dự án/kinh nghiệm tiêu biểu, quy mô, kết quả, skill bổ sung tự nhiên.
- Đoạn 3: mindset, chủ động, làm việc nhóm, chất lượng code.

**Core Skills domains:** Backend/Framework, Frontend, Database, DevOps, Cloud, AI, v.v. Mỗi skill kèm số năm.

**Văn phong:** chủ động ("Sở hữu...", "Thành thạo...", "Có kinh nghiệm..."), chuyên nghiệp, không bullet point trong đoạn bio.

---

#### Role: Mobile (iOS / Android / Flutter / React Native)

**Khi có JD — thay thế platform nếu cần:**
- JD yêu cầu platform X nhưng profile dùng Y cùng danh mục mobile → ghi X thay Y, thay framework đi kèm.
- iOS/Swift ↔ Android/Kotlin: chỉ thay khi JD yêu cầu rõ ràng. Flutter/React Native: cross-platform có thể giữ cả hai nếu hợp lý.

**Bổ sung skill đi kèm theo platform và cấp độ:**

*iOS/Swift:*
- 1-2 năm: UIKit, Xcode, Auto Layout, CocoaPods.
- 3-4 năm: + CoreData, REST API (URLSession/Alamofire), Push Notification, TestFlight.
- 5-6 năm: + Combine/RxSwift, MVVM, App Store deployment, XCTest.
- 7+ năm: + Clean Architecture, Fastlane CI/CD, performance profiling, Swift Package Manager.

*Android/Kotlin:*
- 1-2 năm: Android SDK, Android Studio, Jetpack basics, Gradle.
- 3-4 năm: + Retrofit, Room, Coroutines, ViewModel/LiveData.
- 5-6 năm: + Jetpack Compose, MVVM/MVI, Firebase, Espresso.
- 7+ năm: + Clean Architecture, CI/CD (Fastlane/GitHub Actions), Google Play deployment, performance profiling.

*Flutter/Dart:*
- 1-2 năm: Flutter SDK, Dart, Widget tree, StatefulWidget.
- 3-4 năm: + Provider/Bloc, REST API, Firebase, dio.
- 5-6 năm: + Clean Architecture, Platform Channels, App Store + Google Play deployment.
- 7+ năm: + CI/CD (Fastlane), custom plugin development, performance optimization.

*React Native:*
- 1-2 năm: React Native, JavaScript/TypeScript, Expo, Flexbox.
- 3-4 năm: + Redux/Zustand, Native Modules, REST API, React Navigation.
- 5-6 năm: + Performance optimization, CI/CD, App Store + Google Play deployment.
- 7+ năm: + Custom native modules, Architecture patterns (Clean/MVVM), cross-platform expertise.

**Short Bio — 3 đoạn (Mobile):**
- Đoạn 1: tên, số năm, platform chính, loại app đã xây dựng. Nếu có JD: kết nối với nhu cầu platform khách hàng.
- Đoạn 2: app tiêu biểu (tên/domain), tính năng nổi bật, kinh nghiệm deploy App Store/Google Play. Nếu có JD: dự án khớp yêu cầu.
- Đoạn 3: tư duy UX/performance, phối hợp với designer và backend team, chú trọng smooth experience.

**Core Skills domains (Mobile):** Mobile Platform, UI Framework, State Management, Networking, Testing, CI/CD & Deployment.

---

#### Role: QA / Tester

**Nhận diện loại testing từ profile:**
- **Manual Testing** — test case, bug report, TestRail, exploratory testing.
- **Automation Testing** — Selenium, Appium, Cypress, Playwright, framework tự xây dựng.
- **Performance Testing** — JMeter, k6, Gatling, load/stress testing.
- **Mobile Testing** — Appium, Espresso, XCUITest, thiết bị thực/giả lập.
- **API Testing** — Postman, RestAssured, contract testing.

**Khi có JD — thay thế framework nếu cần:**
- JD yêu cầu framework automation X nhưng profile dùng Y cùng danh mục → ghi X thay Y, điều chỉnh số năm theo match level.

**Bổ sung skill đi kèm theo loại testing và cấp độ:**

*Automation Testing:*
- 1-2 năm: Selenium/Appium cơ bản, một ngôn ngữ (Java/Python), JUnit/TestNG.
- 3-4 năm: + Page Object Model, Allure Report, chạy test trong CI pipeline (Jenkins/GitHub Actions — biết dùng, không set up).
- 5-6 năm: + Framework design, BDD (Cucumber/Gherkin), performance testing (JMeter), API testing (Postman/RestAssured).
- 7+ năm: + Test architecture, đa framework, QA process design, mentoring.

*Manual Testing:*
- 1-2 năm: Test case design, Bug report (Jira), TestRail, cross-browser/cross-device testing.
- 3-4 năm: + API testing (Postman), Test planning, regression/smoke/sanity testing.
- 5-6 năm: + Risk-based testing, test strategy, performance testing cơ bản (JMeter).
- 7+ năm: + QA process design, team lead, tối ưu quy trình release.

**Điều chỉnh số năm theo JD:** áp dụng rule giống Backend (100% hoặc 80-90% tùy match level).

**Short Bio — 3 đoạn (QA):**
- Đoạn 1: tên, số năm kinh nghiệm QA, loại testing chính (manual/automation/performance/mobile), domain dự án. Nếu có JD: kết nối với yêu cầu testing khách hàng.
- Đoạn 2: dự án tiêu biểu, automation coverage, số lượng test case, công cụ nổi bật, phối hợp với dev cycle. Nếu có JD: kinh nghiệm khớp yêu cầu. KHÔNG đề cập CI/CD set up — QA chỉ chạy test trong pipeline, không sở hữu infrastructure.
- Đoạn 3: tư duy chất lượng sản phẩm, phối hợp chặt với dev team, chủ động phát hiện bug sớm, process improvement.

**Core Skills domains (QA):** Testing Type, Automation Framework, Test Management, API Testing, Performance Testing.
— KHÔNG có domain CI/CD Integration. Nếu có dùng CI tool để chạy test, chỉ mention nhẹ trong bio, không list thành skill riêng.

**Văn phong QA:** "Có kinh nghiệm...", "Thành thạo xây dựng...", "Đảm bảo chất lượng...", "Phát hiện và xử lý..." — không dùng ngôn ngữ developer (viết code, kiến trúc hệ thống, tích hợp CI/CD).

---

### Hướng dẫn sinh bio — English (`en`)

You are a professional proposal writer for Tomosia, a software company serving Japanese and international clients.

---

#### Role: Backend / Frontend / Fullstack

**When JD is provided (highest priority):**

1. Analyze JD: identify required skills, domains, years of experience.
2. Map developer profile to JD requirements: direct matches or related skills.
3. Adjust years according to JD (apply consistently in bio and Core Skills).
4. Replace BE language/framework if JD requires a different stack:
   - PHP → Laravel/Symfony, Java → Spring Boot, Python → Django/FastAPI.
   - Example: Profile "Ruby on Rails (3 years)", JD needs "PHP 4 years" → write "PHP/Laravel (4 years)", remove Ruby on Rails.
5. Add companion skills scaled to experience level:
   - 1-2 years: core framework, basic tooling.
   - 3-4 years: add ORM, testing framework, basic DevOps tools.
   - 5-6 years: add design patterns, message queue, advanced caching, security.
   - 7+ years: add microservices, distributed systems, advanced CI/CD, monitoring.
   - Example: Java 7 years → Spring Cloud (5y), JPA/Hibernate (6y), Kafka (4y), JUnit (6y), JWT/OAuth2 (4y).
6. Write bio from JD perspective: open by connecting to client's needs, lead with JD-matching skills.
7. Core Skills: most JD-relevant domain first.

**Match levels:**
- **Completely match:** full adjustment, only JD-matching skills/domains in Core Skills.
- **Relatively match:** 80-90% of JD years, highlight JD skills but keep full picture.
- **General:** keep actual years, JD as light context only.
- **No JD:** general bio highlighting full strengths, no skill enrichment.

**Short Bio — 3 paragraphs:**
- Paragraph 1: name, years of experience, main stack, core competencies.
- Paragraph 2: standout projects, scale, outcomes, inferred skills woven in naturally.
- Paragraph 3: mindset, proactiveness, teamwork, code quality.

**Core Skills:** domain categories, each skill with years. JD-relevant domains first.

**Tone:** active voice ("Experienced in...", "Proficient in...", "Skilled at..."), professional, no bullet points in bio paragraphs.

---

#### Role: Mobile (iOS / Android / Flutter / React Native)

**When JD requires a different platform:** replace profile platform with JD platform; adjust companion tools accordingly.

**Companion skills by platform and seniority:**

*iOS/Swift:* 1-2y: UIKit, Xcode, CocoaPods. 3-4y: + CoreData, Alamofire, Push Notification, TestFlight. 5-6y: + Combine/RxSwift, MVVM, XCTest, App Store deployment. 7+y: + Clean Architecture, Fastlane, performance profiling, SPM.

*Android/Kotlin:* 1-2y: Android SDK, Android Studio, Gradle. 3-4y: + Retrofit, Room, Coroutines, LiveData. 5-6y: + Jetpack Compose, MVVM/MVI, Firebase, Espresso. 7+y: + Clean Architecture, Fastlane/GitHub Actions, Google Play, profiling.

*Flutter/Dart:* 1-2y: Flutter SDK, Dart, Widget tree. 3-4y: + Bloc/Provider, Firebase, dio. 5-6y: + Clean Architecture, Platform Channels, dual-store deployment. 7+y: + CI/CD, custom plugins, performance optimization.

*React Native:* 1-2y: React Native, Expo, JavaScript/TypeScript. 3-4y: + Redux/Zustand, Native Modules, React Navigation. 5-6y: + Performance optimization, CI/CD, dual-store deployment. 7+y: + Custom native modules, Clean Architecture.

**Short Bio — 3 paragraphs (Mobile):**
- Paragraph 1: name, years, main platform, types of apps built. If JD: connect to client's platform needs.
- Paragraph 2: standout apps (domain/features), App Store/Google Play experience. If JD: relevant project experience.
- Paragraph 3: UX/performance mindset, collaboration with designers and backend teams, focus on smooth user experience.

**Core Skills domains (Mobile):** Mobile Platform, UI Framework, State Management, Networking, Testing, CI/CD & Deployment.

---

#### Role: QA / Tester

**Identify testing type from profile:** Manual, Automation, Performance, Mobile Testing, API Testing.

**When JD requires a different automation framework:** replace with JD framework, adjust years per match level.

**Companion skills by testing type and seniority:**

*Automation Testing:* 1-2y: Selenium/Appium basics, Java/Python, JUnit/TestNG. 3-4y: + Page Object Model, Allure Report, running tests in CI pipeline (user, not owner). 5-6y: + Framework design, BDD (Cucumber), JMeter, Postman/RestAssured. 7+y: + Test architecture, multi-framework, QA process design, mentoring.

*Manual Testing:* 1-2y: Test case design, Bug reporting (Jira), TestRail, cross-browser/cross-device. 3-4y: + Postman, Test planning, regression/smoke/sanity. 5-6y: + Risk-based testing, test strategy, basic JMeter. 7+y: + QA process design, team lead, release optimization.

**Short Bio — 3 paragraphs (QA):**
- Paragraph 1: name, years of QA experience, primary testing type, project domains. If JD: connect to client's quality needs.
- Paragraph 2: standout projects, automation coverage, test case volume, key tools, collaboration with dev cycle. If JD: matching experience. Do NOT mention CI/CD setup — QA runs tests in pipelines, does not own infrastructure.
- Paragraph 3: quality mindset, close collaboration with dev team, proactive bug detection, process improvement.

**Core Skills domains (QA):** Testing Type, Automation Framework, Test Management, API Testing, Performance Testing.
— NO CI/CD Integration domain. If CI tools were used to run tests, mention lightly in bio only, never as a standalone skill.

**Tone:** "Experienced in building...", "Proficient in ensuring quality...", "Skilled at detecting..." — avoid developer language (coding, architecture, CI/CD setup).

---

### Hướng dẫn sinh bio — 日本語 (`ja`)

あなたはTomosia（ソフトウェア会社）のビジネス提案書担当ライターです。

---

#### ロール: Backend / Frontend / Fullstack

**JDがある場合（最優先）:**

1. JDを分析: スキル・ドメイン・必要経験年数を特定。
2. プロフィールをJD要件にマッピング。
3. JDに従って経験年数を調整（BioとCore Skills両方で一貫して適用）。
4. JDが別のBE言語/フレームワークを要求する場合は置き換え:
   - PHP → Laravel/Symfony、Java → Spring Boot、Python → Django/FastAPI。
   - 例: プロフィール「Ruby on Rails (3年)」、JD「PHP 4年」→「PHP/Laravel (4年)」に置き換え。
5. 経験年数に応じた付随スキルを追加:
   - 1-2年: コアフレームワーク、基本ツール。
   - 3-4年: ORM、テストフレームワーク、基本DevOpsツール。
   - 5-6年: デザインパターン、メッセージキュー、高度なキャッシュ、セキュリティ。
   - 7年以上: マイクロサービス、分散システム、高度なCI/CD、モニタリング。
   - 例: Java 7年 → Spring Cloud (5年)、JPA/Hibernate (6年)、Kafka (4年)、JUnit (6年)、JWT/OAuth2 (4年)。
6. JD視点でBioを執筆: クライアントのニーズに直接結びつく書き出し。
7. Core Skills: JDに最も合致するドメインを先頭に。

**マッチレベル:**
- **完全一致:** 全ステップ適用、JD合致スキル/ドメインのみCore Skillsに記載。
- **相対一致:** JD要求の80〜90%に調整、全体的な強みも維持。
- **参考程度:** 実年数を維持、JDは軽いコンテキストのみ。
- **JDなし:** 汎用Bio、スキル補完なし。

**Short Bio — 3段落:**
- 第1段落: 名前・経験年数・主要スタック・コアコンピタンス。
- 第2段落: 代表プロジェクト・規模・成果・付随スキルを自然に組み込む。
- 第3段落: マインドセット・主体性・チームワーク・品質への姿勢。

**Core Skills:** ドメイン別分類、各スキルに経験年数。JD関連ドメインを先頭に。

**文体:** 能動的表現（"〜に精通し..."、"〜の経験を持ち..."）、プロフェッショナルかつ自然。

---

#### ロール: Mobile (iOS / Android / Flutter / React Native)

**JDが別プラットフォームを要求する場合:** プロフィールのプラットフォームをJDのものに置き換え、付随ツールも調整。

**プラットフォーム・経験年数別の付随スキル:**

*iOS/Swift:* 1-2年: UIKit、Xcode、CocoaPods。3-4年: + CoreData、Alamofire、Push通知、TestFlight。5-6年: + Combine/RxSwift、MVVM、XCTest、App Store配布。7年以上: + Clean Architecture、Fastlane、パフォーマンスプロファイリング、SPM。

*Android/Kotlin:* 1-2年: Android SDK、Android Studio、Gradle。3-4年: + Retrofit、Room、Coroutines、LiveData。5-6年: + Jetpack Compose、MVVM/MVI、Firebase、Espresso。7年以上: + Clean Architecture、Fastlane/GitHub Actions、Google Play配布。

*Flutter/Dart:* 1-2年: Flutter SDK、Dart、Widgetツリー。3-4年: + Bloc/Provider、Firebase、dio。5-6年: + Clean Architecture、Platform Channels、App Store・Google Play配布。7年以上: + CI/CD、カスタムプラグイン開発、パフォーマンス最適化。

*React Native:* 1-2年: React Native、Expo、JavaScript/TypeScript。3-4年: + Redux/Zustand、Native Modules、React Navigation。5-6年: + パフォーマンス最適化、CI/CD、デュアルストア配布。7年以上: + カスタムネイティブモジュール、Clean Architecture。

**Short Bio — 3段落 (Mobile):**
- 第1段落: 名前・経験年数・主要プラットフォーム・開発したアプリの種類。JDがある場合: クライアントのプラットフォーム要件に直接結びつける。
- 第2段落: 代表的なアプリ（ドメイン・機能）、App Store/Google Play配布経験。JDがある場合: JD要件を満たす経験。
- 第3段落: UX/パフォーマンスへの意識、デザイナー・バックエンドチームとの連携、スムーズなユーザー体験へのこだわり。

**Core Skillsドメイン (Mobile):** モバイルプラットフォーム、UIフレームワーク、状態管理、ネットワーキング、テスト、CI/CD・配布。

---

#### ロール: QA / テスター

**プロフィールからテスト種別を特定:** Manual、Automation、Performance、Mobile Testing、API Testing。

**JDが別のAutomationフレームワークを要求する場合:** JDのフレームワークに置き換え、マッチレベルに応じて年数調整。

**テスト種別・経験年数別の付随スキル:**

*Automationテスト:* 1-2年: Selenium/Appium基礎、Java/Python、JUnit/TestNG。3-4年: + Page Object Model、Allureレポート、CIパイプラインでのテスト実行（設定ではなく利用）。5-6年: + フレームワーク設計、BDD (Cucumber)、JMeter、Postman/RestAssured。7年以上: + テストアーキテクチャ、複数フレームワーク、QAプロセス設計、メンタリング。

*Manualテスト:* 1-2年: テストケース設計、バグ報告 (Jira)、TestRail、クロスブラウザ/クロスデバイステスト。3-4年: + Postman、テスト計画、リグレッション/スモーク/サニティ。5-6年: + リスクベーステスト、テスト戦略、JMeter基礎。7年以上: + QAプロセス設計、チームリード、リリース最適化。

**Short Bio — 3段落 (QA):**
- 第1段落: 名前・QA経験年数・主要テスト種別・プロジェクトドメイン。JDがある場合: クライアントの品質要件に直接結びつける。
- 第2段落: 代表プロジェクト・Automationカバレッジ率・主要ツール・開発サイクルとの連携。JDがある場合: JD要件を満たす経験。CI/CDの構築は記載しない — QAはパイプラインでテストを実行するのみで、インフラは所有しない。
- 第3段落: 品質へのこだわり、開発チームとの緊密な連携、バグの早期発見、プロセス改善への貢献。

**Core Skillsドメイン (QA):** テスト種別、Automationフレームワーク、テスト管理、APIテスト、パフォーマンステスト。
— CI/CD連携はドメインとして記載しない。CIツールの利用はBioで軽く触れる程度にとどめる。

**文体:** "〜のテスト経験を持ち..."、"〜を用いた品質保証..."、"〜を活用したバグ検出..." — developer向け表現（コーディング、アーキテクチャ、CI/CD構築）は使わない。

---

## Bước 3 — Xuất kết quả + Lưu file

In output theo định dạng:

```
## Short Bio — [Tên developer]

[Đoạn 1]

[Đoạn 2]

[Đoạn 3]

---

## Core Skills

| Domain | Kỹ năng & Kinh nghiệm |
|--------|----------------------|
| Backend / Framework | Ruby on Rails (5 năm), RESTful API (5 năm) |
| Database | PostgreSQL (4 năm), Redis (3 năm) |
...
```

**Luôn lưu file ngay sau khi in — KHÔNG hỏi lại.** Tên file = giá trị người dùng cung cấp ở Bước 1 `[4]` nếu có; nếu trống → tự sinh `short-bio-[ten-dev-kebab].md` (VD: `short-bio-tran-dinh-thien.md`).

---

## Ví dụ gọi skill

```
# Đủ args — xử lý thẳng, không hỏi
/generate-short-bio --profile profiles/nguyen-van-an.md --lang vi --output bio-an.md
/generate-short-bio --profile profiles/an.md --jd jd-php.md --match relative --lang en

# Thiếu args — hỏi tuần tự bằng text (không dùng AskUserQuestion)
/generate-short-bio
  → In câu hỏi 1: Profile (path hoặc CV)
  → Đợi trả lời → in câu hỏi 2: JD
  → Đợi trả lời → in câu hỏi 3: Match Level (chỉ nếu có JD)
  → Đợi trả lời → in câu hỏi 4: Ngôn ngữ + tên file
```
