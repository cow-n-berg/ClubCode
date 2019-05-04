import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.clubcode 1.0
import "pages"

ApplicationWindow
{
    id: mainApp
    MainViewModel
    {
        id: main
    }
    property bool largeScreen: Screen.width > 1080
    property bool mediumScreen: (Screen.width > 720 && Screen.width <= 1080)
    property bool smallScreen: (Screen.width  >= 720 && Screen.width < 1080)
    property bool smallestScreen: Screen.width  < 720
    property int sizeRatio: smallestScreen ? 1 : smallScreen ? 1.5 : 2

    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted
    _defaultPageOrientations: Orientation.Portrait | Orientation.Landscape
    | Orientation.LandscapeInverted

    initialPage: Component { HomePage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}
