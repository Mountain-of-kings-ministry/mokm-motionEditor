import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

RowLayout {
    id: root
    spacing: 6

    property real value: 0
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property int decimals: 0
    property string suffix: ""

    signal valueEdited(real val)

    Slider {
        id: slider
        Layout.fillWidth: true
        from: root.from
        to: root.to
        stepSize: root.stepSize
        value: root.value
        snapMode: Slider.SnapAlways
        onMoved: root.valueEdited(value)

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 120
            implicitHeight: 4
            width: slider.availableWidth
            height: implicitHeight
            radius: 2
            color: Theme.muted

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                color: Theme.primary
                radius: 2
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 14
            implicitHeight: 14
            radius: 7
            color: slider.pressed ? Theme.primaryHover : Theme.primary
            border.color: Theme.border
            border.width: 1
        }
    }

    TextField {
        id: inputField
        Layout.preferredWidth: 58
        Layout.preferredHeight: 24
        horizontalAlignment: Text.AlignRight
        text: root.value.toFixed(root.decimals)
        color: Theme.foreground
        font.pixelSize: 11
        font.family: "monospace"
        background: Rectangle {
            color: Theme.input
            border.color: inputField.activeFocus ? Theme.primary : Theme.border
            border.width: 1
            radius: 3
        }
        topPadding: 2
        bottomPadding: 2
        leftPadding: 6
        rightPadding: 4
        validator: DoubleValidator { bottom: root.from; top: root.to; decimals: root.decimals }
        onEditingFinished: {
            var val = parseFloat(text)
            if (!isNaN(val)) root.valueEdited(val)
        }
    }

    Text {
        visible: suffix !== ""
        text: suffix
        color: Theme.mutedForeground
        font.pixelSize: 10
    }

    function setValue(v) {
        root.value = v
    }
}
