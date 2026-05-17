import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

ColumnLayout {
    id: root

    property string label: ""
    property string placeholderText: ""
    property string text: ""
    property string suffix: ""
    property bool readOnly: false
    property bool numbersOnly: false

    signal textEdited(string newText)

    spacing: 4

    Text {
        visible: label !== ""
        text: label
        color: Theme.mutedForeground
        font.pixelSize: 11
        font.bold: true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            color: Theme.input
            border.color: fieldInput.activeFocus ? Theme.primary : Theme.border
            border.width: 1
            radius: 4

            TextField {
                id: fieldInput
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                verticalAlignment: TextInput.AlignVCenter
                text: root.text
                placeholderText: root.placeholderText
                placeholderTextColor: Theme.mutedForeground
                color: Theme.foreground
                font.pixelSize: 13
                readOnly: root.readOnly
                selectByMouse: true
                inputMethodHints: root.numbersOnly ? Qt.ImhDigitsOnly : 0
                background: null

                onTextChanged: {
                    root.text = text;
                    root.textEdited(text);
                }
            }
        }

        Rectangle {
            visible: suffix !== ""
            Layout.preferredHeight: 32
            Layout.preferredWidth: suffixText.implicitWidth + 16
            color: Theme.secondary
            border.color: Theme.border
            border.width: 1
            radius: 4

            Text {
                id: suffixText
                anchors.centerIn: parent
                text: root.suffix
                color: Theme.mutedForeground
                font.pixelSize: 12
            }
        }
    }
}