import QtQuick
import "../../core"

PhenomenonViewer {
    title: qsTr("Hiện tượng: Đom đóm phát sáng")
    description: qsTr("Đêm khuya ở nông thôn Việt Nam, những con đom đóm bay lả lả trên đồng lúa, phát ra ánh sáng xanh nhẹ nhàng nhấp nháy. Tại sao chúng phát sáng?")

    hotspots: [
        { x: 0.5, y: 0.65, label: qsTr("Bụng đom đóm"), detail: qsTr("Bụng (phía dưới) của đom đóm có cơ quan phát sáng đặc biệt. Bên trong chứa chất luciferin và enzyme luciferase. Khi luciferin phản ứng với oxy dưới tác động của luciferase, ánh sáng được tạo ra. Đây là hiện tượng phát quang sinh học (bioluminescence).") },
        { x: 0.3, y: 0.45, label: qsTr("Nhịp nhấp nháy"), detail: qsTr("Đom đóm nhấp nháy theo nhịp điệu đặc biệt — mỗi loài có kiểu nhấp nháy riêng. Con đực nhấp nháy để gọi bạn, con cái nhấp nháy để đáp lại. Nhịp nháy được điều khiển bởi hệ thần kinh kiểm soát lượng oxy vào cơ quan phát sáng.") },
        { x: 0.7, y: 0.55, label: qsTr("Không nóng"), detail: qsTr("Ánh sáng đom đóm là 'ánh sáng lạnh' — chỉ khoảng 1% năng lượng thoát ra thành nhiệt, nên bụng đom đóm không nóng dù đang sáng rực. Bóng đèn sợi đốt thì ngược hẳn: khoảng 95% năng lượng thành nhiệt, chỉ ~5% thành ánh sáng. Lưu ý: 'không tỏa nhiệt' không có nghĩa là 'hiệu suất 100%' — phản ứng của đom đóm biến khoảng 40% năng lượng thành ánh sáng, phần còn lại nằm trong sản phẩm hóa học.") }
    ]

    sceneComponent: Component {
        Rectangle {
            anchors.fill: parent
            radius: 12; color: "#0A0E1A"

            // Night sky gradient
            Rectangle {
                width: parent.width; height: parent.height * 0.6
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#0B0D1A" }
                    GradientStop { position: 1.0; color: "#141E30" }
                }
            }

            // Moon
            Rectangle {
                x: parent.width * 0.82; y: parent.height * 0.06
                width: 30; height: 30; radius: 15
                color: "#E0E0B0"
                opacity: 0.5
            }

            // Stars
            Repeater {
                model: [
                    { cx: 0.1, cy: 0.08, sz: 3 },
                    { cx: 0.25, cy: 0.04, sz: 2 },
                    { cx: 0.4, cy: 0.12, sz: 2 },
                    { cx: 0.55, cy: 0.06, sz: 3 },
                    { cx: 0.7, cy: 0.15, sz: 2 },
                    { cx: 0.15, cy: 0.18, sz: 2 },
                    { cx: 0.48, cy: 0.2, sz: 2 },
                    { cx: 0.65, cy: 0.03, sz: 3 },
                    { cx: 0.9, cy: 0.1, sz: 2 },
                    { cx: 0.35, cy: 0.22, sz: 2 }
                ]
                Rectangle {
                    x: parent.width * modelData.cx
                    y: parent.height * modelData.cy
                    width: modelData.sz; height: modelData.sz
                    radius: modelData.sz / 2; color: "#FFFDE7"
                    opacity: 0.6

                    SequentialAnimation on opacity {
                        running: true; loops: Animation.Infinite
                        NumberAnimation { from: 0.4; to: 0.9; duration: 2000; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 0.9; to: 0.4; duration: 2000; easing.type: Easing.InOutSine }
                    }
                }
            }

            // Ground / grass area
            Rectangle {
                anchors.bottom: parent.bottom; width: parent.width
                height: parent.height * 0.3; radius: 8
                color: "#1B2A10"
                Rectangle {
                    anchors.top: parent.top; width: parent.width; height: 4; color: "#2E4A1A"
                }
            }

            // Grass blades
            Repeater {
                model: [
                    { cx: 0.05, ht: 35, rot: -8 },
                    { cx: 0.12, ht: 28, rot: 5 },
                    { cx: 0.22, ht: 40, rot: -3 },
                    { cx: 0.35, ht: 32, rot: 6 },
                    { cx: 0.45, ht: 38, rot: -5 },
                    { cx: 0.58, ht: 30, rot: 4 },
                    { cx: 0.68, ht: 36, rot: -7 },
                    { cx: 0.78, ht: 33, rot: 3 },
                    { cx: 0.88, ht: 42, rot: -4 },
                    { cx: 0.95, ht: 28, rot: 6 }
                ]
                Rectangle {
                    x: parent.width * modelData.cx
                    y: parent.height * 0.70 - modelData.ht
                    width: 3; height: modelData.ht
                    radius: 1; color: "#2E7D32"
                    rotation: modelData.rot
                    transformOrigin: Item.Bottom
                    opacity: 0.7
                }
            }

            // Firefly 1 - slow blink
            Item {
                id: firefly1
                x: parent.width * 0.25; y: parent.height * 0.40
                width: 12; height: 8

                // Body
                Rectangle {
                    anchors.centerIn: parent
                    width: 10; height: 6; radius: 3
                    color: "#3E2723"
                }

                // Glow
                Rectangle {
                    id: glow1
                    anchors.centerIn: parent
                    width: 20; height: 20; radius: 10
                    color: "#CCFF00"; opacity: 0.0

                    SequentialAnimation on opacity {
                        running: true; loops: Animation.Infinite
                        NumberAnimation { from: 0.0; to: 0.8; duration: 600; easing.type: Easing.OutQuad }
                        NumberAnimation { from: 0.8; to: 0.8; duration: 400 }
                        NumberAnimation { from: 0.8; to: 0.0; duration: 800; easing.type: Easing.InQuad }
                        PauseAnimation { duration: 1200 }
                    }
                }

                SequentialAnimation on y {
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: parent.height * 0.40; to: parent.height * 0.35; duration: 3000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: parent.height * 0.35; to: parent.height * 0.40; duration: 3000; easing.type: Easing.InOutSine }
                }
            }

            // Firefly 2 - fast blink
            Item {
                id: firefly2
                x: parent.width * 0.55; y: parent.height * 0.50
                width: 12; height: 8

                Rectangle {
                    anchors.centerIn: parent
                    width: 10; height: 6; radius: 3
                    color: "#3E2723"
                }

                Rectangle {
                    id: glow2
                    anchors.centerIn: parent
                    width: 18; height: 18; radius: 9
                    color: "#B2FF59"; opacity: 0.0

                    SequentialAnimation on opacity {
                        running: true; loops: Animation.Infinite
                        NumberAnimation { from: 0.0; to: 0.9; duration: 300; easing.type: Easing.OutQuad }
                        NumberAnimation { from: 0.9; to: 0.0; duration: 500; easing.type: Easing.InQuad }
                        PauseAnimation { duration: 800 }
                    }
                }

                SequentialAnimation on y {
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: parent.height * 0.50; to: parent.height * 0.44; duration: 2500; easing.type: Easing.InOutSine }
                    NumberAnimation { from: parent.height * 0.44; to: parent.height * 0.50; duration: 2500; easing.type: Easing.InOutSine }
                }
            }

            // Firefly 3 - medium blink
            Item {
                id: firefly3
                x: parent.width * 0.75; y: parent.height * 0.38
                width: 12; height: 8

                Rectangle {
                    anchors.centerIn: parent
                    width: 10; height: 6; radius: 3
                    color: "#3E2723"
                }

                Rectangle {
                    id: glow3
                    anchors.centerIn: parent
                    width: 22; height: 22; radius: 11
                    color: "#E6FF70"; opacity: 0.0

                    SequentialAnimation on opacity {
                        running: true; loops: Animation.Infinite
                        NumberAnimation { from: 0.0; to: 0.7; duration: 500; easing.type: Easing.OutQuad }
                        NumberAnimation { from: 0.7; to: 0.7; duration: 300 }
                        NumberAnimation { from: 0.7; to: 0.0; duration: 700; easing.type: Easing.InQuad }
                        PauseAnimation { duration: 1500 }
                    }
                }

                SequentialAnimation on y {
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: parent.height * 0.38; to: parent.height * 0.32; duration: 3500; easing.type: Easing.InOutSine }
                    NumberAnimation { from: parent.height * 0.32; to: parent.height * 0.38; duration: 3500; easing.type: Easing.InOutSine }
                }
            }

            // Firefly 4 - low near grass
            Item {
                id: firefly4
                x: parent.width * 0.40; y: parent.height * 0.60
                width: 10; height: 6

                Rectangle {
                    anchors.centerIn: parent
                    width: 8; height: 5; radius: 2
                    color: "#3E2723"
                }

                Rectangle {
                    id: glow4
                    anchors.centerIn: parent
                    width: 16; height: 16; radius: 8
                    color: "#CCFF00"; opacity: 0.0

                    SequentialAnimation on opacity {
                        running: true; loops: Animation.Infinite
                        NumberAnimation { from: 0.0; to: 0.6; duration: 400; easing.type: Easing.OutQuad }
                        NumberAnimation { from: 0.6; to: 0.0; duration: 600; easing.type: Easing.InQuad }
                        PauseAnimation { duration: 2000 }
                    }
                }

                SequentialAnimation on x {
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: parent.width * 0.40; to: parent.width * 0.48; duration: 4000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: parent.width * 0.48; to: parent.width * 0.40; duration: 4000; easing.type: Easing.InOutSine }
                }
            }

            // Firefly 5 - high flier
            Item {
                id: firefly5
                x: parent.width * 0.15; y: parent.height * 0.28
                width: 10; height: 6

                Rectangle {
                    anchors.centerIn: parent
                    width: 8; height: 5; radius: 2
                    color: "#3E2723"
                }

                Rectangle {
                    id: glow5
                    anchors.centerIn: parent
                    width: 14; height: 14; radius: 7
                    color: "#B2FF59"; opacity: 0.0

                    SequentialAnimation on opacity {
                        running: true; loops: Animation.Infinite
                        NumberAnimation { from: 0.0; to: 0.85; duration: 350; easing.type: Easing.OutQuad }
                        NumberAnimation { from: 0.85; to: 0.85; duration: 200 }
                        NumberAnimation { from: 0.85; to: 0.0; duration: 450; easing.type: Easing.InQuad }
                        PauseAnimation { duration: 1000 }
                    }
                }

                SequentialAnimation on x {
                    running: true; loops: Animation.Infinite
                    NumberAnimation { from: parent.width * 0.15; to: parent.width * 0.22; duration: 5000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: parent.width * 0.22; to: parent.width * 0.15; duration: 5000; easing.type: Easing.InOutSine }
                }
            }

            // Bottom label
            Text {
                anchors.bottom: parent.bottom; anchors.bottomMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Đêm nông thôn Việt Nam — Đom đóm nhấp nháy trên đồng lúa")
                font.pixelSize: NeoConstants.fontCaption; color: "#CCFF00"; font.bold: true
            }
        }
    }
}
