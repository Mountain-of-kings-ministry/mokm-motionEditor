import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Window {
    id: setupWin
    width: 960
    height: 620
    minimumWidth: 800
    minimumHeight: 520
    visible: true
    title: qsTr("MOKM MotionEditor — New Project")

    color: Theme.background
    flags: Qt.FramelessWindowHint

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        border.color: Theme.border
        border.width: 1
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // === Title Bar ===
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                color: Theme.secondary
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 8
                    spacing: 8

                    Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        color: Theme.primary
                        radius: 6

                        Text {
                            anchors.centerIn: parent
                            text: "M"
                            color: Theme.background
                            font.bold: true
                            font.pixelSize: 14
                        }
                    }

                    Text {
                        text: "MOKM MotionEditor"
                        color: Theme.foreground
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        color: closeBtn.containsMouse ? Theme.error : "transparent"
                        radius: 6

                        Text {
                            anchors.centerIn: parent
                            text: "\u2715"
                            color: Theme.mutedForeground
                            font.pixelSize: 14
                        }

                        MouseArea {
                            id: closeBtn
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.quit()
                        }
                    }
                }
            }

            // === Main Content ===
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 24
                spacing: 24

                // --- LEFT: Recent Projects ---
                Rectangle {
                    Layout.preferredWidth: 300
                    Layout.fillHeight: true
                    color: Theme.secondary
                    radius: 8
                    border.color: Theme.border

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "Recent Projects"
                            color: Theme.foreground
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 32
                            color: Theme.input
                            border.color: Theme.border
                            border.width: 1
                            radius: 4

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 4
                                spacing: 4

                                ThemedIcon {
                                    source: "qrc:/icons/outline/search.svg"
                                    iconSize: 14
                                    color: Theme.mutedForeground
                                }

                                TextField {
                                    Layout.fillWidth: true
                                    color: Theme.foreground
                                    font.pixelSize: 12
                                    placeholderText: "Search projects..."
                                    background: null
                                    topPadding: 0
                                    bottomPadding: 0
                                }
                            }
                        }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 6
                            clip: true
                            model: recentModel
                            delegate: ProjectCard {
                                width: ListView.view.width
                                projectName: model.name
                                resolution: model.resolution
                                frameRate: model.fps
                                duration: model.duration
                                dateModified: model.date
                                highlighted: model.highlighted
                                onClicked: {
                                    // Load recent project
                                    openMainWindow();
                                }
                            }
                        }

                        StyledButton {
                            Layout.fillWidth: true
                            text: "Open Other..."
                            iconSource: "qrc:/icons/outline/folder-open.svg"
                            variant: "secondary"
                            onClicked: {
                                // File dialog to open project
                            }
                        }
                    }
                }

                // Divider
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 1
                    color: Theme.border
                }

                // --- RIGHT: New Project Settings ---
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 16

                        Text {
                            text: "New Project"
                            color: Theme.foreground
                            font.pixelSize: 14
                            font.bold: true
                        }

                        ScrollView {
                            id: scrollProject
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            ScrollBar.vertical.policy: ScrollBar.AsNeeded
                            ScrollBar.vertical.interactive: true

                            ColumnLayout {
                            width: scrollProject.availableWidth
                                // width: parent.width
                                spacing: 14
                                Layout.fillHeight: true

                                // --- Project Name ---
                                StyledTextField {
                                    label: "Project Name"
                                    placeholderText: "My Awesome Project"
                                    Layout.fillWidth: true
                                }

                                // --- Resolution & FPS row ---
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    StyledComboBox {
                                        id: presetCombo
                                        label: "Resolution Preset"
                                        Layout.fillWidth: true
                                        model: ["1920x1080 Full HD", "3840x2160 4K UHD", "1280x720 HD", "4096x2160 4K DCI", "7680x4320 8K UHD", "1080x1080 Square", "1080x1920 Vertical", "Custom"]
                                        onComboIndexChanged: applyPreset(currentIndex)
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    StyledTextField {
                                        id: widthField
                                        label: "Width (px)"
                                        text: "1920"
                                        numbersOnly: true
                                        Layout.fillWidth: true
                                    }

                                    StyledTextField {
                                        id: heightField
                                        label: "Height (px)"
                                        text: "1080"
                                        numbersOnly: true
                                        Layout.fillWidth: true
                                    }

                                    StyledComboBox {
                                        id: fpsCombo
                                        label: "Frame Rate"
                                        Layout.fillWidth: true
                                        model: ["23.976", "24", "25", "29.97", "30", "48", "50", "59.94", "60"]
                                        currentIndex: 3
                                    }
                                }

                                // --- Pixel Aspect Ratio & Duration ---
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    StyledComboBox {
                                        id: parCombo
                                        label: "Pixel Aspect Ratio"
                                        Layout.fillWidth: true
                                        model: ["Square (1.0)", "NTSC (0.9091)", "PAL (1.094)", "HD (1.333)"]
                                    }

                                    StyledTextField {
                                        id: durationField
                                        label: "Duration"
                                        text: "00:01:00:00"
                                        Layout.fillWidth: true
                                    }
                                }

                                // --- Audio & Color ---
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    StyledComboBox {
                                        id: sampleRateCombo
                                        label: "Audio Sample Rate"
                                        Layout.fillWidth: true
                                        model: ["44100 Hz", "48000 Hz", "96000 Hz"]
                                        currentIndex: 1
                                    }

                                    StyledComboBox {
                                        id: colorSpaceCombo
                                        label: "Color Space"
                                        Layout.fillWidth: true
                                        model: ["Rec.709", "Rec.2020", "ACES", "sRGB", "Raw"]
                                    }
                                }

                                // --- Bit Depth & Proxy ---
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    StyledComboBox {
                                        id: bitDepthCombo
                                        label: "Bit Depth"
                                        Layout.fillWidth: true
                                        model: ["8-bit", "10-bit", "12-bit", "16-bit float"]
                                    }

                                    StyledComboBox {
                                        id: proxyCombo
                                        label: "Auto Proxy"
                                        Layout.fillWidth: true
                                        model: ["Disabled", "540p", "720p", "1080p"]
                                    }
                                }

                                // --- Renderer ---
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    StyledComboBox {
                                        id: rendererCombo
                                        label: "Renderer"
                                        Layout.fillWidth: true
                                        model: ["Auto", "Qt RHI (Vulkan)", "Qt RHI (OpenGL)", "Qt RHI (Metal)", "CPU Fallback"]
                                    }

                                    StyledComboBox {
                                        id: vectorEngineCombo
                                        label: "Vector Engine"
                                        Layout.fillWidth: true
                                        model: ["ThorVG (Default)", "Skia (High Quality)"]
                                    }
                                }

                                // --- 3D & Plugins ---
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 32
                                        color: Theme.input
                                        border.color: Theme.border
                                        border.width: 1
                                        radius: 4

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            spacing: 8

                                            Text {
                                                text: "Enable 3D (Filament + USD)"
                                                color: Theme.foreground
                                                font.pixelSize: 12
                                                Layout.fillWidth: true
                                            }

                                            Switch {
                                                checked: true
                                                palette.dark: Theme.primary
                                            }
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 32
                                        color: Theme.input
                                        border.color: Theme.border
                                        border.width: 1
                                        radius: 4

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            spacing: 8

                                            Text {
                                                text: "Expression Engine"
                                                color: Theme.foreground
                                                font.pixelSize: 12
                                                Layout.fillWidth: true
                                            }

                                            Text {
                                                text: "QuickJS"
                                                color: Theme.primary
                                                font.pixelSize: 12
                                                font.bold: true
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // --- Action Buttons ---
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Item { Layout.fillWidth: true }

                            StyledButton {
                                text: "Cancel"
                                variant: "ghost"
                                onClicked: Qt.quit()
                            }

                            StyledButton {
                                text: "Create Project"
                                iconSource: "qrc:/icons/outline/player-play.svg"
                                variant: "primary"
                                onClicked: openMainWindow()
                            }
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: recentModel

        ListElement {
            name: "Sunday Service Highlights"
            resolution: "1920x1080"
            fps: "29.97"
            duration: "00:15:30:00"
            date: "Today 3:45 PM"
            highlighted: true
        }
        ListElement {
            name: "Youth Conference Reel"
            resolution: "3840x2160"
            fps: "60"
            duration: "00:08:15:00"
            date: "Yesterday"
            highlighted: false
        }
        ListElement {
            name: "Worship Intro Pack"
            resolution: "1920x1080"
            fps: "29.97"
            duration: "00:03:45:00"
            date: "3 days ago"
            highlighted: false
        }
        ListElement {
            name: "Christmas Broadcast"
            resolution: "1920x1080"
            fps: "23.976"
            duration: "00:42:00:00"
            date: "Last week"
            highlighted: false
        }
        ListElement {
            name: "Social Media Promo"
            resolution: "1080x1920"
            fps: "30"
            duration: "00:00:30:00"
            date: "2 weeks ago"
            highlighted: false
        }
    }

    function applyPreset(index) {
        var presets = [
            { w: "1920", h: "1080" },
            { w: "3840", h: "2160" },
            { w: "1280", h: "720" },
            { w: "4096", h: "2160" },
            { w: "7680", h: "4320" },
            { w: "1080", h: "1080" },
            { w: "1080", h: "1920" }
        ];
        if (index >= 0 && index < presets.length) {
            widthField.text = presets[index].w;
            heightField.text = presets[index].h;
        }
    }

    function openMainWindow() {
        var component = Qt.createComponent("Main.qml");
        if (component.status === Component.Ready) {
            var win = component.createObject();
            win.show();
            setupWin.close();
        } else {
            console.log("Error loading Main.qml:", component.errorString());
        }
    }
}
