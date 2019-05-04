import QtQuick 2.0
import Sailfish.Silica 1.0

import harbour.clubcode 1.0
import ".."

Dialog
{
    onAccepted: main.createCode(context.current)

    AddNewCodePageViewModel
    {
        id: context
    }

    SilicaFlickable
    {
        VerticalScrollDecorator {
        }
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: header.height + code_templ.height

        DialogHeader
        {
            id: header
            acceptText: qsTr("Create code")
        }

        EditCodeTemplate
        {
            id: code_templ
            context: context.current
            anchors.top: header.bottom
        }
    }
}
