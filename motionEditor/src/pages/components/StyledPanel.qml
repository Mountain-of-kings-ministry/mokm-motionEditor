import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    id: root

    property string title: ""
    property var titleBarContent: null
    property bool collapsible: false
    property bool collapsed: false

    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: headerBar
            Layout.fillWidth: true
            Layout.preferredHeight: title !== "" || titleBarContent ? 36 : 0
            visible: height > 0
            color: Theme.secondary
            border.color: Theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 8
                spacing: 8

                Text {
                    text: root.title
                    color: Theme.foreground
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Item { Layout.fillWidth: true }

                Loader {
                    sourceComponent: root.titleBarContent
                    Layout.preferredHeight: 24
                }

                Rectangle {
                    visible: root.collapsible
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    color: mouseCollapse.containsMouse ? Theme.secondaryHover : "transparent"
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: root.collapsed ? "\u25BC" : "\u25B2"
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }

                    MouseArea {
                        id: mouseCollapse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.collapsed = !root.collapsed
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: !root.collapsed
            Layout.preferredHeight: root.collapsed ? 0 : implicitHeight
            clip: true
            color: "transparent"
            border.color: Theme.border
            border.width: 1
            visible: !root.collapsed

            default property alias content: contentArea.data

            Item {
                id: contentArea
                anchors.fill: parent
                anchors.margins: 1
            }
        }
    }
}