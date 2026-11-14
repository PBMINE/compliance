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

        property color surfaceColor: Qt.alpha(Theme.Matugen.md3.surface, 0.85)
        property color foregroundColor: Theme.Matugen.md3.on_surface
        property color primaryColor: Theme.Matugen.md3.primary

        property string fontFamily: "Iosevka Nerd Font"
        property int fontSize: 14

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

        Rectangle {
                id: panel

                anchors.fill: parent

                color: root.surfaceColor
                radius: 15

                RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8

                        Repeater {
                                model: niri.workspaces

                                Rectangle {
                                        id: workspacesbutton
                                        property bool isActive: model.isActive

                                        color: isActive ? root.primaryColor : "transparent"

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: height

                                        radius: panel.radius * (height / panel.height)

                                        Text {
                                                text: niri.workspaces.indexOfId(model.id) + 1
                                                color: isActive ? "#000000" : root.foregroundColor
                                                anchors.centerIn: parent

                                                font {
                                                        family: root.fontFamily
                                                        pixelSize: root.fontSize
                                                        bold: true
                                                }
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

                        Item {
                                id: batteryIcon

                                visible: UPower.displayDevice.ready && UPower.displayDevice.isPresent

                                Layout.preferredWidth: 33
                                Layout.preferredHeight: 16
                                Layout.rightMargin: 10

                                readonly property real batteryPercentage: UPower.displayDevice.percentage * 100

                                readonly property bool isCharging: UPower.displayDevice.state === UPowerDeviceState.Charging

                                Rectangle {
                                        id: batteryIndicator

                                        width: 28
                                        height: 16

                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter

                                        radius: panel.radius * (height / panel.height)
                                        color: Qt.alpha("#ffffff", 0.50)
                                        clip: true

                                        Rectangle {
                                                id: batteryFill

                                                width: batteryIndicator.width * batteryIcon.batteryPercentage / 100
                                                height: parent.height
                                                radius: batteryIndicator.radius

                                                color: Qt.alpha(batteryIcon.isCharging ? "#7CFC00" : batteryIcon.batteryPercentage <= 20 ? "#ff4444" : "#ffffff", 0.85)
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
                                                anchors.fill: parent

                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter

                                                text: Math.round(batteryIcon.batteryPercentage)
                                                color: "#000000"

                                                font {
                                                        family: root.fontFamily
                                                        pixelSize: root.fontSize - 2
                                                        bold: true
                                                }
                                        }
                                }

                                Rectangle {
                                        id: batteryTerminal

                                        width: 2
                                        height: 8

                                        anchors.left: batteryIndicator.right
                                        anchors.leftMargin: 2
                                        anchors.verticalCenter: batteryIndicator.verticalCenter

                                        radius: panel.radius * (height / panel.height)
                                        color: batteryIndicator.color
                                }
                        }

                        Text {
                                id: clock

                                text: Qt.formatDateTime(new Date(), "MMM dd | HH:mm")
                                color: root.foregroundColor

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

                                        onTriggered: {
                                                clock.text = Qt.formatDateTime(new Date(), "MMM dd | HH:mm");
                                        }
                                }
                        }
                }
        }
}
