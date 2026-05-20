import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../Components"

/**
 * 基本设置卡片（点击认证/自启/通知）
 */
ColumnLayout {
    id: root

    required property var settingsVM
    required property var themeVM

    spacing: 8

    // 卡片标题
    Text {
        text: "基本功能"
        font.pixelSize: 11
        font.weight: Font.DemiBold
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 1.2
        color: themeVM.palette.textTertiary
        Layout.leftMargin: 4
    }

    // 点击托盘图标立即认证
    SwitchToggle {
        Layout.fillWidth: true
        checked: settingsVM.clickToAuth
        title: "单击托盘图标立即认证"
        description: "点击系统托盘图标时重新登录"
        themeVM: root.themeVM

        onToggled: function(checked) {
            settingsVM.clickToAuth = checked
        }
    }

    // 开机自动启动
    SwitchToggle {
        Layout.fillWidth: true
        checked: settingsVM.autostart
        title: "开机自动启动"
        description: "登录系统后自动后台运行"
        themeVM: root.themeVM

        onToggled: function(checked) {
            settingsVM.autostart = checked
        }
    }

    // 系统通知提醒
    SwitchToggle {
        Layout.fillWidth: true
        checked: settingsVM.notifications
        title: "系统通知提醒"
        description: "登录/登出/错误时弹出通知"
        themeVM: root.themeVM

        onToggled: function(checked) {
            settingsVM.notifications = checked
        }
    }
}
