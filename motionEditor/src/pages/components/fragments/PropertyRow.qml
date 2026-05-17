import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

RowLayout {
    id: root

    property string label: ""
    property bool animatable: false
    property bool keyframed: false
    property int labelWidth: 72

    signal toggleKeyframe()

    spacing: 6

    Text {
        text: root.label
        color: Theme.mutedForeground
        font.pixelSize: 11
        Layout.preferredWidth: root.labelWidth
        Layout.minimumWidth: 50
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        topPadding: 6
    }

    Item {
        id: controlSlot
        Layout.fillWidth: true
        Layout.preferredHeight: 26
    }

    KeyframeDiamond {
        visible: root.animatable
        active: root.keyframed
        Layout.preferredWidth: 14
        Layout.preferredHeight: 14
        Layout.alignment: Qt.AlignVCenter
        onClicked: root.toggleKeyframe()
    }

    default property alias cell: controlSlot.data
}
