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

          experimental.overview: true
        //   experimental.userStyleSheets: [ (Theme.colorScheme == Theme.LightOnDark) ? Qt.resolvedUrl("./htmlViewer_Dark.css") : Qt.resolvedUrl("./htmlViewer_Light.css") ]
          // express.sid
          experimental.transparentBackground: true
          onLoadingChanged: {
              console.log(loadRequest.url.toString())
              if (loadRequest.status === WebView.LoadSucceededStatus){
                  webview.experimental.evaluateJavaScript(root.getUserInfoScript, function(rs){
                      if (rs && rs.name){
                          py.call('app.api.get_other_param', [rs.name, rs.avatar], function(ret){
                              if (ret){
                                  app.isLoggedIn = true;
                                  app.bduss = ret.bduss;
                                  app.uid = ret.uid;
                                  app.username = rs.name;
                                  app.avatarUrl = rs.avatar
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
var avatar = document.getElementById('user_dropdown').childNodes[1].src;
var res = {avatar: avatar, name: userName};
return res;
})()"

    Component.onCompleted: {
        var url = app.siteUrl + "/login"
        webview.url = url;
    }
}
