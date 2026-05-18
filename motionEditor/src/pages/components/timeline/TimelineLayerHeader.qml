import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    id: root

    property string layerName: "Layer 1"
    property bool visible_: true
    property bool locked: false

    signal toggleVisibility()
    signal toggleLock()
    signal requestAddTrack()
    signal requestMoveUp()
    signal requestMoveDown()
    signal requestDelete()
    signal selected()

    height: 28
    color: mouseArea.containsMouse ? Theme.secondaryHover : Theme.secondary
    border.color: Theme.border
    border.width: 1
    radius: 3

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: 4
        spacing: 4

        Text {
            text: root.layerName
            color: Theme.foreground
            font.pixelSize: 11
            font.bold: true
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        Rectangle {
            Layout.preferredWidth: 20; Layout.preferredHeight: 20
            radius: 3
            color: visMouse.containsMouse ? Theme.secondaryHover : "transparent"
            ThemedIcon {
                anchors.centerIn: parent
                source: root.visible_ ? "qrc:/icons/outline/eye.svg" : "qrc:/icons/outline/eye-off.svg"
                iconSize: 14
                color: root.visible_ ? Theme.foreground : Theme.muted
            }
            MouseArea {
                id: visMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.toggleVisibility()
            }
        }

        Rectangle {
            Layout.preferredWidth: 20; Layout.preferredHeight: 20
            radius: 3
            color: lockMouse.containsMouse ? Theme.secondaryHover : "transparent"
            ThemedIcon {
                anchors.centerIn: parent
                source: root.locked ? "qrc:/icons/outline/lock.svg" : "qrc:/icons/outline/lock-open.svg"
                iconSize: 14
                color: root.locked ? Theme.primary : Theme.mutedForeground
            }
            MouseArea {
                id: lockMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.toggleLock()
            }
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

        MenuItem { text: "Add Track..."; onTriggered: root.requestAddTrack() }
        MenuItem { text: root.locked ? "Unlock" : "Lock"; onTriggered: root.toggleLock() }
        MenuItem { text: root.visible_ ? "Hide" : "Show"; onTriggered: root.toggleVisibility() }
        MenuSeparator { background: Rectangle { color: Theme.border; height: 1; implicitWidth: 180 } }
        MenuItem { text: "Move Up"; onTriggered: root.requestMoveUp() }
        MenuItem { text: "Move Down"; onTriggered: root.requestMoveDown() }
        MenuSeparator { background: Rectangle { color: Theme.border; height: 1; implicitWidth: 180 } }
        MenuItem { text: "Delete Layer"; onTriggered: root.requestDelete() }
    }
}
