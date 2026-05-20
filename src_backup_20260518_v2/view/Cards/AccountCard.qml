import QtQuick 2.15
import QtQuick.Layouts 1.15

/**
 * 账户信息卡片（用户名/密码）
 *
 * 卡片自带主题背景
 * 注意：TextInput 无 placeholderText 属性，用 Text overlay 模拟
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
            text: "账户信息"
            font.pixelSize: 11
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.2
            renderType: Text.NativeRendering
            font.hintingPreference: Font.PreferFullHinting
            color: themeVM.palette.textTertiary
            Layout.leftMargin: 4
        }

        // 用户名输入
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: "用户名"
                font.pixelSize: 11
                renderType: Text.NativeRendering
                font.hintingPreference: Font.PreferFullHinting
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.5
                color: themeVM.palette.textSecondary
            }

            Rectangle {
                id: usernameBox
                Layout.fillWidth: true
                height: 40
                radius: 10
                color: themeVM.palette.inputBackground
                border.color: usernameInput.activeFocus ? themeVM.palette.inputFocusBorder : themeVM.palette.inputBorder
                border.width: 1

                Behavior on border.color {
                    ColorAnimation { duration: 200 }
                }
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                TextInput {
                    id: usernameInput
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.textPrimary
                    text: settingsVM.username
                    clip: true

                    onTextChanged: {
                        settingsVM.username = text
                    }
                }

                // Placeholder
                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.textTertiary
                    text: "校园网账号（自动补@unicom）"
                    visible: usernameInput.text.length === 0 && !usernameInput.activeFocus
                    enabled: false
                    z: -1
                }
            }
        }

        // 密码输入
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: "密码"
                font.pixelSize: 11
                renderType: Text.NativeRendering
                font.hintingPreference: Font.PreferFullHinting
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.5
                color: themeVM.palette.textSecondary
            }

            Rectangle {
                id: passwordBox
                Layout.fillWidth: true
                height: 40
                radius: 10
                color: themeVM.palette.inputBackground
                border.color: passwordInput.activeFocus ? themeVM.palette.inputFocusBorder : themeVM.palette.inputBorder
                border.width: 1

                Behavior on border.color {
                    ColorAnimation { duration: 200 }
                }
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.textPrimary
                    text: settingsVM.password
                    echoMode: TextInput.Password
                    clip: true

                    onTextChanged: {
                        settingsVM.password = text
                    }
                }

                // Placeholder
                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    color: themeVM.palette.textTertiary
                    text: "请输入校园网密码"
                    visible: passwordInput.text.length === 0 && !passwordInput.activeFocus
                    enabled: false
                    z: -1
                }
            }
        }
    }
}
