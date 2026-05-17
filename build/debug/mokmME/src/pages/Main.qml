import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Effects
import kingClass
import mokmME

ApplicationWindow {
    id: mainWin
    width: 1400
    height: 900
    minimumWidth: 1024
    minimumHeight: 600
    visible: true
    title: qsTr("MOKM MotionEditor — Untitled Project")

    flags: Qt.FramelessWindowHint | Qt.Window

    color: Theme.background

    // === Custom Title Bar ===
    Rectangle {
        id: titleBar
        width: parent.width
        height: 30
        color: Theme.secondary

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 4
            spacing: 2

            Text {
                text: "MOKM MotionEditor"
                color: Theme.primary
                font.pixelSize: 12
                font.bold: true
                leftPadding: 4
            }

            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 16; color: Theme.border; Layout.margins: 4 }

            // Inline menu items
            Rectangle {
                id: fileMenuBtn
                Layout.preferredHeight: 24; Layout.preferredWidth: 36
                color: fileMenuBtnMa.containsMouse ? Theme.secondaryHover : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "File"; color: fileMenuBtnMa.containsMouse ? Theme.primary : Theme.foreground; font.pixelSize: 11 }
                MouseArea { id: fileMenuBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: fileMenu.popup(fileMenuBtn, 0, fileMenuBtn.height) }
            }
            Rectangle {
                id: editMenuBtn
                Layout.preferredHeight: 24; Layout.preferredWidth: 34
                color: editMenuBtnMa.containsMouse ? Theme.secondaryHover : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "Edit"; color: editMenuBtnMa.containsMouse ? Theme.primary : Theme.foreground; font.pixelSize: 11 }
                MouseArea { id: editMenuBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: editMenu.popup(editMenuBtn, 0, editMenuBtn.height) }
            }
            Rectangle {
                id: viewMenuBtn
                Layout.preferredHeight: 24; Layout.preferredWidth: 36
                color: viewMenuBtnMa.containsMouse ? Theme.secondaryHover : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "View"; color: viewMenuBtnMa.containsMouse ? Theme.primary : Theme.foreground; font.pixelSize: 11 }
                MouseArea { id: viewMenuBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: viewMenu.popup(viewMenuBtn, 0, viewMenuBtn.height) }
            }
            Rectangle {
                id: toolsMenuBtn
                Layout.preferredHeight: 24; Layout.preferredWidth: 44
                color: toolsMenuBtnMa.containsMouse ? Theme.secondaryHover : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "Tools"; color: toolsMenuBtnMa.containsMouse ? Theme.primary : Theme.foreground; font.pixelSize: 11 }
                MouseArea { id: toolsMenuBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: toolsMenu.popup(toolsMenuBtn, 0, toolsMenuBtn.height) }
            }
            Rectangle {
                id: compMenuBtn
                Layout.preferredHeight: 24; Layout.preferredWidth: 80
                color: compMenuBtnMa.containsMouse ? Theme.secondaryHover : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "Composition"; color: compMenuBtnMa.containsMouse ? Theme.primary : Theme.foreground; font.pixelSize: 11 }
                MouseArea { id: compMenuBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: compositionMenu.popup(compMenuBtn, 0, compMenuBtn.height) }
            }
            Rectangle {
                id: helpMenuBtn
                Layout.preferredHeight: 24; Layout.preferredWidth: 36
                color: helpMenuBtnMa.containsMouse ? Theme.secondaryHover : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "Help"; color: helpMenuBtnMa.containsMouse ? Theme.primary : Theme.foreground; font.pixelSize: 11 }
                MouseArea { id: helpMenuBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: helpMenu.popup(helpMenuBtn, 0, helpMenuBtn.height) }
            }

            Item { Layout.fillWidth: true }

            // Window controls
            Rectangle {
                Layout.preferredWidth: 36; Layout.preferredHeight: 24
                color: minBtnMa.containsMouse ? Theme.secondaryHover : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "─"; color: Theme.foreground; font.pixelSize: 16 }
                MouseArea { id: minBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: mainWin.showMinimized() }
            }
            Rectangle {
                Layout.preferredWidth: 36; Layout.preferredHeight: 24
                color: maxBtnMa.containsMouse ? Theme.secondaryHover : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "□"; color: Theme.foreground; font.pixelSize: 12 }
                MouseArea { id: maxBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: mainWin.visibility === Window.Maximized ? mainWin.showNormal() : mainWin.showMaximized() }
            }
            Rectangle {
                Layout.preferredWidth: 36; Layout.preferredHeight: 24
                color: closeBtnMa.containsMouse ? "#e81123" : "transparent"
                radius: 4
                Text { anchors.centerIn: parent; text: "✕"; color: Theme.foreground; font.pixelSize: 12 }
                MouseArea { id: closeBtnMa; anchors.fill: parent; hoverEnabled: true; onClicked: Qt.quit() }
            }
        }

        // Window drag
        MouseArea {
            anchors.fill: parent
            property point clickPos: Qt.point(0, 0)
            onPressed: { clickPos = Qt.point(mouse.x, mouse.y) }
            onPositionChanged: {
                mainWin.x += mouse.x - clickPos.x
                mainWin.y += mouse.y - clickPos.y
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // === Toolbar ===
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: Theme.secondary
            border.color: Theme.border

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                spacing: 2

                // Repeater {
                //     model: [
                //         { icon: "cursor-default", tooltip: "Select (V)" },
                //         { icon: "arrows-move", tooltip: "Move (M)" },
                //         { icon: "scissors", tooltip: "Blade (B)" },
                //         { icon: "hand-grab", tooltip: "Hand" },
                //         { icon: "zoom-in", tooltip: "Zoom" }
                //     ]
                //     delegate: Rectangle {
                //         Layout.preferredWidth: 32
                //         Layout.preferredHeight: 32
                //         color: toolMouse.containsMouse ? Theme.secondaryHover : "transparent"
                //         radius: 4

                //         Image {
                //             anchors.centerIn: parent
                //             source: "qrc:/icons/outline/" + modelData.icon + ".svg"
                //             sourceSize.width: 18
                //             sourceSize.height: 18
                //         }

                //         ToolTip {
                //             visible: toolMouse.containsMouse
                //             text: modelData.tooltip
                //             delay: 600
                //             background: Rectangle { color: Theme.secondary; border.color: Theme.border; radius: 4 }
                //             contentItem: Text { text: modelData.tooltip; color: Theme.foreground; font.pixelSize: 11 }
                //         }

                //         MouseArea {
                //             id: toolMouse
                //             anchors.fill: parent
                //             hoverEnabled: true
                //             cursorShape: Qt.PointingHandCursor
                //             onClicked: { /* set active tool */ }
                //         }
                //     }
                // }
                //
                Repeater {
                    model: [
                        { icon: "hand-click", tooltip: "Select (V)" },
                        { icon: "arrows-move", tooltip: "Move (M)" },
                        { icon: "scissors", tooltip: "Blade (B)" },
                        { icon: "hand-grab", tooltip: "Hand" },
                        { icon: "zoom-in", tooltip: "Zoom" }
                    ]

                    delegate: Rectangle {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        radius: 4

                        color: toolMouse.containsMouse
                               ? Theme.secondaryHover
                               : "transparent"

                        ThemedIcon {
                            anchors.centerIn: parent

                            source: "qrc:/icons/outline/" + modelData.icon + ".svg"

                            iconSize: 18

                            color: toolMouse.containsMouse
                                   ? Theme.primary
                                   : Theme.foreground
                        }

                        ToolTip {
                            visible: toolMouse.containsMouse
                            text: modelData.tooltip
                            delay: 600

                            background: Rectangle {
                                color: Theme.secondary
                                border.color: Theme.border
                                radius: 4
                            }

                            contentItem: Text {
                                text: modelData.tooltip
                                color: Theme.foreground
                                font.pixelSize: 11
                            }
                        }

                        MouseArea {
                            id: toolMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                /* set active tool */
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1; Layout.preferredHeight: 24
                    color: Theme.border; Layout.margins: 4
                }

                Repeater {
                    model: [
                        { icon: "magnet", tooltip: "Snap (S)" },
                        { icon: "anchor", tooltip: "Anchor Point" },
                        { icon: "grid-dots", tooltip: "Grid" }
                    ]
                    delegate: Rectangle {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        color: toolMouse2.containsMouse ? Theme.secondaryHover : "transparent"
                        radius: 4

                        ThemedIcon {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/" + modelData.icon + ".svg"
                            iconSize: 18
                            color: toolMouse2.containsMouse ? Theme.primary : Theme.foreground
                        }

                        ToolTip {
                            visible: toolMouse2.containsMouse
                            text: modelData.tooltip
                            delay: 600
                            background: Rectangle { color: Theme.secondary; border.color: Theme.border; radius: 4 }
                            contentItem: Text { text: modelData.tooltip; color: Theme.foreground; font.pixelSize: 11 }
                        }

                        MouseArea {
                            id: toolMouse2
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "00:00:00:00"
                    color: Theme.primary
                    font.pixelSize: 13
                    font.bold: true
                    font.family: "monospace"
                }

                Item { Layout.preferredWidth: 8 }
            }
        }

        // === Main Content: SplitView Vertical ===
        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Vertical

            // --- TOP SECTION: Horizontal Split (Bin | Viewport | Properties) ---
            SplitView {
                id: topSplit
                SplitView.fillWidth: true
                SplitView.fillHeight: true
                orientation: Qt.Horizontal

                // Project Bin
                StyledPanel {
                    title: "Project Bin"
                    SplitView.preferredWidth: 240
                    SplitView.minimumWidth: 160
                    collapsible: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            StyledButton {
                                text: "Import"
                                iconSource: "qrc:/icons/outline/file-import.svg"
                                variant: "secondary"
                                Layout.fillWidth: true
                                onClicked: importDialog.open()
                            }

                            StyledButton {
                                iconSource: "qrc:/icons/outline/plus.svg"
                                variant: "ghost"
                                Layout.preferredWidth: 32
                                onClicked: { /* new folder, etc */ }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 28
                            color: Theme.input
                            border.color: Theme.border
                            border.width: 1
                            radius: 4

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                spacing: 4
                                ThemedIcon {
                                    source: "qrc:/icons/outline/search.svg"
                                    iconSize: 12
                                    color: Theme.mutedForeground
                                }
                                TextField {
                                    Layout.fillWidth: true
                                    color: Theme.foreground
                                    font.pixelSize: 11
                                    placeholderText: "Search assets..."
                                    background: null
                                    topPadding: 0
                                    bottomPadding: 0
                                }
                            }
                        }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 2
                            clip: true
                            model: ["Videos", "Audio", "Images", "Compositions", "Effects"]
                            delegate: Rectangle {
                                width: parent.width
                                height: 28
                                color: mouseArea3.containsMouse ? Theme.secondaryHover : "transparent"
                                radius: 4

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    spacing: 8

                                    ThemedIcon {
                                        source: {
                                            var icons = ["video", "music", "photo", "layers-subtract", "sparkles"];
                                            "qrc:/icons/outline/" + icons[index] + ".svg"
                                        }
                                        iconSize: 14
                                        color: Theme.foreground
                                    }

                                    Text {
                                        text: modelData
                                        color: Theme.foreground
                                        font.pixelSize: 12
                                    }

                                    Item { Layout.fillWidth: true }

                                    Text {
                                        text: "0"
                                        color: Theme.mutedForeground
                                        font.pixelSize: 10
                                    }
                                }

                                MouseArea {
                                    id: mouseArea3
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }
                    }
                }

                // Viewport
                Rectangle {
                    id: viewport
                    SplitView.fillWidth: true
                    SplitView.fillHeight: true
                    color: "#0a0a1a"
                    border.color: Theme.border

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        // Viewport Toolbar
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 32
                            color: Theme.secondary
                            border.color: Theme.border

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 6
                                anchors.rightMargin: 6
                                spacing: 2

                                Repeater {
                                    model: ["aspect-ratio", "grid-4x4", "eye", "maximize"]
                                    delegate: Rectangle {
                                        Layout.preferredWidth: 26
                                        Layout.preferredHeight: 26
                                        color: vpMouse.containsMouse ? Theme.secondaryHover : "transparent"
                                        radius: 4

                                        ThemedIcon {
                                            anchors.centerIn: parent
                                            source: "qrc:/icons/outline/" + modelData + ".svg"
                                            iconSize: 14
                                            color: Theme.foreground
                                        }

                                        MouseArea {
                                            id: vpMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                        }
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    text: "100%"
                                    color: Theme.mutedForeground
                                    font.pixelSize: 11
                                    font.family: "monospace"
                                }

                                Item { Layout.preferredWidth: 4 }
                            }
                        }

                        // Viewport Canvas
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#0a0a1a"
                            clip: true

                            Rectangle {
                                anchors.centerIn: parent
                                width: parent ? parent.width * 0.7 : 0
                                height: parent ? parent.width * 0.7 * (9/16) : 0
                                color: "#111122"
                                border.color: Theme.muted
                                border.width: 1
                                radius: 2

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 8

                                    Text {
                                        text: "No media on timeline"
                                        color: Theme.mutedForeground
                                        font.pixelSize: 13
                                        horizontalAlignment: Text.AlignHCenter
                                        Layout.fillWidth: true
                                    }

                                    StyledButton {
                                        text: "Import Media"
                                        iconSource: "qrc:/icons/outline/file-import.svg"
                                        variant: "secondary"
                                        Layout.alignment: Qt.AlignHCenter
                                        onClicked: importDialog.open()
                                    }
                                }
                            }
                        }

                        // Transport Controls
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            color: Theme.secondary
                            border.color: Theme.border

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Repeater {
                                    model: ["player-skip-back", "player-track-prev", "player-play", "player-track-next", "player-skip-forward"]
                                    delegate: Rectangle {
                                        Layout.preferredWidth: 32
                                        Layout.preferredHeight: 28
                                        color: transportMouse.containsMouse ? Theme.secondaryHover : "transparent"
                                        radius: 4

                                        ThemedIcon {
                                            anchors.centerIn: parent
                                            source: "qrc:/icons/outline/" + modelData + ".svg"
                                            iconSize: 16
                                            color: Theme.foreground
                                            opacity: index === 2 ? 1.0 : 0.7
                                        }

                                        MouseArea {
                                            id: transportMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Properties Panel
                StyledPanel {
                    title: "Properties"
                    SplitView.preferredWidth: 260
                    SplitView.minimumWidth: 180
                    collapsible: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        Text {
                            text: "No selection"
                            color: Theme.mutedForeground
                            font.pixelSize: 12
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.topMargin: 40
                        }

                        Item { Layout.fillHeight: true }
                    }
                }

                handle: Rectangle {
                    implicitWidth: 4
                    implicitHeight: 4
                    color: SplitHandle.pressed ? Theme.primary : (SplitHandle.hovered ? Theme.primaryHover : Theme.border)
                }
            }

            // --- BOTTOM SECTION: Tabs ---
            Rectangle {
                id: bottomSection
                SplitView.preferredHeight: 250
                SplitView.minimumHeight: 120
                color: Theme.background

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0


                    StackLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        currentIndex: bottomTabBar.currentIndex

                        TimelineTab { }
                        NodeEditorTab { }
                        GraphEditorTab { }
                        AudioEditorTab { }
                    }
                }
            }

            handle: Rectangle {
                implicitHeight: 4
                implicitWidth: 4
                color: SplitHandle.pressed ? Theme.primary : (SplitHandle.hovered ? Theme.primaryHover : Theme.border)
            }
        }


        //tab bar

        TabBar {
            id: bottomTabBar
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            background: Rectangle { color: Theme.secondary; border.color: Theme.border }

            TabButton {
                text: "Timeline"
                background: Rectangle { color: parent.checked ? Theme.background : "transparent" }
                contentItem: Text {
                    text: parent.text
                    color: parent.checked ? Theme.primary : Theme.mutedForeground
                    font.pixelSize: 11
                    font.bold: parent.checked
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TabButton {
                text: "Node Editor"
                background: Rectangle { color: parent.checked ? Theme.background : "transparent" }
                contentItem: Text {
                    text: parent.text
                    color: parent.checked ? Theme.primary : Theme.mutedForeground
                    font.pixelSize: 11
                    font.bold: parent.checked
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TabButton {
                text: "Graph Editor"
                background: Rectangle { color: parent.checked ? Theme.background : "transparent" }
                contentItem: Text {
                    text: parent.text
                    color: parent.checked ? Theme.primary : Theme.mutedForeground
                    font.pixelSize: 11
                    font.bold: parent.checked
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            TabButton {
                text: "Audio Editor"
                background: Rectangle { color: parent.checked ? Theme.background : "transparent" }
                contentItem: Text {
                    text: parent.text
                    color: parent.checked ? Theme.primary : Theme.mutedForeground
                    font.pixelSize: 11
                    font.bold: parent.checked
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        // === Status Bar ===
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            color: Theme.secondary
            border.color: Theme.border

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 16

                Text {
                    text: "No project loaded"
                    color: Theme.mutedForeground
                    font.pixelSize: 10
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "CPU: 0% | GPU: 0% | FPS: 0"
                    color: Theme.mutedForeground
                    font.pixelSize: 10
                    font.family: "monospace"
                }

                Text {
                    text: "1920x1080 | 29.97 fps"
                    color: Theme.mutedForeground
                    font.pixelSize: 10
                }
            }
        }
    }

    Menu {
        id: fileMenu
        Action { text: "New Project"; icon.source: "qrc:/icons/outline/file-plus.svg" }
        Action { text: "Open Project..."; icon.source: "qrc:/icons/outline/folder-open.svg" }
        Action { text: "Save"; icon.source: "qrc:/icons/outline/device-floppy.svg"; shortcut: "Ctrl+S" }
        Action { text: "Save As..."; shortcut: "Ctrl+Shift+S" }
        MenuSeparator { }
        Action { text: "Import Media..."; icon.source: "qrc:/icons/outline/file-import.svg"; shortcut: "Ctrl+I" }
        Action { text: "Export..."; icon.source: "qrc:/icons/outline/file-export.svg"; shortcut: "Ctrl+E" }
        MenuSeparator { }
        Action { text: "Exit"; shortcut: "Ctrl+Q"; onTriggered: Qt.quit() }
    }

    Menu {
        id: editMenu
        Action { text: "Undo"; shortcut: "Ctrl+Z" }
        Action { text: "Redo"; shortcut: "Ctrl+Shift+Z" }
        MenuSeparator { }
        Action { text: "Cut"; shortcut: "Ctrl+X" }
        Action { text: "Copy"; shortcut: "Ctrl+C" }
        Action { text: "Paste"; shortcut: "Ctrl+V" }
        Action { text: "Duplicate"; shortcut: "Ctrl+D" }
        Action { text: "Delete"; shortcut: "Del" }
        MenuSeparator { }
        Action { text: "Select All"; shortcut: "Ctrl+A" }
    }

    Menu {
        id: viewMenu
        Action { text: "Toggle Fullscreen"; shortcut: "F11" }
        MenuSeparator { }
        Action { text: "Show Timeline"; checkable: true; checked: true }
        Action { text: "Show Node Editor"; checkable: true }
        Action { text: "Show Graph Editor"; checkable: true }
        Action { text: "Show Audio Editor"; checkable: true }
        MenuSeparator { }
        Action { text: "Reset Layout" }
    }

    Menu {
        id: toolsMenu
        Action { text: "Select Tool"; shortcut: "V"; icon.source: "qrc:/icons/outline/hand-click.svg" }
        Action { text: "Move Tool"; shortcut: "M" }
        Action { text: "Blade Tool"; shortcut: "B" }
        Action { text: "Snap Toggle"; shortcut: "S" }
        MenuSeparator { }
        Action { text: "Graph Editor" }
        Action { text: "Node Editor" }
    }

    Menu {
        id: compositionMenu
        Action { text: "New Composition"; shortcut: "Ctrl+N" }
        Action { text: "Composition Settings"; shortcut: "Ctrl+Shift+C" }
        MenuSeparator { }
        Action { text: "Add Video Track" }
        Action { text: "Add Audio Track" }
    }

    Menu {
        id: helpMenu
        Action { text: "About MOKM MotionEditor" }
        Action { text: "Documentation" }
        Action { text: "Report Issue" }
    }

    FileDialog {
        id: importDialog
        title: "Import Media"
        fileMode: FileDialog.OpenFiles
        nameFilters: ["All supported (*.mp4 *.mov *.avi *.mkv *.png *.jpg *.svg *.gif *.mp3 *.wav *.flac)", "All files (*)"]
    }

    SomeClass {
        id: someClass
    }
}
