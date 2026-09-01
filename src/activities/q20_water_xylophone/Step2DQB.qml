import QtQuick
import NEO_STEM

DrivingQuestionBoard {
    drivingQuestion: qsTr("Tại sao gõ chai nước và thổi chai nước cho kết quả ngược nhau?")

    subQuestions: [
        { text: qsTr("Khi GÕ, cái gì rung lên?"), answered: false },
        { text: qsTr("Khi THỔI, cái gì rung lên?"), answered: false },
        { text: qsTr("Thêm nước thì vật rung nặng hơn hay nhẹ hơn?"), answered: false },
        { text: qsTr("Vật nặng hơn thì rung nhanh hay chậm hơn?"), answered: false },
        { text: qsTr("Sáo trúc giống cách gõ hay cách thổi?"), answered: false }
    ]
}
