# NEO STEM

Ứng dụng giáo dục STEM tương tác cho học sinh Việt Nam (**Lớp 4-9**), bám Chương trình GDPT 2018, học từ những hiện tượng đời sống quen thuộc theo cách trực quan, chạm để khám phá và có thể dùng cả khi không có Internet.

## Ứng dụng này là gì?

NEO STEM mang đến 20 hoạt động khoa học theo mô hình học tập 5 bước:
Hiện tượng → Câu hỏi → Thí nghiệm → Mô hình → Thách thức.
Mỗi hoạt động giúp học sinh quan sát, đặt câu hỏi, thử nghiệm, tự rút kết luận và kiểm tra lại hiểu biết qua trò chơi.

## Dành cho ai

- Học sinh Việt Nam **lớp 4-9** — môn Khoa học (lớp 4-5) và Khoa học tự nhiên (lớp 6-9)
- Phụ huynh và giáo viên muốn có nội dung STEM dễ dùng, có lộ trình rõ ràng
- Môi trường học tại nhà, lớp học, thư viện hoặc trung tâm

## Trải nghiệm học tập

- 3 cấp độ theo môn học: **Khoa học 4-5** · **KHTN 6-7** · **KHTN 8-9**, mỗi hoạt động ghi rõ lớp theo GDPT 2018
- Mỗi bước được chấm sao (1-3 sao), tối đa 300 sao cho toàn bộ nội dung
- 29 huy hiệu khích lệ tiến bộ và sự kiên trì


> **Vì sao là lớp 4 chứ không phải lớp 3.** Chương trình GDPT 2018 chỉ có môn Khoa học **từ lớp 4**;
> lớp 1-3 học Tự nhiên và Xã hội, chương trình đó không có bay hơi, ngưng tụ, tần số hay mạch điện.
> Nhãn lớp của từng hoạt động hiện ngay trên thẻ chọn bài.

## Nội dung nổi bật

- 20 hiện tượng khoa học đời sống, ví dụ: nồi cơm, sương mù, cầu vồng, âm thanh trống, bong bóng xà phòng, kem lạnh...
- 4 nhóm chủ đề giúp học sinh liên hệ khoa học với thế giới xung quanh
- Giao diện chạm thân thiện, dễ thao tác với trẻ nhỏ

## Tính năng chính

- Hoạt động offline, lưu tiến độ học tập trên thiết bị
- Có tiếng Việt mặc định và tùy chọn tiếng Anh
- Tối ưu cho màn hình cảm ứng và thiết bị phổ thông

## Hướng dẫn sử dụng

### Cách mở ứng dụng trên NEO One

- Ở góc trái trên cùng màn hình, trong phần Application → Education, chọn NEO STEM
- Từ terminal: chạy lệnh `neostem`
- Từ giao diện desktop: mở biểu tượng/launcher được tạo bởi trình cài đặt

### Cách sử dụng theo từng tính năng

- Chọn hoạt động: vào danh sách 20 hiện tượng, chọn một chủ đề để bắt đầu
- 5 bước học tập: lần lượt trải nghiệm Hiện tượng → Câu hỏi → Thí nghiệm → Mô hình → Thách thức
- Quan sát hiện tượng: chạm vào các điểm tương tác để khám phá
- Câu hỏi dẫn dắt: tạo câu hỏi và trả lời bằng ghi chú dán
- Thí nghiệm mô phỏng: thao tác theo hướng dẫn để quan sát dữ liệu
- Mô hình kéo thả: lắp ghép các thành phần để giải thích hiện tượng
- Thách thức trắc nghiệm: chọn đáp án, hoàn thành để nhận sao
- Sao và huy hiệu: mỗi bước được chấm sao (1-3), tích lũy để nhận huy hiệu
- Tiến độ học tập: kết quả được lưu trên thiết bị, mở lại để học tiếp
- Ngôn ngữ: dùng tiếng Việt mặc định, có tùy chọn tiếng Anh

## Bắt đầu nhanh

### Cài đặt trên NEO One (Linux / macOS)

Cài trên NEO One
```bash
curl -sSL https://raw.githubusercontent.com/MEO-3/neo-stem/master/scripts/install_on_neo.sh | bash
```

### Cài đặt thủ công

```bash
pip install PyQt6
python -m neo_stem.app
```

Hoặc dùng entry point:

```bash
pip install -e .
neo-stem
```

## Yêu cầu tối thiểu

- Windows 10+, macOS 13+, Linux (Ubuntu 22.04+ / Debian 12+)
- Python 3.8+ và PyQt6 6.5+

## License

MIT - Bình Dân Học STEM & Robot

## Tài liệu

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - Kiến trúc ứng dụng
- [docs/publishing.md](docs/publishing.md) - Quy trình phát hành
