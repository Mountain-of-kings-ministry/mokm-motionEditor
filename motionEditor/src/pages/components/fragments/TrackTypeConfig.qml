pragma Singleton
import QtQuick

QtObject {
    id: root

    property ListModel types: ListModel {
        ListElement { type: "Video"; icon: "video"; color: "#3b82f6"; label: "Video Track" }
        ListElement { type: "Audio"; icon: "music"; color: "#22c55e"; label: "Audio Track" }
        ListElement { type: "Vector"; icon: "git-merge"; color: "#a855f7"; label: "Vector Track" }
        ListElement { type: "Text"; icon: "text-caption"; color: "#f59e0b"; label: "Text Track" }
        ListElement { type: "Mask"; icon: "mask"; color: "#ef4444"; label: "Mask Track" }
    }

    function iconFor(type) {
        for (var i = 0; i < types.count; i++) {
            if (types.get(i).type === type) return types.get(i).icon
        }
        return "file"
    }

    function colorFor(type) {
        for (var i = 0; i < types.count; i++) {
            if (types.get(i).type === type) return types.get(i).color
        }
        return "#888888"
    }

    function labelFor(type) {
        for (var i = 0; i < types.count; i++) {
            if (types.get(i).type === type) return types.get(i).label
        }
        return "Track"
    }
}
