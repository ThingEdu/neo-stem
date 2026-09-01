import QtQuick
import "../../core"
import QtQuick.Layouts

InvestigationBase {
    title: qsTr("Thí nghiệm: Lăng kính tách ánh sáng")
    instructions: qsTr("Xoay lăng kính và đo dải quang phổ hứng trên màn. Chú ý xem CÁI GÌ thay đổi và CÁI GÌ giữ nguyên khi góc thay đổi.")
    requiredDataPoints: 5
    dataHeaders: [qsTr("Góc tới (°)"), qsTr("Độ rộng dải (mm)"), qsTr("Số màu"), qsTr("Thứ tự màu")]

    property real prismAngle: 0

    // Lăng kính tán sắc ánh sáng trắng thành dải màu LIÊN TỤC — mọi màu xuất hiện CÙNG LÚC,
    // không có chuyện "thêm dần từng màu" khi xoay lăng kính.
    // Xoay lăng kính chỉ làm thay đổi ĐỘ RỘNG của dải quang phổ hứng được trên màn:
    //     độ rộng ~ độ tán sắc góc, tăng khi góc tới lệch xa góc lệch cực tiểu.
    // Mô hình dùng ở đây: width = 42 * sin(góc tới), đơn vị mm, màn đặt cách lăng kính 30 cm.
    property real spectrumWidth: 42 * Math.sin(prismAngle * Math.PI / 180)
    property bool dispersed: prismAngle > 2

    // Số màu KHÔNG phụ thuộc góc: có tán sắc thì thấy đủ cả dải.
    property int visibleColors: dispersed ? 7 : 0

    // Thứ tự màu cũng KHÔNG đổi: đỏ lệch ít nhất, tím lệch nhiều nhất.
    property string colorOrder: dispersed ? qsTr("Đỏ, Cam, Vàng, Lục, Lam, Chàm, Tím (đỏ lệch ít nhất)")
                                          : qsTr("Chưa tán sắc")

    experimentArea: [
        Item {
            anchors.fill: parent

            // White light beam
            Rectangle {
                id: lightBeam
                x: 0; y: parent.height * 0.4
                width: parent.width * 0.35; height: 6
                color: "white"
                border.width: 1; border.color: "#E0E0E0"
            }

            // Prism
            Canvas {
                id: prism
                anchors.centerIn: parent
                width: 80; height: 70
                rotation: prismAngle * 0.5
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.beginPath()
                    ctx.moveTo(width / 2, 0)
                    ctx.lineTo(width, height)
                    ctx.lineTo(0, height)
                    ctx.closePath()
                    ctx.fillStyle = "rgba(200, 230, 255, 0.6)"
                    ctx.fill()
                    ctx.strokeStyle = "#90CAF9"
                    ctx.lineWidth = 2
                    ctx.stroke()
                }
            }

            // Spectrum output
            Column {
                x: parent.width * 0.65
                y: parent.height * 0.2
                width: parent.width * 0.3
                spacing: 2
                Repeater {
                    model: [
                        { c: "#FF0000", n: qsTr("Đỏ") },
                        { c: "#FF7F00", n: qsTr("Cam") },
                        { c: "#FFFF00", n: qsTr("Vàng") },
                        { c: "#00FF00", n: qsTr("Lục") },
                        { c: "#0000FF", n: qsTr("Lam") },
                        { c: "#4B0082", n: qsTr("Chàm") },
                        { c: "#8B00FF", n: qsTr("Tím") }
                    ]
                    Rectangle {
                        width: parent.width
                        // Cả 7 màu luôn xuất hiện cùng lúc; góc lớn hơn chỉ làm dải RỘNG ra.
                        height: dispersed ? Math.max(3, spectrumWidth * 0.42) : 2
                        radius: 2
                        color: modelData.c
                        opacity: dispersed ? 0.9 : 0.12

                        Behavior on opacity { NumberAnimation { duration: 300 } }
                        Behavior on height { NumberAnimation { duration: 300 } }
                    }
                }
            }

            // Angle display
            Rectangle {
                anchors.left: parent.left; anchors.leftMargin: 8
                anchors.top: parent.top; anchors.topMargin: 8
                width: angleText.implicitWidth + 16; height: angleText.implicitHeight + 8
                radius: 8; color: NeoConstants.oceanBlue
                Text {
                    id: angleText; anchors.centerIn: parent
                    text: dispersed ? qsTr("Góc: %1° — dải rộng %2 mm — vẫn đủ 7 màu")
                                          .arg(Math.round(prismAngle)).arg(Math.round(spectrumWidth))
                                    : qsTr("Góc: %1° — chưa tán sắc").arg(Math.round(prismAngle))
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "white"
                }
            }
        }
    ]

    controlsArea: [
        SliderControl {
            anchors.fill: parent; anchors.margins: 8
            label: qsTr("🔄 Góc tới của tia sáng")
            value: prismAngle; from: 0; to: 75; stepSize: 1
            accentColor: NeoConstants.stepIndigo
            labels: [qsTr("0°"), qsTr("25°"), qsTr("50°"), qsTr("75°")]
            onValueChanged: prismAngle = value
        }
    ]

    function recordCurrentData() {
        addDataPoint([Math.round(prismAngle), Math.round(spectrumWidth), visibleColors, colorOrder])
    }

    function getConclusion() {
        if (dataPoints.length >= requiredDataPoints) {
            return qsTr("Kết luận: hãy nhìn lại bảng số liệu của em — cột nào ĐỔI và cột nào KHÔNG ĐỔI?\n\n" +
                        "ĐỔI: độ rộng dải quang phổ. Góc tới càng lớn, các màu càng tách xa nhau, dải càng rộng.\n\n" +
                        "KHÔNG ĐỔI: số màu (luôn đủ cả dải) và thứ tự màu (đỏ luôn lệch ít nhất, tím lệch nhiều nhất). " +
                        "Ánh sáng trắng đã chứa sẵn tất cả các màu, nên khi tán sắc thì chúng hiện ra CÙNG MỘT LÚC — " +
                        "không có chuyện xoay lăng kính để 'thêm dần từng màu'.\n\n" +
                        "Vì sao tím lệch nhiều nhất? Vì chiết suất của thủy tinh với ánh sáng tím lớn hơn với ánh sáng đỏ. " +
                        "Cầu vồng chính là quang phổ của ánh sáng mặt trời được hàng triệu giọt mưa tách ra theo đúng cách này.")
        }
        return qsTr("Cần thêm dữ liệu để kết luận.")
    }
}
