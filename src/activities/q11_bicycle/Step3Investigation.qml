import QtQuick
import QtQuick.Layouts
import NEO_STEM

InvestigationBase {
    title: qsTr("Thí nghiệm: Máng nghiêng và viên bi")
    instructions: qsTr("Chỉ thay đổi MỘT biến: độ cao của máng. Đo tốc độ viên bi ở cuối máng. Ghi lại dữ liệu.")
    requiredDataPoints: 5
    dataHeaders: [qsTr("Độ cao (cm)"), qsTr("Tốc độ (cm/s)"), qsTr("Nhận xét")]

    property real rampHeight: 20  // 10-50 cm — BIẾN ĐỘC LẬP DUY NHẤT của thí nghiệm này
    // Bảo toàn cơ năng: m*g*h = 1/2*m*v^2  →  v = sqrt(2*g*h), tức v tỉ lệ với CĂN BẬC HAI độ cao.
    // Gấp đôi độ cao KHÔNG làm tốc độ gấp đôi, chỉ nhanh hơn khoảng 1,41 lần.
    property real ballSpeed: Math.sqrt(rampHeight) * 15

    experimentArea: [
        Item {
            anchors.fill: parent

            // Ramp
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    var topY = height * (0.8 - rampHeight / 70)
                    var bottomY = height * 0.8
                    // Ramp surface
                    ctx.beginPath()
                    ctx.moveTo(width * 0.15, topY)
                    ctx.lineTo(width * 0.65, bottomY)
                    ctx.lineTo(width * 0.65, bottomY + 6)
                    ctx.lineTo(width * 0.15, topY + 6)
                    ctx.closePath()
                    ctx.fillStyle = "#795548"
                    ctx.fill()
                    // Flat section
                    ctx.fillRect(width * 0.65, bottomY, width * 0.3, 6)
                }
                // rampHeight thuộc về InvestigationBase (gốc file), không thể viết
                // onRampHeightChanged trực tiếp trong Canvas con — phải nhân bản thuộc tính.
                property real hWatch: rampHeight
                onHWatchChanged: requestPaint()
            }

            // Ball rolling animation
            Rectangle {
                id: ball
                width: 16; height: 16; radius: 8; color: "#F44336"

                property real animDur: Math.max(300, 2000 - ballSpeed * 15)

                SequentialAnimation on x {
                    id: ballAnimX
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: parent.width * 0.15; to: parent.width * 0.85; duration: ball.animDur }
                    PauseAnimation { duration: 500 }
                }
                SequentialAnimation on y {
                    id: ballAnimY
                    running: true; loops: Animation.Infinite
                    NumberAnimation {
                        from: parent.height * (0.8 - rampHeight / 70) - 16
                        to: parent.height * 0.8 - 16
                        duration: ball.animDur * 0.75
                    }
                    NumberAnimation {
                        from: parent.height * 0.8 - 16
                        to: parent.height * 0.8 - 16
                        duration: ball.animDur * 0.25
                    }
                    PauseAnimation { duration: 500 }
                }
            }

            // Height marker
            Rectangle {
                x: parent.width * 0.08; y: parent.height * (0.8 - rampHeight / 70)
                width: 3; height: parent.height * 0.8 - y
                color: "#FF9800"

                Text {
                    anchors.right: parent.left; anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("%1 cm").arg(Math.round(rampHeight))
                    font.pixelSize: 12; color: "#FF9800"; font.bold: true
                }
            }

            // Speed display
            Rectangle {
                anchors.right: parent.right; anchors.rightMargin: 8
                anchors.top: parent.top; anchors.topMargin: 8
                width: speedText2.implicitWidth + 16; height: speedText2.implicitHeight + 8
                radius: 8; color: NeoConstants.warmOrange
                Text {
                    id: speedText2; anchors.centerIn: parent
                    text: qsTr("Tốc độ: %1 cm/s").arg(Math.round(ballSpeed))
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "white"
                }
            }
        }
    ]

    controlsArea: [
        SliderControl {
            anchors.fill: parent; anchors.margins: 8
            label: qsTr("📐 Độ cao máng nghiêng")
            value: rampHeight; from: 10; to: 50; stepSize: 1
            accentColor: NeoConstants.warmOrange
            labels: [qsTr("10cm"), qsTr("30cm"), qsTr("50cm")]
            onValueChanged: rampHeight = value
        }
    ]

    function recordCurrentData() {
        var speedLabel = ballSpeed < 40 ? qsTr("Chậm") : (ballSpeed < 70 ? qsTr("Vừa") : qsTr("Nhanh"))
        addDataPoint([Math.round(rampHeight), Math.round(ballSpeed), speedLabel])
    }

    function getConclusion() {
        if (dataPoints.length >= requiredDataPoints) {
            return qsTr("Kết luận: viên bi ở trên cao mang THẾ NĂNG hấp dẫn (W = m·g·h). Khi lăn xuống, " +
                        "toàn bộ thế năng chuyển thành ĐỘNG NĂNG (W = 1/2·m·v²).\n\n" +
                        "Cho hai vế bằng nhau: m·g·h = 1/2·m·v²  →  v = căn bậc hai của (2·g·h).\n\n" +
                        "Hãy kiểm tra lại bảng số liệu của em: nâng máng từ 10 cm lên 40 cm là gấp BỐN lần độ cao, " +
                        "nhưng tốc độ chỉ tăng khoảng HAI lần — vì tốc độ tỉ lệ với CĂN BẬC HAI của độ cao, không tỉ lệ thẳng.\n\n" +
                        "Xe đạp xuống dốc cũng vậy: dốc cao gấp đôi không làm xe nhanh gấp đôi.")
        }
        return qsTr("Cần thêm dữ liệu để kết luận.")
    }
}
