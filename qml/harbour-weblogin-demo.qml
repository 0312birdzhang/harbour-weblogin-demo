import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import io.thp.pyotherside 1.5
import Nemo.Notifications 1.0

ApplicationWindow
{
    id: app
    property bool isLoggedIn: false
    readonly property string siteDomain: "sailfishos.club"
    readonly property string siteUrl: "https://" + siteDomain
    property string username: ''
    property string bduss: ''
    property string uid: ''
    property string avatarUrl: ''

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Notification {
        id: notification

        function error(msg, timeout){
            previewSummary = qsTr("Error")
            previewBody = qsTr(msg)
            if (typeof timeout !== 'undefined'){
                expireTimeout = timeout
            }

            publish()
        }
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./python'))

            setHandler('log', function(msg){
                console.log(msg)
            })

            setHandler('error', function(msg){
                notification.error(qsTr(msg))
            })

            importModule('app', function(){
                py.call('app.api.get_logged_in_user', [], function(rs){
                    if (rs && rs.username){
                        app.isLoggedIn = true
                        app.username = rs.username
                        app.bduss = rs.bduss;
                        app.uid = rs.uid
                        app.avatarUrl = rs.avatarUrl
                    }
                })
            })
        }
    }
}
