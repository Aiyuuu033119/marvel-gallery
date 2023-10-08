// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

class WebViewer extends StatefulWidget {
  final bool darkMode;
  final String url;
  final String codeName;

  const WebViewer({
    Key key,
    this.darkMode,
    this.url,
    this.codeName,
  }) : super(key: key);

  @override
  _WebViewerState createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  List<Color> bodyLight = [Color(0xff850D00), Color(0xffB81300), Color(0xffB81300), Color(0xff850D00)];
  List<Color> bodyDark = [Color(0xff2F2F2F), Color(0xff484848), Color(0xff484848), Color(0xff2F2F2F)];

  bool onload = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        elevation: 0,
        backgroundColor: !widget.darkMode ? Color(0xff850D00) : Color(0xff2F2F2F),
        title: Text(
          widget.codeName.toUpperCase(),
          style: TextStyle(
            fontFamily: 'avenir',
            fontSize: 20,
            color: Color(0xffFFFFFF),
            fontWeight: FontWeight.w500,
          ),
        ),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(_controller.future),
          // SampleMenu(_controller.future),
        ],
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Stack(
            children: <Widget>[
              WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                // ignore: prefer_collection_literals
                javascriptChannels: <JavascriptChannel>[
                  _toasterJavascriptChannel(context),
                ].toSet(),
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith(widget.url)) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');

                  Timer(Duration(seconds: 2), () {
                    setState(() {
                      onload = false;
                    });
                  });
                },
              ),
              if (onload)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: !widget.darkMode ? bodyLight : bodyDark,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.2, 0.8, 1.8]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width / 2.5,
                          child: Image.asset('assets/marvel-logo.png'),
                        ),
                        SizedBox(
                          height: 65.0,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      // floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  // Widget favoriteButton() {
  //   return FutureBuilder<WebViewController>(
  //       future: _controller.future,
  //       builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
  //         if (controller.hasData) {
  //           return FloatingActionButton(
  //             onPressed: () async {
  //               final String url = await controller.data.currentUrl();
  //               Scaffold.of(context).showSnackBar(
  //                 SnackBar(content: Text('Favorited $url')),
  //               );
  //             },
  //             child: const Icon(Icons.favorite),
  //           );
  //         }
  //         return Container();
  //       });
  // }
}

// enum MenuOptions {
//   showUserAgent,
//   listCookies,
//   clearCookies,
//   addToCache,
//   listCache,
//   clearCache,
//   navigationDelegate,
// }

// class SampleMenu extends StatelessWidget {
//   SampleMenu(this.controller);

//   final Future<WebViewController> controller;
//   final CookieManager cookieManager = CookieManager();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: controller,
//       builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
//         return PopupMenuButton<MenuOptions>(
//           onSelected: (MenuOptions value) {
//             switch (value) {
//               case MenuOptions.showUserAgent:
//                 _onShowUserAgent(controller.data, context);
//                 break;
//               case MenuOptions.listCookies:
//                 _onListCookies(controller.data, context);
//                 break;
//               case MenuOptions.clearCookies:
//                 _onClearCookies(context);
//                 break;
//               case MenuOptions.addToCache:
//                 _onAddToCache(controller.data, context);
//                 break;
//               case MenuOptions.listCache:
//                 _onListCache(controller.data, context);
//                 break;
//               case MenuOptions.clearCache:
//                 _onClearCache(controller.data, context);
//                 break;
//               case MenuOptions.navigationDelegate:
//                 _onNavigationDelegateExample(controller.data, context);
//                 break;
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//             PopupMenuItem<MenuOptions>(
//               value: MenuOptions.showUserAgent,
//               child: const Text('Show user agent'),
//               enabled: controller.hasData,
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.listCookies,
//               child: Text('List cookies'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCookies,
//               child: Text('Clear cookies'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.addToCache,
//               child: Text('Add to cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.listCache,
//               child: Text('List cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCache,
//               child: Text('Clear cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.navigationDelegate,
//               child: Text('Navigation Delegate example'),
//             ),
//           ],
//         );
//       },
//     );
//   }

// void _onShowUserAgent(WebViewController controller, BuildContext context) async {
//   // Send a message with the user agent string to the Toaster JavaScript channel we registered
//   // with the WebView.
//   controller.evaluateJavascript('Toaster.postMessage("User Agent: " + navigator.userAgent);');
// }

// void _onListCookies(WebViewController controller, BuildContext context) async {
//   final String cookies = await controller.evaluateJavascript('document.cookie');
//   Scaffold.of(context).showSnackBar(SnackBar(
//     content: Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         const Text('Cookies:'),
//         _getCookieList(cookies),
//       ],
//     ),
//   ));
// }

// void _onAddToCache(WebViewController controller, BuildContext context) async {
//   await controller.evaluateJavascript('caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
//   Scaffold.of(context).showSnackBar(const SnackBar(
//     content: Text('Added a test entry to cache.'),
//   ));
// }

// void _onListCache(WebViewController controller, BuildContext context) async {
//   await controller.evaluateJavascript('caches.keys()'
//       '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
//       '.then((caches) => Toaster.postMessage(caches))');
// }

// void _onClearCache(WebViewController controller, BuildContext context) async {
//   await controller.clearCache();
//   Scaffold.of(context).showSnackBar(const SnackBar(
//     content: Text("Cache cleared."),
//   ));
// }

// void _onClearCookies(BuildContext context) async {
//   final bool hadCookies = await cookieManager.clearCookies();
//   String message = 'There were cookies. Now, they are gone!';
//   if (!hadCookies) {
//     message = 'There are no cookies.';
//   }
//   Scaffold.of(context).showSnackBar(SnackBar(
//     content: Text(message),
//   ));
// }

// void _onNavigationDelegateExample(WebViewController controller, BuildContext context) async {
//   final String contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
//   controller.loadUrl('data:text/html;base64,$contentBase64');
// }

//   Widget _getCookieList(String cookies) {
//     if (cookies == null || cookies == '""') {
//       return Container();
//     }
//     final List<String> cookieList = cookies.split(';');
//     final Iterable<Text> cookieWidgets = cookieList.map((String cookie) => Text(cookie));
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: cookieWidgets.toList(),
//     );
//   }
// }

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture) : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No back history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
              ),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        controller.goForward();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No forward history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(
                Icons.replay,
              ),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
