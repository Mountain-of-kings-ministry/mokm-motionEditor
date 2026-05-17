import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Window {
    id: splash
    width: 480
    height: 360
    visible: true
    title: qsTr("MOKM MotionEditor")

    color: Theme.background
    flags: Qt.FramelessWindowHint

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16

        Rectangle {
            width: 100
            height: 100
            color: Theme.primary
            radius: 16
            border.color: Theme.border
            Layout.alignment: Qt.AlignHCenter

            Text {
                anchors.centerIn: parent
                text: "MOKM"
                color: Theme.background
                font.pixelSize: 22
                font.bold: true
            }
        }

        Text {
            text: qsTr("MOKM MotionEditor")
            color: Theme.foreground
            font.pixelSize: 22
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: qsTr("Video Editor & Motion Graphics Suite")
            color: Theme.mutedForeground
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
        }

        Item { height: 8; width: 1 }

        BusyIndicator {
            running: true
            Layout.alignment: Qt.AlignHCenter
            palette.dark: Theme.primary
        }
    }

    Timer {
        interval: 1800
        running: true
        repeat: false
        onTriggered: {
            var component = Qt.createComponent("ProjectSetup.qml");
            if (component.status === Component.Ready) {
                var win = component.createObject();
                win.show();
                splash.close();
            } else {
                console.log("Error loading ProjectSetup:", component.errorString());
            }
        }
    }
}
