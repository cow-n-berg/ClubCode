import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            Label {
                text: "ClubCode"
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image
            {
                source: Qt.resolvedUrl("../../cover.png")
                anchors.horizontalCenter: parent.horizontalCenter
                scale: mainApp.sizeRatio
                layer.effect: ShaderEffect {
                    property color color: Theme.primaryColor

                    fragmentShader: "
                    varying mediump vec2 qt_TexCoord0;
                    uniform highp float qt_Opacity;
                    uniform lowp sampler2D source;
                    uniform highp vec4 color;
                    void main() {
                        highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                        gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                    }
                    "
                }
                layer.enabled: true
                layer.samplerName: "source"
            }
            Label {
                text: qsTr("Generate barcodes by entering a code.<p> \
                <b>Supports:</b> Code 128, Code 39, Code 93, UPC-A, UPC-E, EAN-8 and EAN-13.")
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                horizontalAlignment: Text.Center
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
            }
            SectionHeader {
                text: qsTr("Author")
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
            }
            Label {
                text: "© 2015 B2qa/2019 Arno Dekker"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
