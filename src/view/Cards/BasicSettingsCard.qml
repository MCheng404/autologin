import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../Components"

/**
 * 基本设置卡片（点击认证/自启/通知）
 *
 * 卡片自带主题背景，无需外部包裹
 */
Rectangle {
    id: root

    required property var settingsVM
    required property var themeVM

    radius: 16
    color: themeVM.palette.cardBackground
    border.color: themeVM.palette.cardBorder
    border.width: 1
    implicitHeight: col.implicitHeight + 32  // 上下各 16 padding

    // 卡片投影层（悬停时加深）
    Rectangle {
        anchors.fill: parent
        anchors.margins: -4
        radius: parent.radius + 4
        color: themeVM.palette.cardShadow
        z: -1

        Behavior on color {
            ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
        }
    }

    // 悬停高亮边框
    Rectangle {
        id: hoverBorder
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.color: themeVM.palette.primary
        border.width: 1
        opacity: 0

        Behavior on opacity {
            ColorAnimation { duration: 200 }
        }
    }

    // 整个卡片可悬停
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: {
            hoverBorder.opacity = containsMouse ? 0.4 : 0
        }
    }

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
            text: "基本功能"
            font.pixelSize: 11
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2
            font.family: "Sarasa UI SC, WenQuanYi Rounded SC, WenQuanYi Micro Hei, sans-serif"
            renderType: Text.NativeRendering
            font.hintingPreference: Font.PreferFullHinting
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

        // 通知显示位置
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: "通知位置"
                font.pixelSize: 11
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.5
                font.family: "Sarasa UI SC, WenQuanYi Rounded SC, WenQuanYi Micro Hei, sans-serif"
                renderType: Text.NativeRendering
                font.hintingPreference: Font.PreferFullHinting
                color: themeVM.palette.textSecondary
                Layout.leftMargin: 4
            }

            ToastPositionSelector {
                position: settingsVM.toastPosition
                isEnabled: settingsVM.notifications
                themeVM: root.themeVM

                onPositionChanged: {
                    settingsVM.toastPosition = position
                }
            }
        }
    }
}
