import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    id: root

    property string selectedType: "composition"  // composition, layer, track, clip
    property var selectedObject: null

    color: "transparent"

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
                    onTextEdited: { if (ProjectSettings) ProjectSettings.projectName = newText }
                }
            }

            PropertyRow { label: "Width"; animatable: false
                NumberSlider {
                    Layout.fillWidth: true
                    from: 1; to: 7680; stepSize: 1; decimals: 0
                    value: ProjectSettings ? ProjectSettings.width : 1920
                    onValueEdited: { if (ProjectSettings) ProjectSettings.width = val }
                }
            }

            PropertyRow { label: "Height"; animatable: false
                NumberSlider {
                    Layout.fillWidth: true
                    from: 1; to: 4320; stepSize: 1; decimals: 0
                    value: ProjectSettings ? ProjectSettings.height : 1080
                    onValueEdited: { if (ProjectSettings) ProjectSettings.height = val }
                }
            }

            PropertyRow { label: "FPS"; animatable: false
                NumberSlider {
                    Layout.fillWidth: true
                    from: 1; to: 120; stepSize: 0.01; decimals: 2
                    value: ProjectSettings ? ProjectSettings.frameRate : 29.97
                    onValueEdited: { if (ProjectSettings) ProjectSettings.frameRate = val }
                }
            }

            PropertyRow { label: "Duration"; animatable: false
                NumberSlider {
                    Layout.fillWidth: true
                    from: 1; to: 36000; stepSize: 1; decimals: 0; suffix: "s"
                    value: ProjectSettings ? ProjectSettings.duration : 30
                    onValueEdited: { if (ProjectSettings) ProjectSettings.duration = val }
                }
            }

            PropertyRow { label: "Renderer"; animatable: false
                StyledComboBox {
                    Layout.fillWidth: true
                    model: ["Auto", "OpenGL", "DirectX", "Vulkan", "Metal"]
                    currentIndex: 0
                }
            }

            // === Layer Section (visible when layer/track/clip selected) ===
            SectionHeader {
                title: "Layer"
                visible: root.selectedType !== "composition"
            }

            PropertyRow { label: "Opacity"; animatable: true; visible: root.selectedType !== "composition"
                NumberSlider {
                    Layout.fillWidth: true
                    from: 0; to: 100; stepSize: 1; decimals: 0; suffix: "%"
                    value: 100
                }
            }

            PropertyRow { label: "Blend"; animatable: true; visible: root.selectedType !== "composition"
                StyledComboBox {
                    Layout.fillWidth: true
                    model: ["Normal", "Add", "Multiply", "Screen", "Overlay", "Lighten", "Darken"]
                }
            }

            PropertyRow { label: "Position X"; animatable: true; visible: root.selectedType !== "composition"
                NumberSlider { Layout.fillWidth: true; from: -10000; to: 10000; stepSize: 1; decimals: 0 }
            }

            PropertyRow { label: "Position Y"; animatable: true; visible: root.selectedType !== "composition"
                NumberSlider { Layout.fillWidth: true; from: -10000; to: 10000; stepSize: 1; decimals: 0 }
            }

            PropertyRow { label: "Scale X"; animatable: true; visible: root.selectedType !== "composition"
                NumberSlider { Layout.fillWidth: true; from: 0; to: 500; stepSize: 1; decimals: 0; suffix: "%" }
            }

            PropertyRow { label: "Scale Y"; animatable: true; visible: root.selectedType !== "composition"
                NumberSlider { Layout.fillWidth: true; from: 0; to: 500; stepSize: 1; decimals: 0; suffix: "%" }
            }

            PropertyRow { label: "Rotation"; animatable: true; visible: root.selectedType !== "composition"
                NumberSlider { Layout.fillWidth: true; from: -360; to: 360; stepSize: 0.1; decimals: 1; suffix: "°" }
            }

            PropertyRow { label: "Anchor X"; animatable: true; visible: root.selectedType !== "composition"
                NumberSlider { Layout.fillWidth: true; from: 0; to: 1; stepSize: 0.01; decimals: 2 }
            }

            PropertyRow { label: "Anchor Y"; animatable: true; visible: root.selectedType !== "composition"
                NumberSlider { Layout.fillWidth: true; from: 0; to: 1; stepSize: 0.01; decimals: 2 }
            }

            // === Track Section ===
            SectionHeader {
                title: "Track"
                visible: root.selectedType === "track" || root.selectedType === "clip"
            }

            PropertyRow { label: "Muted"; animatable: false; visible: root.selectedType === "track" || root.selectedType === "clip"
                Switch {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    indicator: Rectangle {
                        implicitWidth: 36; implicitHeight: 20
                        x: parent.width - width - 4
                        y: parent.height / 2 - height / 2
                        radius: 10
                        color: parent.checked ? Theme.primary : Theme.muted
                        Rectangle {
                            x: parent.checked ? parent.width - width - 2 : 2
                            y: 2; width: 16; height: 16; radius: 8
                            color: Theme.foreground
                        }
                    }
                }
            }

            PropertyRow { label: "Solo"; animatable: false; visible: root.selectedType === "track" || root.selectedType === "clip"
                Switch {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    indicator: Rectangle {
                        implicitWidth: 36; implicitHeight: 20
                        x: parent.width - width - 4
                        y: parent.height / 2 - height / 2
                        radius: 10
                        color: parent.checked ? Theme.accent : Theme.muted
                        Rectangle {
                            x: parent.checked ? parent.width - width - 2 : 2
                            y: 2; width: 16; height: 16; radius: 8
                            color: Theme.foreground
                        }
                    }
                }
            }

            PropertyRow { label: "Track Opacity"; animatable: true; visible: root.selectedType === "track" || root.selectedType === "clip"
                NumberSlider { Layout.fillWidth: true; from: 0; to: 100; stepSize: 1; decimals: 0; suffix: "%" }
            }

            PropertyRow { label: "Volume"; animatable: true; visible: root.selectedType === "track" || root.selectedType === "clip"
                NumberSlider { Layout.fillWidth: true; from: 0; to: 200; stepSize: 1; decimals: 0; suffix: "%" }
            }

            PropertyRow { label: "Pan"; animatable: true; visible: root.selectedType === "track" || root.selectedType === "clip"
                NumberSlider { Layout.fillWidth: true; from: -100; to: 100; stepSize: 1; decimals: 0; suffix: "%" }
            }

            // === Clip Section ===
            SectionHeader {
                title: "Clip"
                visible: root.selectedType === "clip"
            }

            PropertyRow { label: "Start"; animatable: false; visible: root.selectedType === "clip"
                NumberSlider { Layout.fillWidth: true; from: 0; to: 36000; stepSize: 0.01; decimals: 2; suffix: "s" }
            }

            PropertyRow { label: "Duration"; animatable: false; visible: root.selectedType === "clip"
                NumberSlider { Layout.fillWidth: true; from: 0.01; to: 36000; stepSize: 0.01; decimals: 2; suffix: "s" }
            }

            PropertyRow { label: "Clip Opacity"; animatable: true; visible: root.selectedType === "clip"
                NumberSlider { Layout.fillWidth: true; from: 0; to: 100; stepSize: 1; decimals: 0; suffix: "%" }
            }

            PropertyRow { label: "Speed"; animatable: true; visible: root.selectedType === "clip"
                NumberSlider { Layout.fillWidth: true; from: 0.01; to: 10; stepSize: 0.01; decimals: 2; suffix: "x" }
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
