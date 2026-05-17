import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    color: Theme.background

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            color: Theme.secondary
            border.color: Theme.border

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 4

                Repeater {
                    model: ["music", "volume", "microphone", "wave-saw-tool"]
                    delegate: Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        color: toolMouse.containsMouse ? Theme.secondaryHover : "transparent"
                        radius: 4

                        ThemedIcon {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/" + modelData + ".svg"
                            iconSize: 16
                            color: Theme.foreground
                        }

                        MouseArea {
                            id: toolMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Audio Editor"
                    color: Theme.mutedForeground
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.background

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8

                RowLayout {
                    spacing: 4
                    Layout.alignment: Qt.AlignHCenter

                    Repeater {
                        model: 48
                        delegate: Rectangle {
                            Layout.preferredWidth: 3
                            Layout.preferredHeight: heightMap[index % 16]
                            color: Theme.accent
                            opacity: 0.5 + (index % 8) * 0.06
                            radius: 1

                            property var heightMap: [24, 48, 36, 60, 42, 28, 56, 44, 32, 52, 38, 20, 50, 40, 60, 30]
                        }
                    }
                }

                Text {
                    text: "Audio Editor — mix and edit audio tracks"
                    color: Theme.mutedForeground
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
    }
}