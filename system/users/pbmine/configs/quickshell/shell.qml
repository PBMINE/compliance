import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Niri
import qs.Theme as Theme
import Quickshell.Services.UPower

PanelWindow {
        id: root
        color: "transparent"
        margins {
                right: 10
                bottom: 10
                left: 10
        }

        anchors {
                bottom: true
        }

        BackgroundEffect.blurRegion: Region {
                item: panel
                radius: panel.radius
        }

        implicitWidth: 800

        implicitHeight: 47

        // Font and color
        property color colBg: Qt.alpha(Theme.Matugen.md3.background, 0.85)

        property color colWhite: Theme.Matugen.md3.on_surface
        property color colMuted: Qt.alpha(Theme.Matugen.md3.outline_variant, 0.85)
        property color colBlue: Theme.Matugen.md3.primary

        property string fontFamily: "Iosevka Nerd Font"

        property int fontSize: 14

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

        Timer {
                interval: 2000
                running: true
                repeat: true
                onTriggered: {
                        cpuProc.running = true;
                }
        }

        Rectangle {
                id: panel
                anchors.fill: parent
                color: root.colBg
                border.color: root.colMuted
                border.width: 2
                radius: 20
                RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8

                        Repeater {
                                model: niri.workspaces
                                Rectangle {
                                        property bool isActive: model.isFocused
                                        color: isActive ? root.colBlue : "transparent"
                                        Layout.fillHeight: true
                                        Layout.preferredWidth: height
                                        radius: panel.radius * (height / panel.height)
                                        Text {
                                                text: niri.workspaces.indexOfId(model.id) + 1
                                                color: isActive ? root.colBg : root.colWhite
                                                anchors.centerIn: parent
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
                        }

                        Item {
                                Layout.fillWidth: true
                        }

                        Rectangle {
                                id: batteryIcon

                                visible: UPower.displayDevice.ready && UPower.displayDevice.isPresent

                                width: 32
                                height: 16
                                Layout.rightMargin: 10
                                radius: panel.radius * (height / panel.height)
                                color: Qt.alpha("#555555", 0.75)
                                clip: true

                                readonly property real batteryPercentage: UPower.displayDevice.percentage * 100

                                readonly property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging

                                Rectangle {
                                        id: batteryFill

                                        width: batteryIcon.width * batteryIcon.batteryPercentage / 100
                                        height: parent.height
                                        radius: panel.radius * (height / panel.height)

                                        color: batteryIcon.charging ? "#7CFC00" : batteryIcon.batteryPercentage <= 20 ? "#ff4444" : "#ffffff"

                                        Behavior on width {
                                                NumberAnimation {
                                                        duration: 200
                                                }
                                        }

                                        Behavior on color {
                                                ColorAnimation {
                                                        duration: 150
                                                }
                                        }
                                }

                                Text {
                                        anchors.centerIn: parent

                                        text: Math.round(batteryIcon.batteryPercentage)
                                        color: "#000000"

                                        font {
                                                family: root.fontFamily
                                                pixelSize: root.fontSize - 2
                                                bold: true
                                        }
                                }
                        }

                        Text {
                                id: clock
                                text: Qt.formatDateTime(new Date(), "MMM dd | HH:mm")
                                color: root.colWhite
                                Layout.rightMargin: 10
                                Layout.leftMargin: 10
                                font {
                                        family: root.fontFamily
                                        pixelSize: root.fontSize
                                        bold: true
                                }

                                Timer {
                                        interval: 1000
                                        running: true
                                        repeat: true
                                        onTriggered: clock.text = Qt.formatDateTime(new Date(), "MMM dd | HH:mm")
                                }
                        }
                }
        }
}
