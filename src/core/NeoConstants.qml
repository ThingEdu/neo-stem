import QtQuick
pragma Singleton

QtObject {
    // Colors - Primary
    readonly property color forestGreen: "#2E7D32"
    readonly property color oceanBlue: "#1565C0"

    // Colors - Accent
    readonly property color warmOrange: "#FF8F00"
    readonly property color sunshine: "#FFD600"

    // Colors - Background
    readonly property color ricePaper: "#FFF8E1"
    readonly property color cardBg: "#FFFFFF"

    // Colors - 5 Step Colors
    readonly property color stepCoral: "#FF7043"
    readonly property color stepAmber: "#FFB300"
    readonly property color stepTeal: "#26A69A"
    readonly property color stepIndigo: "#5C6BC0"
    readonly property color stepPurple: "#AB47BC"

    // Colors - Feedback
    readonly property color successGreen: "#43A047"
    readonly property color errorRed: "#E53935"
    readonly property color hintBlue: "#29B6F6"

    // Step colors array
    readonly property var stepColors: [stepCoral, stepAmber, stepTeal, stepIndigo, stepPurple]

    // Step names
    readonly property var stepNames: [
        qsTr("Hiện tượng Neo"),
        qsTr("Bảng câu hỏi"),
        qsTr("Thí nghiệm"),
        qsTr("Xây dựng mô hình"),
        qsTr("Thách thức")
    ]

    // Cấp độ theo Chương trình GDPT 2018 (Thông tư 32/2018/TT-BGDĐT).
    // Lưu ý: môn Khoa học chỉ bắt đầu từ LỚP 4. Lớp 1-3 học Tự nhiên và Xã hội,
    // chương trình đó không có bay hơi, ngưng tụ, tần số hay mạch điện — nên ứng dụng này là LỚP 4-9.
    readonly property string levelBasic: "basic"                // Khoa học 4-5 (Tiểu học)
    readonly property string levelIntermediate: "intermediate"  // KHTN 6-7 (THCS)
    readonly property string levelAdvanced: "advanced"          // KHTN 8-9 (THCS)
    readonly property string levelEnrichment: "enrichment"      // Ngoài yêu cầu cần đạt — dùng cho ngoại khóa

    // Nhãn hiển thị = TÊN MÔN, ghép với gradeCore thành "Khoa học 4", "KHTN 9"...
    readonly property var levelLabels: ({
        "basic": qsTr("Khoa học"),
        "intermediate": qsTr("KHTN"),
        "advanced": qsTr("KHTN"),
        "enrichment": qsTr("Ngoại khóa")
    })

    readonly property var levelColors: ({
        "basic": "#4CAF50",
        "intermediate": "#FF9800",
        "advanced": "#E91E63",
        "enrichment": "#7E57C2"
    })

    // Question data
    readonly property var questions: [
        {
            id: 1,
            title: qsTr("Nồi cơm điện"),
            question: qsTr("Tại sao nắp nồi cơm điện rung và có hơi nước?"),
            topic: qsTr("Chuyển thể, bay hơi"),
            icon: "🍚",
            level: levelBasic, gradeCore: 4, gradeRange: "4",
            curriculumTopic: qsTr("Khoa học 4 — Nước: sự chuyển thể"),
            mapX: 0.5, mapY: 0.6
        },
        {
            id: 2,
            title: qsTr("Sương mù Đà Lạt"),
            question: qsTr("Tại sao Đà Lạt sáng sớm có sương mù, trưa tan hết?"),
            topic: qsTr("Chu trình nước, ngưng tụ"),
            icon: "🌫",
            level: levelBasic, gradeCore: 4, gradeRange: "4",
            curriculumTopic: qsTr("Khoa học 4 — Nước: chuyển thể, vòng tuần hoàn của nước"),
            mapX: 0.6, mapY: 0.45
        },
        {
            id: 3,
            title: qsTr("Rừng ngập mặn"),
            question: qsTr("Tại sao cây bần/đước sống được trong nước mặn?"),
            topic: qsTr("Tế bào, thẩm thấu"),
            icon: "🌳",
            level: levelIntermediate, gradeCore: 7, gradeRange: "7",
            curriculumTopic: qsTr("KHTN 7 — Trao đổi nước và chất khoáng ở thực vật"),
            mapX: 0.55, mapY: 0.7
        },
        {
            id: 4,
            title: qsTr("Giọt nước trên ly đá"),
            question: qsTr("Tại sao bên ngoài ly đá có giọt nước bám?"),
            topic: qsTr("Ngưng tụ, điểm sương"),
            icon: "🧊",
            level: levelBasic, gradeCore: 4, gradeRange: "4",
            curriculumTopic: qsTr("Khoa học 4 — Nước: sự ngưng tụ"),
            mapX: 0.4, mapY: 0.55
        },
        {
            id: 5,
            title: qsTr("Muối biển"),
            question: qsTr("Tại sao muối biển lấy được bằng cách phơi nắng?"),
            topic: qsTr("Bay hơi, tách hỗn hợp"),
            icon: "🧂",
            level: levelBasic, gradeCore: 4, gradeRange: "4",
            curriculumTopic: qsTr("Khoa học 4 — Sự bay hơi (nghề làm muối); mở rộng KHTN 6 — tách chất"),
            mapX: 0.65, mapY: 0.58
        },
        {
            id: 6,
            title: qsTr("Cầu vồng"),
            question: qsTr("Tại sao cầu vồng xuất hiện sau cơn mưa?"),
            topic: qsTr("Khúc xạ ánh sáng, quang phổ"),
            icon: "🌈",
            level: levelAdvanced, gradeCore: 9, gradeRange: "9",
            curriculumTopic: qsTr("KHTN 9 — Ánh sáng: tán sắc ánh sáng qua lăng kính"),
            mapX: 0.35, mapY: 0.4
        },
        {
            id: 7,
            title: qsTr("Pha mặt trăng"),
            question: qsTr("Tại sao mặt trăng thay đổi hình dạng mỗi đêm?"),
            topic: qsTr("Pha mặt trăng, phản xạ"),
            icon: "🌙",
            level: levelIntermediate, gradeCore: 6, gradeRange: "6",
            curriculumTopic: qsTr("KHTN 6 — Trái Đất và bầu trời: các hình dạng nhìn thấy của Mặt Trăng"),
            mapX: 0.7, mapY: 0.35
        },
        {
            id: 8,
            title: qsTr("Tiếng trống"),
            question: qsTr("Tại sao đập trống phát ra tiếng vang?"),
            topic: qsTr("Sóng âm, rung động"),
            icon: "🥁",
            level: levelBasic, gradeCore: 4, gradeRange: "4",
            curriculumTopic: qsTr("Khoa học 4 — Âm thanh: nguồn âm, sự truyền âm"),
            mapX: 0.45, mapY: 0.75
        },
        {
            id: 9,
            title: qsTr("Quạt điện"),
            question: qsTr("Tại sao quạt điện quay khi cắm điện?"),
            topic: qsTr("Mạch điện, chuyển hóa năng lượng"),
            icon: "🔌",
            level: levelBasic, gradeCore: 5, gradeRange: "5",
            curriculumTopic: qsTr("Khoa học 5 — Mạch điện đơn giản, vật dẫn điện và vật cách điện"),
            mapX: 0.3, mapY: 0.55
        },
        {
            id: 10,
            title: qsTr("Nam châm"),
            question: qsTr("Tại sao nam châm hút đinh sắt nhưng không hút nhôm?"),
            topic: qsTr("Từ tính, vật liệu sắt từ"),
            icon: "🧲",
            level: levelIntermediate, gradeCore: 7, gradeRange: "7",
            curriculumTopic: qsTr("KHTN 7 — Từ: nam châm, từ trường, la bàn"),
            mapX: 0.75, mapY: 0.5
        },
        {
            id: 11,
            title: qsTr("Xe đạp xuống dốc"),
            question: qsTr("Tại sao xe đạp đi nhanh hơn khi xuống dốc?"),
            topic: qsTr("Trọng lực, thế năng/động năng"),
            icon: "🚲",
            level: levelAdvanced, gradeCore: 9, gradeRange: "9",
            curriculumTopic: qsTr("KHTN 9 — Năng lượng cơ học: động năng, thế năng, cơ năng"),
            mapX: 0.2, mapY: 0.65
        },
        {
            id: 12,
            title: qsTr("Lá cây xanh"),
            question: qsTr("Tại sao lá cây xanh nhưng hoa có nhiều màu?"),
            topic: qsTr("Quang hợp, sắc tố"),
            icon: "🌿",
            level: levelIntermediate, gradeCore: 7, gradeRange: "7",
            curriculumTopic: qsTr("KHTN 7 — Quang hợp ở thực vật"),
            mapX: 0.6, mapY: 0.3
        },
        {
            id: 13,
            title: qsTr("Bóng đèn"),
            question: qsTr("Tại sao bóng đèn phát sáng khi bật công tắc?"),
            topic: qsTr("Mạch điện, năng lượng điện→quang"),
            icon: "💡",
            level: levelBasic, gradeCore: 5, gradeRange: "5",
            curriculumTopic: qsTr("Khoa học 5 — Năng lượng điện, sử dụng an toàn và tiết kiệm điện"),
            mapX: 0.8, mapY: 0.65
        },
        {
            id: 14,
            title: qsTr("Rỉ sét"),
            question: qsTr("Tại sao sắt để ngoài mưa bị rỉ sét?"),
            topic: qsTr("Oxy hóa, biến đổi hóa học"),
            icon: "🔩",
            level: levelAdvanced, gradeCore: 9, gradeRange: "9",
            curriculumTopic: qsTr("KHTN 9 — Kim loại: ăn mòn và chống ăn mòn; nhập môn Khoa học 5"),
            mapX: 0.25, mapY: 0.45
        },
        {
            id: 15,
            title: qsTr("Cá thở dưới nước"),
            question: qsTr("Tại sao cá sống được dưới nước?"),
            topic: qsTr("Hô hấp, mang cá, oxy hòa tan"),
            icon: "🐟",
            level: levelIntermediate, gradeCore: 7, gradeRange: "7",
            curriculumTopic: qsTr("KHTN 7 — Trao đổi khí ở sinh vật"),
            mapX: 0.5, mapY: 0.8
        },
        {
            id: 16,
            title: qsTr("Nước ngọt có ga"),
            question: qsTr("Tại sao mở chai nước ngọt có ga bọt phun ra?"),
            topic: qsTr("Độ tan khí, áp suất"),
            icon: "🥤",
            level: levelIntermediate, gradeCore: 6, gradeRange: "6",
            curriculumTopic: qsTr("KHTN 6 — Hỗn hợp, dung dịch, ảnh hưởng của nhiệt độ tới độ tan"),
            mapX: 0.4, mapY: 0.35
        },
        {
            id: 17,
            title: qsTr("Kem tan chảy"),
            question: qsTr("Tại sao kem tan nhanh ngoài nắng?"),
            topic: qsTr("Nóng chảy, truyền nhiệt"),
            icon: "🍦",
            level: levelBasic, gradeCore: 4, gradeRange: "4",
            curriculumTopic: qsTr("Khoa học 4 — Nhiệt: sự truyền nhiệt, vật cách nhiệt"),
            mapX: 0.55, mapY: 0.5
        },
        {
            id: 18,
            title: qsTr("Bóng bay heli"),
            question: qsTr("Tại sao bóng bay heli bay lên trời?"),
            topic: qsTr("Mật độ, lực đẩy Archimedes"),
            icon: "🎈",
            level: levelAdvanced, gradeCore: 8, gradeRange: "8",
            curriculumTopic: qsTr("KHTN 8 — Khối lượng riêng, áp suất, lực đẩy Archimedes"),
            mapX: 0.7, mapY: 0.75
        },
        {
            id: 19,
            title: qsTr("Đom đóm"),
            question: qsTr("Tại sao đom đóm phát sáng trong đêm?"),
            topic: qsTr("Phát quang sinh học, hóa năng→quang"),
            icon: "✨",
            level: levelEnrichment, gradeCore: 0, gradeRange: "—",
            curriculumTopic: qsTr("Ngoài yêu cầu cần đạt — dùng cho ngoại khóa, câu lạc bộ"),
            mapX: 0.35, mapY: 0.7
        },
        {
            id: 20,
            title: qsTr("Chai nước xylophone"),
            question: qsTr("Tại sao gõ và thổi cùng một chai nước cho kết quả ngược nhau?"),
            topic: qsTr("Tần số âm: khối lượng rung và cột khí"),
            icon: "🎵",
            level: levelIntermediate, gradeCore: 7, gradeRange: "7",
            curriculumTopic: qsTr("KHTN 7 — Biên độ, tần số, độ to và độ cao của âm"),
            mapX: 0.8, mapY: 0.4
        }
    ]

    // Chế độ chữ lớn — bật trong Cài đặt, lưu qua Settings
    property bool largeTextMode: false
    readonly property real textScale: largeTextMode ? 1.25 : 1.0

    // Typography — tối ưu cho trẻ em 8-11 tuổi (đã tăng baseline)
    readonly property int fontTitle: Math.round(36 * textScale)   // was 32 → 36, large: 45
    readonly property int fontBody: Math.round(24 * textScale)    // was 20 → 24, large: 30
    readonly property int fontButton: Math.round(24 * textScale)  // was 22 → 24, large: 30
    readonly property int fontCaption: Math.round(18 * textScale) // was 16 → 18, large: 23
    readonly property int fontSmall: Math.round(16 * textScale)   // was 13 → 16, large: 20

    // Touch targets — tăng cho ngón tay nhỏ
    readonly property int touchMin: largeTextMode ? 60 : 52
    readonly property int dragItemSize: largeTextMode ? 84 : 72
    readonly property int buttonHeight: largeTextMode ? 68 : 60

    // Animation durations
    readonly property int animFast: 200
    readonly property int animNormal: 400
    readonly property int animSlow: 800

    // Max stars
    readonly property int maxStarsPerStep: 3
    readonly property int maxStarsPerQuestion: 15
    readonly property int maxStarsTotal: 300

    // Badge IDs
    readonly property var badgeIds: [
        "first_step", "explorer", "question_master", "young_scientist",
        "architect", "challenger",
        "master_q1", "master_q2", "master_q3", "master_q4", "master_q5",
        "master_q6", "master_q7", "master_q8", "master_q9", "master_q10",
        "master_q11", "master_q12", "master_q13", "master_q14", "master_q15",
        "master_q16", "master_q17", "master_q18", "master_q19", "master_q20",
        "perfect", "speed_demon", "self_reliant", "adventurer"
    ]

    readonly property var badgeNames: ({
        "first_step": qsTr("Bước đầu tiên"),
        "explorer": qsTr("Nhà thám hiểm"),
        "question_master": qsTr("Bậc thầy câu hỏi"),
        "young_scientist": qsTr("Nhà khoa học nhí"),
        "architect": qsTr("Kiến trúc sư"),
        "challenger": qsTr("Người thách thức"),
        "master_q1": qsTr("Bậc thầy Nồi cơm"),
        "master_q2": qsTr("Bậc thầy Sương mù"),
        "master_q3": qsTr("Bậc thầy Ngập mặn"),
        "master_q4": qsTr("Bậc thầy Ly đá"),
        "master_q5": qsTr("Bậc thầy Muối biển"),
        "master_q6": qsTr("Bậc thầy Cầu vồng"),
        "master_q7": qsTr("Bậc thầy Mặt trăng"),
        "master_q8": qsTr("Bậc thầy Tiếng trống"),
        "master_q9": qsTr("Bậc thầy Quạt điện"),
        "master_q10": qsTr("Bậc thầy Nam châm"),
        "master_q11": qsTr("Bậc thầy Xe đạp"),
        "master_q12": qsTr("Bậc thầy Lá cây"),
        "master_q13": qsTr("Bậc thầy Bóng đèn"),
        "master_q14": qsTr("Bậc thầy Rỉ sét"),
        "master_q15": qsTr("Bậc thầy Cá thở"),
        "master_q16": qsTr("Bậc thầy Nước ngọt"),
        "master_q17": qsTr("Bậc thầy Kem tan"),
        "master_q18": qsTr("Bậc thầy Bóng bay"),
        "master_q19": qsTr("Bậc thầy Đom đóm"),
        "master_q20": qsTr("Bậc thầy Chai nước"),
        "perfect": qsTr("Hoàn hảo"),
        "speed_demon": qsTr("Nhanh như gió"),
        "self_reliant": qsTr("Tự lực cánh sinh"),
        "adventurer": qsTr("Trí tuệ thám dò")
    })

    // Question groups by knowledge domain
    // "grades" = dải lớp theo GDPT 2018 của các hoạt động trong nhóm (không phải tuổi).
    readonly property var questionGroups: [
        { name: qsTr("Nước & Nhiệt"), icon: "💧", color: "#1E88E5", grades: "4", questionIds: [1,2,4,5,17] },
        { name: qsTr("Ánh sáng & Âm thanh"), icon: "🔆", color: "#FF8F00", grades: "4-9", questionIds: [6,7,8,13,20] },
        { name: qsTr("Lực & Điện từ"), icon: "⚡", color: "#E53935", grades: "5-9", questionIds: [9,10,11,18] },
        { name: qsTr("Sự sống & Hóa học"), icon: "🌱", color: "#43A047", grades: "6-9", questionIds: [3,12,14,15,16,19] }
    ]

    function getQuestionById(id) {
        for (var i = 0; i < questions.length; i++) {
            if (questions[i].id === id) return questions[i]
        }
        return null
    }

    function stepColor(stepIndex) {
        return stepColors[Math.max(0, Math.min(stepIndex, 4))]
    }
}
