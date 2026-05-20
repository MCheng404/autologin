import QtQuick 2.15
import QtQuick.Layouts 1.15

/**
 * 通用主题卡片容器
 * 包裹内容，提供统一的背景/边框/圆角/Behavior 过渡
 *
 * 用法：
 *   ThemeCard {
 *       Layout.fillWidth: true
 *       // 卡片内容...
 *   }
 */
Rectangle {
    id: root

    required property var themeVM

    radius: 16
    color: themeVM.palette.cardBackground
    border.color: themeVM.palette.cardBorder
    border.width: 1

    Behavior on color {
        ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
    }
    Behavior on border.color {
        ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
    }

    property alias contentDataAlias: col.data

    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10
    }
}
