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
                    model: ["chart-area-line", "chart-arrows", "grid-dots", "zoom-in"]
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
                    text: "Graph Editor"
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

                Rectangle {
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 120
                    color: "transparent"
                    border.color: Theme.muted
                    border.width: 1
                    radius: 4

                    Canvas {
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.strokeStyle = Theme.primary;
                            ctx.lineWidth = 2;
                            ctx.beginPath();
                            ctx.moveTo(0, 80);
                            ctx.bezierCurveTo(50, 20, 150, 100, 200, 40);
                            ctx.stroke();
                            ctx.strokeStyle = Theme.accent;
                            ctx.lineWidth = 1;
                            ctx.beginPath();
                            ctx.moveTo(0, 60);
                            ctx.bezierCurveTo(50, 90, 150, 30, 200, 60);
                            ctx.stroke();
                        }
                    }
                }

                Text {
                    text: "Graph Editor — edit animation curves"
                    color: Theme.mutedForeground
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
    }
}