import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Popup {
    id: root

    property string selectedType: "Video"

    signal trackTypeChosen(string type)
    signal cancelled()

    modal: true
    dim: false
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 320
    height: 260
    padding: 16

    background: Rectangle {
        color: Theme.secondary
        border.color: Theme.border
        border.width: 1
        radius: 8
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Text {
            text: "Add Track"
            color: Theme.foreground
            font.pixelSize: 14
            font.bold: true
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 3
            rowSpacing: 8
            columnSpacing: 8

            Repeater {
                model: TrackTypeConfig ? TrackTypeConfig.types : null

                delegate: Rectangle {
                    id: card
                    Layout.preferredWidth: 88
                    Layout.preferredHeight: 72
                    radius: 6
                    color: root.selectedType === model.type ? Qt.rgba(1,1,1,0.1) : "transparent"
                    border.color: root.selectedType === model.type ? Theme.primary : "transparent"
                    border.width: root.selectedType === model.type ? 2 : 0

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Rectangle {
                            Layout.preferredWidth: 32; Layout.preferredHeight: 32
                            radius: 8
                            color: model.color
                            Layout.alignment: Qt.AlignHCenter

                            ThemedIcon {
                                anchors.centerIn: parent
                                source: "qrc:/icons/outline/" + model.icon + ".svg"
                                iconSize: 18
                                color: "#ffffff"
                            }
                        }

                        Text {
                            text: model.type
                            color: Theme.foreground
                            font.pixelSize: 11
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectedType = model.type
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Item { Layout.fillWidth: true }

            StyledButton {
                text: "Cancel"
                variant: "ghost"
                onClicked: root.cancelled()
            }

            StyledButton {
                text: "Add Track"
                variant: "primary"
                onClicked: {
                    root.trackTypeChosen(root.selectedType)
                    root.close()
                }
            }
        }
    }
}
