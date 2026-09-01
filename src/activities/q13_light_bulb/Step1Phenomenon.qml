import QtQuick
import NEO_STEM

PhenomenonViewer {
    title: qsTr("Hiện tượng: Bóng đèn phát sáng")
    description: qsTr("Quan sát căn phòng Việt Nam buổi tối. Bật công tắc đèn — bạn thấy gì?")

    hotspots: [
        { x: 0.5, y: 0.3, label: qsTr("Dây tóc (filament)"), detail: qsTr("Dây tóc tungsten bên trong bóng đèn sợi đốt nóng đến 2500°C khi dòng điện chạy qua. Nhiệt độ cực cao khiến dây tóc phát sáng — hiện tượng gọi là bức xạ nhiệt.") },
        { x: 0.5, y: 0.15, label: qsTr("Ánh sáng"), detail: qsTr("Ánh sáng là dạng năng lượng mắt nhìn thấy được. Đèn sợi đốt phát ánh sáng ấm vàng, trong khi LED phát ánh sáng trắng mát. Ánh sáng lan tỏa khắp phòng theo mọi hướng.") },
        { x: 0.65, y: 0.45, label: qsTr("Nhiệt"), detail: qsTr("Sờ gần bóng đèn sợi đốt rất nóng! Khoảng 95% điện năng thoát ra thành nhiệt, chỉ khoảng 5% thành ánh sáng. Đèn LED mát hơn nhiều vì chuyển được tới ~35% điện năng thành ánh sáng.") }
    ]

    sceneComponent: Component {
        Rectangle {
            anchors.fill: parent
            radius: 12; color: "#263238"

            property bool lightOn: false

            // Dark room background that brightens when light is on
            Rectangle {
                anchors.fill: parent; radius: 12
                color: lightOn ? "#FFF8E1" : "#263238"
                Behavior on color { ColorAnimation { duration: 400 } }
            }

            // Ceiling
            Rectangle {
                width: parent.width; height: parent.height * 0.08
                color: lightOn ? "#EFEBE9" : "#37474F"
                Behavior on color { ColorAnimation { duration: 400 } }
            }

            // Wire from ceiling
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.08; width: 2; height: parent.height * 0.12
                color: "#555"
            }

            // Bulb glass
            Rectangle {
                id: bulbGlass
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.2
                width: 50; height: 60; radius: 25
                color: lightOn ? "#FFF9C4" : "#78909C"
                opacity: lightOn ? 0.9 : 0.6
                border.width: 1; border.color: lightOn ? "#FFF176" : "#546E7A"

                Behavior on color { ColorAnimation { duration: 300 } }
                Behavior on opacity { NumberAnimation { duration: 300 } }
            }

            // Filament inside bulb
            Canvas {
                id: filamentCanvas
                // lightOn thuộc về Rectangle cha, nên không thể viết onLightOnChanged ở đây.
                // Nhân bản thành thuộc tính cục bộ để bắt được tín hiệu thay đổi.
                property bool lit: lightOn
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.25; width: 30; height: 30
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = lightOn ? "#FF6F00" : "#666"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    ctx.moveTo(10, 25)
                    ctx.lineTo(10, 10)
                    ctx.lineTo(12, 5)
                    ctx.lineTo(14, 10)
                    ctx.lineTo(16, 5)
                    ctx.lineTo(18, 10)
                    ctx.lineTo(20, 5)
                    ctx.lineTo(20, 25)
                    ctx.stroke()
                }
                onLitChanged: requestPaint()
            }

            // Bulb base (screw cap)
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.2 + 55
                width: 30; height: 20; radius: 4
                color: "#9E9E9E"; border.width: 1; border.color: "#757575"
            }

            // Glow effect when on
            Rectangle {
                visible: lightOn
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.1
                width: 140; height: 140; radius: 70
                color: "transparent"
                border.width: 0

                Rectangle {
                    anchors.centerIn: parent
                    width: 120; height: 120; radius: 60
                    color: "#FFF9C4"; opacity: 0.3
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 80; height: 80; radius: 40
                    color: "#FFEE58"; opacity: 0.2
                }

                SequentialAnimation on opacity {
                    running: lightOn; loops: Animation.Infinite
                    NumberAnimation { from: 0.7; to: 1.0; duration: 800 }
                    NumberAnimation { from: 1.0; to: 0.7; duration: 800 }
                }
            }

            // Light rays
            Repeater {
                model: 6
                Rectangle {
                    property real rayAngle: index * 60
                    property real rayLen: lightOn ? 40 : 0
                    visible: lightOn
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: Math.cos(rayAngle * Math.PI / 180) * 50
                    y: parent.height * 0.25 + Math.sin(rayAngle * Math.PI / 180) * 50
                    width: rayLen; height: 2; radius: 1
                    rotation: rayAngle
                    color: "#FFD54F"; opacity: 0.6

                    Behavior on width { NumberAnimation { duration: 400 } }
                }
            }

            // Furniture silhouettes (visible in both states)
            // Table
            Rectangle {
                x: parent.width * 0.1; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.1
                width: parent.width * 0.3; height: parent.height * 0.05
                color: lightOn ? "#8D6E63" : "#37474F"; radius: 2
                Behavior on color { ColorAnimation { duration: 400 } }
            }
            // Table legs
            Rectangle {
                x: parent.width * 0.12; anchors.bottom: parent.bottom
                width: 4; height: parent.height * 0.1; color: lightOn ? "#795548" : "#37474F"
                Behavior on color { ColorAnimation { duration: 400 } }
            }
            Rectangle {
                x: parent.width * 0.36; anchors.bottom: parent.bottom
                width: 4; height: parent.height * 0.1; color: lightOn ? "#795548" : "#37474F"
                Behavior on color { ColorAnimation { duration: 400 } }
            }

            // Chair
            Rectangle {
                x: parent.width * 0.6; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.1
                width: parent.width * 0.15; height: parent.height * 0.04
                color: lightOn ? "#A1887F" : "#37474F"; radius: 2
                Behavior on color { ColorAnimation { duration: 400 } }
            }

            // Floor
            Rectangle {
                anchors.bottom: parent.bottom; width: parent.width
                height: parent.height * 0.08; color: lightOn ? "#D7CCC8" : "#212121"
                Behavior on color { ColorAnimation { duration: 400 } }
            }

            // Switch
            Rectangle {
                x: parent.width * 0.78; y: parent.height * 0.45
                width: 36; height: 50; radius: 6
                color: "#ECEFF1"; border.width: 2; border.color: "#90A4AE"

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: lightOn ? 6 : 26; width: 18; height: 18; radius: 3
                    color: lightOn ? "#4CAF50" : "#BDBDBD"
                    border.width: 1; border.color: "#777"

                    Behavior on y { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: lightOn = !lightOn
                }
            }

            // Comparison labels
            Row {
                anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.09
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                Text {
                    text: qsTr("Bật/tắt công tắc")
                    font.pixelSize: NeoConstants.fontCaption; font.bold: true
                    color: lightOn ? "#5D4037" : "#B0BEC5"
                }
            }

            // Heat indicator for incandescent
            Text {
                visible: lightOn
                anchors.right: parent.right; anchors.rightMargin: 10
                anchors.top: parent.top; anchors.topMargin: parent.height * 0.2
                text: qsTr("Nhiệt: Rất nóng!")
                font.pixelSize: 11; color: "#E65100"; font.bold: true
            }
        }
    }
}
