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
          experimental.userStyleSheets: [ (Theme.colorScheme == Theme.LightOnDark) ? Qt.resolvedUrl("./htmlViewer_Dark.css") : Qt.resolvedUrl("./htmlViewer_Light.css") ]

          experimental.transparentBackground: true
          onLoadingChanged: {
              if (loadRequest.status === WebView.LoadSucceededStatus){
                  console.log(loadRequest.url.toString())
                  if (loadRequest.url.toString().indexOf('m.baidu.com/?uid') > 0){
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
                          }else{
                              notification.error("Login failed")
                              pageStack.pop();
                          }
                      })
                  }
              }
          }
      }

    property string getUserInfoScript: "(function(){
var userName = document.getElementsByClassName('login')[0].innerText;
var avatar = document.getElementsByClassName('head-icon')[0].src;
var res = {avatar: avatar, name: userName};
return res;
})()"

    Component.onCompleted: {
        var date = new Date();
        var uid = date.getTime() + "_" + date.getSeconds()
        var url = "https://wappass.baidu.com/passport/?clientfrom=&adapter=0&ssid=&from=&authsite=&bd_page_type=&uid=" +
                uid+
                "&pu=&tpl=wimn&u=https://m.baidu.com/%3Fuid%3D" +
                uid +
                "%26traceid%3D296B8703&type=&bdcm=&tn=&regist_mode=&login_share_strategy="+
                "&subpro=&skin=default_v2&client=&connect=0&smsLoginLink=1&loginLink=&bindToSmsLogin=&overseas=&is_voice_sms=&subpro=&traceid=&hideSLogin=&forcesetpwd=&nousername=&regdomestic=&extrajson=%7B%22src%22:%22se_000000%22%7D"
        webview.url = url;
    }
}
