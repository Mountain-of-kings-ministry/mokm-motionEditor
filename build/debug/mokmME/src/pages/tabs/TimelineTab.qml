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
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                spacing: 2

                Repeater {
                    model: [
                        { icon: "hand-click", tooltip: "Select (V)" },
                        { icon: "arrows-move", tooltip: "Move (M)" },
                        { icon: "scissors", tooltip: "Blade (B)" },
                        { icon: "hand-grab", tooltip: "Hand" },
                        { icon: "zoom-in", tooltip: "Zoom" }
                    ]
                    delegate: Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 26
                        radius: 4
                        color: toolMouse.containsMouse ? Theme.secondaryHover : "transparent"
                        ThemedIcon {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/" + modelData.icon + ".svg"
                            iconSize: 16
                            color: toolMouse.containsMouse ? Theme.primary : Theme.foreground
                        }
                        ToolTip {
                            visible: toolMouse.containsMouse
                            text: modelData.tooltip
                            delay: 600
                            background: Rectangle { color: Theme.secondary; border.color: Theme.border; radius: 4 }
                            contentItem: Text { text: modelData.tooltip; color: Theme.foreground; font.pixelSize: 11 }
                        }
                        MouseArea {
                            id: toolMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 18; color: Theme.border; Layout.margins: 2 }

                Repeater {
                    model: ["camera", "cut", "copy", "clipboard-plus", "trash", "arrow-back-up"]
                    delegate: Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 26
                        color: editMouse.containsMouse ? Theme.secondaryHover : "transparent"
                        radius: 4
                        ThemedIcon {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/" + modelData + ".svg"
                            iconSize: 16
                            color: Theme.foreground
                        }
                        MouseArea {
                            id: editMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 18; color: Theme.border; Layout.margins: 2 }

                Repeater {
                    model: [
                        { icon: "magnet", tooltip: "Snap (S)" },
                        { icon: "anchor", tooltip: "Anchor Point" },
                        { icon: "grid-dots", tooltip: "Grid" }
                    ]
                    delegate: Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 26
                        color: toggleMouse.containsMouse ? Theme.secondaryHover : "transparent"
                        radius: 4
                        ThemedIcon {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/" + modelData.icon + ".svg"
                            iconSize: 16
                            color: toggleMouse.containsMouse ? Theme.primary : Theme.foreground
                        }
                        ToolTip {
                            visible: toggleMouse.containsMouse
                            text: modelData.tooltip
                            delay: 600
                            background: Rectangle { color: Theme.secondary; border.color: Theme.border; radius: 4 }
                            contentItem: Text { text: modelData.tooltip; color: Theme.foreground; font.pixelSize: 11 }
                        }
                        MouseArea {
                            id: toggleMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "00:00:00:00"
                    color: Theme.primary
                    font.pixelSize: 12
                    font.bold: true
                    font.family: "monospace"
                }

                Text {
                    text: "Timeline"
                    color: Theme.mutedForeground
                    font.pixelSize: 11
                    font.bold: true
                    leftPadding: 8
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

                Text {
                    text: "0000+00"
                    color: Theme.muted
                    font.pixelSize: 48
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Text {
                    text: "Timeline — add tracks and clips here"
                    color: Theme.mutedForeground
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
    }
}