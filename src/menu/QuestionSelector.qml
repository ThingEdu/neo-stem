import QtQuick
import QtQuick.Controls
import NEO_STEM

Item {
    id: root

    signal questionSelected(int questionId)
    signal backClicked()

    Rectangle {
        anchors.fill: parent
        color: NeoConstants.ricePaper
    }

    // Top bar
    Rectangle {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 64
        color: NeoConstants.forestGreen

        Row {
            anchors.fill: parent
            anchors.leftMargin: 12
            spacing: 12

            TouchButton {
                width: 48; height: 48
                text: "⬅"
                fontSize: 20
                buttonColor: "transparent"
                textColor: "white"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.backClicked()
            }

            Text {
                text: qsTr("Chọn câu hỏi khám phá")
                font.pixelSize: NeoConstants.fontBody
                font.bold: true
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Total stars
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            Text {
                text: "★"
                font.pixelSize: 20
                color: NeoConstants.sunshine
            }
            Text {
                text: ProgressTracker.getTotalStars() + "/" + NeoConstants.maxStarsTotal
                font.pixelSize: NeoConstants.fontCaption
                font.bold: true
                color: "white"
            }
        }
    }

    // Scrollable content
    Flickable {
        id: flickable
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentWidth: width
        contentHeight: groupsColumn.height + 32
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: groupsColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            y: 16
            spacing: 20

            Repeater {
                model: NeoConstants.questionGroups

                // Group section
                Column {
                    id: groupSection
                    width: groupsColumn.width
                    spacing: 0

                    required property var modelData
                    required property int index

                    property color groupColor: modelData.color
                    property var qIds: modelData.questionIds
                    property int completedCount: {
                        var count = 0
                        for (var i = 0; i < qIds.length; i++) {
                            if (ProgressTracker.isQuestionComplete(qIds[i]))
                                count++
                        }
                        return count
                    }

                    // Group header
                    Rectangle {
                        width: parent.width
                        height: 64
                        radius: 12
                        color: groupSection.groupColor

                        // Only round top corners
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.radius
                            color: parent.color
                        }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 10

                            // Group icon
                            Text {
                                text: groupSection.modelData.icon
                                font.pixelSize: 28
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            // Group name
                            Text {
                                text: groupSection.modelData.name
                                font.pixelSize: NeoConstants.fontBody
                                font.bold: true
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            // Age tag
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: ageText.implicitWidth + 16
                                height: 24
                                radius: 12
                                color: Qt.rgba(1, 1, 1, 0.3)

                                Text {
                                    id: ageText
                                    anchors.centerIn: parent
                                    text: qsTr("Lớp ") + groupSection.modelData.grades
                                    font.pixelSize: NeoConstants.fontSmall
                                    font.bold: true
                                    color: "white"
                                }
                            }


                        }

                        // Progress text
                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            text: groupSection.completedCount + "/" + groupSection.qIds.length + " " + qsTr("hoàn thành")
                            font.pixelSize: NeoConstants.fontSmall
                            color: Qt.rgba(1, 1, 1, 0.9)
                        }
                    }

                    // Progress bar + cards container
                    Rectangle {
                        width: parent.width
                        height: progressBar.height + cardsFlow.height + 24
                        color: Qt.rgba(groupSection.groupColor.r, groupSection.groupColor.g, groupSection.groupColor.b, 0.08)
                        border.width: 1
                        border.color: Qt.rgba(groupSection.groupColor.r, groupSection.groupColor.g, groupSection.groupColor.b, 0.2)

                        // Only round bottom corners
                        radius: 12
                        Rectangle {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.radius
                            color: parent.color
                            Rectangle {
                                anchors.fill: parent
                                border.width: parent.parent.border.width
                                border.color: parent.parent.border.color
                                color: parent.color
                            }
                        }

                        // Progress bar
                        Item {
                            id: progressBar
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 16
                            anchors.topMargin: 12
                            height: 8

                            Rectangle {
                                anchors.fill: parent
                                radius: 4
                                color: Qt.rgba(0, 0, 0, 0.08)
                            }

                            Rectangle {
                                width: groupSection.qIds.length > 0
                                       ? parent.width * (groupSection.completedCount / groupSection.qIds.length)
                                       : 0
                                height: parent.height
                                radius: 4
                                color: groupSection.groupColor

                                Behavior on width {
                                    NumberAnimation { duration: NeoConstants.animNormal; easing.type: Easing.OutCubic }
                                }
                            }
                        }

                        // Question cards
                        Flow {
                            id: cardsFlow
                            anchors.top: progressBar.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 12
                            anchors.topMargin: 12
                            spacing: 12

                            Repeater {
                                model: groupSection.qIds

                                // Question card
                                Column {
                                    id: card
                                    spacing: 8
                                    width: NeoConstants.largeTextMode ? 180 : 150

                                    required property var modelData
                                    required property int index

                                    property var questionData: NeoConstants.getQuestionById(card.modelData)
                                    property bool isComplete: ProgressTracker.isQuestionComplete(card.modelData)
                                    property int questionStars: ProgressTracker.getQuestionStars(card.modelData)

                                    // Icon circle
                                    Rectangle {
                                        id: iconCircle
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: NeoConstants.largeTextMode ? 88 : 76
                                        height: width
                                        radius: width / 2
                                        color: card.isComplete
                                               ? groupSection.groupColor
                                               : Qt.rgba(groupSection.groupColor.r, groupSection.groupColor.g, groupSection.groupColor.b, 0.15)
                                        border.width: 2
                                        border.color: groupSection.groupColor

                                        Text {
                                            anchors.centerIn: parent
                                            text: card.questionData ? card.questionData.icon : ""
                                            font.pixelSize: NeoConstants.largeTextMode ? 42 : 36
                                        }

                                        // Completed badge
                                        Rectangle {
                                            visible: card.isComplete
                                            anchors.top: parent.top
                                            anchors.right: parent.right
                                            anchors.margins: -4
                                            width: 26
                                            height: 26
                                            radius: 13
                                            color: NeoConstants.sunshine

                                            Text {
                                                anchors.centerIn: parent
                                                text: "✓"
                                                font.pixelSize: NeoConstants.fontSmall
                                                font.bold: true
                                                color: "white"
                                            }
                                        }

                                        // Pulse animation for incomplete
                                        SequentialAnimation on scale {
                                            running: !card.isComplete
                                            loops: Animation.Infinite
                                            NumberAnimation { from: 1.0; to: 1.06; duration: 1200; easing.type: Easing.InOutSine }
                                            NumberAnimation { from: 1.06; to: 1.0; duration: 1200; easing.type: Easing.InOutSine }
                                        }

                                        Behavior on scale {
                                            NumberAnimation { duration: 100 }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            anchors.margins: -8
                                            onClicked: root.questionSelected(card.modelData)
                                            onPressed: iconCircle.scale = 0.9
                                            onReleased: iconCircle.scale = 1.0
                                            onCanceled: iconCircle.scale = 1.0
                                        }
                                    }

                                    // Label
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: parent.width
                                        text: card.questionData ? card.questionData.title : ""
                                        font.pixelSize: NeoConstants.fontCaption
                                        font.bold: true
                                        color: "#333333"
                                        horizontalAlignment: Text.AlignHCenter
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                    }

                                    // Difficulty level badge
                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: levelText.implicitWidth + 16
                                        height: 26
                                        radius: 13
                                        color: card.questionData ? (NeoConstants.levelColors[card.questionData.level] || "#999") : "#999"

                                        Text {
                                            id: levelText
                                            anchors.centerIn: parent
                                            text: {
                                                if (!card.questionData) return ""
                                                var label = NeoConstants.levelLabels[card.questionData.level] || ""
                                                // Hiện tên môn + lớp theo GDPT 2018, ví dụ "Khoa học 4", "KHTN 9".
                                                // Hoạt động ngoài chương trình chỉ hiện nhãn "Ngoại khóa".
                                                if (card.questionData.gradeCore <= 0) return label
                                                return label + " " + card.questionData.gradeCore
                                            }
                                            font.pixelSize: NeoConstants.fontSmall
                                            font.bold: true
                                            color: "white"
                                        }
                                    }

                                    // Stars
                                    NeoScore {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        stars: Math.min(3, Math.floor(card.questionStars / 5))
                                        starSize: NeoConstants.largeTextMode ? 24 : 20
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
