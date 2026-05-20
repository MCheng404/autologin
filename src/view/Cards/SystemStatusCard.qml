import QtQuick 2.15
import QtQuick.Layouts 1.15

/**
 * 系统状态卡片（时钟 + 运行时间 + 上次认证间隔）
 *
 * appStartMs 由 C++ TrayViewModel 构造函数在应用启动时记录，
 * 比 QML 的 Component.onCompleted 更早、更可靠。
 */
Rectangle {
    id: root

    // ---- 公开属性 ----
    required property var trayVM
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

    // ---- 辅助函数 ----

    function fmtHMS(totalMs) {
        if (!totalMs || totalMs <= 0) return "00:00:00"
        var secs = Math.floor(totalMs / 1000)
        var hours = Math.floor(secs / 3600)
        secs = secs % 3600
        var minutes = Math.floor(secs / 60)
        secs = secs % 60
        var hh = String(hours).padStart(2, "0")
        var mm = String(minutes).padStart(2, "0")
        var ss = String(secs).padStart(2, "0")
        return hh + ":" + mm + ":" + ss
    }

    // ---- 动态数据 ----

    // 当前系统时间字符串（每秒刷新）
    property string timeStr: "00:00:00"

    // 当前系统日期字符串（Timer 驱动）
    property string dateStr: (function() {
        var d = new Date()
        var week = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return d.getFullYear() + "年" +
               String(d.getMonth() + 1).padStart(2, "0") + "月" +
               String(d.getDate()).padStart(2, "0") + "日  " +
               week[d.getDay()]
    })()
    property string runtimeStr: "00:00:00"

    // 距上次认证
    property string sinceAuthStr: "从未"

    // 每秒刷新——同时更新 timeStr/runtimeStr/sinceAuthStr
    Timer {
        id: ticker
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            var now = Date.now()

            // 时钟
            var d = new Date(now)
            timeStr = String(d.getHours()).padStart(2, "0") + ":" +
                       String(d.getMinutes()).padStart(2, "0") + ":" +
                       String(d.getSeconds()).padStart(2, "0")

            // 日期（周几中文映射）
            var week = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
            dateStr = d.getFullYear() + "年" +
                       String(d.getMonth() + 1).padStart(2, "0") + "月" +
                       String(d.getDate()).padStart(2, "0") + "日  " +
                       week[d.getDay()]

            // 运行时间
            var startMs = trayVM ? trayVM.appStartMs : 0
            runtimeStr = startMs > 0 ? fmtHMS(now - startMs) : "00:00:00"

            // 距上次认证
            var last = trayVM ? trayVM.lastAuthMs : 0
            sinceAuthStr = last > 0 ? fmtHMS(now - last) : "从未"
        }
    }

    // ---- 布局 ----
    ColumnLayout {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        spacing: 12

        // 卡片标题
        Text {
            text: "系统状态"
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

        // 时间 + 日期（大号字体，居中）
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.timeStr
                font.pixelSize: 28
                font.weight: Font.Light
                font.family: "Sarasa Mono SC, Sarasa UI SC, WenQuanYi Rounded SC, monospace"
                renderType: Text.NativeRendering
                font.hintingPreference: Font.PreferFullHinting
                color: themeVM.palette.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: root.dateStr
                font.pixelSize: 12
                font.weight: Font.Normal
                font.family: "Sarasa UI SC, WenQuanYi Rounded SC, WenQuanYi Micro Hei, sans-serif"
                renderType: Text.NativeRendering
                font.hintingPreference: Font.PreferFullHinting
                color: themeVM.palette.textTertiary
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // 分隔线
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: themeVM.palette.divider
        }

        // 统计行
        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            // 运行时间
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "运行时间"
                    font.pixelSize: 10
                    font.weight: Font.Normal
                    font.family: "Sarasa UI SC, WenQuanYi Rounded SC, sans-serif"
                    renderType: Text.NativeRendering
                    color: themeVM.palette.textTertiary
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: root.runtimeStr
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    font.family: "Sarasa Mono SC, Sarasa UI SC, WenQuanYi Rounded SC, monospace"
                    renderType: Text.NativeRendering
                    color: themeVM.palette.textSecondary
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // 竖线分隔
            Rectangle {
                width: 1
                Layout.fillHeight: true
                color: themeVM.palette.divider
            }

            // 距上次认证
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "距上次认证"
                    font.pixelSize: 10
                    font.weight: Font.Normal
                    font.family: "Sarasa UI SC, WenQuanYi Rounded SC, sans-serif"
                    renderType: Text.NativeRendering
                    color: themeVM.palette.textTertiary
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: root.sinceAuthStr
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    font.family: "Sarasa Mono SC, Sarasa UI SC, WenQuanYi Rounded SC, monospace"
                    renderType: Text.NativeRendering
                    color: themeVM.palette.textSecondary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
