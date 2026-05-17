import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import mokmME

RowLayout {
    id: root
    spacing: 6

    property color value: "#ffffff"
    signal colorEdited(color c)

    Rectangle {
        Layout.preferredWidth: 24
        Layout.preferredHeight: 24
        radius: 4
        color: root.value
        border.color: Theme.border
        border.width: 1

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: colorDialog.open()
        }
    }

    TextField {
        Layout.fillWidth: true
        Layout.preferredHeight: 24
        text: root.value.toString()
        color: Theme.foreground
        font.pixelSize: 11
        font.family: "monospace"
        background: Rectangle {
            color: Theme.input
            border.color: parent.activeFocus ? Theme.primary : Theme.border
            border.width: 1
            radius: 3
        }
        topPadding: 2; bottomPadding: 2; leftPadding: 6; rightPadding: 6
        onEditingFinished: {
            var c = text.trim()
            if (c.length === 7 || c.length === 9) {
                root.colorEdited(c)
            }
        }
    }

    ColorDialog {
        id: colorDialog
        selectedColor: root.value
        onAccepted: root.colorEdited(selectedColor)
    }
}
