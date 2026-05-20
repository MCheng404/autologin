import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../Components"

/**
 * 网络设置卡片（热点/优先级）
 *
 * 卡片自带主题背景
 */
Rectangle {
    id: root

    required property var settingsVM
    required property var themeVM

    radius: 16
    color: themeVM.palette.cardBackground
    border.color: themeVM.palette.cardBorder
    border.width: 1
    implicitHeight: col.implicitHeight + 32

    Behavior on color {
        ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
    }
    Behavior on border.color {
        ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
    }

    ColumnLayout {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        spacing: 12

        // 卡片标题
        Text {
            text: "网络设置"
            font.pixelSize: 11
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2
            renderType: Text.NativeRendering
            font.hintingPreference: Font.PreferFullHinting
            color: themeVM.palette.textTertiary
            Layout.leftMargin: 4
        }

        // 认证后自动开热点
        SwitchToggle {
            Layout.fillWidth: true
            checked: settingsVM.autoHotspot
            title: "认证后自动开热点"
            description: "登录成功后自动开启 WLAN 热点"
            themeVM: root.themeVM

            onToggled: function(checked) {
                settingsVM.autoHotspot = checked
            }
        }

        // 提高线程优先级
        SwitchToggle {
            Layout.fillWidth: true
            checked: settingsVM.highPriority
            title: "提高线程优先级"
            description: "需要以管理员权限运行"
            themeVM: root.themeVM

            onToggled: function(checked) {
                settingsVM.highPriority = checked
            }
        }
    }
}
