import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0

Page {
    id: root

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaWebView {
          id: webview
          anchors.fill: parent
        property bool _isScrolledToEnd: (webview.contentY + webview.height + 2) >= webview.contentHeight
        property bool _isScrolledToBeginning: webview.contentY <= 2
        property bool _isFinishedPanning: webview.atXBeginning && webview.atXEnd && !webview.moving
        property string userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
        experimental.userAgent: userAgent
        experimental.overview: true
        experimental.deviceWidth: webview.width
        experimental.deviceHeight: webview.height
        experimental.transparentBackground: true
        experimental.customLayoutWidth: {
            return root.width * 0.6
        }
        experimental.overview: true
        //   experimental.userStyleSheets: [ (Theme.colorScheme == Theme.LightOnDark) ? Qt.resolvedUrl("./htmlViewer_Dark.css") : Qt.resolvedUrl("./htmlViewer_Light.css") ]
          experimental.transparentBackground: true
          onLoadingChanged: {
              console.log(loadRequest.url.toString())
              if (loadRequest.status === WebView.LoadSucceededStatus){
                  webview.experimental.evaluateJavaScript(root.getUserInfoScript, function(rs){
                      if (rs && rs.name){
                          py.call('app.api.get_other_param', [rs.name], function(ret){
                              if (ret){
                                  app.isLoggedIn = true;
                                  app.bduss = ret.bduss;
                                  app.uid = ret.uid;
                                  app.username = rs.name;
                                  app.avatarUrl = ret.avatar
                                  pageStack.pop()
                              }
                          })
                      }
                  })
              }
          }
      }

    property string getUserInfoScript: "(function(){
var userName = document.getElementById('user-header-name').innerText;
var res = {name: userName};
return res;
})()"

    Component.onCompleted: {
        var url = app.siteUrl + "/login"
        webview.url = url;
    }
}
