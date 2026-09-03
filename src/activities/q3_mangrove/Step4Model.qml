import QtQuick
import NEO_STEM

ModelBuilder {
    title: qsTr("Mô hình: Thẩm thấu ở cây ngập mặn")
    instructions: qsTr("Sắp xếp các bước giải thích cách cây ĐƯỚC sống trong nước mặn. Cẩn thận: có một ô mô tả cơ chế của cây MẮM, không phải cây đước.")

    correctSequence: [
        { id: "salt_water", label: qsTr("Nước mặn quanh rễ") },
        { id: "filter", label: qsTr("Rễ chặn 90% muối lại") },
        { id: "water_in", label: qsTr("Nước sạch vào tế bào") },
        { id: "old_leaf", label: qsTr("Muối dư dồn vào lá già rồi rụng") },
        { id: "survive", label: qsTr("Cây sống khỏe") }
    ]

    distractors: [
        { id: "salt_excrete", label: qsTr("Lá tiết muối thừa (cây mắm)") },
        { id: "absorb_salt", label: qsTr("Hấp thụ toàn bộ muối") },
        { id: "osmosis_out", label: qsTr("Nước rút ra ngoài") }
    ]

    dropZoneLabels: [
        qsTr("Môi trường"),
        qsTr("Rễ"),
        qsTr("Tế bào"),
        qsTr("Xử lý muối dư"),
        qsTr("Kết quả")
    ]
}
