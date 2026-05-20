import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../Components"

/**
 * 主题色选择卡片
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

    // 卡片投影层
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

    Component.onCompleted: {
        console.log("AccentColorCard loaded")
        console.log("  themeVM:", themeVM)
        console.log("  accentColors.length:", themeVM.accentColors.length)
        console.log("  accentColorIndex:", themeVM.accentColorIndex)
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
            text: "主题色彩"
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

        // 8x2 颜色网格
        GridLayout {
            Layout.fillWidth: true
            columns: 8
            rowSpacing: 8
            columnSpacing: 8

            ColorDot {
                colorIndex: 0
                accentColor: "" + themeVM.accentColors[0]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 1
                accentColor: "" + themeVM.accentColors[1]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 2
                accentColor: "" + themeVM.accentColors[2]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 3
                accentColor: "" + themeVM.accentColors[3]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 4
                accentColor: "" + themeVM.accentColors[4]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 5
                accentColor: "" + themeVM.accentColors[5]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 6
                accentColor: "" + themeVM.accentColors[6]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 7
                accentColor: "" + themeVM.accentColors[7]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 8
                accentColor: "" + themeVM.accentColors[8]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 9
                accentColor: "" + themeVM.accentColors[9]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 10
                accentColor: "" + themeVM.accentColors[10]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 11
                accentColor: "" + themeVM.accentColors[11]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 12
                accentColor: "" + themeVM.accentColors[12]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 13
                accentColor: "" + themeVM.accentColors[13]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 14
                accentColor: "" + themeVM.accentColors[14]
                themeVM: root.themeVM
            }
            ColorDot {
                colorIndex: 15
                accentColor: "" + themeVM.accentColors[15]
                themeVM: root.themeVM
            }
        }

        // 当前选中颜色的文字提示
        Text {
            text: "当前主题色"
            font.pixelSize: 11
            renderType: Text.NativeRendering
            font.hintingPreference: Font.PreferFullHinting
            color: themeVM.palette.textTertiary
            Layout.leftMargin: 4
        }

        // 颜色预览
        RowLayout {
            spacing: 10

            Rectangle {
                implicitWidth: 32
                implicitHeight: 32
                radius: 8
                color: themeVM.palette.primary

                Behavior on color {
                    ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
                }
            }

            Text {
                text: themeVM.palette.primary
                font.pixelSize: 13
                font.weight: Font.Medium
                renderType: Text.NativeRendering
                font.hintingPreference: Font.PreferFullHinting
                color: themeVM.palette.textPrimary

                Behavior on color {
                    ColorAnimation { duration: 300; easing.type: Easing.InOutCubic }
                }
            }
        }
    }
}
