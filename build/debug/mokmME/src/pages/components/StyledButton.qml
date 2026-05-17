import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    id: root

    property string text: ""
    property string iconSource: ""
    property string variant: "primary"   // primary, secondary, ghost, danger
    property bool rounded: true
    property bool buttonEnabled: true

    signal clicked()

    implicitWidth: row.implicitWidth + 24
    implicitHeight: 36
    radius: rounded ? 6 : 2
    color: {
        if (!buttonEnabled) return Theme.muted;
        switch (variant) {
            case "primary":   return mouseArea.containsMouse ? Theme.primaryHover : Theme.primary;
            case "secondary": return mouseArea.containsMouse ? Theme.secondaryHover : Theme.secondary;
            case "ghost":     return mouseArea.containsMouse ? Theme.secondaryHover : "transparent";
            case "danger":    return mouseArea.containsMouse ? "#dc2626" : Theme.error;
            default:          return Theme.primary;
        }
    }
    border.color: variant === "ghost" ? (mouseArea.containsMouse ? Theme.border : "transparent") : "transparent"
    border.width: variant === "ghost" ? 1 : 0
    opacity: buttonEnabled ? 1.0 : 0.5

    property color textColor: {
        if (!buttonEnabled) return Theme.mutedForeground;
        if (variant === "primary" || variant === "danger") return Theme.foreground;
        return Theme.foreground;
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        ThemedIcon {
            visible: iconSource !== ""
            source: iconSource
            iconSize: 16
            color: root.textColor
        }

        Text {
            visible: text !== ""
            text: root.text
            color: root.textColor
            font.pixelSize: 13
            font.bold: variant === "primary"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: buttonEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: { if (buttonEnabled) root.clicked(); }
    }
}