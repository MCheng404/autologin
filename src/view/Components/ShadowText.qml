import QtQuick 2.15

/**
 * ShadowText — 带主题色阴影的文字
 *
 * 属性：
 *   text, font.pixelSize, font.weight 等标准 Text 属性直接透传
 *   shadowOffset — 阴影偏移（默认 1px）
 *   shadowOpacity — 阴影透明度（默认 0.25）
 */
Text {
    id: root

    property int shadowOffset: 1
    property real shadowOpacity: 0.25

    // ── 阴影层（偏移 + 主题色）──
    Text {
        anchors.fill: parent
        anchors.leftMargin: root.shadowOffset
        anchors.topMargin: root.shadowOffset
        text: root.text
        font: root.font
        elide: root.elide
        wrapMode: root.wrapMode
        horizontalAlignment: root.horizontalAlignment
        verticalAlignment: root.verticalAlignment
        renderType: root.renderType
        color: themeVM.palette.primary
        opacity: shadowOpacity
        z: -1
    }
}
