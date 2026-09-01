import QtQuick
import NEO_STEM

ProblematizeChallenge {
    title: qsTr("Thách thức: Sáo trúc — gõ hay thổi?")

    scenario: qsTr("Bạn Minh xem nghệ sĩ thổi sáo trúc. Nghệ sĩ chỉ dùng một ống tre có lỗ, " +
                   "nhưng bịt mở các lỗ khác nhau thì tạo ra các nốt Đồ, Rê, Mi, Fa, Sol rõ ràng. " +
                   "Minh nhớ lại thí nghiệm chai nước: GÕ và THỔI cho quy luật ngược nhau. " +
                   "Vậy cây sáo trúc hoạt động giống cách nào?")

    challengeQuestion: qsTr("Sáo trúc giống cách GÕ hay cách THỔI chai nước?")

    choices: [
        {
            text: qsTr("Giống cách THỔI — vật rung là cột không khí trong ống; bịt lỗ làm cột khí dài ra nên tiếng trầm hơn"),
            correct: true,
            explanation: qsTr("Đúng! Ở sáo trúc, thân tre gần như đứng yên — thứ rung lên là CỘT KHÔNG KHÍ bên trong ống, " +
                             "y hệt khi ta thổi ngang miệng chai nước.\n\n" +
                             "Bịt nhiều lỗ → không khí bị giữ trong đoạn ống dài hơn → cột khí dài → rung chậm → tần số thấp → tiếng TRẦM.\n" +
                             "Mở lỗ → không khí thoát ra sớm → cột khí ngắn → rung nhanh → tần số cao → tiếng CAO.\n\n" +
                             "Muốn biết cao độ thay đổi ra sao, luôn phải hỏi trước: CÁI GÌ đang rung?")
        },
        {
            text: qsTr("Giống cách GÕ — vì ống tre là vật rắn, chính thân tre rung lên tạo ra âm thanh"),
            correct: false,
            explanation: qsTr("Chưa đúng. Thân tre có rung một chút, nhưng đó chỉ là âm sắc. " +
                             "Nếu bịt chặt hai đầu ống rồi thổi, sáo sẽ không kêu — chứng tỏ thứ tạo ra nốt nhạc là cột không khí, không phải thân tre.\n\n" +
                             "Nhạc cụ thuộc nhóm GÕ (thân vật rung) là đàn đá, chuông, mõ, cồng chiêng — chúng vẫn kêu khi không có khoang khí nào.")
        },
        {
            text: qsTr("Không giống cách nào, vì sáo dùng hơi người thổi nên là nguyên lý hoàn toàn khác"),
            correct: false,
            explanation: qsTr("Hơi thổi chỉ là cách CUNG CẤP năng lượng, giống như que gõ ở chai nước. " +
                             "Điều quyết định cao độ vẫn là vật nào rung và nó nặng hay nhẹ, dài hay ngắn. " +
                             "Ở sáo, đó là cột không khí — đúng như cách THỔI chai nước.")
        },
        {
            text: qsTr("Giống cả hai, vì cách nào cũng tạo ra âm thanh nên nguyên lý như nhau"),
            correct: false,
            explanation: qsTr("Cùng tạo ra âm thanh, nhưng quy luật thì ngược nhau — đó chính là phát hiện của bài này. " +
                             "Thêm nước vào chai: GÕ thì tiếng trầm đi, THỔI thì tiếng cao lên. " +
                             "Không thể gộp hai cơ chế làm một.")
        }
    ]

    extendedInfo: qsTr("Mở rộng: mọi nhạc cụ đều thuộc một trong hai nhóm này.\n\n" +
                       "NHÓM CỘT KHÍ RUNG (giống cách THỔI): sáo trúc, sáo recorder, kèn trumpet, đàn organ nhà thờ. " +
                       "Ống càng dài → tiếng càng trầm. Ống lớn nhất của organ nhà thờ dài tới 10 mét!\n\n" +
                       "NHÓM VẬT RẮN RUNG (giống cách GÕ): đàn đá Việt Nam, cồng chiêng Tây Nguyên, mõ, chuông, đàn t'rưng. " +
                       "Thanh đá càng to và nặng → tiếng càng trầm — đúng quy luật khối lượng mà em vừa đo ở chai nước.\n\n" +
                       "Người xưa làm đàn đá đã biết chọn thanh đá theo kích thước để có đủ nốt, dù chưa hề có công thức nào. " +
                       "Đó là khoa học rút ra từ quan sát và thử nghiệm — đúng cách em đang học.")
}
