import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

ColumnLayout {
    id: root

    property string label: ""
    property var model: [""]
    property int currentIndex: 0
    property string currentText: ""

    signal comboIndexChanged(int index)

    spacing: 4

    Text {
        visible: label !== ""
        text: label
        color: Theme.mutedForeground
        font.pixelSize: 11
        font.bold: true
    }

    ComboBox {
        id: combo
        Layout.fillWidth: true
        Layout.preferredHeight: 32
        model: root.model
        currentIndex: root.currentIndex

        background: Rectangle {
            color: Theme.input
            border.color: combo.activeFocus ? Theme.primary : Theme.border
            border.width: 1
            radius: 4
        }

        contentItem: Text {
            leftPadding: 10
            text: combo.displayText
            color: Theme.foreground
            font.pixelSize: 13
            verticalAlignment: Text.AlignVCenter
        }

        indicator: Text {
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "\u25BC"
            color: Theme.mutedForeground
            font.pixelSize: 8
        }

        popup: Popup {
            y: combo.height
            width: combo.width
            padding: 0
            background: Rectangle {
                color: Theme.secondary
                border.color: Theme.border
                border.width: 1
                radius: 4
            }
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: combo.delegateModel
                delegate: ItemDelegate {
                    width: combo.width
                    height: 32
                    contentItem: Text {
                        text: modelData
                        color: combo.highlightedIndex === index ? Theme.primary : Theme.foreground
                        font.pixelSize: 13
                        leftPadding: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: combo.highlightedIndex === index ? Theme.secondaryHover : "transparent"
                    }
                }
            }
        }

        onCurrentIndexChanged: {
            root.currentIndex = currentIndex;
            root.currentText = currentText;
            root.comboIndexChanged(currentIndex);
        }
    }
}