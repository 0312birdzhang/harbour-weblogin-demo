import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: app.isLoggedIn?qsTr("Logout"):qsTr("Login")
                onClicked: {
                    if(!app.isLoggedIn){
                        console.log("to login page")
                        pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
                    }else{
                        console.log("logout")
                        app.isLoggedIn = false
                        app.username = ''
                        app.bduss = ''
                        app.uid = ''
                        app.avatarUrl = ''
                        py.call('app.api.do_logout')
                    }
                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: app.username || "Guest User"
            }

            Image{
                source: app.avatarUrl || "image://theme/harbour-weblogin-demo"
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width/4
                height: width
            }

            Label{
                text: "bduss: " + ( app.bduss || "")
                width: parent.width
                wrapMode: Text.WrapAnywhere
                font.pixelSize: Theme.fontSizeSmall
                anchors.margins: Theme.paddingMedium
            }

            Label{
                text: "uid: " + ( app.uid || "")
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                anchors.margins: Theme.paddingMedium
            }
        }
    }
}
