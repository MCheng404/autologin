import QtQuick 2.15
import QtQuick.Layouts 1.15

/**
 * 账户信息卡片（用户名/密码）
 *
 * 注意：TextInput 无 placeholderText 属性，用 Text overlay 模拟
 */
 ColumnLayout {
    id: root

    required property var settingsVM
    required property var themeVM

    spacing: 8

    // 卡片标题
    Text {
        text: "账户信息"
        font.pixelSize: 11
        font.weight: Font.DemiBold
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 1.2
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
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 0.5
            color: themeVM.palette.textSecondary
        }

        Rectangle {
            Layout.fillWidth: true
            height: 40
            radius: 10
            color: themeVM.palette.inputBackground
            border.color: usernameInput.activeFocus ? themeVM.palette.primary : themeVM.palette.inputBorder
            border.width: 1

            // Placeholder 文字（TextInput 无此属性，用 Text 叠加）
            Text {
                anchors.fill: parent
                anchors.margins: 10
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
                color: themeVM.palette.textTertiary
                text: "校园网账号（自动补@unicom）"
                visible: usernameInput.text.length === 0
            }

            TextInput {
                id: usernameInput
                anchors.fill: parent
                anchors.margins: 10
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
                color: themeVM.palette.textPrimary
                text: settingsVM.username
                clip: true

                onTextChanged: {
                    settingsVM.username = text
                }

                onActiveFocusChanged: {
                    if (activeFocus) {
                        parent.border.color = themeVM.palette.primary
                        parent.color = Qt.rgba(0.39, 0.40, 0.95, 0.06)
                    } else {
                        parent.border.color = themeVM.palette.inputBorder
                        parent.color = themeVM.palette.inputBackground
                    }
                }
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
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 0.5
            color: themeVM.palette.textSecondary
        }

        Rectangle {
            Layout.fillWidth: true
            height: 40
            radius: 10
            color: themeVM.palette.inputBackground
            border.color: passwordInput.activeFocus ? themeVM.palette.primary : themeVM.palette.inputBorder
            border.width: 1

            // Placeholder 文字
            Text {
                anchors.fill: parent
                anchors.margins: 10
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
                color: themeVM.palette.textTertiary
                text: "请输入校园网密码"
                visible: passwordInput.text.length === 0
            }

            TextInput {
                id: passwordInput
                anchors.fill: parent
                anchors.margins: 10
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
                color: themeVM.palette.textPrimary
                text: settingsVM.password
                echoMode: TextInput.Password
                clip: true

                onTextChanged: {
                    settingsVM.password = text
                }

                onActiveFocusChanged: {
                    if (activeFocus) {
                        parent.border.color = themeVM.palette.primary
                        parent.color = Qt.rgba(0.39, 0.40, 0.95, 0.06)
                    } else {
                        parent.border.color = themeVM.palette.inputBorder
                        parent.color = themeVM.palette.inputBackground
                    }
                }
            }
        }
    }
}
