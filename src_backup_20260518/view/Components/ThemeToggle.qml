import QtQuick 2.15

/**
 * 太阳/月亮切换按钮（300ms 过渡）
 */
Item {
    id: root

    required property bool isDark
    signal toggleClicked()

    width: 36
    height: 36

    Rectangle {
        anchors.fill: parent
        radius: 18
        color: mouseArea.containsMouse 
            ? (root.isDark ? "rgba(255,255,255,0.1)" : "rgba(0,0,0,0.05)")
            : "transparent"

        // 图标容器
        Item {
            anchors.centerIn: parent
            width: 20
            height: 20

            // 太阳图标
            Text {
                anchors.centerIn: parent
                text: root.isDark ? "🌙" : "☀️"
                font.pixelSize: 18
                Behavior on rotation {
                    NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
                }
                rotation: root.isDark ? 0 : 180
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.toggleClicked()
        }
    }
}
