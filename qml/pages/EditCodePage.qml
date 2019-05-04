import QtQuick 2.0
import Sailfish.Silica 1.0

import ".."
import harbour.clubcode 1.0

Dialog
{
    property alias current : context.current

    onAccepted:
    {
        context.save();
        main.save();
    }

    EditCodePageViewModel
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
        }

        EditCodeTemplate
        {
            id: code_templ
            context: context.clone
            anchors.top: header.bottom
        }
    }
}
