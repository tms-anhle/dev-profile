# generate-short-bio — Use cases

Spec flow đã chốt (2026-10-21) — `SKILL.md` triển khai theo tài liệu này. Sửa flow thì sửa tài liệu này trước.

Use case được xác định bởi 3 điều kiện đầu vào:
- **Nguồn thông tin:** form nhập tay · file / link CV (paste ở Câu 1, hoặc gõ kèm lệnh `/generate-short-bio [link CV | thông tin member]` — bỏ bước in form). Skill không nhận flag.
- **Mức độ chi tiết:** chi tiết · sơ sài
- **JD:** không có · có

Output luôn chỉ là file bio (vi mặc định; en / ja khi member yêu cầu) — không tạo file profile hay file trung gian.

---

## 1. Thứ tự xử lý chung

Mọi use case đi theo cùng một thứ tự. Use case chỉ khác nhau ở cách thực hiện từng bước.

```
1. Lấy thông tin      form (Câu 1) · đọc CV
2. Bổ sung / xác nhận  hỏi field bắt buộc còn thiếu · hỏi bổ sung dự án nếu sơ sài · CV: in tóm tắt, không chờ "ok"
3. Kiểm tra role       role ↔ stack
4. JD                  Câu 2
5. Mức match           Câu 3 (chỉ khi có JD)
6. Sinh bio            mapping JD (nếu có) → viết → humanize
7. In + lưu file bio   trùng tên → hỏi ghi đè / tạo mới
8. Nhắc thông tin thiếu → kết thúc (bản en / ja chỉ tạo khi member yêu cầu)
```

Bước 2 gồm nhiều việc nhưng **gộp tối đa vào 1 lượt hỏi** khi có thể (VD: form thiếu field bắt buộc + chưa có dự án → hỏi cùng 1 lượt, lượt này tính là lần hỏi bổ sung duy nhất).

---

## 2. Phân loại mức độ chi tiết

Đánh giá ở bước 2, sau khi có thông tin thô, áp dụng cho form và CV.

| Mức độ | Tiêu chí | Ví dụ |
|---|---|---|
| **Chi tiết** | Có ít nhất 1 dự án kèm mô tả: sản phẩm làm gì, vai trò hoặc stack dùng. Kết quả, số liệu là điểm cộng, không bắt buộc. | "Zext — hệ thống cloud cho công ty kế toán Nhật, ReactJS, team 6 người, làm basic design → implementation" |
| **Sơ sài** | Chỉ có 4 field bắt buộc (có thể kèm email, ngày sinh, domain), **hoặc** dự án chỉ có tên, không mô tả. | "Nguyễn Văn A, Frontend, 3 năm, React, Vue" |

---

## 3. Bảng use case

| Nguồn | Mức độ | Không kèm JD | Kèm JD |
|---|---|---|---|
| Form nhập tay | Chi tiết | **UC1** | **UC2** |
| Form nhập tay | Sơ sài | **UC3** | **UC4** |
| File / link CV | Chi tiết | **UC5** | **UC6** |
| File / link CV | Sơ sài | **UC7** | **UC8** |

---

## 4. Use case — Form nhập tay

### UC1 — Form chi tiết, không kèm JD

**Điều kiện:** nhập đủ 4 field bắt buộc + dự án có mô tả. Câu 2 trả lời `skip`.

**Luồng xử lý:**
1. Câu 1: in form, member nhập.
2. Validate 4 field (thiếu → chỉ hỏi đúng field thiếu, không nhắc lại thông tin đã nhập).
3. Kiểm tra role với stack.
4. Câu 2: `skip`, không hỏi mức match.
5. Sinh bio → humanize → in → lưu file → nhắc thông tin thiếu.

**Output:**
- **Short Bio, 3 đoạn:**
  - Đoạn 1: role, số năm, stack chính, domain.
  - Đoạn 2: kinh nghiệm tổng hợp qua các dự án (loại sản phẩm, domain, quy mô, kết quả) — không xoáy vào hay gọi tên một dự án cụ thể.
  - Đoạn 3: cách làm việc rút ra từ vai trò trong các dự án.
  - Nêu bật điểm mạnh theo Core Skills, ngôn ngữ tự nhiên, chỉ dùng thông tin đưa vào.
- **Core Skills:** đúng skill và số năm member nhập. Không thêm skill đi kèm.
- **Số năm:** giữ nguyên thực tế.
- **Project Examples:** tạo từ dự án member nhập (mục 6).

### UC2 — Form chi tiết, kèm JD

**Điều kiện:** như UC1, có JD (paste ở Câu 2).

**Luồng xử lý:**
1. Câu 1 → validate → kiểm tra role.
2. Câu 2: paste JD.
3. Câu 3: chọn mức match 1/2/3.
4. Mapping với JD:
   - Tìm skill khớp.
   - Số năm chỉ nâng, không hạ: `max(thực tế, mốc theo mức match)`.
   - Thay stack cùng loại nếu JD yêu cầu (áp dụng cho Core Skills và Short Bio, xem *Stack khi có JD*).
   - Bổ sung skill đi kèm theo số năm.
   - JD ghi số năm cho một skill member chưa có (VD "3 năm AWS") → mức 1/2 thêm skill với số năm theo mức match, mức 3 không thêm (Q12).
   - Skill thêm theo JD mà member chưa có → liệt kê trong khối nhắc (mục 8).
   - Role JD khác role member → cross-role.
5. Sinh bio → humanize → in → lưu bio → nhắc thông tin thiếu.

**Output:**
- **Short Bio, 3 đoạn:** đoạn 1 mở đầu kết nối nhu cầu JD; đoạn 2 ưu tiên kinh nghiệm khớp JD (gom theo mảng sản phẩm, không gọi tên dự án). Nêu bật điểm mạnh theo Core Skills **và yêu cầu JD**, ngôn ngữ tự nhiên.
- **Core Skills:** skill member + skill bổ sung khớp JD. Domain khớp JD lên trước. Phạm vi theo mức match:
  - **Hoàn toàn khớp:** chỉ skill khớp JD.
  - **Tương đối:** highlight skill khớp, giữ điểm mạnh khác.
  - **Tổng quát:** JD là gợi ý nhẹ.
- **Project Examples:** mục 6, ưu tiên dự án khớp JD.

**Stack khi có JD (áp dụng cho UC2/4/6/8):**

| Phần | Stack ghi |
|---|---|
| Core Skills | Theo JD (đã thay stack cùng loại) |
| Short Bio (năng lực tổng hợp, không kể riêng dự án) | Theo JD |
| Short Bio, câu gắn stack với loại sản phẩm / domain đã làm | Stack thật |
| Project Examples | Stack thật của dự án (Q10) |

Lý do: dự án là thông tin cụ thể mà khách có thể hỏi lại. Phần điều chỉnh theo JD nằm ở năng lực tổng quát.

### UC3 — Form sơ sài, không kèm JD

**Điều kiện:** chỉ nhập 4 field bắt buộc (hoặc dự án chỉ có tên). Câu 2 `skip`.

**Luồng xử lý:**
1. Câu 1 → validate.
2. **Hỏi bổ sung 1 lần (tùy chọn)** — nêu đích danh phần còn thiếu:
   - Không có dự án:
     ```
     Bổ sung 1-2 dự án (tên, thời gian, vai trò, mô tả, tính năng, tech stack) hoặc gõ "skip":
     ```
   - Dự án chỉ có tên:
     ```
     Bổ sung mô tả cho Labofi, QLEAR (thời gian, vai trò, mô tả, tính năng, tech stack) hoặc gõ "skip":
     ```
   - Member bổ sung → đánh giá lại → đủ chi tiết thì chuyển sang **UC1**.
   - Member `skip` → tiếp tục UC3.
3. Kiểm tra role.
4. Câu 2: `skip`.
5. Sinh bio sơ sài → humanize → in → lưu bio → nhắc thông tin thiếu.

**Output:**
- **Short Bio, 2 đoạn** (Q1). Không bịa dự án, kết quả hay cách làm việc.
  - Đoạn 1: role, số năm, stack chính, domain (nếu có).
  - Đoạn 2: điểm mạnh theo nhóm Core Skills, viết tự nhiên. VD: "Làm việc chủ yếu với React và Vue, quen tổ chức state bằng Redux/Pinia và tích hợp REST API." Chỉ nêu skill member đã nhập.
- **Core Skills:** đúng skill member nhập. Không có số năm từng skill → skill chính của role ghi bằng tổng số năm, skill khác để `_… năm/tháng_` cho member tự điền (Q2).
- **Project Examples:** có ghi tên dự án → vẫn tạo, field thiếu để placeholder. Không ghi dự án nào → không sinh section (mục 6).

### UC4 — Form sơ sài, kèm JD

**Điều kiện:** như UC3, có JD.

**Luồng xử lý:**
1. Câu 1 → validate → hỏi bổ sung 1 lần (như UC3 bước 2). Đủ chi tiết thì chuyển sang **UC2**.
2. Kiểm tra role.
3. JD → mức match → mapping (như UC2 bước 2–4).
4. Sinh bio → humanize → in → lưu → nhắc thông tin thiếu.

**Output:**
- **Short Bio, 2 đoạn** (Q1). Không bịa dự án.
  - Đoạn 1: kết nối nhu cầu JD với role, số năm, stack.
  - Đoạn 2: điểm mạnh theo skill khớp JD, kể cả skill bổ sung từ mapping.
- **Core Skills:** như UC2 (có skill bổ sung theo JD).
- **Project Examples:** như UC3.

---

## 5. Use case — File / link CV

**Đầu vào hỗ trợ:**
- **Cách đưa CV:** paste link / đường dẫn file ở Câu 1.
- **Link:** Google Docs, Sheets, Drive, URL PDF/DOCX.
- **File:** PDF, DOCX, XLSX, TXT, MD. Ảnh / PDF scan: đọc bằng vision (Q5).

**Các bước chung khi đọc CV (cho UC5–UC8):**
1. **Lấy thông tin:** đọc CV → trích theo các field của form.
   - **Bỏ qua:** học vấn, bằng cấp, chứng chỉ trường học, trình độ ngoại ngữ, giới tính, số điện thoại, địa chỉ, ảnh, lương, sở thích.
   - **Số năm kinh nghiệm:** CV không ghi rõ thì tính từ công việc IT đầu tiên đến nay.
   - **Năm dùng từng skill:** suy từ thời gian các dự án.
   - **Thời gian dự án:** ưu tiên mốc tháng/năm (VD `06/2026 – now`). Mốc và số tháng ghi trong CV mâu thuẫn nhau → dùng mốc tháng/năm, nêu trong "Lưu ý" của tóm tắt.
2. **Tóm tắt — không chờ xác nhận:** in tóm tắt rồi đi tiếp ngay, không hỏi `ok`:
   ```
   Thông tin đọc từ CV:
   - Tên: [...]
   - Role: [...]  (CV không ghi chức danh — suy từ stack)
   - Số năm kinh nghiệm: [...]
   - Tech stack: [...]
   - Email: [... | chưa có]
   - Ngày sinh: [... | chưa có]
   - Domain: [... | chưa có]
   - Dự án: [tên 1] (06/2026 – nay), [tên 2] (12/2025 – 05/2026)...

   Lưu ý:
   - Medical Stock: CV ghi "06/2026 – now" nhưng thời lượng ghi "8 months" — dùng mốc tháng/năm.
   - [Tên dự án] chưa có mô tả.

   Cần sửa / bổ sung thì nhắn kèm câu trả lời tiếp theo.
   ```
   - Mục "Lưu ý" chỉ hiện khi có vấn đề (thời gian mâu thuẫn, dự án thiếu mô tả / vai trò, CV không có dự án).
   - Thời gian mâu thuẫn → tự dùng mốc tháng/năm. Thiếu thông tin dự án → không hỏi bổ sung, đánh giá mức độ với thông tin hiện có.
   - **Ngoại lệ:** thiếu field bắt buộc → dừng, hỏi đúng field còn thiếu rồi mới đi tiếp.
   - Câu hỏi kế tiếp (Câu 2 / Câu 3) in luôn cùng lượt với tóm tắt. Member trả lời kèm phần sửa / bổ sung → merge vào thông tin member (lưu ở bước cuối cùng file bio), rồi xử lý tiếp.
3. **Kiểm tra role.**

**Biến thể:** vừa đưa link CV vừa gõ thêm thông tin → đọc CV, phần gõ tay ưu tiên khi trùng field.

### UC5 — CV chi tiết, không kèm JD
- **Luồng:** các bước đọc CV → Câu 2 `skip` → sinh bio như **UC1**.
- **Output:** như UC1. CV thường có nhiều dự án và skill hơn form, nên chọn lọc điểm mạnh nổi bật nhất. Project Examples lấy từ dự án trong CV (mục 6).

### UC6 — CV chi tiết, kèm JD
- **Luồng:** các bước đọc CV → JD → mức match → mapping → sinh bio như **UC2**.
- **Output:** như UC2. Dự án chọn theo mức khớp JD.

### UC7 — CV sơ sài, không kèm JD
- **Luồng:** các bước đọc CV (mục "Lưu ý" nêu thiếu dự án, không hỏi bổ sung). Member nhắn bổ sung kèm câu trả lời Câu 2 → đánh giá lại, đủ thì như **UC5**; không → Câu 2 `skip` → sinh bio như **UC3**.
- **Output:** như UC3.

### UC8 — CV sơ sài, kèm JD
- **Luồng:** như UC7, sau đó JD → mức match → mapping → sinh bio như **UC4**.
- **Output:** như UC4.

---

## 6. Project Examples

### Khi nào tạo

| Đầu vào | Có sinh section Project Examples? |
|---|---|
| Form có nhập dự án (kể cả chỉ có tên) | Có |
| Form không nhập dự án | **Không** — bỏ hẳn section khỏi file output |
| CV có dự án / kinh nghiệm làm việc theo dự án | Có |
| CV không có thông tin dự án nào | Không, và nêu trong mục "Lưu ý" của tóm tắt CV |

Số dự án: 1–2 (Q8), chọn tiêu biểu nhất:
- Không JD: ưu tiên dự án gần đây, có kết quả, quy mô lớn.
- Có JD: ưu tiên dự án khớp JD.

### Format

```
## Project Examples

### Project 1 — [Tên dự án]
**Thời gian:** [X tháng / X năm Y tháng]
**Vị trí:** [Vai trò trong dự án]
**Mô tả:** [2-3 câu: sản phẩm làm gì, cho ai, giá trị chính]
**Tính năng chính:**
- [Tính năng 1]
- [Tính năng 2]
- [Tính năng 3]
**Tech Stack:** [Stack của dự án]

### Project 2 — [Tên dự án]
...
```

Nhãn trên là bản vi; bản en / ja dịch nhãn theo Q11.

Ví dụ (dự án giả định):

```
### Project 1 — ShopNow
**Thời gian:** 10 tháng
**Vị trí:** Frontend Developer
**Mô tả:** Website thương mại điện tử bán đồ gia dụng cho khách hàng tại Nhật. Người dùng tìm kiếm sản phẩm, đặt hàng và theo dõi đơn hàng trên cùng một hệ thống.
**Tính năng chính:**
- Tìm kiếm và lọc sản phẩm
- Giỏ hàng và thanh toán
- Theo dõi trạng thái đơn hàng
**Tech Stack:** NuxtJS, Pinia, Tailwind CSS
```

### Quy tắc từng field

| Field | Lấy từ | Thiếu thông tin |
|---|---|---|
| Tên dự án | Input / CV, giữ nguyên tên gốc | — (không có tên thì không tính là dự án) |
| Thời gian | Mốc thời gian trong input / CV → tự tính (VD `02/2025 – 12/2025` → `10 tháng`). Đang làm → tính đến ngày tạo file và ghi `(đang làm)`, VD `4 tháng (đang làm)` | Placeholder |
| Vị trí | Vai trò trong dự án ghi trong input / CV | Placeholder, không tự lấy role của member (Q9) |
| Mô tả | Mô tả dự án trong input / CV, viết lại gọn và tự nhiên, không thêm chi tiết mới | Placeholder |
| Tính năng chính | Tính năng được nêu trong input / CV (tối đa 5; input ít hơn thì giữ đúng số đó). Mô tả có liệt kê tính năng thì được tách ra | Placeholder, không tự suy tính năng |
| Tech Stack | Stack thật của riêng dự án đó (kể cả khi có JD) | Placeholder |

- **Ngôn ngữ:** mọi nội dung theo ngôn ngữ output, kể cả phần lấy từ CV viết bằng ngôn ngữ khác (CV tiếng Anh, xuất bản vi → dịch Mô tả, Tính năng chính). Giữ nguyên tên dự án, tên công nghệ. Nhãn: theo Q11.
- **Placeholder:** field thiếu vẫn giữ dòng, ghi `_(chưa có — vui lòng bổ sung)_` (en: `_(not provided — please fill in)_`, ja: `_（未記入 — ご記入ください）_`).

---

## 7. Lưu file khi đã tồn tại

Áp dụng cho mọi file bio (vi / en / ja).

**Luồng:**
1. Không trùng tên → lưu luôn, không hỏi.
2. Trùng tên → in bio trước, rồi hỏi 1 câu trước khi lưu:
   ```
   File short-bio-la-hoang-long-2026-10-21.md đã tồn tại. Chọn:
   1. Ghi đè file cũ
   2. Tạo file mới (short-bio-la-hoang-long-2026-10-21-v2.md)
   ```
   - Option 2 hiển thị sẵn tên file mới: hậu tố `-v2`, `-v3`... (file gốc là v1, lấy số nhỏ nhất chưa dùng).
   - Trả lời khác 1/2 → nhắc nhập 1 hoặc 2, hỏi lại.
3. Lưu theo lựa chọn, in `Đã lưu: [tên file]` (ghi đè thì `Đã ghi đè: [tên file]`).

**Bản en / ja member yêu cầu thêm:**
- Tên theo cùng kiểu với bản đầu (bản đầu tạo `-v2` thì bản en là `...-en-[ngày]-v2.md`).
- Tên đó cũng đã tồn tại → hỏi lại như bước 2.

---

## 8. Nhắc thông tin còn thiếu

Sau khi lưu file bio, nếu file còn placeholder, Short Bio có ý suy luận, hoặc có skill thêm theo JD mà member chưa có → in **1 khối nhắc duy nhất** (không phải câu hỏi), gom mọi field thiếu trong file:

```
⚠ File short-bio-la-hoang-long-2026-10-21.md còn thông tin chưa có:
- Header: Email
- Project 1 — Labofi: Thời gian, Tính năng chính
- Project 2 — QLEAR: Mô tả
- Core Skills (thêm theo JD, input không có): AWS (2 năm)
- Short Bio (suy luận, cần kiểm tra): "quản lý kho y tế" suy từ tên dự án Medical Stock
Bổ sung trực tiếp vào file trước khi gửi khách hàng.
```

Không còn placeholder, ý suy luận hay skill thêm theo JD → không in khối này.

---

## 9. Quy tắc chung cho mọi use case

- Hỏi tuần tự bằng text, mỗi lượt 1 câu, không dùng form chọn (`AskUserQuestion`).
- Hỏi bổ sung khi sơ sài **tối đa 1 lần** mỗi lượt chạy. Member `skip` thì không hỏi lại trong lượt đó.
- **Short Bio:**
  - Mỗi đoạn 2–3 câu, không bullet point. Diễn giải skill thành năng lực, ~110–160 từ (chi tiết) / ~80–120 từ (sơ sài).
  - Không dùng đại từ nhân xưng, không gọi tên, không dùng câu bị động.
  - Luôn qua humanizer để đọc tự nhiên. Số liệu, số năm, stack đã chốt được giữ nguyên.
  - Không bịa thông tin hay số liệu không có trong đầu vào (JD chỉ được dùng để chọn và bổ sung skill, không tạo ra dự án).
- Toàn bộ output theo ngôn ngữ output, kể cả nội dung lấy từ CV ở ngôn ngữ khác.
- Không dùng học vấn, lương, level.
- Lưu file ngay sau khi in: `short-bio-[ten]-[YYYY-MM-DD].md` (en/ja thêm `-en` / `-ja`). File đã tồn tại → hỏi ghi đè hay tạo mới (mục 7).
- Sau khi lưu: nhắc thông tin thiếu (mục 8) rồi kết thúc — không hỏi tạo thêm bản en / ja; member tự yêu cầu nếu cần.

---

## 10. Xử lý ngoại lệ (áp dụng chung)

| Tình huống | Áp dụng | Xử lý |
|---|---|---|
| Form thiếu field bắt buộc | UC1–4 | Chỉ hỏi field còn thiếu, merge, validate lại |
| CV thiếu field bắt buộc | UC5–8 | In tóm tắt, rồi dừng hỏi đúng field còn thiếu (ngoại lệ duy nhất phải chờ) |
| CV không đọc được: 404 | UC5–8 | Báo `không tìm thấy tài liệu`, nhắc kiểm tra lại link |
| CV không đọc được: private / cần đăng nhập (LinkedIn) | UC5–8 | Báo `cần đăng nhập hoặc chưa chia sẻ`, nhắc bật "Anyone with the link" |
| CV không đọc được: file hỏng / không trích được text | UC5–8 | Báo lỗi, gợi ý gửi file khác hoặc nhập form → chuyển sang UC1–4 |
| CV dạng ảnh / PDF scan | UC5–8 | Đọc bằng vision (Q5); vẫn in tóm tắt để member sửa |
| CV có thời gian dự án mâu thuẫn | UC5–8 | Dùng mốc tháng/năm, nêu trong "Lưu ý" |
| Role chung chung / CV không ghi chức danh | Tất cả | Suy từ stack, không hỏi (với CV: ghi chú trong tóm tắt để member sửa nếu cần) |
| Role lệch stack | Tất cả | Hỏi giữ role hay đổi |
| Role member ngoài BE / FE / Fullstack / Mobile / QA | Tất cả | Báo không hỗ trợ, hỏi chọn role gần nhất hoặc dừng |
| Role JD ngoài 5 role hỗ trợ | Có JD | Báo không hỗ trợ, hỏi tạo bio không theo JD hay dừng (Q7) |
| JD là đường dẫn file không tồn tại | Có JD | Báo `Không tìm thấy file JD`, hỏi lại Câu 2 |
| JD là link không đọc được | Có JD | Báo lỗi giống bảng lỗi CV, gợi ý paste nội dung JD, hỏi lại Câu 2 (Q6) |
| Câu 2 nhận link / file trông giống CV (có kinh nghiệm, dự án của 1 người, không có yêu cầu tuyển dụng) | Có JD | Hỏi lại: `Nội dung này giống CV hơn JD. Đây là JD khách hàng (1) hay CV của bạn (2)?` — chọn 2 → quay lại bước lấy thông tin với CV đó |
| Câu trả lời không hợp lệ (mức match, ghi đè/tạo mới) | Tất cả | Nhắc lựa chọn hợp lệ, hỏi lại |

---

## 11. Quyết định đã chốt

| # | Vấn đề | Quyết định |
|---|---|---|
| Q1 | Bio sơ sài (UC3/4/7/8) có giữ 3 đoạn không | **2 đoạn.** Không có dự án thì đoạn 2–3 dễ thành câu chung chung hoặc bịa |
| Q2 | Sơ sài: member chỉ ghi tổng số năm, không ghi năm từng skill | Skill chính của role (VD React với FE) ghi bằng tổng số năm; các skill khác không ghi năm thì để member tự điền số năm vào, điền sẵn text năm/tháng |
| Q3 | Có JD thì có hỏi mức match không | Luôn hỏi Câu 3 vì mức match quyết định số năm ghi trong bio |
| Q4 | Có nhận argument (`--cv`, `--jd`, `--profile`...) không | **Không nhận flag.** Nội dung gõ kèm lệnh (link CV / thông tin member) = câu trả lời Câu 1, bỏ bước in form; mọi thông tin còn lại lấy qua câu hỏi; output chỉ có file bio |
| Q5 | CV dạng ảnh hoặc PDF scan | Đọc bằng vision; vẫn in tóm tắt nên member sửa được nếu sai |
| Q6 | JD là link | Đọc giống link CV (cùng cách xử lý lỗi) |
| Q7 | Role JD nằm ngoài 5 role hỗ trợ | Báo không hỗ trợ, cho chạy tiếp không JD |
| Q8 | Số dự án tối đa trong Project Examples | Giữ **1 đến 2**; CV nhiều dự án thì chọn 2 tiêu biểu nhất |
| Q9 | Thiếu Position của dự án | Note để member điền vào |
| Q10 | Có JD: Tech Stack trong Project Examples có thay theo JD không | **Không thay**, theo bảng *Stack khi có JD* ở UC2. |
| Q11 | Nhãn Project Examples | Dịch theo ngôn ngữ output (vi: Thời gian, Vị trí, Mô tả, Tính năng chính, Tech Stack · en: Duration, Position, Description, Key Features, Tech Stack · ja: 期間, ポジション, 概要, 主な機能, 技術スタック) |
| Q12 | JD ghi số năm cho một skill member chưa có (VD "3 năm AWS") | Mức 1 / 2: thêm skill, số năm = N / 80% × N (≤ tổng số năm). Mức 3: không thêm. Luôn liệt kê trong khối nhắc |
| Q13 | Suy role từ CV có cả FE lẫn BE | Fullstack chỉ khi cả hai phía là stack chính (mỗi phía ≥ nửa tổng số năm hoặc ở phần lớn dự án); không thì lấy phía chiếm ưu thế |
| Q14 | Domain Core Skills cho BE / FE / Fullstack | Thêm API Integration, Testing, UI/UX Design; chỉ in domain có skill |
