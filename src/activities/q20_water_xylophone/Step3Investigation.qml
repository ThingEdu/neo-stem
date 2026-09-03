import QtQuick
import QtQuick.Layouts
import NEO_STEM

InvestigationBase {
    title: qsTr("Thí nghiệm: Chai nước và tần số")
    instructions: qsTr("Chọn cách tạo âm (GÕ hay THỔI), chọn chai, chỉnh mực nước. Hãy đo cả hai cách trên cùng một chai rồi so sánh. Ghi lại dữ liệu.")
    requiredDataPoints: 6
    dataHeaders: [qsTr("Cách"), qsTr("Chai #"), qsTr("% Nước"), qsTr("Tần số (Hz)"), qsTr("Cao/Trầm")]

    property int selectedBottle: 0
    property int playMode: 0                    // 0 = GÕ (struck), 1 = THỔI (blown)
    property var waterLevels: [20, 40, 50, 70, 90]
    property real currentWater: waterLevels[selectedBottle]
    property real airColumn: 100 - currentWater
    property real waterFrac: currentWater / 100

    // GÕ — vật rung là thành thủy tinh + khối nước. Mô hình khối lượng - độ cứng:
    //      f = f0 / sqrt(1 + k*m_nuoc)  →  càng nhiều nước, khối lượng rung càng lớn, tần số càng THẤP.
    //      Dải thực tế của chai thủy tinh khi gõ: ~455 Hz (gần rỗng) xuống ~228 Hz (gần đầy).
    property real freqTap: 500 / Math.sqrt(1 + 4 * waterFrac)

    // THỔI — vật rung là cột không khí (cộng hưởng Helmholtz):
    //      f = c/(2*pi) * sqrt(A / (V_khi * L_co))  →  f tỉ lệ nghịch với căn bậc hai THỂ TÍCH KHÍ.
    //      Càng nhiều nước, thể tích khí càng nhỏ, tần số càng CAO.
    //      Dải thực tế khi thổi ngang miệng chai: ~205 Hz (gần rỗng) lên ~894 Hz (gần đầy).
    property real freqBlow: 200 / Math.sqrt(Math.max(0.05, 1 - waterFrac))

    property real frequency: playMode === 0 ? freqTap : freqBlow
    property string modeName: playMode === 0 ? qsTr("Gõ") : qsTr("Thổi")

    function pitchLabelFor(f) {
        return f > 500 ? qsTr("Cao") : (f > 320 ? qsTr("Vừa") : qsTr("Trầm"))
    }

    experimentArea: [
        Item {
            anchors.fill: parent

            // Background
            Rectangle {
                anchors.fill: parent; radius: 8
                color: "#E8F5E9"
            }

            // Title
            Text {
                anchors.top: parent.top; anchors.topMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                text: playMode === 0 ? qsTr("GÕ vào thành chai — thủy tinh + nước cùng rung")
                                     : qsTr("THỔI ngang miệng chai — cột không khí rung")
                font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "#2E7D32"
            }

            // 5 bottles side by side
            Row {
                id: bottleRow
                anchors.centerIn: parent; spacing: 8

                Repeater {
                    model: 5
                    Item {
                        id: bottleItem
                        property real wLevel: waterLevels[index]
                        property bool isSelected: selectedBottle === index
                        property real waveBaseScale: 1.0
                        property real waveTargetScale: 1.6
                        width: (bottleRow.parent.width - 60) / 5; height: bottleRow.parent.height * 0.6

                        // Selection highlight
                        Rectangle {
                            anchors.fill: parent; anchors.margins: -3
                            radius: 8; color: "transparent"
                            border.width: isSelected ? 3 : 0; border.color: "#FF6F00"
                        }

                        // Bottle body
                        Rectangle {
                            id: bBody
                            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.8; height: parent.height * 0.7
                            radius: 4; color: "transparent"
                            border.width: 2; border.color: "#78909C"

                            // Water
                            Rectangle {
                                anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                                anchors.margins: 2
                                width: parent.width - 4
                                height: Math.max(0, (parent.height - 4) * wLevel / 100)
                                radius: 3; color: isSelected ? "#42A5F5" : "#90CAF9"; opacity: 0.85
                            }
                        }

                        // Bottle neck
                        Rectangle {
                            anchors.bottom: bBody.top; anchors.bottomMargin: -2
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.35; height: parent.height * 0.25
                            radius: 3; color: "transparent"
                            border.width: 2; border.color: "#78909C"
                        }

                        // Sound wave when selected
                        Rectangle {
                            id: selWave
                            anchors.centerIn: bBody
                            width: bBody.width * 1.2; height: width; radius: width / 2
                            color: "transparent"
                            border.width: 2; border.color: "#FF9800"
                            visible: isSelected

                            SequentialAnimation on scale {
                                running: isSelected; loops: Animation.Infinite
                                NumberAnimation { from: selWave.parent.waveBaseScale; to: selWave.parent.waveTargetScale; duration: 800 }
                                PauseAnimation { duration: 200 }
                            }
                            SequentialAnimation on opacity {
                                running: isSelected; loops: Animation.Infinite
                                NumberAnimation { from: 0.6; to: 0.0; duration: 800 }
                                PauseAnimation { duration: 200 }
                            }
                        }

                        // Bottle number
                        Text {
                            anchors.top: parent.bottom; anchors.topMargin: 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Chai %1").arg(index + 1)
                            font.pixelSize: 10; font.bold: isSelected; color: isSelected ? "#FF6F00" : "#5D4037"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: { selectedBottle = index }
                        }
                    }
                }
            }

            // Sound wave visualization bar
            Row {
                anchors.bottom: parent.bottom; anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 2
                Repeater {
                    model: 30
                    Rectangle {
                        // Số bó sóng vẽ ra tỉ lệ với TẦN SỐ: tần số cao → sóng dày hơn
                        property real waveH: 26 * Math.abs(Math.sin((index / 30.0) * Math.PI * (frequency / 110)))
                        width: 3; height: Math.max(2, waveH); radius: 1
                        color: NeoConstants.warmOrange
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Frequency display badge
            Rectangle {
                anchors.right: parent.right; anchors.rightMargin: 8
                anchors.top: parent.top; anchors.topMargin: 8
                width: freqText.implicitWidth + 16; height: freqText.implicitHeight + 8
                radius: 8; color: frequency > 500 ? "#E53935" : (frequency > 320 ? "#FF9800" : "#1565C0")
                Text {
                    id: freqText; anchors.centerIn: parent
                    text: qsTr("%1 Hz — %2").arg(Math.round(frequency)).arg(pitchLabelFor(frequency))
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "white"
                }
            }

            // Air column info
            Rectangle {
                anchors.left: parent.left; anchors.leftMargin: 8
                anchors.top: parent.top; anchors.topMargin: 8
                width: airText.implicitWidth + 16; height: airText.implicitHeight + 8
                radius: 8; color: playMode === 0 ? "#1565C0" : "#26A69A"
                Text {
                    id: airText; anchors.centerIn: parent
                    text: playMode === 0 ? qsTr("Khối nước rung: %1%").arg(Math.round(currentWater))
                                          : qsTr("Cột khí rung: %1%").arg(Math.round(airColumn))
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "white"
                }
            }
        }
    ]

    controlsArea: [
        Column {
            anchors.fill: parent; anchors.margins: 8
            spacing: 4

            // Play mode: GÕ vs THỔI
            Row {
                width: parent.width; spacing: 6
                Repeater {
                    model: [{ label: qsTr("🥁 GÕ vào chai"), color: "#1565C0" },
                            { label: qsTr("💨 THỔI miệng chai"), color: "#26A69A" }]
                    Rectangle {
                        required property int index
                        required property var modelData
                        width: (parent.width - 6) / 2; height: 36
                        radius: 6
                        color: playMode === index ? modelData.color : "#E0E0E0"
                        border.width: playMode === index ? 0 : 1
                        border.color: "#BDBDBD"
                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            font.pixelSize: 12; font.bold: true
                            color: playMode === index ? "white" : "#333"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: { playMode = index }
                        }
                    }
                }
            }

            // Bottle selector row
            Row {
                width: parent.width; spacing: 4
                Repeater {
                    model: 5
                    Rectangle {
                        width: (parent.width - 16) / 5; height: 32
                        radius: 6; color: selectedBottle === index ? "#FF6F00" : "#E0E0E0"
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Chai %1").arg(index + 1)
                            font.pixelSize: 11; font.bold: true
                            color: selectedBottle === index ? "white" : "#333"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: { selectedBottle = index }
                        }
                    }
                }
            }

            SliderControl {
                width: parent.width; height: parent.height - 80
                label: qsTr("Mực nước chai %1").arg(selectedBottle + 1)
                value: waterLevels[selectedBottle]; from: 5; to: 95; stepSize: 1
                accentColor: "#1565C0"
                labels: [qsTr("5%"), qsTr("50%"), qsTr("95%")]
                onValueChanged: {
                    var lvls = waterLevels
                    lvls[selectedBottle] = value
                    waterLevels = lvls
                }
            }
        }
    ]

    function recordCurrentData() {
        addDataPoint([modeName, selectedBottle + 1, Math.round(currentWater),
                      Math.round(frequency), pitchLabelFor(frequency)])
    }

    function getConclusion() {
        if (dataPoints.length < requiredDataPoints)
            return qsTr("Cần thêm dữ liệu để kết luận.")

        var hasTap = false, hasBlow = false
        for (var i = 0; i < dataPoints.length; i++) {
            if (dataPoints[i][0] === qsTr("Gõ")) hasTap = true
            else if (dataPoints[i][0] === qsTr("Thổi")) hasBlow = true
        }

        if (hasTap && hasBlow) {
            return qsTr("Kết luận: Hai cách tạo âm cho quy luật NGƯỢC NHAU, vì chúng làm rung hai vật khác nhau.\n\n" +
                        "GÕ — vật rung là thành thủy tinh cùng khối nước. Thêm nước = khối lượng rung tăng " +
                        "→ rung CHẬM hơn → tần số GIẢM → tiếng TRẦM hơn.\n\n" +
                        "THỔI — vật rung là cột không khí phía trên mặt nước. Thêm nước = thể tích khí giảm " +
                        "→ rung NHANH hơn → tần số TĂNG → tiếng CAO hơn.\n\n" +
                        "Muốn biết cao độ thay đổi thế nào, phải hỏi trước: CÁI GÌ đang rung?")
        }
        if (hasTap) {
            return qsTr("Kết luận (cách GÕ): vật rung là thành thủy tinh cùng khối nước. " +
                        "Chai càng nhiều nước → khối lượng rung càng lớn → tần số càng THẤP → tiếng càng TRẦM.\n\n" +
                        "Hãy đo thêm bằng cách THỔI trên cùng những chai này — bạn sẽ gặp một bất ngờ.")
        }
        return qsTr("Kết luận (cách THỔI): vật rung là cột không khí phía trên mặt nước. " +
                    "Chai càng nhiều nước → cột khí càng ngắn → tần số càng CAO → tiếng càng CAO.\n\n" +
                    "Hãy đo thêm bằng cách GÕ trên cùng những chai này — bạn sẽ gặp một bất ngờ.")
    }
}
