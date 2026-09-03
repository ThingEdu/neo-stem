# NEO STEM — Rà soát nội dung K-12 và mức độ chính xác

**Phạm vi rà soát:** toàn bộ 20 hoạt động trong `neo_stem/qml/activities/`, đối chiếu với `README.md`, `docs/ARCHITECTURE.md`, tài liệu nguồn `20_cau_hoi_openscied_gdpt2018.docx` và bản ứng dụng di động Expo.
**Ngày rà soát:** 01/09/2026 · **Ngày vá:** 02/09/2026
**Chuẩn đối chiếu:** Chương trình GDPT 2018 (Thông tư 32/2018/TT-BGDĐT) — môn **Khoa học** lớp 4-5 và môn **Khoa học tự nhiên** lớp 6-9.

---

## 0. Kết luận nhanh

| Hạng mục | Đánh giá |
|---|---|
| Phương pháp sư phạm (OpenSciEd 5 bước) | **Tốt** — cấu trúc Hiện tượng → DQB → Điều tra → Mô hình → Thách thức được hiện thực hóa nhất quán ở cả 20 hoạt động |
| Bối cảnh Việt Nam | **Rất tốt** — Đà Lạt, Ninh Thuận, Cần Giờ, ao cá, nồi cơm điện, sáo trúc… gần gũi và đúng tinh thần "hiện tượng neo" |
| Độ chính xác khoa học | ✅ **ĐÃ VÁ 02/09/2026** — cả 5 lỗi (A1-A5) đã sửa trong mã nguồn, kèm công thức chuẩn |
| Bám chương trình GDPT 2018 | ✅ **ĐÃ VÁ 02/09/2026** — gán lại lớp cho 9 hoạt động, thêm `gradeCore` + `curriculumTopic` vào dữ liệu, bỏ nhãn "Lớp 3" |
| Tính nhất quán giữa 2 sản phẩm | **Kém** — bản Qt và bản Expo là hai bộ 20 câu hỏi **khác nhau**, chỉ trùng 5 hiện tượng, và trùng nhưng gán lớp lệch nhau |

**Tình trạng:** toàn bộ nhóm A và các mục P0-P1 của nhóm C đã được vá và kiểm chứng (120/120 file QML nạp được bằng đúng stack PyQt6). Chi tiết từng bản vá ghi ngay dưới mỗi mục.

> ### 🆕 Hai lỗi PHÁT SINH tìm được trong lúc vá
>
> Khi dựng bộ kiểm tra nạp QML (`scripts/check_qml_loads.py`) cho toàn bộ file hoạt động, phát hiện **hai bài không mở được bước đó** — lỗi có sẵn từ trước, không liên quan tới nội dung khoa học:
>
> | Bài | Lỗi | Hậu quả |
> |---|---|---|
> | **Q13 Bóng đèn — Bước 1** | `onLightOnChanged` viết trong `Canvas` con, nhưng `lightOn` khai báo ở `Rectangle` cha | Bước 1 của bài 13 **không nạp được**, học sinh không vào được bài |
> | **Q11 Xe đạp — Bước 3** | `onRampHeightChanged` viết trong `Canvas` con, nhưng `rampHeight` khai báo ở gốc file | Bước 3 của bài 11 **không nạp được** |
>
> Cả hai đã sửa bằng cách nhân bản thuộc tính vào phần tử con (`property bool lit: lightOn` / `property real hWatch: rampHeight`) rồi bắt tín hiệu trên thuộc tính đó.
>
> **Bài học cho quy trình:** ứng dụng nạp QML lúc chạy, không biên dịch trước, nên **không có bước nào trong quy trình hiện tại phát hiện được lỗi này** — đóng gói `.deb` vẫn thành công, cài lên NEO One vẫn xong, chỉ tới khi học sinh bấm vào bài mới thấy màn hình trống. Hai lỗi này đã nằm trong bản phát hành **v1.0.3 đang chạy trên máy thật**. Cần thêm bước kiểm tra nạp QML vào CI (xem mục 4).

---

## 1. Nhóm A — Lỗi khoa học (phải sửa)

### A1. ✅ ĐÃ VÁ — Q20 "Chai nước xylophone" — mô hình vật lý ngược với thao tác

**Hiện trạng.** Bước 1 mô tả: *"dùng que gõ vào từng chai"*, rồi giải thích *"Chai nhiều nước → cột không khí ngắn → rung nhanh → tần số cao"*. Code:

```qml
// neo_stem/qml/activities/q20_water_xylophone/Step3Investigation.qml:15
property real frequency: 200 + (currentWater / 100) * 600  // more water = shorter air = higher freq
```

**Vấn đề.** Đây là hai hệ dao động khác hẳn nhau:

| Thao tác | Vật dao động | Thêm nước thì… |
|---|---|---|
| **Gõ** vào thành chai | thành thủy tinh **+ khối nước** | khối lượng dao động tăng → tần số **GIẢM** → tiếng **trầm** |
| **Thổi** ngang miệng chai | **cột không khí** phía trên mặt nước | cột khí ngắn lại → tần số **TĂNG** → tiếng **cao** |

Phần mềm đang dùng thao tác **gõ** nhưng áp công thức của **thổi**. Hệ quả nghiêm trọng hơn cả việc sai một con số: học sinh về nhà xếp 5 chai và gõ bằng chiếc đũa sẽ nghe **ngược hẳn** với những gì app vừa dạy — làm hỏng đúng cái năng lực mà OpenSciEd muốn xây: tin vào dữ liệu quan sát của chính mình.

Bước 5 lại hỏi về **sáo trúc** (cột khí) — tức là bài đang đứng một chân ở mỗi hệ.

**Cách sửa (chọn 1):**
- **(a) Đổi thao tác thành "thổi"** — giữ nguyên toàn bộ công thức và bước 5. Sửa ít nhất, an toàn nhất.
- **(b) Giữ "gõ"** — đảo công thức (`frequency = 800 - water*6`), viết lại Step1/Step4, và đổi bài Thách thức sang đàn đá/chuông.
- **(c) Khuyến nghị: làm cả hai.** Cho học sinh chọn "Gõ" hay "Thổi" trong bước Điều tra, ghi hai cột dữ liệu, và biến chính sự đối lập này thành bài Thách thức bước 5.

#### ✅ Đã vá — phương án (c), công thức chuẩn

Bước 3 nay có nút chọn **🥁 GÕ vào chai** / **💨 THỔI miệng chai**, mỗi chế độ một công thức riêng:

```qml
// GÕ — vật rung là thành thủy tinh + khối nước (hệ khối lượng - độ cứng):
//      f = f0 / sqrt(1 + k·m_nước)   → thêm nước, khối lượng rung tăng, tần số GIẢM
property real freqTap:  500 / Math.sqrt(1 + 4 * waterFrac)     // 456 Hz → 228 Hz

// THỔI — vật rung là cột không khí (cộng hưởng Helmholtz):
//      f = c/(2π)·sqrt(A / (V_khí · L_cổ))  → f tỉ lệ nghịch căn bậc hai THỂ TÍCH KHÍ
property real freqBlow: 200 / Math.sqrt(Math.max(0.05, 1 - waterFrac))   // 205 Hz → 894 Hz
```

Kết quả đo được trong mô phỏng:

| Mực nước | GÕ | THỔI |
|---|---|---|
| 5% | 456 Hz | 205 Hz |
| 20% | 373 Hz | 224 Hz |
| 50% | 289 Hz | 283 Hz |
| 90% | 233 Hz | 632 Hz |
| 95% | 228 Hz | 894 Hz |

Hai đường **cắt nhau quanh mức 50%** — một chi tiết đẹp ngoài dự kiến: ở nửa chai, gõ và thổi cho gần cùng một nốt.

**Các bước khác đã đồng bộ theo:**
- Bước 1 — hiện tượng neo đổi thành hai bạn tranh luận: một bạn gõ, một bạn thổi, kết quả ngược nhau.
- Bước 2 — 5 câu hỏi mẫu đổi sang trục "cái gì đang rung": *"Khi GÕ, cái gì rung lên?"*, *"Vật nặng hơn thì rung nhanh hay chậm hơn?"*
- Bước 4 — chuỗi mô hình đổi thành `Gõ vào thành chai → Thủy tinh + nước cùng rung → Nhiều nước = khối lượng lớn → Rung chậm, tần số thấp → Nghe tiếng trầm`; ô *"Cột không khí rung"* chuyển thành **ô nhiễu**.
- Bước 5 — thách thức mới: *"Sáo trúc giống cách GÕ hay cách THỔI?"* Phần mở rộng chia nhạc cụ Việt Nam thành hai nhóm: cột khí rung (sáo trúc) và vật rắn rung (đàn đá, cồng chiêng, đàn t'rưng).
- Kết luận bước 3 thay đổi theo dữ liệu học sinh ghi: nếu đo cả hai chế độ mới hiện phát hiện lớn nhất.

---

### A2. ✅ ĐÃ VÁ — Q6 "Cầu vồng" — thí nghiệm lăng kính dạy một quy luật không tồn tại

**Hiện trạng.** `neo_stem/qml/activities/q6_rainbow/Step3Investigation.qml:15-31` sinh dữ liệu theo góc xoay lăng kính: dưới 15° → 0 màu; 15-30° → 2 màu (Đỏ, Cam); 30-45° → 4 màu; 45-60° → 6 màu; trên 60° → 7 màu. Bảng dữ liệu học sinh ghi lại có cột **"Góc (°) — Số màu"**.

**Vấn đề.** Lăng kính tán sắc ánh sáng trắng thành **dải màu liên tục, xuất hiện cùng lúc**. Xoay lăng kính làm thay đổi **góc lệch** và **độ rộng/độ sáng** của quang phổ, chứ không "thêm dần từng màu". Quan hệ "góc → số màu" là dữ liệu bịa. Thêm nữa, nếu có màu nào tách rõ trước thì đó là **tím** (lệch nhiều nhất), không phải đỏ.

#### ✅ Đã vá — công thức chuẩn

Bỏ hẳn quan hệ "góc → số màu". Bảng dữ liệu nay có **4 cột**, trong đó hai cột cố tình **không đổi**:

| Góc tới (°) | Độ rộng dải (mm) | Số màu | Thứ tự màu |
|---|---|---|---|
| 0 | 0 | 0 | chưa tán sắc |
| 15 | 11 | **7** | Đỏ → Tím |
| 30 | 21 | **7** | Đỏ → Tím |
| 45 | 30 | **7** | Đỏ → Tím |
| 75 | 41 | **7** | Đỏ → Tím |

```qml
// Tán sắc cho dải màu LIÊN TỤC, mọi màu xuất hiện CÙNG LÚC.
// Xoay lăng kính chỉ đổi ĐỘ RỘNG dải hứng trên màn (màn cách lăng kính 30 cm):
property real spectrumWidth: 42 * Math.sin(prismAngle * Math.PI / 180)
property int  visibleColors: dispersed ? 7 : 0        // KHÔNG phụ thuộc góc
```

Bảy thanh màu nay cùng hiện một lúc và **cùng dày lên** khi góc tăng, thay vì sáng dần từng thanh. Kết luận bước 3 hỏi thẳng học sinh: *"cột nào ĐỔI và cột nào KHÔNG ĐỔI?"* — biến bài thành một bài học về biến độc lập / đại lượng bất biến, và bổ sung lý do tím lệch nhiều nhất (chiết suất của thủy tinh với ánh sáng tím lớn hơn với ánh sáng đỏ).

---

### A3. ✅ ĐÃ VÁ — Q13 "Bóng đèn" — ba con số hiệu suất trong cùng một bài mâu thuẫn nhau

| Nơi xuất hiện | Nội dung | Tỉ lệ LED/sợi đốt ngụ ý |
|---|---|---|
| Step5, đáp án đúng | "LED chuyển **90%** điện năng thành ánh sáng, sợi đốt chỉ 10%" | 9 lần |
| Step5, phần bác bỏ | "LED **9W** cho độ sáng tương đương sợi đốt **60W**" | ~6,7 lần |
| Step3, mô phỏng (`Step3Investigation.qml:14-19`) | sáng = 25/pin (sợi đốt) so với 30/pin (LED) | **1,2 lần** |

**Vấn đề.** Con số 90% là sai: hiệu suất chuyển đổi điện → ánh sáng của đèn LED dân dụng hiện nay khoảng **20-45%**; đèn sợi đốt khoảng **5%** (không phải 10%). Và mô phỏng ở bước 3 gần như xóa sạch sự khác biệt mà bước 5 đang nhấn mạnh — học sinh làm thí nghiệm xong sẽ không rút ra được kết luận của bài.

#### ✅ Đã vá — một bộ số duy nhất

```qml
// Sợi đốt ~5% điện năng thành ánh sáng · LED ~35% → LED sáng hơn ~7 lần
property real brightness: bulbType === 0 ? batteryCount * 5 : batteryCount * 33
// Nhiệt độ VỎ BÓNG (không phải dây tóc — dây tóc tungsten lên tới 2500°C)
```

| | 1 pin | 2 pin | 3 pin | Tỉ số LED / sợi đốt |
|---|---|---|---|---|
| Sợi đốt | 5% | 10% | 15% | |
| LED | 33% | 66% | 99% | **6,6 lần** |

6,6 lần khớp với mốc kiểm chứng ngoài đời **60W / 9W ≈ 6,7 lần**. Ba con số trong bài nay nhất quán.

Thêm vào đó: bảng dữ liệu ghi **con số** thay vì nhãn "Mờ / Sáng", để học sinh tự tính được tỉ số; cột nhiệt độ đổi tên thành **"Nhiệt độ vỏ bóng"**; ngưỡng đồ họa hạ xuống để bóng sợi đốt vẫn hiện sáng (mờ) chứ không tắt hẳn; phần mở rộng thêm cách tự kiểm chứng bằng nhãn bóng đèn ngoài cửa hàng.

---

### A4. ✅ ĐÃ VÁ — Q19 "Đom đóm" — "gần 100% năng lượng thành ánh sáng"

**Hiện trạng.** Step1: *"gần 100% năng lượng chuyển thành ánh sáng"*. Code `Step3Investigation.qml:15-19`: đom đóm 95% sáng / 2% nhiệt.

**Vấn đề.** Con số 88-100% là số liệu cũ đã bị bác bỏ. Đo lại bằng phương pháp hiện đại cho **hiệu suất lượng tử khoảng 40-45%**. Điều **đúng** và đáng dạy là: đom đóm phát **"ánh sáng lạnh"** — phần năng lượng không thành ánh sáng đi vào các sản phẩm hóa học chứ **không tỏa thành nhiệt**, nên bụng đom đóm không nóng. "Không tỏa nhiệt" ≠ "hiệu suất 100%": đây là hai khẳng định khác nhau và app đang gộp làm một.

#### ✅ Đã vá — số liệu đo thật

| Nguồn sáng | Thành ánh sáng | Thoát ra thành nhiệt |
|---|---|---|
| Bóng sợi đốt | ~5% | **~95%** |
| Que phát sáng | ~15% | ~5% |
| Đom đóm | **~40%** | **~1%** |

Kết luận bước 3 nay nói thẳng điều trước đây bị gộp nhầm: *"điều đặc biệt của đom đóm không phải là biến 100% năng lượng thành ánh sáng — mà là gần như KHÔNG TỎA NHIỆT. Hai điều đó khác nhau."* Và trả lời câu hỏi tất yếu tiếp theo: 60% năng lượng còn lại nằm trong **sản phẩm hóa học** của phản ứng luciferin + O₂ + luciferase, chứ không thoát ra thành nhiệt. Chiều cao ba cột đồ họa cũng đã đồng bộ với bộ số mới.

---

### A5. ✅ ĐÃ VÁ — Q3 "Rừng ngập mặn" — gán nhầm cơ chế chống mặn cho cây đước

**Hiện trạng.** Cả bài lấy nhân vật là **cây đước**, nhưng bước Mô hình có ô *"Lá tiết muối thừa"*.

**Vấn đề.** Cây ngập mặn có hai chiến lược khác nhau, và đước chỉ dùng một:
- **Ngăn muối ở rễ** (đước — *Rhizophora*): lọc ~90-95% muối ngay tại rễ, **không có tuyến tiết muối trên lá**.
- **Tiết muối qua lá** (mắm, sú — *Avicennia*, *Aegiceras*): hút cả muối vào rồi đẩy ra qua tuyến muối ở mặt lá — sờ lá thấy mặn, phơi nắng thấy tinh thể muối.

Gán cả hai cho một cây là sai, và làm mất một cơ hội dạy rất hay.

#### ✅ Đã vá — đúng cơ chế của từng loài

Chuỗi mô hình của cây đước sửa thành:
`Nước mặn quanh rễ → Rễ chặn 90% muối lại → Nước sạch vào tế bào → Muối dư dồn vào lá già rồi rụng → Cây sống khỏe`

Ô **"Lá tiết muối thừa (cây mắm)"** chuyển thành **ô nhiễu** — học sinh phải nhận ra nó thuộc về loài khác. Ô vùng thả thứ tư đổi tên từ "Lá" thành **"Xử lý muối dư"** cho khớp cơ chế.

Bước 1 bổ sung phần đối chiếu hai chiến lược, kèm cách tự kiểm chứng ngoài thực địa: **sờ lá mắm thấy mặn, sờ lá đước không**.

---

## 2. Nhóm B — Đơn vị, thuật ngữ, dữ liệu mô phỏng (nên sửa)

| Mã | Hoạt động | Vấn đề | Vị trí |
|---|---|---|---|
| B1 | Q8 Tiếng trống | Biên độ tuyến tính (`hitForce*100`) được hiển thị kèm đơn vị **dB**. Decibel là thang **logarit của cường độ âm**, không phải biên độ; cột bảng ghi "Biên độ" nhưng nhãn hiển thị "dB". Bỏ đơn vị dB, để "Biên độ (đơn vị quy ước)". *(Quan hệ định tính trong bài — đập mạnh → biên độ lớn → to hơn; trống nhỏ → tần số cao — đều **đúng**.)* | `q8_drum_sound/Step3Investigation.qml:13,88` |
| B2 ✅ | Q11 Xe đạp | **ĐÃ VÁ.** Bỏ hẳn cột "Góc" giả. Bảng nay là `Độ cao (cm) · Tốc độ (cm/s) · Nhận xét` — một biến độc lập duy nhất. Kết luận bổ sung phép kiểm chứng: nâng máng từ 10 cm lên 40 cm là gấp **bốn** lần độ cao nhưng tốc độ chỉ tăng **hai** lần, vì `v = √(2gh)`. | `q11_bicycle/Step3Investigation.qml:11-13` |
| B3 ✅ | Q13 Bóng đèn | **ĐÃ VÁ.** Cột đổi tên thành "Nhiệt độ vỏ bóng", kèm chú thích trong mã nguồn phân biệt với dây tóc 2500°C. | `q13_light_bulb/Step3Investigation.qml:25` |
| B4 | Q18 Bóng heli | Trộn hai mốc nhiệt độ: heli 0,164 kg/m³ (ở 25°C) đặt cạnh không khí 1,225 kg/m³ (ở 0°C). Thống nhất về 25°C: heli 0,164 — không khí **1,18**. | `q18_helium_balloon/Step3Investigation.qml` |
| B5 | Q7 Pha Mặt Trăng | Bảng pha có hai mục cùng tên "Trăng mới" (vị trí 0° và mục kế). Nên dùng hệ tên chuẩn: Trăng mới → Lưỡi liềm đầu tháng → Thượng huyền → Trăng khuyết đầu → Trăng tròn (rằm) → Trăng khuyết cuối → Hạ huyền → Lưỡi liềm cuối tháng. | `q7_moon_phases/Step3Investigation.qml` |

### Những chỗ **đúng** và nên giữ nguyên

Ghi lại để không bị "sửa nhầm" trong đợt hiệu đính:

- **Q1** — nước sôi ở 120°C khi áp suất 2 atm: **đúng**; giải thích nồi áp suất chuẩn.
- **Q4** — điểm sương, ngưng tụ, và mở rộng sang vệt contrail máy bay: **đúng và rất đẹp**.
- **Q7** — xử lý dứt khoát ngộ nhận kinh điển *"phần tối của Mặt Trăng là bóng Trái Đất"*, và phân biệt trăng mới với nguyệt thực: **xuất sắc**.
- **Q11** — tốc độ tỉ lệ với căn bậc hai độ cao; giải thích xe dừng bằng ma sát chứ không phải "hết đà": **đúng**, kể cả phần bác bỏ khái niệm "đà".
- **Q12** — diệp lục hấp thụ đỏ + xanh dương, phản xạ xanh lục; lá đổi màu mùa thu do diệp lục phân hủy để lộ carotenoid: **đúng**.
- **Q15** — cá voi có phổi / cá mập có mang: **đúng**, xử lý gọn một ngộ nhận phổ biến.
- **Q16** — độ tan của CO₂ giảm khi nhiệt độ tăng: **đúng**.
- **Q17** — thùng xốp **cách nhiệt** chứ không "tạo hơi lạnh": **đúng**, và phần bác bỏ rất sắc.
- **Q5** — ba phương pháp tách, trong đó **lọc thất bại**: đây là thiết kế thí nghiệm tốt nhất trong cả bộ, vì cho học sinh gặp một phương án **không hoạt động**.

---

## 3. Nhóm C — Bám chương trình GDPT 2018

### C1. ✅ ĐÃ VÁ — 9/20 hoạt động gán sai lớp, đều lệch theo hướng **gán thấp hơn** thực tế

| # | Hoạt động | README ghi | Đúng theo GDPT 2018 | Độ lệch |
|---|---|---|---|---|
| 6 | Cầu vồng | Lớp 6-7 | **KHTN 9** — Tán sắc ánh sáng qua lăng kính | −2 đến −3 lớp |
| 11 | Xe đạp xuống dốc | Lớp 7 | **KHTN 9** — Động năng, thế năng, cơ năng | −2 lớp |
| 7 | Pha Mặt Trăng | Lớp 4-5 | **KHTN 6** — Trái Đất và bầu trời: các hình dạng nhìn thấy của Mặt Trăng | −1 đến −2 lớp |
| 10 | Nam châm | Lớp 5-6 | **KHTN 7** — Nam châm, từ trường, la bàn | −1 đến −2 lớp |
| 20 | Chai nước xylophone | Lớp 4-5 | **KHTN 7** — Biên độ, tần số, độ to, độ cao của âm | −2 lớp |
| 12 | Lá cây xanh | Lớp 5-6 | **KHTN 7** — Quang hợp ở thực vật | −1 lớp |
| 18 | Bóng bay heli | Lớp 6-8 | **KHTN 8** — Khối lượng riêng, áp suất, lực đẩy Archimedes | thu hẹp về đúng lớp 8 |
| 14 | Rỉ sét | Lớp 7-8 | **KHTN 9** — Kim loại: ăn mòn và chống ăn mòn *(nhập môn ở Khoa học 5 — sự biến đổi hóa học)* | −1 lớp |
| 3 | Rừng ngập mặn | Lớp 8-9 | **KHTN 7** — Trao đổi nước và chất khoáng ở thực vật *(mở rộng KHTN 8 — hệ sinh thái)* | **+1 đến +2 lớp** (gán quá cao) |

11 hoạt động còn lại gán đúng hoặc chấp nhận được. Bảng ánh xạ đầy đủ 20/20: xem [`BAN_DO_GDPT_2018.md`](BAN_DO_GDPT_2018.md).

**Đã vá.** Toàn bộ 20 hoạt động trong `neo_stem/qml/core/NeoConstants.qml` nay mang thêm hai trường:

```qml
level: levelAdvanced, gradeCore: 9, gradeRange: "9",
curriculumTopic: qsTr("KHTN 9 — Ánh sáng: tán sắc ánh sáng qua lăng kính"),
```

Nhãn trên thẻ chọn bài đổi từ `"Cơ bản L6-7"` sang **`"KHTN 9"`** — ghép tên môn với `gradeCore`. Thêm cấp độ thứ tư `levelEnrichment` ("Ngoại khóa", màu tím) cho hoạt động Đom đóm, vốn không thuộc yêu cầu cần đạt của lớp nào.

### C2. ✅ ĐÃ VÁ — Nhãn "Lớp 3-5" không có cơ sở trong chương trình

`README.md` ghi *"Lớp 3-9, 8-15 tuổi"* và *"Cơ bản (Lớp 3-5)"*. Nhưng trong GDPT 2018:

- Môn **Khoa học chỉ bắt đầu từ lớp 4**. Lớp 1-2-3 học **Tự nhiên và Xã hội** — chương trình này **không có** bay hơi, ngưng tụ, điểm sương, tần số, mạch điện hay thẩm thấu.
- Không hoạt động nào trong 20 hoạt động thực sự nằm ở tầm lớp 3.

**Đã vá.** README ghi **"Lớp 4-9"**; ba cấp độ chia theo môn (`Khoa học 4-5` · `KHTN 6-7` · `KHTN 8-9`); tiêu đề bốn nhóm hoạt động đổi từ khoảng tuổi ("6-10 tuổi") sang khoảng lớp ("Khoa học 4", "Lớp 5 đến 9"); trường `age` trong `questionGroups` đổi thành `grades`. README bổ sung ghi chú giải thích vì sao không có lớp 3.

### C3. 🔴 BA kho mã cùng tên NEO STEM — hai trong số đó đã chết

Đây là phát hiện tốn thời gian nhất của cả đợt rà soát, và là rủi ro lớn nhất cho các đợt sửa sau.

| Kho | Stack | Trạng thái |
|---|---|---|
| **`ThingEdu/neo-stem`** (kho này) | **PyQt6 + QML**, `neo_stem/qml/` | ✅ **Bản sản xuất** — NeoPlay ship từ đây, có `debian/`, release `.deb` |
| `tuanln/NEO_STEM` | Qt6 + C++ + CMake | ⚠️ **Đã lỗi thời 29 commit**, từ trước lần migrate sang PyQt6 |
| `Ai-Code/NEO_STEM/neo-stem` | Expo / React Native | Ứng dụng di động trắc nghiệm, **20 bài khác hẳn**, chỉ trùng 5 hiện tượng |

Ngay trong kho này còn một cái bẫy thứ hai: thư mục **`src/activities/` và `CMakeLists.txt` là xác chết** từ thời tiền-PyQt6. `neo_stem/app.py` nạp QML từ `neo_stem/qml/`, không đụng tới `src/`. Sửa nhầm vào `src/` thì build vẫn xanh, test vẫn qua, mà người dùng không thấy gì thay đổi.

Đợt rà soát này ban đầu **đã vá nhầm vào đúng chỗ đó** — sửa `src/activities/` trong kho `tuanln/NEO_STEM`, tức là mã chết trong kho lỗi thời. Chỉ khi chuẩn bị cập nhật catalog NeoPlay mới lộ ra.

**Đề xuất:**
1. Xoá hẳn `src/` và `CMakeLists.txt` ở một PR dọn dẹp riêng, hoặc thêm `src/DEPRECATED.md` nói rõ.
2. Ghi ở đầu `README.md` rằng đây là kho sản xuất duy nhất.
3. Lưu trữ (archive) `tuanln/NEO_STEM` trên GitHub để không ai mở PR vào đó nữa.

*Trong khi chờ, bản vá đợt này áp cho **cả hai** đường `neo_stem/qml/` và `src/` để hai bản không lệch nhau.*

### C4. ✅ ĐÃ VÁ — Code không có trường dữ liệu chương trình

`ActivityBase` chỉ mang `questionId`, `questionTitle`, `drivingQuestion`. Không có `subject`, `grade`, `curriculumCode`, `yeuCauCanDat`. Hệ quả: không lọc bài theo lớp được, không xuất được báo cáo cho giáo viên, và mọi ánh xạ chương trình chỉ tồn tại trong README (nên đã trôi khỏi thực tế).

**Đề xuất tối thiểu:**

```qml
ActivityBase {
    questionId: 6
    subject: "KHTN"        // "KhoaHoc" | "KHTN"
    gradeCore: 9           // lớp chính thức học nội dung này
    gradeIntro: 4          // lớp có thể chơi ở mức trải nghiệm (tuỳ chọn)
    curriculumTopic: "Ánh sáng — Tán sắc ánh sáng qua lăng kính"
}
```

**Đã vá** với `gradeCore` và `curriculumTopic` đặt trong `NeoConstants.questions` (nơi dữ liệu 20 hoạt động thực sự nằm, thay vì `ActivityBase` như đề xuất ban đầu). Dữ liệu đã sẵn sàng; **bộ lọc theo lớp ở màn chọn bài chưa làm** — đó là việc còn lại ở mục 4.

### C5. 🟡 Phân bố nội dung lệch nặng về lớp 4-5 và lớp 7

Sau khi gán lại đúng lớp, 20 hoạt động rơi vào:

| Lớp | Số hoạt động | Nhận xét |
|---|---|---|
| Khoa học 4 | 6 | dày, tốt |
| Khoa học 5 | 3 | đủ |
| KHTN 6 | 2 | mỏng |
| KHTN 7 | 5 | dày |
| KHTN 8 | 1 | **rất mỏng** |
| KHTN 9 | 3 | mỏng |
| Ngoài chương trình (mở rộng) | 1 (đom đóm) | chấp nhận được |

Toàn bộ mạch **"Chất và sự biến đổi chất"** ở THCS gần như trống: không có nguyên tử/phân tử (KHTN 7), không có phản ứng hóa học/acid-base/muối (KHTN 8), không có hợp chất hữu cơ (KHTN 9). Tương tự, mạch **"Vật sống"** ở lớp 8-9 (cơ thể người, di truyền) không có bài nào — trong khi tài liệu nguồn `.docx` **đã soạn sẵn** bài di truyền màu mắt và hai bài Tin học 9.

**Đề xuất bổ sung 6 hoạt động** để phủ kín (chi tiết ở [`BAN_DO_GDPT_2018.md`](BAN_DO_GDPT_2018.md) mục 4).

### C6. 🟡 Bước 3 chưa đúng tinh thần OpenSciEd (bước 2 thì đạt)

Tài liệu nguồn viết rõ: *"Mỗi em viết 1-2 câu hỏi, dán lên bảng"* và *"Thí nghiệm thực hành để trả lời từng nhóm câu hỏi"*. Đối chiếu với app:

- **Bước 2 (DQB)** — **làm đúng**: bảng cho phép học sinh sửa nội dung từng tờ giấy nhớ và bấm "+ Thêm câu hỏi" (tối đa 8 tờ), số sao tính theo số câu hỏi các em điền (`DrivingQuestionBoard.qml:158`). Điểm cần cải thiện là 5 câu hỏi mẫu được điền sẵn ngay từ đầu, nên phần lớn học sinh sẽ bấm qua thay vì tự nghĩ. Đề xuất: để bảng **trống** ở lần chơi đầu, nút 💡 Gợi ý mới hiện các câu mẫu.
- **Bước 3 (Điều tra)** — dữ liệu là **mô phỏng**, không phải đo đạc thật. Với những hiện tượng làm được tại nhà bằng đồ 5 nghìn đồng (ly đá, chai nước, cần tây, đinh sắt), thay thí nghiệm thật bằng thanh trượt là đánh đổi lớn — và chính là chỗ lỗi A1 lọt qua mà không ai phát hiện.

**Đề xuất.** Không bỏ mô phỏng, mà **thêm một lớp "làm thật"**: mỗi hoạt động có một phiếu in được với vật liệu, các bước, và bảng trống để học sinh điền số đo **của mình**, rồi so với bảng của app. Chỗ nào lệch chính là bài học đắt nhất. Toàn bộ phiếu này đã được soạn trong hai cuốn sổ tay:

- [`SO_TAY_HOC_SINH_TIEU_HOC.md`](SO_TAY_HOC_SINH_TIEU_HOC.md) — lớp 4-5
- [`SO_TAY_HOC_SINH_THCS.md`](SO_TAY_HOC_SINH_THCS.md) — lớp 6-9

---

## 4. Danh sách việc cần làm (theo thứ tự ưu tiên)

| Trạng thái | Việc | File |
|---|---|---|
| ✅ xong | A1 — Q20 gõ/thổi, hai công thức riêng | 5 file trong `q20_water_xylophone/` |
| ✅ xong | A2 — thiết kế lại thí nghiệm lăng kính | `q6_rainbow/Step3Investigation.qml` |
| ✅ xong | A3 — thống nhất số liệu hiệu suất LED | `q13_light_bulb/` Step1, Step3, Step5 |
| ✅ xong | A4 — đổi trục "% ánh sáng" thành "% nhiệt" | `q19_firefly/` Step1, Step3 |
| ✅ xong | A5 — tách hai chiến lược chống mặn | `q3_mangrove/` Step1, Step4 |
| ✅ xong | B2, B3 — bỏ cột góc giả, ghi rõ nhiệt độ vỏ bóng | `q11_bicycle/`, `q13_light_bulb/` |
| ✅ xong | Lỗi phát sinh — 2 bước không nạp được | `q13_light_bulb/Step1`, `q11_bicycle/Step3` |
| ✅ xong | Gán lại lớp cho 9 hoạt động, thêm `gradeCore` + `curriculumTopic` | `neo_stem/qml/core/NeoConstants.qml` |
| ✅ xong | Nhãn thẻ đổi thành "Khoa học 4" / "KHTN 9" / "Ngoại khóa"; nhóm ghi lớp thay vì tuổi | `neo_stem/qml/menu/QuestionSelector.qml` |
| ✅ xong | Bỏ nhãn "Lớp 3", README ghi lớp theo GDPT 2018 | `README.md` |
| ⬜ còn lại | B1 — bỏ đơn vị dB ở bài Tiếng trống | `q8_drum_sound/Step3Investigation.qml:13,88` |
| ⬜ còn lại | B4 — thống nhất mốc nhiệt độ khối lượng riêng | `q18_helium_balloon/Step3Investigation.qml` |
| ⬜ còn lại | B5 — trùng tên "Trăng mới" | `q7_moon_phases/Step3Investigation.qml` |
| ⬜ còn lại | Lọc hoạt động theo lớp ở màn chọn bài (dữ liệu đã sẵn sàng) | `neo_stem/qml/menu/QuestionSelector.qml` |
| ⬜ còn lại | **Thêm bước kiểm tra nạp QML vào CI** — build sạch không chứng minh QML chạy được | mới |
| ⬜ còn lại | Bổ sung 6 hoạt động phủ lớp 8-9 | mới |
| ⬜ còn lại | Hợp nhất ánh xạ chương trình cho cả bản Qt và bản Expo | JSON dùng chung |

### Cách kiểm chứng đã dùng

Ứng dụng chạy bằng **PyQt6**, nên phải kiểm bằng đúng stack đó — dùng Qt6 hệ thống là sai stack và có thể bỏ sót khác biệt phiên bản.

```bash
python3 -m venv .venv && .venv/bin/pip install PyQt6

# Nạp thật từng file bước học bằng QQmlComponent (bước đã phát hiện 2 lỗi có sẵn)
QT_QPA_PLATFORM=offscreen .venv/bin/python scripts/check_qml_loads.py
```

Kết quả: **120/120 file nạp được** sau khi vá. Trước khi vá là 118/120 — hai file trượt đúng là `q13_light_bulb/Step1Phenomenon.qml` và `q11_bicycle/Step3Investigation.qml`. Đây cũng là cách chứng minh bộ kiểm tra thật sự bắt được lỗi, thay vì luôn báo xanh.

---

---

## 5. Nguồn gốc phương pháp, bản quyền và mức độ bản địa hóa

### Cái gì mượn của OpenSciEd

NEO STEM dùng **mô hình dạy học của OpenSciEd** — một chương trình khoa học phổ thông mã nguồn mở của Mỹ, phát triển với sự tài trợ của Carnegie Corporation of New York và một số quỹ khác. Trang chính thức: <https://www.openscied.org>.

Cụ thể, phần mượn là **khung quy trình lên lớp**, gồm các "routine" mà OpenSciEd đặt tên như sau:

| Tên gốc của OpenSciEd | Bước trong NEO STEM | Ý nghĩa |
|---|---|---|
| Anchoring Phenomenon Routine | **Bước 1 — Hiện tượng Neo** | Mở đầu bằng một hiện tượng thật, hấp dẫn và khó giải thích ngay, để kích hoạt tò mò |
| Driving Question Board (DQB) | **Bước 2 — Bảng câu hỏi** | Học sinh tự viết thắc mắc lên bảng; cả quá trình sau đó do chính câu hỏi của các em dẫn dắt |
| Investigation Routine | **Bước 3 — Thí nghiệm** | Thu thập dữ liệu để trả lời từng nhóm câu hỏi trên bảng |
| Putting the Pieces Together Routine | **Bước 4 — Xây dựng mô hình** | Ghép các mảnh phát hiện rời rạc thành một lời giải thích có cơ chế |
| Problematizing Routine | **Bước 5 — Thách thức** | Chỉ ra chỗ mô hình hiện tại còn hở, mở ra câu hỏi mới |

*(OpenSciEd còn một routine thứ sáu — **Navigation Routine**, nối các bài học liên tiếp trong cùng một chuỗi. NEO STEM chưa hiện thực hóa routine này vì mỗi hoạt động hiện đứng độc lập, chưa thành chuỗi bài nhiều tiết.)*

### Cái gì là của Việt Nam

**Toàn bộ nội dung 20 hoạt động là biên soạn mới, không phải bản dịch.** Không hiện tượng nào trong NEO STEM lấy từ một unit của OpenSciEd. Các hiện tượng neo được chọn từ đời sống Việt Nam:

sương mù Đà Lạt · ruộng muối Ninh Thuận · rừng ngập mặn Cần Giờ · nồi cơm điện · ao cá · cổng sắt gỉ trong hẻm · chai nước gõ thành nhạc · sáo trúc · đàn đá và cồng chiêng · bóng bay lễ hội · kem ốc quế ngày nắng

Phần bản địa hóa không dừng ở việc đổi bối cảnh:

- **Ánh xạ sang Chương trình GDPT 2018** (Thông tư 32/2018/TT-BGDĐT) — môn Khoa học lớp 4-5 và Khoa học tự nhiên lớp 6-9. OpenSciEd bám chuẩn NGSS của Mỹ, hai hệ thống không trùng nhau về thứ tự và độ sâu, nên mỗi hoạt động phải đối chiếu lại yêu cầu cần đạt của Việt Nam.
- **Thí nghiệm chọn theo vật liệu sẵn có** — ly nước đá, cần tây, đinh sắt, chai thủy tinh, đĩa CD. Không cần phòng lab.
- **Liên hệ văn hóa** — "lúa chín cúi đầu", nhạc cụ dân tộc, nghề làm muối, thích ứng xâm nhập mặn ở ĐBSCL.
- **Giao diện và toàn bộ nội dung bằng tiếng Việt**, tối ưu cho màn hình cảm ứng của máy NEO One.

### Bản quyền

Tài liệu của OpenSciEd phát hành theo giấy phép Creative Commons:

- **Trung học cơ sở (Middle School): CC BY 4.0**
- **Tiểu học và Trung học phổ thông: CC BY-NC 4.0** (phi thương mại)

Giấy phép cho phép sử dụng lại, chỉnh sửa, phối lại và phân phối, với điều kiện **ghi công đúng cách**, dẫn liên kết tới giấy phép, và nói rõ có thay đổi hay không.

**Vì NEO STEM chỉ áp dụng khung phương pháp chứ không sao chép nội dung unit nào**, đây không phải là tác phẩm phái sinh theo nghĩa của giấy phép. Dù vậy, việc ghi công vẫn nên làm — vừa đúng tinh thần tài nguyên giáo dục mở, vừa để giáo viên biết đường tìm tới nguồn gốc:

> Phương pháp dạy học của NEO STEM phỏng theo mô hình của **OpenSciEd** (<https://www.openscied.org>), phát hành theo giấy phép Creative Commons CC BY 4.0 (cấp THCS) và CC BY-NC 4.0 (cấp Tiểu học và THPT). Nội dung 20 hoạt động trong NEO STEM là biên soạn mới cho bối cảnh Việt Nam, không phải bản dịch tài liệu của OpenSciEd. OpenSciEd không thẩm định và không bảo trợ cho NEO STEM.

Câu cuối là bắt buộc về mặt pháp lý: giấy phép CC yêu cầu **không được để người đọc hiểu nhầm rằng bên giữ bản quyền bảo trợ cho sản phẩm của mình**.

⚠️ **Việc cần làm nếu NEO STEM đi theo hướng thương mại** (bán kèm máy NEO One, bán bản quyền cho trường): phần cấp Tiểu học và THPT của OpenSciEd mang giấy phép **NC — phi thương mại**. Chỉ dùng khung phương pháp thì không vướng, nhưng nếu sau này có lấy trực tiếp nội dung unit nào của OpenSciEd thì phải xin *License for Commercial Use of Curriculum Materials*. Nên chốt điểm này với người phụ trách sản phẩm trước khi mở rộng.

### Storyline — tư tưởng cốt lõi mượn được, và chỗ NEO STEM chưa đạt

Thứ đáng giá nhất lấy từ OpenSciEd không phải năm cái routine, mà là khái niệm **storyline**: chuỗi bài học phải **mạch lạc theo góc nhìn học sinh**, mỗi bước tiếp theo trả lời một câu hỏi mà chính các em vừa đặt ra. Cách dạy truyền thống sắp bài theo trật tự mà *chuyên gia* thấy hợp lý — trật tự đó chỉ mạch lạc với người đã hiểu môn học rồi.

**NEO STEM hiện chưa có storyline.** 20 hoạt động đứng độc lập; học xong một bài, học sinh quay về màn hình chọn bài. Đúng như đã nêu ở mục ánh xạ routine: cái duy nhất chưa hiện thực hóa là **Navigation Routine** — routine giữ cho mạch chuyện không đứt. NEO STEM đang có 20 mở đầu truyện hay, chưa có cuốn truyện nào.

Đây là hướng phát triển lớn nhất còn lại, lớn hơn cả việc bổ sung hoạt động cho lớp 8-9. Bốn mạch chuyện có thể ghép ngay từ bộ hoạt động hiện tại, cùng điều kiện kỹ thuật cần thêm, nằm ở [`TRIET_LY_NEO_STEM.md`](TRIET_LY_NEO_STEM.md) mục 1.4.

### Phần NEO STEM mở rộng: thí nghiệm mô phỏng

OpenSciEd thiết kế cho lớp học có bộ dụng cụ đi kèm. NEO STEM chạy trên máy đặt ở nhà, thư viện, điểm trường vùng xa — nên bước 3 là **mô phỏng tương tác**. Đây là phần NEO STEM tự thêm, không có trong OpenSciEd.

Cái được: học sinh thấy quy luật trong vài phút, và thấy được cả thứ không làm nổi ở nhà (30 ngày gỉ sét, pha Mặt Trăng suốt một tháng).

Cái mất: **số liệu do người viết phần mềm đặt ra** — hiểu sai thì học sinh học điều sai với đầy đủ vẻ ngoài của một phép đo khoa học. Toàn bộ 5 lỗi trong báo cáo này đều là hệ quả của rủi ro đó. Ba kỷ luật đi kèm phần mở rộng này: xem [`TRIET_LY_NEO_STEM.md`](TRIET_LY_NEO_STEM.md) mục 4.

### Hai nguồn tư tưởng còn lại

Tài liệu nguồn `20_cau_hoi_openscied_gdpt2018.docx` nêu rõ NEO STEM đứng trên ba chân, OpenSciEd chỉ là một:

- **Seymour Papert** — học bằng cách kiến tạo, "microworld" cho phép thử sai an toàn. Thấy rõ nhất ở bước 3 và bước 4: học sinh chỉnh thanh trượt, quan sát quy luật, rồi tự ghép mô hình thay vì được giảng.
- **Tư tưởng Hồ Chí Minh về giáo dục quần chúng** — "học đi đôi với hành", xuất phát từ đời sống thật của nhân dân, ai cũng tham gia được với chi phí thấp.
- **OpenSciEd** — khung quy trình lên lớp lấy câu hỏi của học sinh làm trung tâm.

## 6. Lưu ý về nguồn đối chiếu

Ánh xạ trong tài liệu này dựa trên Chương trình GDPT 2018 (Thông tư 32/2018/TT-BGDĐT) và các bộ SGK hiện hành (Kết nối tri thức, Chân trời sáng tạo, Cánh diều). Vì thứ tự bài giữa ba bộ sách có khác nhau đôi chút, **tên chủ đề** được dùng làm mốc thay cho số bài. Trước khi in tài liệu phát cho học sinh, nên đối chiếu lần cuối với bộ sách mà trường đang dùng.
