import QtQuick
import "../../core"

ModelBuilder {
    title: qsTr("Mô hình: Chai nước và tần số âm thanh")
    instructions: qsTr("Kéo các ô vào đúng thứ tự để giải thích tại sao GÕ vào chai nhiều nước lại nghe tiếng trầm.")

    correctSequence: [
        { id: "tap", label: qsTr("Gõ vào thành chai") },
        { id: "glass_water", label: qsTr("Thủy tinh + nước cùng rung") },
        { id: "more_mass", label: qsTr("Nhiều nước = khối lượng lớn") },
        { id: "low_freq", label: qsTr("Rung chậm → tần số thấp") },
        { id: "low_pitch", label: qsTr("Nghe tiếng trầm") }
    ]

    distractors: [
        { id: "air_vibrate", label: qsTr("Cột không khí rung") },
        { id: "water_sound", label: qsTr("Nước tự tạo âm") },
        { id: "hard_tap", label: qsTr("Gõ mạnh = tiếng cao") }
    ]

    dropZoneLabels: [
        qsTr("Hành động"),
        qsTr("Vật rung"),
        qsTr("Yếu tố quyết định"),
        qsTr("Kết quả vật lý"),
        qsTr("Kết quả nghe")
    ]
}
