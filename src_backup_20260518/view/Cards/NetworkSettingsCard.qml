import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../Components"

/**
 * 网络设置卡片（热点/优先级）
 */
ColumnLayout {
    id: root

    required property var settingsVM
    required property var themeVM

    spacing: 8

    // 卡片标题
    Text {
        text: "网络设置"
        font.pixelSize: 11
        font.weight: Font.DemiBold
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 1.2
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
