import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Niri

PanelWindow {
    id: root
    visible: !niri.overview.isOpen

    margins {
        right: 10
        bottom: 10
        left: 10
    }
    // Font and color
    property color colBg: "#1a1b26"
    property color colCyan: "#0db9d7"
    property color colMuted: "#444b6a"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"
    property string fontFamily: "Iosevka Nerd Font"
    property int fontSize: 12

    // System
    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    property int batteryPercentage: 0

    Item {
        Niri {
            id: niri
            Component.onCompleted: connect()
            onConnected: {
                console.log("Niri IPC Loaded!");
                niri.workspaces.maxCount = 9;
            }
            onErrorOccurred: function (error) {
                console.error("Connection error:", error);
            }
        }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: data => {
                var part = data.trim().split(/\s+/);
                var idle = parseInt(part[4]) + parseInt(part[5]);
                var total = part.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                if (lastCpuTotal > 0) {
                    cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));
                }
                lastCpuIdle = idle;
                lastCpuTotal = total;
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: batteryTrack
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity"]
        stdout: SplitParser {
            onRead: data => {
                var battery = data.trim();
                batteryPercentage = battery;
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            batteryTrack.running = true;
        }
    }

    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: root.colBg
        border.color: root.colMuted
        border.width: 2
        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            Repeater {
                model: niri.workspaces

                Text {
                    property bool isActive: model.isFocused

                    text: model.index
                    color: isActive ? "#0bd9d7" : "#7aa2f7"
                    font {
                        family: root.fontFamily
                        pixelSize: root.fontSize
                        bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: niri.focusWorkspaceById(model.id)
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                text: "Battery " + batteryPercentage + "%"
                color: root.colBlue
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }
            }

            Rectangle {
                width: 1
                height: 16
                color: root.colMuted
            }

            Text {
                text: "CPU " + cpuUsage + "%"
                color: root.colYellow
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }
            }

            Rectangle {
                width: 1
                height: 16
                color: root.colMuted
            }

            Text {
                id: clock
                text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                color: root.colCyan
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                }
            }

            Rectangle {
                width: 1
                height: 16
                color: root.colMuted
            }
        }
    }
}
