import QtQuick 2.15
import QtQuick.Layouts 1.15
import "."

/**
 * 卡片内 SpinBox（居中数字 + 单位标签）
 *
 * required property:
 * - value: 当前值
 * - from: 最小值
 * - to: 最大值
 * - unit: 单位文字
 * - label: 标签文字
 * - enabled: 是否启用
 * - themeVM: 主题 ViewModel
 *
 * signal:
 * - valueChanged(int value)
 */
Rectangle {
    id: root

    required property int value
    required property int from
    required property int to
    required property string unit
    required property string label
    required property var themeVM

    height: 80
    radius: 10
    color: themeVM.palette.inputBackground
    border.color: root.enabled ? themeVM.palette.inputBorder : "transparent"
    border.width: 1
    opacity: root.enabled ? 1.0 : 0.35

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
    Behavior on color {
        ColorAnimation { duration: 200 }
    }
    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4

        // 标签
        Text {
            text: root.label
            font.pixelSize: 11
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 0.5
            font.family: "LXGW Neo XiHei Plus, Inter, sans-serif"
            renderType: Text.NativeRendering
            font.hintingPreference: Font.PreferFullHinting
            color: themeVM.palette.textTertiary
        }

        // 数值和按钮
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            // 减少按钮
            Rectangle {
                width: 28
                height: 28
                radius: 6
                color: minusMouseArea.containsMouse ? themeVM.palette.hoverBackground : "transparent"

                LucideIcon {
                    anchors.centerIn: parent
                    name: "minus"
                    size: 16
                    color: themeVM.palette.onSurface
                }

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }

                MouseArea {
                    id: minusMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (root.value > root.from) {
                            root.value = root.value - 1
                        }
                    }
                }
            }

            // 数值显示
            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: root.value.toString()
                font.pixelSize: 22
                font.weight: Font.DemiBold
                font.family: "JetBrains Mono, LXGW Neo XiHei Plus, monospace"
                renderType: Text.NativeRendering
                font.hintingPreference: Font.PreferFullHinting
                color: themeVM.palette.textPrimary

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            // 增加按钮
            Rectangle {
                width: 28
                height: 28
                radius: 6
                color: plusMouseArea.containsMouse ? themeVM.palette.hoverBackground : "transparent"

                LucideIcon {
                    anchors.centerIn: parent
                    name: "plus"
                    size: 16
                    color: themeVM.palette.onSurface
                }

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }

                MouseArea {
                    id: plusMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (root.value < root.to) {
                            root.value = root.value + 1
                        }
                    }
                }
            }
        }

        // 单位文字
        Text {
            text: root.unit
            font.pixelSize: 12
            font.family: "LXGW Neo XiHei Plus, Inter, sans-serif"
            renderType: Text.NativeRendering
            font.hintingPreference: Font.PreferFullHinting
            color: themeVM.palette.textTertiary
        }
    }
}
