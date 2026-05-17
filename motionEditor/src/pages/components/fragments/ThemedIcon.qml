import QtQuick
import QtQuick.Effects

Item {
    id: root

    property alias source: icon.source
    property color color: "white"
    property int iconSize: 18
    property bool active: false
    property bool disabled: false

    implicitWidth: iconSize
    implicitHeight: iconSize

    Image {
        id: icon
        anchors.fill: parent
        sourceSize.width: root.iconSize
        sourceSize.height: root.iconSize
        visible: false
    }

    MultiEffect {
        id: effect
        anchors.fill: parent
        source: icon

        // 1. Fully enable colorization
        colorization: 1.0
        colorizationColor: root.color

        // 2. FORCE black/dark SVGs to accept the color
        // This boosts the underlying pixels so the colorizationColor can blend
        brightness: 1.0
        contrast: 1.0

        autoPaddingEnabled: true
    }
}
