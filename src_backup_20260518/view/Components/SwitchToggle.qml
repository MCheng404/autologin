import QtQuick 2.15
import QtQuick.Layouts 1.15

/**
 * 自定义开关（弹性动画）
 * 
 * required property:
 * - checked: 当前状态
 * - title: 开关标题
 * - description: 描述文字
 * 
 * signal:
 * - toggled(bool checked)
 */
Item {
    id: root

    required property bool checked
    required property string title
    required property string description
    required property var themeVM

    signal toggled(bool checked)

    implicitHeight: optionRow.height
    height: implicitHeight

    // 选项行
    RowLayout {
        id: optionRow
        width: root.width
        spacing: 12

        // 文字区域
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.title
                font.pixelSize: 14
                color: themeVM.palette.onSurface
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }

            Text {
                text: root.description
                font.pixelSize: 11
                color: themeVM.palette.textSecondary
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
        }

        // 开关控件
        Rectangle {
            id: toggleTrack
            width: 44
            height: 24
            radius: 24
            color: root.checked ? themeVM.palette.toggleActive : themeVM.palette.toggleTrack
            Behavior on color {
                ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
            }

            // 滑块
            Rectangle {
                id: thumb
                width: 18
                height: 18
                radius: 18
                color: "#ffffff"
                x: root.checked ? 23 : 3
                y: 3

                Behavior on x {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutElastic
                        easing.amplitude: 0.8
                        easing.period: 0.4
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.checked = !root.checked
                        root.toggled(root.checked)
                    }
                }
            }
        }
    }
}
