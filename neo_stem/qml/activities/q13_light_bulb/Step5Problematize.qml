import QtQuick
import "../../core"

ProblematizeChallenge {
    title: qsTr("Thách thức: LED tiết kiệm điện")

    scenario: qsTr("Gia đình bạn Hoa thay toàn bộ 20 bóng đèn sợi đốt 60W bằng đèn LED 9W. " +
                   "Sau một tháng, tiền điện giảm đáng kể. Bố Hoa nói: 'LED sáng tương đương mà tốn ít điện hơn nhiều!' " +
                   "Hoa thắc mắc: cả hai đều dùng điện, tại sao LED lại tiết kiệm hơn?")

    challengeQuestion: qsTr("Tại sao LED tiết kiệm điện hơn đèn sợi đốt?")

    choices: [
        {
            text: qsTr("LED chuyển khoảng 35% điện năng thành ánh sáng, đèn sợi đốt chỉ khoảng 5% (95% thành nhiệt lãng phí)"),
            correct: true,
            explanation: qsTr("Đúng! Đèn sợi đốt phải ĐỐT NÓNG dây tóc lên 2500°C mới phát sáng — khoảng 95% điện năng thoát ra thành NHIỆT, chỉ ~5% thành ánh sáng. " +
                             "Đèn LED cho electron phát photon trực tiếp, không qua bước đốt nóng — khoảng 35% điện năng thành ÁNH SÁNG (loại tốt nhất hiện nay đạt trên 50%). " +
                             "Chênh khoảng 7 lần, đúng bằng tỉ số bóng LED 9W thay được bóng sợi đốt 60W mà em kiểm chứng được ngay ở cửa hàng.")
        },
        {
            text: qsTr("Vì LED dùng loại điện khác, ít tốn năng lượng hơn"),
            correct: false,
            explanation: qsTr("Cả hai đều dùng cùng nguồn điện từ ổ cắm (220V AC). Sự khác biệt nằm ở cách CHUYỂN HÓA năng lượng: sợi đốt lãng phí thành nhiệt, LED chuyển trực tiếp thành ánh sáng.")
        },
        {
            text: qsTr("Vì LED nhỏ hơn nên cần ít điện hơn"),
            correct: false,
            explanation: qsTr("Kích thước không quyết định hiệu suất. Vấn đề là tỉ lệ chuyển hóa: đèn sợi đốt lãng phí khoảng 95% điện thành nhiệt, còn LED chuyển được khoảng 35% thành ánh sáng — gấp bảy lần.")
        },
        {
            text: qsTr("Vì LED phát sáng yếu hơn nên tốn ít điện"),
            correct: false,
            explanation: qsTr("LED 9W cho độ sáng TƯƠNG ĐƯƠNG đèn sợi đốt 60W — hơn gần 7 lần. LED không sáng yếu hơn; nó hiệu quả hơn vì chuyển điện thành ánh sáng trực tiếp, không qua bước đốt nóng.")
        }
    ]

    extendedInfo: qsTr("So sánh hiệu suất các loại đèn (phần điện năng thật sự thành ánh sáng):\n\n" +
                       "Đèn sợi đốt: ~5% ánh sáng, ~95% nhiệt (tuổi thọ ~1.000 giờ)\n" +
                       "Đèn huỳnh quang compact: ~15% ánh sáng (tuổi thọ ~8.000 giờ)\n" +
                       "Đèn LED dân dụng: ~30-40% ánh sáng (tuổi thọ ~25.000 giờ)\n\n" +
                       "Cách tự kiểm chứng: ra cửa hàng đọc nhãn bóng đèn. Bóng LED 9W ghi 'tương đương 60W' — " +
                       "tỉ số 60/9 gần bằng 7, đúng bằng tỉ số 35% chia 5%. Con số trên nhãn và con số hiệu suất phải khớp nhau, " +
                       "nếu không thì một trong hai đã sai.\n\n" +
                       "Ứng dụng: thay 1 bóng sợi đốt 60W bằng LED 9W tiết kiệm ~51W. " +
                       "Với 20 bóng, bật 8 giờ/ngày, tiết kiệm ~245 kWh/năm.")
}
