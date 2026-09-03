import QtQuick
import "../../core"

PhenomenonViewer {
    title: qsTr("Hiện tượng: Chai nước xylophone")
    description: qsTr("Các bạn nhỏ Việt Nam xếp 5 chai nước có mực nước khác nhau. Bạn Lan dùng que GÕ vào thành chai, bạn Minh THỔI ngang miệng chai — và hai bạn cãi nhau, vì chai nhiều nước cho kết quả ngược nhau!")

    hotspots: [
        { x: 0.2, y: 0.5, label: qsTr("GÕ vào thành chai"), detail: qsTr("Khi gõ, vật rung là THÀNH THỦY TINH CÙNG KHỐI NƯỚC bên trong. Càng nhiều nước → khối lượng rung càng lớn → rung càng chậm → tần số THẤP → nghe tiếng TRẦM.") },
        { x: 0.7, y: 0.5, label: qsTr("THỔI ngang miệng chai"), detail: qsTr("Khi thổi, vật rung là CỘT KHÔNG KHÍ phía trên mặt nước. Càng nhiều nước → cột không khí càng ngắn → rung càng nhanh → tần số CAO → nghe tiếng CAO.") },
        { x: 0.45, y: 0.2, label: qsTr("Hai kết quả ngược nhau"), detail: qsTr("Cùng một chai đầy nước: gõ thì nghe TRẦM, thổi thì nghe CAO. Không ai sai cả — vì hai cách làm rung hai vật khác nhau. Đây chính là câu đố của bài này!") }
    ]

    sceneComponent: Component {
        Rectangle {
            anchors.fill: parent; radius: 12
            color: "#FFF8E1"

            // Table surface
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width; height: parent.height * 0.15
                color: "#8D6E63"; radius: 6
                Rectangle {
                    anchors.top: parent.top; width: parent.width
                    height: 4; color: "#6D4C41"
                }
            }

            // 5 Bottles with different water levels
            Repeater {
                model: 5
                Item {
                    id: bottle
                    property real bx: 0.12 + index * 0.17
                    property real waterPercent: [20, 40, 50, 70, 90][index]
                    property string waterColor: ["#E3F2FD", "#BBDEFB", "#90CAF9", "#64B5F6", "#42A5F5"][index]
                    property string bottleLabel: [qsTr("Đồ"), qsTr("Rê"), qsTr("Mi"), qsTr("Fa"), qsTr("Sol")][index]
                    property int waveDur: [2200, 1800, 1600, 1400, 1200][index]
                    property real noteStartY: parent.height * 0.15
                    property real noteEndY: parent.height * 0.02

                    x: parent.width * bx; y: parent.height * 0.25
                    width: parent.width * 0.12; height: parent.height * 0.55

                    // Bottle body
                    Rectangle {
                        id: bottleBody
                        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width; height: parent.height * 0.75
                        radius: 4; color: "transparent"
                        border.width: 2; border.color: "#78909C"

                        // Water fill
                        Rectangle {
                            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: 2
                            width: parent.width - 4
                            height: (parent.height - 4) * waterPercent / 100
                            radius: 3; color: waterColor; opacity: 0.8

                            // Water surface wave
                            Rectangle {
                                anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width; height: 3; radius: 1
                                color: Qt.darker(waterColor, 1.1)

                                SequentialAnimation on anchors.horizontalCenterOffset {
                                    running: true; loops: Animation.Infinite
                                    NumberAnimation { from: -2; to: 2; duration: 800; easing.type: Easing.InOutSine }
                                    NumberAnimation { from: 2; to: -2; duration: 800; easing.type: Easing.InOutSine }
                                }
                            }
                        }
                    }

                    // Bottle neck
                    Rectangle {
                        anchors.bottom: bottleBody.top; anchors.bottomMargin: -2
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.4; height: parent.height * 0.28
                        radius: 3; color: "transparent"
                        border.width: 2; border.color: "#78909C"
                    }

                    // Sound wave rings when tapped
                    Repeater {
                        model: 2
                        Rectangle {
                            id: waveRing
                            property int ringDur: bottle.waveDur
                            anchors.centerIn: bottleBody
                            width: bottleBody.width * (1.2 + index * 0.4)
                            height: width; radius: width / 2
                            color: "transparent"
                            border.width: 2; border.color: "#FF9800"

                            SequentialAnimation on opacity {
                                running: true; loops: Animation.Infinite
                                NumberAnimation { from: 0.5; to: 0.0; duration: waveRing.ringDur }
                                PauseAnimation { duration: 400 }
                            }
                            SequentialAnimation on scale {
                                running: true; loops: Animation.Infinite
                                NumberAnimation { from: 1.0; to: 1.8; duration: waveRing.ringDur }
                                PauseAnimation { duration: 400 }
                            }
                        }
                    }

                    // Musical note floating up
                    Text {
                        id: musicalNote
                        property string noteSymbol: ["♩", "♪", "♫", "♬", "♪"][index]
                        property int noteDur: bottle.waveDur
                        x: parent.width * 0.3
                        text: noteSymbol
                        font.pixelSize: 16; color: "#FF6F00"; font.bold: true

                        SequentialAnimation on y {
                            running: true; loops: Animation.Infinite
                            NumberAnimation { from: musicalNote.parent.noteStartY; to: musicalNote.parent.noteEndY; duration: musicalNote.noteDur; easing.type: Easing.OutQuad }
                            PauseAnimation { duration: 600 }
                        }
                        SequentialAnimation on opacity {
                            running: true; loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 0.0; duration: musicalNote.noteDur }
                            PauseAnimation { duration: 600 }
                        }
                    }

                    // Note name label
                    Text {
                        anchors.top: bottleBody.bottom; anchors.topMargin: 4
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: bottleLabel
                        font.pixelSize: NeoConstants.fontCaption; font.bold: true; color: "#5D4037"
                    }
                }
            }

            // Tapping stick
            Rectangle {
                id: stick
                x: parent.width * 0.48; y: parent.height * 0.1
                width: 6; height: 60; radius: 3
                color: "#8D6E63"; rotation: -10
                transformOrigin: Item.Bottom

                Rectangle {
                    anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
                    width: 14; height: 14; radius: 7; color: "#5D4037"
                }

                SequentialAnimation on rotation {
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: -10; to: -25; duration: 150 }
                    NumberAnimation { from: -25; to: -10; duration: 150 }
                    PauseAnimation { duration: 500 }
                }
            }

            // Bottom label
            Text {
                anchors.bottom: parent.bottom; anchors.bottomMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Gõ hay thổi? Cùng một chai, hai cách tạo âm cho kết quả ngược nhau")
                font.pixelSize: NeoConstants.fontCaption; color: "#5D4037"; font.bold: true
            }
        }
    }
}
