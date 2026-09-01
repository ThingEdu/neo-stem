import QtQuick
import "../../core"
import QtQuick.Layouts

InvestigationBase {
    title: qsTr("Thí nghiệm: So sánh bóng đèn")
    instructions: qsTr("Thay đổi loại bóng đèn (sợi đốt / LED) và số pin. Với CÙNG số pin, hãy so độ sáng của hai loại. Ghi lại dữ liệu.")
    requiredDataPoints: 5
    dataHeaders: [qsTr("Loại đèn"), qsTr("Số pin"), qsTr("Độ sáng"), qsTr("Nhiệt độ vỏ bóng")]

    property int bulbType: 0     // 0 = sợi đốt (incandescent), 1 = LED
    property int batteryCount: 1 // 1-3

    // Độ sáng thu được trên cùng một mức điện năng.
    // Sợi đốt ~5% điện năng thành ánh sáng, LED ~35% → LED sáng hơn khoảng 7 lần.
    // Thang quy ước 0-100 cho 3 pin: sợi đốt 5*pin, LED 33*pin.
    property real brightness: {
        if (bulbType === 0) {
            return batteryCount * 5    // sợi đốt: ~5% điện năng thành ánh sáng
        } else {
            return batteryCount * 33   // LED: ~35% điện năng thành ánh sáng
        }
    }

    // Nhiệt độ VỎ BÓNG (không phải dây tóc — dây tóc tungsten lên tới 2500 độ C).
    property real temperature: {
        if (bulbType === 0) {
            return 30 + batteryCount * 40  // sợi đốt: vỏ bóng rất nóng
        } else {
            return 30 + batteryCount * 5   // LED: vỏ bóng chỉ hơi ấm
        }
    }

    experimentArea: [
        Item {
            anchors.fill: parent

            // Circuit wire loop
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.7; height: parent.height * 0.6
                color: "transparent"; border.width: 3
                border.color: batteryCount > 0 ? "#FFD600" : "#78909C"
                radius: 8

                Behavior on border.color { ColorAnimation { duration: 300 } }
            }

            // Batteries
            Row {
                anchors.left: parent.left; anchors.leftMargin: parent.width * 0.08
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4
                Repeater {
                    model: batteryCount
                    Rectangle {
                        width: 20; height: 36; radius: 3
                        color: "#4CAF50"; border.width: 1; border.color: "#333"
                        Rectangle {
                            anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
                            width: 10; height: 4; color: "#F44336"
                        }
                        Text { anchors.centerIn: parent; text: "+"; color: "white"; font.pixelSize: 14; font.bold: true }
                    }
                }
            }

            // Bulb
            Rectangle {
                id: bulbBody
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: parent.width * 0.15
                y: parent.height * 0.15
                width: 50; height: 60; radius: 25
                color: {
                    if (bulbType === 0) {
                        return brightness > 8 ? "#FFF9C4" : "#FFF3E0"
                    } else {
                        return brightness > 25 ? "#E3F2FD" : "#ECEFF1"
                    }
                }
                opacity: 0.35 + brightness / 100 * 0.65
                border.width: 1
                border.color: bulbType === 0 ? "#FFA000" : "#1565C0"

                Behavior on color { ColorAnimation { duration: 300 } }
                Behavior on opacity { NumberAnimation { duration: 300 } }

                // Filament for incandescent or chip for LED
                Rectangle {
                    anchors.centerIn: parent
                    width: bulbType === 0 ? 3 : 14
                    height: bulbType === 0 ? 20 : 8
                    radius: bulbType === 0 ? 1 : 2
                    color: {
                        if (bulbType === 0) {
                            return brightness > 8 ? "#FF6F00" : "#9E9E9E"
                        } else {
                            return brightness > 25 ? "#2196F3" : "#90A4AE"
                        }
                    }

                    Behavior on color { ColorAnimation { duration: 300 } }
                }
            }

            // Bulb screw base
            Rectangle {
                anchors.horizontalCenter: bulbBody.horizontalCenter
                y: bulbBody.y + bulbBody.height - 5
                width: 30; height: 18; radius: 4
                color: "#9E9E9E"; border.width: 1; border.color: "#757575"
            }

            // Glow effect
            Rectangle {
                visible: brightness > 8
                anchors.centerIn: bulbBody
                width: 90; height: 90; radius: 45
                color: bulbType === 0 ? "#FFF9C4" : "#E3F2FD"
                opacity: brightness / 100 * 0.4

                SequentialAnimation on opacity {
                    running: brightness > 8; loops: Animation.Infinite
                    NumberAnimation { from: 0.15; to: 0.35; duration: 1000 }
                    NumberAnimation { from: 0.35; to: 0.15; duration: 1000 }
                }
            }

            // Heat indicator (thermometer)
            Rectangle {
                anchors.right: parent.right; anchors.rightMargin: parent.width * 0.08
                anchors.verticalCenter: parent.verticalCenter
                width: 16; height: 80; radius: 8
                color: "#ECEFF1"; border.width: 1; border.color: "#B0BEC5"

                // Mercury level
                Rectangle {
                    anchors.bottom: parent.bottom; anchors.bottomMargin: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 10; radius: 5
                    height: Math.min(parent.height - 4, (temperature - 30) / 120 * (parent.height - 4) + 10)
                    color: temperature > 100 ? "#F44336" : (temperature > 60 ? "#FF9800" : "#4CAF50")

                    Behavior on height { NumberAnimation { duration: 400 } }
                    Behavior on color { ColorAnimation { duration: 400 } }
                }
            }

            // Temperature label
            Rectangle {
                anchors.right: parent.right; anchors.rightMargin: 6
                anchors.top: parent.top; anchors.topMargin: 8
                width: tempLabel.implicitWidth + 12; height: tempLabel.implicitHeight + 6
                radius: 6; color: temperature > 100 ? "#F44336" : (temperature > 60 ? "#FF9800" : "#4CAF50")
                Text {
                    id: tempLabel; anchors.centerIn: parent
                    text: qsTr("%1°C").arg(Math.round(temperature))
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "white"
                }
            }

            // Brightness label
            Rectangle {
                anchors.left: parent.left; anchors.leftMargin: 8
                anchors.top: parent.top; anchors.topMargin: 8
                width: brightLabel.implicitWidth + 12; height: brightLabel.implicitHeight + 6
                radius: 6; color: bulbType === 0 ? NeoConstants.warmOrange : "#1565C0"
                Text {
                    id: brightLabel; anchors.centerIn: parent
                    text: qsTr("Sáng: %1%").arg(Math.round(brightness))
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "white"
                }
            }

            // Bulb type label
            Text {
                anchors.horizontalCenter: bulbBody.horizontalCenter
                anchors.top: bulbBody.bottom; anchors.topMargin: 20
                text: bulbType === 0 ? qsTr("Sợi đốt") : qsTr("LED")
                font.pixelSize: 12; font.bold: true; color: "#555"
            }
        }
    ]

    controlsArea: [
        Column {
            anchors.fill: parent; anchors.margins: 8; spacing: 4
            SliderControl {
                width: parent.width; height: (parent.height - 4) / 2
                label: qsTr("Loại bóng đèn")
                value: bulbType; from: 0; to: 1; stepSize: 1
                accentColor: bulbType === 0 ? NeoConstants.warmOrange : "#1565C0"
                labels: [qsTr("Sợi đốt"), qsTr("LED")]
                onValueChanged: bulbType = Math.round(value)
            }
            SliderControl {
                width: parent.width; height: (parent.height - 4) / 2
                label: qsTr("Số pin")
                value: batteryCount; from: 1; to: 3; stepSize: 1
                accentColor: NeoConstants.successGreen
                labels: [qsTr("1 pin"), qsTr("2 pin"), qsTr("3 pin")]
                onValueChanged: batteryCount = Math.round(value)
            }
        }
    ]

    function recordCurrentData() {
        var typeName = bulbType === 0 ? qsTr("Sợi đốt") : qsTr("LED")
        var tempLabel = temperature < 50 ? qsTr("Mát") : (temperature < 100 ? qsTr("Ấm") : qsTr("Rất nóng"))
        addDataPoint([typeName, batteryCount, Math.round(brightness) + "%",
                      Math.round(temperature) + "°C — " + tempLabel])
    }

    function getConclusion() {
        if (dataPoints.length >= requiredDataPoints) {
            return qsTr("Kết luận: cùng số pin (cùng lượng điện năng), đèn LED sáng hơn đèn sợi đốt khoảng BẢY LẦN.\n\n" +
                        "Đèn sợi đốt phải đốt nóng dây tóc lên 2500°C mới phát sáng: khoảng 95% điện năng thoát ra thành NHIỆT " +
                        "(vỏ bóng rất nóng), chỉ khoảng 5% thành ánh sáng.\n\n" +
                        "Đèn LED cho electron phát photon trực tiếp, không qua bước đốt nóng: khoảng 35% điện năng thành ÁNH SÁNG, " +
                        "vỏ bóng chỉ hơi ấm.\n\n" +
                        "Kiểm chứng ngoài đời: bóng LED 9W ghi trên nhãn là 'tương đương 60W' — tỉ số 60/9 ≈ 7, đúng bằng tỉ số " +
                        "35% chia 5% mà em vừa đo được.")
        }
        return qsTr("Cần thêm dữ liệu để kết luận.")
    }
}
