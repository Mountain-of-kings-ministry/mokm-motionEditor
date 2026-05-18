import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokmME

Rectangle {
    id: root

    property var selectedLayer: null
    property var selectedTrack: null

    property var layers: []

    function addLayer(name) {
        var layer = { name: name, visible: true, locked: false, tracks: [] }
        layers.push(layer)
        layersChanged()
        selectLayer(layer)
    }

    function addTrack(layerObj, type) {
        var count = layerObj.tracks.length + 1
        var track = { name: type + " " + count, trackType: type, visible: true, locked: false }
        layerObj.tracks.push(track)
        layersChanged()
        selectTrack(layerObj, track)
    }

    function removeLayer(layerObj) {
        var idx = layers.indexOf(layerObj)
        if (idx < 0) return
        layers.splice(idx, 1)
        layersChanged()
        if (selectedLayer === layerObj) {
            selectedLayer = layers.length > 0 ? layers[Math.min(idx, layers.length - 1)] : null
            selectedTrack = null
        }
    }

    function removeTrack(layerObj, trackObj) {
        var idx = layerObj.tracks.indexOf(trackObj)
        if (idx < 0) return
        layerObj.tracks.splice(idx, 1)
        layersChanged()
        if (selectedTrack === trackObj) {
            selectedTrack = layerObj.tracks.length > 0 ? layerObj.tracks[Math.min(idx, layerObj.tracks.length - 1)] : null
            if (!selectedTrack && selectedLayer === layerObj) selectedTrack = null
        }
    }

    function moveLayer(layerObj, delta) {
        var idx = layers.indexOf(layerObj)
        var newIdx = idx + delta
        if (newIdx < 0 || newIdx >= layers.length) return
        layers.splice(idx, 1)
        layers.splice(newIdx, 0, layerObj)
        layersChanged()
    }

    function moveTrack(layerObj, trackObj, delta) {
        var idx = layerObj.tracks.indexOf(trackObj)
        var newIdx = idx + delta
        if (newIdx < 0 || newIdx >= layerObj.tracks.length) return
        layerObj.tracks.splice(idx, 1)
        layerObj.tracks.splice(newIdx, 0, trackObj)
        layersChanged()
    }

    function selectLayer(layerObj) {
        selectedLayer = layerObj
        selectedTrack = null
    }

    function selectTrack(layerObj, trackObj) {
        selectedLayer = layerObj
        selectedTrack = trackObj
    }

    color: Theme.background

    Component.onCompleted: {
        addLayer("Layer 1")
        addTrack(layers[0], "Video")
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // === Toolbar ===
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            color: Theme.secondary
            border.color: Theme.border

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                spacing: 2

                Repeater {
                    model: [
                        { icon: "hand-click", tooltip: "Select (V)" },
                        { icon: "arrows-move", tooltip: "Move (M)" },
                        { icon: "scissors", tooltip: "Blade (B)" },
                        { icon: "hand-grab", tooltip: "Hand" },
                        { icon: "zoom-in", tooltip: "Zoom" }
                    ]
                    delegate: Rectangle {
                        Layout.preferredWidth: 28; Layout.preferredHeight: 26; radius: 4
                        color: toolMouse.containsMouse ? Theme.secondaryHover : "transparent"
                        ThemedIcon {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/" + modelData.icon + ".svg"
                            iconSize: 16
                            color: toolMouse.containsMouse ? Theme.primary : Theme.foreground
                        }
                        ToolTip {
                            visible: toolMouse.containsMouse
                            text: modelData.tooltip; delay: 600
                            background: Rectangle { color: Theme.secondary; border.color: Theme.border; radius: 4 }
                            contentItem: Text { text: modelData.tooltip; color: Theme.foreground; font.pixelSize: 11 }
                        }
                        MouseArea {
                            id: toolMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 18; color: Theme.border; Layout.margins: 2 }

                Repeater {
                    model: ["camera", "cut", "copy", "clipboard-plus", "trash", "arrow-back-up"]
                    delegate: Rectangle {
                        Layout.preferredWidth: 28; Layout.preferredHeight: 26; radius: 4
                        color: editMouse.containsMouse ? Theme.secondaryHover : "transparent"
                        ThemedIcon {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/" + modelData + ".svg"; iconSize: 16
                            color: Theme.foreground
                        }
                        MouseArea {
                            id: editMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 18; color: Theme.border; Layout.margins: 2 }

                Repeater {
                    model: [
                        { icon: "magnet", tooltip: "Snap (S)" },
                        { icon: "anchor", tooltip: "Anchor Point" },
                        { icon: "grid-dots", tooltip: "Grid" }
                    ]
                    delegate: Rectangle {
                        Layout.preferredWidth: 28; Layout.preferredHeight: 26; radius: 4
                        color: toggleMouse.containsMouse ? Theme.secondaryHover : "transparent"
                        ThemedIcon {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/" + modelData.icon + ".svg"; iconSize: 16
                            color: toggleMouse.containsMouse ? Theme.primary : Theme.foreground
                        }
                        ToolTip {
                            visible: toggleMouse.containsMouse
                            text: modelData.tooltip; delay: 600
                            background: Rectangle { color: Theme.secondary; border.color: Theme.border; radius: 4 }
                            contentItem: Text { text: modelData.tooltip; color: Theme.foreground; font.pixelSize: 11 }
                        }
                        MouseArea {
                            id: toggleMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "00:00:00:00"
                    color: Theme.primary; font.pixelSize: 12; font.bold: true; font.family: "monospace"
                }
                Text {
                    text: "Timeline"; color: Theme.mutedForeground; font.pixelSize: 11; font.bold: true; leftPadding: 8
                }
            }
        }

        // === Timeline ===
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.background
            clip: true

            ScrollView {
                anchors.fill: parent
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded

                ColumnLayout {
                    width: Math.max(parent ? parent.width : 200, 600)
                    spacing: 0

                    // Time ruler
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Item { Layout.preferredWidth: 200; height: 24 }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 24
                            color: Theme.secondary
                            border.color: Theme.border

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                                text: "0:00"
                                color: Theme.mutedForeground
                                font.pixelSize: 10
                                font.family: "monospace"
                            }
                        }
                    }

                    // Layer/Track rows
                    Repeater {
                        model: root.layers

                        delegate: ColumnLayout {
                            required property var modelData
                            readonly property var layerModel: modelData
                            spacing: 0

                            Text {
                                text: "Layers"
                            }

                            // Layer row: header + lane
                            RowLayout {
                                spacing: 0
                                Layout.fillWidth: true

                                TimelineLayerHeader {
                                    Layout.preferredWidth: 200
                                    Layout.preferredHeight: 28
                                    layerName: layerModel.name
                                    visible_: layerModel.visible
                                    locked: layerModel.locked

                                    onSelected: root.selectLayer(layerModel)
                                    onToggleVisibility: { layerModel.visible = !layerModel.visible; root.layersChanged() }
                                    onToggleLock: { layerModel.locked = !layerModel.locked; root.layersChanged() }
                                    onRequestAddTrack: addTrackDialog.openForLayer(layerModel)
                                    onRequestMoveUp: root.moveLayer(layerModel, -1)
                                    onRequestMoveDown: root.moveLayer(layerModel, 1)
                                    onRequestDelete: root.removeLayer(layerModel)
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 28
                                    color: "transparent"
                                    border.color: Theme.border
                                    border.width: 1
                                }
                            }

                            // Track rows
                            Repeater {
                                model: layerModel.tracks

                                delegate: RowLayout {
                                    spacing: 0
                                    Layout.fillWidth: true

                                    TimelineTrackHeader {
                                        Layout.preferredWidth: 200
                                        Layout.preferredHeight: 28
                                        indent: 14
                                        trackName: modelData.name
                                        trackType: modelData.trackType
                                        visible_: modelData.visible
                                        locked: modelData.locked

                                        onSelected: root.selectTrack(layerModel, modelData)
                                        onToggleVisibility: { modelData.visible = !modelData.visible; root.layersChanged() }
                                        onToggleLock: { modelData.locked = !modelData.locked; root.layersChanged() }
                                        onRequestMoveUp: root.moveTrack(layerModel, modelData, -1)
                                        onRequestMoveDown: root.moveTrack(layerModel, modelData, 1)
                                        onRequestDelete: root.removeTrack(layerModel, modelData)
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 28
                                        color: "transparent"
                                        border.color: Theme.border
                                        border.width: 1
                                    }
                                }
                            }
                        }
                    }

                    // Bottom filler
                    Item { Layout.fillHeight: true; height: 28 }

                    // Add Layer button
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        StyledButton {
                            Layout.preferredWidth: 200
                            text: "+ Layer"
                            iconSource: "qrc:/icons/outline/plus.svg"
                            variant: "ghost"
                            onClicked: root.addLayer("Layer " + (root.layers.length + 1))
                        }

                        Item { Layout.fillWidth: true }
                    }
                }
            }
        }
    }

    AddTrackDialog {
        id: addTrackDialog
        parent: root

        function openForLayer(layerObj) {
            selectedLayer = layerObj
            open()
        }

        onTrackTypeChosen: function(type) {
            root.addTrack(addTrackDialog.selectedLayer, type)
        }
    }
}
