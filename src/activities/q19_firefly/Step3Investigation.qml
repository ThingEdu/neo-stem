import QtQuick
import QtQuick.Layouts
import NEO_STEM

InvestigationBase {
    title: qsTr("Thí nghiệm: So sánh nguồn sáng")
    instructions: qsTr("So sánh 3 nguồn sáng: bóng đèn sợi đốt, que phát sáng (hóa học) và đom đóm (sinh học). Chú ý cột NHIỆT TỎA RA — đó mới là khác biệt lớn nhất giữa chúng.")
    requiredDataPoints: 3
    dataHeaders: [qsTr("Nguồn sáng"), qsTr("Năng lượng vào"), qsTr("% Sáng"), qsTr("% Nhiệt")]

    property int lightSource: 0   // 0=bulb, 1=glowstick, 2=firefly
    property real energyInput: 50  // 0-100

    // Efficiency calculations per source
    // Tỉ lệ năng lượng thành ÁNH SÁNG (hiệu suất đo được thật):
    //   bóng sợi đốt ~5%  ·  que phát sáng ~15%  ·  đom đóm ~40% (hiệu suất lượng tử đo lại năm 2008)
    // Tỉ lệ năng lượng thoát ra thành NHIỆT — đây mới là điểm khác biệt lớn nhất:
    //   bóng sợi đốt ~95%  ·  que phát sáng ~5%  ·  đom đóm ~1%
    // Phần còn lại ở hai nguồn hóa học/sinh học nằm trong SẢN PHẨM HÓA HỌC, không thoát ra thành nhiệt.
    property real lightPercent: lightSource === 0 ? energyInput * 0.05 :
                                (lightSource === 1 ? energyInput * 0.15 :
                                 energyInput * 0.40)
    property real heatPercent: lightSource === 0 ? energyInput * 0.95 :
                               (lightSource === 1 ? energyInput * 0.05 :
                                energyInput * 0.01)

    experimentArea: [
        Item {
            anchors.fill: parent

            // Background
            Rectangle {
                anchors.fill: parent
                color: "#1A1A2E"; radius: 8
            }

            // Title row
            Row {
                id: sourceLabelsRow
                anchors.top: parent.top; anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: parent.width * 0.18

                Text {
                    text: qsTr("Bóng đèn")
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true
                    color: lightSource === 0 ? "#FFD600" : "#666"
                }
                Text {
                    text: qsTr("Que sáng")
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true
                    color: lightSource === 1 ? "#76FF03" : "#666"
                }
                Text {
                    text: qsTr("Đom đóm")
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true
                    color: lightSource === 2 ? "#CCFF00" : "#666"
                }
            }

            // Three light sources side by side
            Row {
                id: sourcesRow
                anchors.centerIn: parent
                spacing: parent.width * 0.08

                // === Incandescent Bulb ===
                Item {
                    width: parent.parent.width * 0.26; height: parent.parent.height * 0.55

                    // Bulb shape
                    Rectangle {
                        id: bulbBody
                        anchors.centerIn: parent
                        width: 36; height: 44; radius: 18
                        color: lightSource === 0 ? Qt.rgba(1.0, 0.85, 0.2, energyInput / 100) : "#444"
                        border.width: 1; border.color: "#888"

                        Behavior on color { ColorAnimation { duration: 300 } }
                    }

                    // Heat waves for bulb
                    Repeater {
                        model: lightSource === 0 ? 3 : 0
                        Rectangle {
                            property int waveIndex: index
                            property int waveDuration: 1500 + index * 300
                            x: bulbBody.x + bulbBody.width + 4
                            y: bulbBody.y + 8 + index * 12
                            width: 14; height: 2; radius: 1
                            color: "#FF6D00"

                            SequentialAnimation on opacity {
                                running: true; loops: Animation.Infinite
                                NumberAnimation { from: 0.8; to: 0.1; duration: 1500; easing.type: Easing.InOutSine }
                                NumberAnimation { from: 0.1; to: 0.8; duration: 1500; easing.type: Easing.InOutSine }
                            }
                        }
                    }

                    // Light bar
                    Column {
                        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 2

                        Rectangle {
                            width: 24
                            height: lightSource === 0 ? (energyInput * 0.05 / 100) * 50 : 5
                            color: "#FFD600"; radius: 2
                            anchors.horizontalCenter: parent.horizontalCenter

                            Behavior on height { NumberAnimation { duration: 300 } }
                        }
                        Text {
                            text: qsTr("Sáng")
                            font.pixelSize: 8; color: "#FFD600"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // === Glow Stick ===
                Item {
                    width: parent.parent.width * 0.26; height: parent.parent.height * 0.55

                    // Stick shape
                    Rectangle {
                        id: stickBody
                        anchors.centerIn: parent
                        width: 12; height: 50; radius: 6
                        color: lightSource === 1 ? Qt.rgba(0.46, 1.0, 0.01, energyInput / 100) : "#444"
                        border.width: 1; border.color: "#888"

                        Behavior on color { ColorAnimation { duration: 300 } }
                    }

                    // Glow around stick
                    Rectangle {
                        anchors.centerIn: stickBody
                        width: 30; height: 60; radius: 15
                        color: "transparent"
                        border.width: lightSource === 1 ? 2 : 0
                        border.color: Qt.rgba(0.46, 1.0, 0.01, 0.3)
                        visible: lightSource === 1
                    }

                    // Light bar
                    Column {
                        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 2

                        Rectangle {
                            width: 24
                            height: lightSource === 1 ? (energyInput * 0.15 / 100) * 50 : 5
                            color: "#76FF03"; radius: 2
                            anchors.horizontalCenter: parent.horizontalCenter

                            Behavior on height { NumberAnimation { duration: 300 } }
                        }
                        Text {
                            text: qsTr("Sáng")
                            font.pixelSize: 8; color: "#76FF03"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // === Firefly ===
                Item {
                    width: parent.parent.width * 0.26; height: parent.parent.height * 0.55

                    // Firefly body
                    Rectangle {
                        id: fireflyBody
                        anchors.centerIn: parent
                        width: 18; height: 10; radius: 5
                        color: "#5D4037"
                    }

                    // Firefly abdomen glow
                    Rectangle {
                        id: fireflyGlow
                        anchors.centerIn: fireflyBody
                        anchors.verticalCenterOffset: 4
                        width: 28; height: 28; radius: 14
                        color: lightSource === 2 ? Qt.rgba(0.8, 1.0, 0.0, energyInput / 100) : "transparent"

                        Behavior on color { ColorAnimation { duration: 300 } }

                        SequentialAnimation on opacity {
                            running: lightSource === 2; loops: Animation.Infinite
                            NumberAnimation { from: 0.3; to: 1.0; duration: 700; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.0; to: 0.3; duration: 700; easing.type: Easing.InOutSine }
                        }
                    }

                    // Light bar
                    Column {
                        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 2

                        Rectangle {
                            width: 24
                            height: lightSource === 2 ? (energyInput * 0.40 / 100) * 50 : 5
                            color: "#CCFF00"; radius: 2
                            anchors.horizontalCenter: parent.horizontalCenter

                            Behavior on height { NumberAnimation { duration: 300 } }
                        }
                        Text {
                            text: qsTr("Sáng")
                            font.pixelSize: 8; color: "#CCFF00"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // Efficiency display
            Rectangle {
                anchors.left: parent.left; anchors.leftMargin: 8
                anchors.top: parent.top; anchors.topMargin: 8
                width: effText.implicitWidth + 16; height: effText.implicitHeight + 8
                radius: 8; color: lightPercent > 50 ? NeoConstants.successGreen : (lightPercent > 15 ? NeoConstants.warmOrange : "#78909C")

                Behavior on color { ColorAnimation { duration: 300 } }

                Text {
                    id: effText; anchors.centerIn: parent
                    text: qsTr("Thành ánh sáng: %1%").arg(Math.round(lightPercent))
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "white"
                }
            }

            // Heat indicator
            Rectangle {
                anchors.right: parent.right; anchors.rightMargin: 8
                anchors.top: parent.top; anchors.topMargin: 8
                width: heatText.implicitWidth + 16; height: heatText.implicitHeight + 8
                radius: 8; color: heatPercent > 50 ? "#D32F2F" : (heatPercent > 10 ? NeoConstants.warmOrange : NeoConstants.successGreen)

                Behavior on color { ColorAnimation { duration: 300 } }

                Text {
                    id: heatText; anchors.centerIn: parent
                    text: qsTr("Nhiệt tỏa: %1%").arg(Math.round(heatPercent))
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "white"
                }
            }

            // Bottom comparison label
            Text {
                anchors.bottom: parent.bottom; anchors.bottomMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                text: lightSource === 0 ? qsTr("Bóng đèn sợi đốt: nhiều nhiệt, ít sáng") :
                      (lightSource === 1 ? qsTr("Que phát sáng: hóa học, mát, ~15% thành ánh sáng") :
                       qsTr("Đom đóm: sinh học, ~40% thành ánh sáng, gần như không tỏa nhiệt"))
                font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "#E0E0E0"
            }
        }
    ]

    controlsArea: [
        RowLayout {
            anchors.fill: parent
            anchors.margins: 4
            spacing: 8

            SliderControl {
                Layout.fillWidth: true
                label: qsTr("Năng lượng đầu vào")
                value: energyInput; from: 0; to: 100; stepSize: 5
                accentColor: NeoConstants.sunshine
                labels: [qsTr("Thấp"), qsTr("Vừa"), qsTr("Cao")]
                onValueChanged: energyInput = value
            }

            Column {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: qsTr("Nguồn sáng:")
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "#333"
                }

                Row {
                    spacing: 6

                    Repeater {
                        model: [
                            { label: qsTr("Bóng đèn"), idx: 0, clr: "#FFD600" },
                            { label: qsTr("Que sáng"), idx: 1, clr: "#76FF03" },
                            { label: qsTr("Đom đóm"), idx: 2, clr: "#CCFF00" }
                        ]
                        Rectangle {
                            width: btnLabel.implicitWidth + 16; height: 28
                            radius: 14
                            color: lightSource === modelData.idx ? modelData.clr : "#E0E0E0"
                            border.width: lightSource === modelData.idx ? 2 : 0
                            border.color: "#333"

                            Text {
                                id: btnLabel
                                anchors.centerIn: parent
                                text: modelData.label
                                font.pixelSize: NeoConstants.fontCaption; font.bold: true
                                color: lightSource === modelData.idx ? "#1A1A2E" : "#666"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: { lightSource = modelData.idx }
                            }
                        }
                    }
                }
            }
        }
    ]

    function recordCurrentData() {
        var sourceName = lightSource === 0 ? qsTr("Bóng đèn") : (lightSource === 1 ? qsTr("Que sáng") : qsTr("Đom đóm"))
        var energyLabel = energyInput < 33 ? qsTr("Thấp") : (energyInput < 66 ? qsTr("Vừa") : qsTr("Cao"))
        var lightLabel = Math.round(lightPercent) + "%"
        var heatLabel = Math.round(heatPercent) + "%"
        addDataPoint([sourceName, energyLabel, lightLabel, heatLabel])
    }

    function getConclusion() {
        if (dataPoints.length >= requiredDataPoints) {
            return qsTr("Kết luận: điều đặc biệt của đom đóm không phải là 'biến 100% năng lượng thành ánh sáng' — " +
                        "mà là 'gần như KHÔNG TỎA NHIỆT'. Hai điều đó khác nhau.\n\n" +
                        "Bóng đèn sợi đốt: ~5% thành ánh sáng, ~95% thoát ra thành NHIỆT — nên rất nóng.\n" +
                        "Que phát sáng: ~15% thành ánh sáng, chỉ ~5% thành nhiệt.\n" +
                        "Đom đóm: ~40% thành ánh sáng, chỉ ~1% thành nhiệt — nên bụng đom đóm mát.\n\n" +
                        "Vậy 60% năng lượng còn lại của đom đóm đi đâu? Nó nằm lại trong các SẢN PHẨM HÓA HỌC của phản ứng " +
                        "Luciferin + O₂ + Luciferase, chứ không thoát ra thành nhiệt. Đó là lý do ta gọi đây là 'ánh sáng lạnh'.")
        }
        return qsTr("Cần thêm dữ liệu để kết luận.")
    }
}
