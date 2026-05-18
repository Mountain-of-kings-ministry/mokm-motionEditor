import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    id: root

    property var selectedLayer: null
    property var selectedTrack: null

    color: "transparent"

    function selectedType() {
        if (root.selectedTrack) return "clip"
        if (root.selectedLayer) return "layer"
        return "composition"
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 6
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            width: parent.width
            spacing: 8

            // === Composition Section ===
            SectionHeader { title: "Composition" }

            PropertyRow { label: "Name"; animatable: false
                StyledTextField {
                    Layout.fillWidth: true
                    text: ProjectSettings ? ProjectSettings.projectName : "Untitled"
                    onTextEdited: function(newText) { if (ProjectSettings) ProjectSettings.projectName = newText }
                }
            }

            PropertyRow { label: "Width"; animatable: false
                NumberSlider {
                    Layout.fillWidth: true
                    from: 1; to: 7680; stepSize: 1; decimals: 0
                    value: ProjectSettings ? ProjectSettings.width : 1920
                    onValueEdited: function(val) { if (ProjectSettings) ProjectSettings.width = val }
                }
            }

            PropertyRow { label: "Height"; animatable: false
                NumberSlider {
                    Layout.fillWidth: true
                    from: 1; to: 4320; stepSize: 1; decimals: 0
                    value: ProjectSettings ? ProjectSettings.height : 1080
                    onValueEdited: function(val) { if (ProjectSettings) ProjectSettings.height = val }
                }
            }

            PropertyRow { label: "FPS"; animatable: false
                NumberSlider {
                    Layout.fillWidth: true
                    from: 1; to: 120; stepSize: 0.01; decimals: 2
                    value: ProjectSettings ? ProjectSettings.frameRate : 29.97
                    onValueEdited: function(val) { if (ProjectSettings) ProjectSettings.frameRate = val }
                }
            }

            PropertyRow { label: "Duration"; animatable: false
                NumberSlider {
                    Layout.fillWidth: true
                    from: 1; to: 36000; stepSize: 1; decimals: 0; suffix: "s"
                    value: ProjectSettings ? ProjectSettings.duration : 30
                    onValueEdited: function(val) { if (ProjectSettings) ProjectSettings.duration = val }
                }
            }

            PropertyRow { label: "Renderer"; animatable: false
                StyledComboBox {
                    Layout.fillWidth: true
                    model: ["Auto", "OpenGL", "DirectX", "Vulkan", "Metal"]
                    currentIndex: 0
                }
            }

            // === Layer Section ===
            SectionHeader {
                title: "Layer"
                visible: root.selectedLayer !== null
            }

            PropertyRow { label: "Opacity"; animatable: true; visible: root.selectedLayer !== null
                NumberSlider {
                    Layout.fillWidth: true
                    from: 0; to: 100; stepSize: 1; decimals: 0; suffix: "%"
                    value: root.selectedLayer ? (root.selectedLayer.opacityValue || 100) : 100
                    onValueEdited: function(val) { if (root.selectedLayer) root.selectedLayer.opacityValue = val }
                }
            }

            PropertyRow { label: "Blend"; animatable: true; visible: root.selectedLayer !== null
                StyledComboBox {
                    Layout.fillWidth: true
                    model: ["Normal", "Add", "Multiply", "Screen", "Overlay", "Lighten", "Darken"]
                    currentIndex: root.selectedLayer ? (root.selectedLayer.blendIndex || 0) : 0
                    onComboIndexChanged: function(idx) { if (root.selectedLayer) root.selectedLayer.blendIndex = idx }
                }
            }

            PropertyRow { label: "Position X"; animatable: true; visible: root.selectedLayer !== null
                NumberSlider {
                    Layout.fillWidth: true; from: -10000; to: 10000; stepSize: 1; decimals: 0
                    value: root.selectedLayer ? (root.selectedLayer.posX || 0) : 0
                    onValueEdited: function(val) { if (root.selectedLayer) root.selectedLayer.posX = val }
                }
            }

            PropertyRow { label: "Position Y"; animatable: true; visible: root.selectedLayer !== null
                NumberSlider {
                    Layout.fillWidth: true; from: -10000; to: 10000; stepSize: 1; decimals: 0
                    value: root.selectedLayer ? (root.selectedLayer.posY || 0) : 0
                    onValueEdited: function(val) { if (root.selectedLayer) root.selectedLayer.posY = val }
                }
            }

            PropertyRow { label: "Scale X"; animatable: true; visible: root.selectedLayer !== null
                NumberSlider {
                    Layout.fillWidth: true; from: 0; to: 500; stepSize: 1; decimals: 0; suffix: "%"
                    value: root.selectedLayer ? (root.selectedLayer.scaleX || 100) : 100
                    onValueEdited: function(val) { if (root.selectedLayer) root.selectedLayer.scaleX = val }
                }
            }

            PropertyRow { label: "Scale Y"; animatable: true; visible: root.selectedLayer !== null
                NumberSlider {
                    Layout.fillWidth: true; from: 0; to: 500; stepSize: 1; decimals: 0; suffix: "%"
                    value: root.selectedLayer ? (root.selectedLayer.scaleY || 100) : 100
                    onValueEdited: function(val) { if (root.selectedLayer) root.selectedLayer.scaleY = val }
                }
            }

            PropertyRow { label: "Rotation"; animatable: true; visible: root.selectedLayer !== null
                NumberSlider {
                    Layout.fillWidth: true; from: -360; to: 360; stepSize: 0.1; decimals: 1; suffix: "°"
                    value: root.selectedLayer ? (root.selectedLayer.rotation || 0) : 0
                    onValueEdited: function(val) { if (root.selectedLayer) root.selectedLayer.rotation = val }
                }
            }

            // === Track Section ===
            SectionHeader {
                title: "Track"
                visible: root.selectedTrack !== null
            }

            PropertyRow { label: "Muted"; animatable: false; visible: root.selectedTrack !== null
                Switch {
                    Layout.fillWidth: true; Layout.preferredHeight: 24
                    checked: root.selectedTrack ? root.selectedTrack.muted || root.selectedTrack.locked : false
                    onCheckedChanged: { if (root.selectedTrack) root.selectedTrack.muted = checked }
                    indicator: Rectangle {
                        implicitWidth: 36; implicitHeight: 20
                        x: parent.width - width - 4; y: parent.height / 2 - height / 2; radius: 10
                        color: parent.checked ? Theme.primary : Theme.muted
                        Rectangle {
                            x: parent.checked ? parent.width - width - 2 : 2
                            y: 2; width: 16; height: 16; radius: 8; color: Theme.foreground
                        }
                    }
                }
            }

            PropertyRow { label: "Solo"; animatable: false; visible: root.selectedTrack !== null
                Switch {
                    Layout.fillWidth: true; Layout.preferredHeight: 24
                    checked: root.selectedTrack ? root.selectedTrack.solo || false : false
                    onCheckedChanged: { if (root.selectedTrack) root.selectedTrack.solo = checked }
                    indicator: Rectangle {
                        implicitWidth: 36; implicitHeight: 20
                        x: parent.width - width - 4; y: parent.height / 2 - height / 2; radius: 10
                        color: parent.checked ? Theme.accent : Theme.muted
                        Rectangle {
                            x: parent.checked ? parent.width - width - 2 : 2
                            y: 2; width: 16; height: 16; radius: 8; color: Theme.foreground
                        }
                    }
                }
            }

            PropertyRow { label: "Track Opacity"; animatable: true; visible: root.selectedTrack !== null
                NumberSlider {
                    Layout.fillWidth: true; from: 0; to: 100; stepSize: 1; decimals: 0; suffix: "%"
                    value: root.selectedTrack ? (root.selectedTrack.opacityValue || 100) : 100
                    onValueEdited: function(val) { if (root.selectedTrack) root.selectedTrack.opacityValue = val }
                }
            }

            PropertyRow { label: "Volume"; animatable: true; visible: root.selectedTrack !== null
                NumberSlider {
                    Layout.fillWidth: true; from: 0; to: 200; stepSize: 1; decimals: 0; suffix: "%"
                    value: root.selectedTrack ? (root.selectedTrack.volume || 100) : 100
                    onValueEdited: function(val) { if (root.selectedTrack) root.selectedTrack.volume = val }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }

    // Section header helper component
    component SectionHeader: Rectangle {
        property string title: ""
        Layout.fillWidth: true
        Layout.preferredHeight: 24
        color: "transparent"

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: parent.title
            color: Theme.primary
            font.pixelSize: 11
            font.bold: true
            font.letterSpacing: 0.5
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: Theme.border
        }
    }
}
