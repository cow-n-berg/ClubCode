import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.clubcode.Settings 1.0
import harbour.clubcode 1.0

Page {
    id: page

    property variant current
    property int orientationSetting: (Orientation.Portrait | Orientation.Landscape
                                      | Orientation.LandscapeInverted)
    allowedOrientations: orientationSetting

    MySettings {
        id: myset
    }

    QrCodeGenerator {
        id: generator

        text: current.code
    }

    Component.onCompleted: {
        // This binds the setting for allowed orientations to the property which is used on all sub-pages
        orientationSetting = Qt.binding(function () {
            switch (myset.value("orientation")) {
            case "portrait":
                return Orientation.Portrait
            case "landscape":
                return Orientation.Landscape
            case "dynamic":
                return (Orientation.Portrait | Orientation.Landscape
                        | Orientation.LandscapeInverted)
            default:
                return Orientation.Portrait
            }
        })
    }

    function resize_barcode() {
        if (qrcodeImage.scale === 1) {
            qrcodeImage.scale = 0.5
        } else {
            qrcodeImage.scale = 1
        }
    }

    Rectangle {
        color: "white"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        id: background

        MouseArea {
            anchors.fill: parent
            onClicked: {
                resize_barcode()
            }
        }

        Column {
            anchors.centerIn: parent

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: current.description !== "" ? "←  " + current.name + " ("
                                                   + current.description + ")" : current.name
                color: "black"
                font.bold: true
            }

            Image {
                id: qrcodeImage
                asynchronous: true
                source: generator.qrcode ? "image://qrcode/" + generator.qrcode : ""
                readonly property int maxDisplaySize: Math.min(
                                                          Screen.width,
                                                          Screen.height) - 4
                                                      * Theme.horizontalPageMargin
                readonly property int maxSourceSize: Math.max(sourceSize.width,
                                                              sourceSize.height)
                readonly property int n: Math.floor(
                                             maxDisplaySize / maxSourceSize)
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                width: sourceSize.width * n
                height: sourceSize.height * n
                smooth: false
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                font.family: 'monospace'
                text: current.code
                color: "black"
                wrapMode: Text.WrapAnywhere
                width: page.width
            }
        }
    }
}
