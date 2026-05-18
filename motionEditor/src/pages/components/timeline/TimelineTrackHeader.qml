import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    id: root

    property string trackName: "Track 1"
    property string trackType: "Video"
    property bool visible_: true
    property bool locked: false
    property bool solo: false
    property int indent: 0

    signal toggleVisibility()
    signal toggleLock()
    signal toggleSolo()
    signal requestMoveUp()
    signal requestMoveDown()
    signal requestDelete()
    signal selected()

    height: 28
    color: mouseArea.containsMouse ? Theme.secondaryHover : Theme.background
    border.color: Theme.border
    border.width: 1
    radius: 2

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        color: TrackTypeConfig.colorFor(root.trackType)
        radius: 1
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8 + root.indent
        anchors.rightMargin: 4
        spacing: 4

        ThemedIcon {
            source: "qrc:/icons/outline/" + TrackTypeConfig.iconFor(root.trackType) + ".svg"
            iconSize: 14
            color: TrackTypeConfig.colorFor(root.trackType)
        }

        Text {
            text: root.trackName
            color: Theme.foreground
            font.pixelSize: 10
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        Text {
            text: root.trackType
            color: TrackTypeConfig.colorFor(root.trackType)
            font.pixelSize: 8
            font.bold: true
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) root.selected()
            if (mouse.button === Qt.RightButton) contextMenu.popup()
        }
    }

    Menu {
        id: contextMenu
        background: Rectangle { color: Theme.secondary; border.color: Theme.border; radius: 4 }

        delegate: MenuItem {
            id: menuDelegate
            implicitWidth: 180
            implicitHeight: 32
            background: Rectangle { color: menuDelegate.highlighted ? Theme.secondaryHover : "transparent" }
            contentItem: Text {
                text: menuDelegate.text
                color: Theme.foreground
                font.pixelSize: 11
                leftPadding: 12
                verticalAlignment: Text.AlignVCenter
            }
        }

        MenuItem { text: root.locked ? "Unlock" : "Lock"; onTriggered: root.toggleLock() }
        MenuItem { text: root.visible_ ? "Hide" : "Show"; onTriggered: root.toggleVisibility() }
        MenuSeparator { background: Rectangle { color: Theme.border; height: 1; implicitWidth: 180 } }
        MenuItem { text: "Move Up"; onTriggered: root.requestMoveUp() }
        MenuItem { text: "Move Down"; onTriggered: root.requestMoveDown() }
        MenuSeparator { background: Rectangle { color: Theme.border; height: 1; implicitWidth: 180 } }
        MenuItem { text: "Delete Track"; onTriggered: root.requestDelete() }
    }
}
