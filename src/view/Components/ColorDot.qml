import QtQuick 2.15

/**
 * 单个颜色圆点组件
 */
Item {
    id: dotRoot

    required property int colorIndex
    required property string accentColor
    required property var themeVM

    width: 28
    height: 28

    // 选中状态（计算属性，避免重复表达式）
    readonly property bool isSelected: themeVM.accentColorIndex === colorIndex

    // 选中描边（最外层，粗描边突出选中状态）
    Rectangle {
        anchors.centerIn: colorCircle
        width: colorCircle.width + 8
        height: colorCircle.height + 8
        radius: (colorCircle.width + 8) / 2
        color: "transparent"
        border.color: accentColor
        border.width: 2
        opacity: isSelected ? 0.9 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        z: -2
    }

    // 外层选中光晕（主题色外发光）
    Rectangle {
        anchors.centerIn: colorCircle
        width: colorCircle.width + 12
        height: colorCircle.height + 12
        radius: (colorCircle.width + 12) / 2
        color: "transparent"
        border.color: accentColor
        border.width: 1
        opacity: isSelected ? 0.5 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        z: -1
    }

    // 颜色圆点
    Rectangle {
        id: colorCircle
        anchors.centerIn: parent
        width: 18
        height: 18
        radius: 9
        color: accentColor
        z: 1

        // 选中时内部高亮（上方半透明白色渐变）
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: parent.height * 0.3
            anchors.bottomMargin: parent.height * 0.5
            anchors.leftMargin: 2
            anchors.rightMargin: 2
            radius: parent.radius - 2
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#30ffffff" }
                GradientStop { position: 1.0; color: "#00ffffff" }
            }
            opacity: isSelected ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            z: 2
        }

        // 悬停时扩散光晕
        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            radius: parent.radius + 3
            color: accentColor
            opacity: dotMouseArea.containsMouse ? 0.35 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
            z: -1
        }
    }

    // 点击选色
    MouseArea {
        id: dotMouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onClicked: {
            themeVM.accentColorIndex = colorIndex
        }
    }
}
