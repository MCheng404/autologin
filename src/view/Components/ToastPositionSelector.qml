import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../Components"

/**
 * 通知位置选择器（SegmentedButton 风格）
 * position: 0=右下角, 1=左下角, 2=顶部居中
 */
RowLayout {
    id: root

    required property var themeVM
    property int position: 0  // 0=右下, 1=左下, 2=顶部居中
    property bool isEnabled: true

    // 从 themeVM 提取调色板
    property var themePalette: themeVM ? themeVM.palette : null

    spacing: 6

    // ========== 右下角 ==========
    Rectangle {
        id: btnBottomRight
        Layout.fillWidth: true
        height: 30
        radius: 8
        color: {
            if (!root.isEnabled) return themePalette ? themePalette.surfaceVariant : "#888"
            return position === 0 ? (themePalette ? themePalette.primary : "#0078d4") : (themePalette ? themePalette.hoverBackground : "#2a2a2a")
        }
        border.color: position === 0 ? (themePalette ? themePalette.primary : "#0078d4") : (themePalette ? themePalette.outline : "#555")
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }

        RowLayout {
            anchors.centerIn: parent
            spacing: 4
            LucideIcon {
                name: "arrow-down-right"
                size: 12
                color: {
                    if (!root.isEnabled) return themePalette ? themePalette.textTertiary : "#888"
                    return position === 0 ? (themePalette ? themePalette.onPrimary : "#fff") : (themePalette ? themePalette.textSecondary : "#aaa")
                }
            }
            Text {
                text: "右下"
                font.pixelSize: 11
                font.weight: position === 0 ? Font.Medium : Font.Normal
                font.family: "LXGW Neo XiHei Plus, Inter, sans-serif"
                color: {
                    if (!root.isEnabled) return themePalette ? themePalette.textTertiary : "#888"
                    return position === 0 ? (themePalette ? themePalette.onPrimary : "#fff") : (themePalette ? themePalette.textSecondary : "#aaa")
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.isEnabled
            onClicked: position = 0
        }
    }

    // ========== 左下角 ==========
    Rectangle {
        id: btnBottomLeft
        Layout.fillWidth: true
        height: 30
        radius: 8
        color: {
            if (!root.isEnabled) return themePalette ? themePalette.surfaceVariant : "#888"
            return position === 1 ? (themePalette ? themePalette.primary : "#0078d4") : (themePalette ? themePalette.hoverBackground : "#2a2a2a")
        }
        border.color: position === 1 ? (themePalette ? themePalette.primary : "#0078d4") : (themePalette ? themePalette.outline : "#555")
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }

        RowLayout {
            anchors.centerIn: parent
            spacing: 4
            LucideIcon {
                name: "arrow-down-left"
                size: 12
                color: {
                    if (!root.isEnabled) return themePalette ? themePalette.textTertiary : "#888"
                    return position === 1 ? (themePalette ? themePalette.onPrimary : "#fff") : (themePalette ? themePalette.textSecondary : "#aaa")
                }
            }
            Text {
                text: "左下"
                font.pixelSize: 11
                font.weight: position === 1 ? Font.Medium : Font.Normal
                font.family: "LXGW Neo XiHei Plus, Inter, sans-serif"
                color: {
                    if (!root.isEnabled) return themePalette ? themePalette.textTertiary : "#888"
                    return position === 1 ? (themePalette ? themePalette.onPrimary : "#fff") : (themePalette ? themePalette.textSecondary : "#aaa")
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.isEnabled
            onClicked: position = 1
        }
    }

    // ========== 顶部居中 ==========
    Rectangle {
        id: btnTopCenter
        Layout.fillWidth: true
        height: 30
        radius: 8
        color: {
            if (!root.isEnabled) return themePalette ? themePalette.surfaceVariant : "#888"
            return position === 2 ? (themePalette ? themePalette.primary : "#0078d4") : (themePalette ? themePalette.hoverBackground : "#2a2a2a")
        }
        border.color: position === 2 ? (themePalette ? themePalette.primary : "#0078d4") : (themePalette ? themePalette.outline : "#555")
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }

        RowLayout {
            anchors.centerIn: parent
            spacing: 4
            LucideIcon {
                name: "arrow-up"
                size: 12
                color: {
                    if (!root.isEnabled) return themePalette ? themePalette.textTertiary : "#888"
                    return position === 2 ? (themePalette ? themePalette.onPrimary : "#fff") : (themePalette ? themePalette.textSecondary : "#aaa")
                }
            }
            Text {
                text: "顶部"
                font.pixelSize: 11
                font.weight: position === 2 ? Font.Medium : Font.Normal
                font.family: "LXGW Neo XiHei Plus, Inter, sans-serif"
                color: {
                    if (!root.isEnabled) return themePalette ? themePalette.textTertiary : "#888"
                    return position === 2 ? (themePalette ? themePalette.onPrimary : "#fff") : (themePalette ? themePalette.textSecondary : "#aaa")
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.isEnabled
            onClicked: position = 2
        }
    }
}
