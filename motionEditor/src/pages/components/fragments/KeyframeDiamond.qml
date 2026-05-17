import QtQuick
import mokmME

Rectangle {
    id: root

    property bool active: false
    property bool hovered: false

    signal clicked()

    width: 14
    height: 14
    rotation: 45
    color: {
        if (active) return Theme.primary
        if (hovered) return Theme.mutedForeground
        return Theme.muted
    }
    radius: 2

    MouseArea {
        anchors.fill: parent
        anchors.margins: -3
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: root.clicked()
    }
}
