import QtQuick 2.15

/**
 * Lucide 风格图标组件
 *
 * 使用内联 SVG 渲染，支持任意颜色和尺寸
 *
 * required property:
 * - name: 图标名称
 *
 * optional property:
 * - color: 图标颜色
 * - size: 图标尺寸（默认 20）
 */
Item {
    id: root
    required property string name
    property color color: "#000000"
    property int size: 20

    width: size
    height: size

    Image {
        anchors.fill: parent
        source: getSvgSource(root.name, root.color, root.size)
        sourceSize.width: root.size
        sourceSize.height: root.size
        smooth: true
        antialiasing: true
        cache: true
    }

    function getSvgSource(iconName, iconColor, iconSize) {
        var paths = {
            "x": "<path d='M18 6 6 18'/><path d='m6 6 12 12'/>",
            "moon": "<path d='M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z'/>",
            "sun": "<circle cx='12' cy='12' r='4'/><path d='M12 2v2'/><path d='M12 20v2'/><path d='m4.93 4.93 1.41 1.41'/><path d='m17.66 17.66 1.41 1.41'/><path d='M2 12h2'/><path d='M20 12h2'/><path d='m6.34 17.66-1.41 1.41'/><path d='m19.07 4.93-1.41 1.41'/>",
            "monitor": "<rect width='20' height='14' x='2' y='3' rx='2'/><line x1='8' x2='16' y1='21' y2='21'/><line x1='12' x2='12' y1='17' y2='21'/>",
            "shield-check": "<path d='M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'/><path d='m9 12 2 2 4-4'/>",
            "mouse-pointer-click": "<path d='M14 4.1 12 6'/><path d='m5.1 8-2.9-.8'/><path d='m6 12-1.9 2'/><path d='M7.2 2.2 8 5.1'/><path d='M9.037 9.69a.498.498 0 0 1 .653-.653l11 4.5a.5.5 0 0 1-.074.949l-4.349 1.041a1 1 0 0 0-.74.739l-1.04 4.35a.5.5 0 0 1-.95.074z'/>",
            "power": "<path d='M12 2v4'/><path d='m5 5 2.8 2.8'/><path d='m19 5-2.8 2.8'/><path d='M6.5 11.5a7 7 0 1 0 11 0'/>",
            "bell": "<path d='M10.268 21a2 2 0 0 0 3.464 0'/><path d='M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326'/>",
            "clock": "<circle cx='12' cy='12' r='10'/><polyline points='12 6 12 12 16 14'/>",
            "user": "<path d='M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2'/><circle cx='12' cy='7' r='4'/>",
            "lock": "<rect width='18' height='11' x='3' y='11' rx='2' ry='2'/><path d='M7 11V7a5 5 0 0 1 10 0v4'/>",
            "wifi": "<path d='M12 20h.01'/><path d='M2 8.82a15 15 0 0 1 20 0'/><path d='M5 12.859a10 10 0 0 1 14 0'/><path d='M8.5 16.429a5 5 0 0 1 7 0'/>",
            "gauge": "<path d='m12 14 4-4'/><path d='M3.34 19a10 10 0 1 1 17.32 0'/>",
            "minus": "<path d='M5 12h14'/>",
            "plus": "<path d='M5 12h14'/><path d='M12 5v14'/>",
            "check": "<path d='M20 6 9 17l-5-5'/>",
            "settings": "<path d='M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z'/><circle cx='12' cy='12' r='3'/>",
            "sparkles": "<path d='m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3z'/><path d='M5 3v4'/><path d='M19 17v4'/><path d='M3 5h4'/><path d='M17 19h4'/>"
        };

        var p = paths[iconName] || "";
        var svg = "<svg xmlns='http://www.w3.org/2000/svg' width='" + iconSize + "' height='" + iconSize + "' viewBox='0 0 24 24' fill='none' stroke='" + iconColor + "' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'>" + p + "</svg>";
        return "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svg);
    }
}
