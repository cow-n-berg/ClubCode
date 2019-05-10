import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.clubcode.Settings 1.0

Page {
    property variant current
    property real fullsize: 260 * mainApp.sizeRatio
    property int orientationSetting: (Orientation.Portrait | Orientation.Landscape
                                      | Orientation.LandscapeInverted)
    allowedOrientations: orientationSetting

    id: page

    MySettings {
        id: myset
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
        if (barlabel.font.pixelSize === (260 * mainApp.sizeRatio)) {
            barlabel.font.pixelSize = barlabel.font.pixelSize / 2
        } else if (barlabel.font.pixelSize === (130 * mainApp.sizeRatio)) {
            barlabel.font.pixelSize = barlabel.font.pixelSize / 2
        } else if (barlabel.font.pixelSize === (65 * mainApp.sizeRatio)) {
            barlabel.font.pixelSize = barlabel.font.pixelSize / 1.5
        } else {
            barlabel.font.pixelSize = fullsize
        }
    }

    function getFontName() {
        if (current.barcodeType === "0") {
            return "Code 128"
        }
        if (current.barcodeType === "1") {
            return "Code EAN13"
        }
        if (current.barcodeType === "2") {
            return "Code EAN13"
        }
        if (current.barcodeType === "3") {
            return "Bar-Code 39"
        }
        if (current.barcodeType === "4") {
            return "Code-93"
        }
        if (current.barcodeType === "5") {
            return "UPC-E Short"
        }
        if (current.barcodeType === "6") {
            return "UPC-A"
        }
        if (current.barcodeType === "8") {
            return "KIX Barcode"
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
            Label {
                id: barlabel
                color: "black"
                font.family: getFontName()
                fontSizeMode: Text.Fit
                font.pixelSize: 260 * mainApp.sizeRatio
                width: background.width - 100
                height: background.height - (Theme.paddingLarge + 100)
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                text: current.generateCode(current.code, current.barcodeType)
                font.letterSpacing: 0
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: 'monospace'
                text: current.code
                color: "black"
                visible: current.barcodeType === "0"
                         || current.barcodeType === "3"
                         || current.barcodeType === "4"
                         || current.barcodeType === "8"
            }
        }
    }
}
