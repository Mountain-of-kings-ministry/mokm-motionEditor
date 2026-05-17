import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    id: root

    property string projectName: "Untitled"
    property string resolution: "1920x1080"
    property string frameRate: "29.97"
    property string duration: "00:01:00:00"
    property string dateModified: "Just now"
    property bool highlighted: false

    signal clicked()

    implicitHeight: 72
    color: mouseArea.containsMouse ? Theme.secondaryHover : (highlighted ? Theme.secondary : "transparent")
    border.color: highlighted ? Theme.primary : "transparent"
    border.width: highlighted ? 1 : 0
    radius: 6

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 14

        Rectangle {
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            color: Theme.primary
            radius: 8
            opacity: 0.2

            Text {
                anchors.centerIn: parent
                text: root.projectName.charAt(0).toUpperCase()
                color: Theme.primary
                font.pixelSize: 20
                font.bold: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2

            Text {
                text: root.projectName
                color: Theme.foreground
                font.pixelSize: 13
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                text: root.resolution + " \u00B7 " + root.frameRate + "fps \u00B7 " + root.duration
                color: Theme.mutedForeground
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Text {
                text: root.dateModified
                color: Theme.mutedForeground
                font.pixelSize: 10
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}