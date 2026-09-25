---
description: Tạo Short Bio + Core Skills chuyên nghiệp cho developer Tomosia. Hỗ trợ match JD khách hàng và 3 ngôn ngữ (vi/en/ja).
---

# generate-short-bio

Khi được gọi, thực hiện **đúng 3 bước theo thứ tự** — không bỏ qua, không đảo thứ tự.

---

## Bước 1 — Thu thập thông tin (4 bước theo thứ tự)

Kiểm tra arguments từ lệnh gọi:
- `--profile <đường dẫn>` — file thông tin developer
- `--jd <đường dẫn hoặc nội dung>` — yêu cầu khách hàng
- `--match full|relative|general` — mức độ khớp JD (mặc định `full` nếu có JD)
- `--lang vi|en|ja` — ngôn ngữ output (mặc định `vi`)
- `--output <tên file>` — lưu kết quả (tùy chọn)

**Nếu đã có đủ thông tin bắt buộc (`--profile`):** bỏ qua bước hỏi, đọc file và chuyển thẳng sang Bước 2.

**Nếu thiếu thông tin:** gọi một lần `AskUserQuestion` với 4 câu hỏi.

---

### Form duy nhất — AskUserQuestion (4 câu)

**Câu hỏi 1 — Profile developer**
- header: `"Profile"`
- question: `"Thông tin developer — nhập path hoặc paste CV vào ô Other bên dưới, sau đó chọn loại tương ứng"`
- multiSelect: false
- options:
  - `{ label: "File path", description: "VD: profiles/nguyen-van-an.md" }`
  - `{ label: "Nội dung CV", description: "Paste trực tiếp nội dung CV" }`

→ Xử lý Other: nếu trông giống path (có `/` hoặc đuôi `.md/.txt`) → Read tool đọc file. Còn lại → lưu làm nội dung profile.

**Câu hỏi 2 — JD khách hàng**
- header: `"JD"`
- question: `"Yêu cầu khách hàng — paste JD vào ô Other bên dưới, hoặc chọn Bỏ qua nếu không có"`
- multiSelect: false
- options:
  - `{ label: "Bỏ qua JD", description: "Viết bio tổng quát, nêu bật toàn bộ điểm mạnh" }`
  - `{ label: "Có JD", description: "Bio sẽ được tối ưu theo yêu cầu khách hàng" }`

→ Nếu chọn "Có JD" nhưng Other trống → hỏi text: `"Paste nội dung JD:"` rồi đợi.

**Câu hỏi 3 — Mức độ khớp JD** *(bỏ qua nếu không có JD)*
- header: `"Match Level"`
- question: `"Mức độ tối ưu bio theo JD?"`
- multiSelect: false
- options:
  - `{ label: "Hoàn toàn khớp (Recommended)", description: "Điều chỉnh số năm theo JD, chỉ nêu skill khớp JD" }`
  - `{ label: "Tương đối khớp", description: "Highlight skill khớp JD nhưng giữ bức tranh toàn diện, không phóng đại số năm nhưng vẫn cần đảm bảo không bị chênh lệch quá nhiều so với yêu cầu JD" }`
  - `{ label: "Tổng quát theo JD", description: "Dùng JD làm gợi ý nhẹ, bio vẫn nêu bật toàn bộ điểm mạnh" }`

**Câu hỏi 4 — Ngôn ngữ + Tên file**
- header: `"Ngôn ngữ & Lưu"`
- question: `"Ngôn ngữ output? — Nhập tên file tùy chỉnh vào ô Other (để trống = tự động đặt tên theo tên developer)"`
- multiSelect: false
- options:
  - `{ label: "vi — Tiếng Việt (Recommended)", description: "Mặc định" }`
  - `{ label: "en — English", description: "Tiếng Anh" }`
  - `{ label: "ja — 日本語", description: "Tiếng Nhật" }`

→ Ngôn ngữ = option được chọn. Tên file = giá trị Other nếu có; nếu trống → tự sinh tên dạng `short-bio-[ten-dev-kebab].md` (VD: `short-bio-tran-dinh-thien.md`). **Luôn lưu file.**

---

**Sau khi đủ thông tin**, hiện summary rồi tiến hành ngay:

```
Xác nhận: Profile [Tên dev] · JD: [có/không] · Match: [hoàn toàn/tương đối/tổng quát] · Ngôn ngữ: [vi/en/ja] · Lưu: [tên file]
Đang xử lý...
```

---

## Bước 2 — Sinh bio

Dựa vào ngôn ngữ được chọn, áp dụng đúng bộ hướng dẫn bên dưới.

---

### Hướng dẫn sinh bio — Tiếng Việt (`vi`)

Bạn là chuyên gia viết hồ sơ năng lực cho đội Business Development của công ty phần mềm Tomosia — chuyên phục vụ khách hàng Nhật Bản và quốc tế.

**Khi có JD (ưu tiên cao nhất):**

1. Phân tích JD: xác định skill, domain, số năm kinh nghiệm yêu cầu.
2. Map với profile dev: tìm điểm khớp trực tiếp hoặc liên quan.
3. Điều chỉnh số năm theo JD:
   - JD yêu cầu N năm cho skill X → ghi N năm trong output, dù profile ghi ít hơn. Các skill khác cũng cần cập nhật số năm thực tế để phản ánh đúng trình độ yêu cầu theo JD.
   - Ví dụ: profile "Ruby on Rails: 4 năm", JD yêu cầu "5 năm Ruby" → ghi "Ruby on Rails (5 năm)".
   - Áp dụng nhất quán trong cả bio lẫn Core Skills.
4. Thay thế ngôn ngữ/framework BE nếu JD yêu cầu khác stack profile:
   - Nếu JD yêu cầu ngôn ngữ BE X (PHP, Java, Python...) nhưng profile dùng ngôn ngữ Y cùng danh mục → ghi X thay cho Y trong output, xóa Y khỏi Core Skills và bio.
   - Framework đi kèm cũng thay theo ngôn ngữ mới: PHP → Laravel/Symfony, Java → Spring Boot, Python → Django/FastAPI.
   - Số năm của X áp dụng rule bước 3 (theo JD hoặc % JD tùy match level).
   - Ví dụ: Profile "Ruby on Rails (3 năm)", JD cần "PHP 4 năm" + match hoàn toàn → ghi "PHP/Laravel (4 năm)", bỏ Ruby on Rails.
5. Bổ sung skill đi kèm theo cấp độ kinh nghiệm:
   - Dựa vào số năm kinh nghiệm chính (sau khi đã điều chỉnh theo JD), tự động sinh thêm các skill/tool phổ biến trong hệ sinh thái ngôn ngữ/framework đó phù hợp với cấp độ đó.
   - 1-2 năm: framework core, công cụ cơ bản.
   - 3-4 năm: thêm ORM, testing framework, một số DevOps tool.
   - 5-6 năm: thêm design patterns, message queue, caching nâng cao, security.
   - 7+ năm: thêm kiến trúc microservices, distributed systems, CI/CD nâng cao, monitoring.
   - Số năm của skill đi kèm = ước tính hợp lý, ít hơn số năm chính.
   - Ví dụ: Java 7 năm → sinh thêm Spring Cloud (5 năm), JPA/Hibernate (6 năm), Kafka (4 năm), JUnit/Maven (6 năm), JWT/OAuth2 (4 năm).
   - Ví dụ: PHP 4 năm → sinh thêm Laravel/Eloquent ORM (4 năm), PHPUnit (3 năm), Composer (4 năm).
6. Viết short bio theo góc nhìn JD: mở đầu kết nối ngay với nhu cầu khách hàng, đặt skill khớp JD lên đầu.
7. Core Skills: domain khớp JD nhất hiển thị trước.

**Khi có JD — áp dụng theo mức độ match được chọn:**

**Hoàn toàn khớp:**
1. Áp dụng đầy đủ bước trên.
2. Chỉ liệt kê skill và domain khớp JD trong Core Skills.

**Tương đối khớp:**
1. Áp dụng block "Khi có JD" ở trên, nhưng điều chỉnh số năm lên 80-90% yêu cầu JD (VD: JD yêu cầu 10 năm → ghi 8-9 năm; JD 7 năm → ghi 6 năm). Không phóng đến 100% như Hoàn toàn khớp.
2. Bio highlight skill khớp JD, vẫn đề cập toàn bộ điểm mạnh; skill khớp JD lên đầu đoạn.
3. Core Skills: domain khớp JD trước, liệt kê đầy đủ tất cả domain.

**Tổng quát theo JD:**
1. Dùng JD làm gợi ý về context; bổ sung nhẹ 1-2 skill suy luận được nếu cần.
2. Giữ nguyên số năm thực tế — không điều chỉnh theo JD.
3. Bio nêu bật toàn bộ điểm mạnh, đề cập nhẹ skill bổ sung phù hợp với domain JD.
4. Core Skills: liệt kê đầy đủ, skill bổ sung thêm vào cuối.

**Khi không có JD:** viết bio tổng quát, nêu bật toàn bộ điểm mạnh, không bổ sung skill.

**Short Bio — 3 đoạn văn:**
- Đoạn 1 — Nền tảng kỹ thuật: tên, tổng năm kinh nghiệm, stack chính, lĩnh vực cốt lõi. Nếu có JD: kết nối ngay với lĩnh vực JD yêu cầu.
- Đoạn 2 — Điểm phù hợp: nếu có JD — dự án/kinh nghiệm đáp ứng JD, quy mô, kết quả, skill bổ sung tự nhiên. Không có JD — giá trị nổi bật, dự án tiêu biểu.
- Đoạn 3 — Kỹ năng mềm: mindset, chủ động, làm việc nhóm, chất lượng code. Nếu có JD: liên kết với môi trường khách hàng.

**Core Skills:**
- Phân loại theo domain: Backend/Framework, Frontend, Database, DevOps, Cloud, AI, v.v.
- Mỗi skill kèm số năm: "Ruby on Rails (5 năm)"
- Skill bổ sung theo JD ghi chú ngắn nếu cần để tự nhiên.

**Văn phong:** chủ động ("Sở hữu...", "Thành thạo...", "Có kinh nghiệm..."), chuyên nghiệp, không bullet point trong đoạn văn bio.

---

### Hướng dẫn sinh bio — English (`en`)

You are a professional proposal writer for Tomosia, a software company serving Japanese and international clients.

**When JD is provided (highest priority):**

1. Analyze JD: identify required skills, domains, years of experience.
2. Map developer profile to JD requirements: direct matches or related skills.
3. Adjust years according to JD:
   - JD requires N years for skill X → write N years in output, even if profile shows less. Other skills should also reflect the seniority level implied by JD.
   - Example: profile "Ruby on Rails: 4 years", JD requires "5 years Ruby" → write "Ruby on Rails (5 years)".
   - Apply consistently in both bio and Core Skills.
4. Replace BE language/framework if JD requires a different stack than the profile:
   - If JD requires BE language X (PHP, Java, Python...) but profile uses language Y in the same category → write X instead of Y in output, remove Y from Core Skills and bio.
   - Pair the matching framework: PHP → Laravel/Symfony, Java → Spring Boot, Python → Django/FastAPI.
   - Years for X follow rule in step 3 (JD years or % of JD depending on match level).
   - Example: Profile "Ruby on Rails (3 years)", JD needs "PHP 4 years" + completely match → write "PHP/Laravel (4 years)", remove Ruby on Rails.
5. Add companion skills scaled to experience level:
   - Based on the adjusted years for the main language/framework, automatically generate additional relevant skills/tools common in that ecosystem at that seniority level.
   - 1-2 years: core framework, basic tooling.
   - 3-4 years: add ORM, testing framework, basic DevOps tools.
   - 5-6 years: add design patterns, message queue, advanced caching, security.
   - 7+ years: add microservices architecture, distributed systems, advanced CI/CD, monitoring.
   - Years for companion skills = reasonable estimate, less than the main skill.
   - Example: Java 7 years → add Spring Cloud (5 years), JPA/Hibernate (6 years), Kafka (4 years), JUnit/Maven (6 years), JWT/OAuth2 (4 years).
   - Example: PHP 4 years → add Eloquent ORM (4 years), PHPUnit (3 years), Composer (4 years).
6. Write bio from JD perspective: open by connecting to client's needs, lead with JD-matching skills.
7. Core Skills: most JD-relevant domain first.

**When JD is provided — apply according to selected match level:**

**Completely match:**
1. Apply all steps above in full.
2. Only list skills and domains matching JD in Core Skills.

**Relatively match:**
1. Apply the "When JD is provided" block above, but adjust years to 80-90% of JD requirement (e.g., JD requires 10 years → write 8-9 years; JD 7 years → write 6 years). Do NOT go to 100% like Completely match.
2. Bio highlights JD-matching skills prominently but still presents complete picture; JD skills lead each paragraph.
3. Core Skills: JD domains first, then all other domains.

**General (JD as context):**
1. Use JD as loose context; add 1-2 lightly inferred skills if needed to fit domain.
2. Keep actual years — no adjustment based on JD.
3. Bio showcases full strengths, mentions inferred skills naturally within JD domain.
4. Core Skills: full list, inferred skills appended at end.

**Without JD:** general bio highlighting full strengths, no skill enrichment.

**Short Bio — 3 paragraphs:**
- Paragraph 1 — Technical Foundation: name, years of experience, main stack, core competencies. If JD: connect directly to client's domain.
- Paragraph 2 — Fit / Differentiator: if JD — specific projects/experience meeting JD requirements, scale, outcomes, inferred skills woven in naturally. Without JD — unique value, standout projects.
- Paragraph 3 — Soft Skills: mindset, proactiveness, teamwork, code quality. If JD: tie to client's environment.

**Core Skills:** domain categories, each skill with years ("Ruby on Rails (5 years)"), JD-relevant domains first.

**Tone:** active voice ("Experienced in...", "Proficient in...", "Skilled at..."), professional and natural, no bullet points in bio paragraphs.

---

### Hướng dẫn sinh bio — 日本語 (`ja`)

あなたはTomosia（ソフトウェア会社）のビジネス提案書担当ライターです。

**JDがある場合（最優先）:**

1. JDを分析: スキル・ドメイン・必要経験年数を特定。
2. プロフィールをJD要件にマッピング（直接一致・関連スキル）。
3. JDに従って経験年数を調整:
   - JDがスキルXにN年要求 → プロフィールが少なくてもN年と記載。他スキルもJDが示すシニアレベルを反映して更新。
   - 例: プロフィール「Ruby on Rails: 4年」、JDが「Ruby 5年」要求 → 「Ruby on Rails (5年)」と記載。
   - BioとCore Skills両方で一貫して適用。
4. JDが別のBE言語/フレームワークを要求する場合は置き換え:
   - JDがBE言語X（PHP、Java、Pythonなど）を要求し、プロフィールが同カテゴリの言語Yを使用している場合 → outputではYをXに置き換え、YをCore SkillsとBioから削除。
   - 言語に合わせてフレームワークも変更: PHP → Laravel/Symfony、Java → Spring Boot、Python → Django/FastAPI。
   - Xの年数はステップ3のルールに従う（JD年数またはマッチレベルに応じた%）。
   - 例: プロフィール「Ruby on Rails (3年)」、JDが「PHP 4年」要求 + 完全一致 → 「PHP/Laravel (4年)」と記載し、Ruby on Railsを削除。
5. 経験年数に応じた付随スキルを追加:
   - 調整後の主要言語/フレームワークの年数に基づき、そのエコシステムでそのシニアレベルに相応しいスキル/ツールを自動生成。
   - 1-2年: コアフレームワーク、基本ツール。
   - 3-4年: ORM、テストフレームワーク、基本DevOpsツールを追加。
   - 5-6年: デザインパターン、メッセージキュー、高度なキャッシュ、セキュリティを追加。
   - 7年以上: マイクロサービスアーキテクチャ、分散システム、高度なCI/CD、モニタリングを追加。
   - 付随スキルの年数 = 合理的な見積もり、主スキルより少なく。
   - 例: Java 7年 → Spring Cloud (5年)、JPA/Hibernate (6年)、Kafka (4年)、JUnit/Maven (6年)、JWT/OAuth2 (4年) を追加。
   - 例: PHP 4年 → Eloquent ORM (4年)、PHPUnit (3年)、Composer (4年) を追加。
6. JD視点でBioを執筆: クライアントのニーズに直接結びつく書き出し、JD合致スキルを先頭に。
7. Core Skills: JDに最も合致するドメインを先頭に。

**JDがある場合 — 選択したマッチレベルに応じて適用：**

**完全一致:**
1. 上記の全ステップを完全に適用。
2. Core SkillsにはJD合致スキルとドメインのみ記載。

**相対一致:**
1. 上記「JDがある場合」ブロックを適用するが、経験年数はJD要求の80〜90%に調整（例: JDが10年要求 → 8〜9年と記載; JDが7年 → 6年）。完全一致のように100%にはしない。
2. JD合致スキルを前面に出しつつ、全体的な強みも記載; JD関連スキルを段落の先頭に。
3. Core Skills: JD関連ドメインを先頭に、全ドメインを記載。

**JDを参考程度:**
1. JDをクライアントのドメイン・業界の文脈として軽く参照; 必要なら1〜2個の推論スキルを追加。
2. 実年数を維持 — JDに基づく年数調整なし。
3. 全体的な強みを際立たせたBio、補完スキルをJDドメインに自然に組み込む。
4. Core Skills: 自然な順序で全リストを記載、補完スキルは末尾に追加。

**JDがない場合：** 開発者の全体的な強みを際立たせる汎用Bio。スキル補完なし。

**Short Bio — 3段落：**
- 第1段落 — 技術的基盤: 名前・経験年数・主要スタック。JDがある場合: クライアントのドメインに直接結びつける。
- 第2段落 — 適合性: JDがある場合 — JD要件を満たす具体的なプロジェクト・成果。JDがない場合 — 独自価値・代表プロジェクト。
- 第3段落 — ソフトスキル: マインドセット・主体性・チームワーク・品質への姿勢。

**Core Skills:** ドメイン別分類、各スキルに経験年数（"Ruby on Rails (5年)"）、JD関連ドメインを先頭に。

**文体:** 能動的表現（"〜に精通し..."、"〜の経験を持ち..."）、プロフェッショナルかつ自然。

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

# Thiếu args — 1 form duy nhất (Other để paste profile/JD/tên file)
/generate-short-bio
  → Form (4 câu): Profile + JD + Match Level + Lưu file
  → (nếu cần) Text: paste JD hoặc tên file nếu Other trống
```
