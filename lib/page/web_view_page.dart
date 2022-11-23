import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import 'package:flutter/material.dart';
import 'package:manual_lkds/navigation/fluro_router.dart';
import 'package:manual_lkds/widgets/drawer_navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);
  static const routeManual = '/manual';

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  String platform = '';

  @override
  void initState() {
    super.initState();
    kIsWeb
        ? platform = 'web'
        : Platform.isWindows
            ? platform = 'windows'
            : Platform.isIOS
                ? platform = 'ios'
                : platform = 'android';
  }

  _goHome() {
    _loadHtmlPage('http://lkds.ru/manual/');
  }

  _update() async {
    // var str = _controller.currentUrl().toString();
    // print(str);
    // _loadHtmlPage(str);
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Хотите закрыть приложение?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Да'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Нет'),
                  ),
                ],
              ));
      return Future.value(true);
    }
  }

  void _loadHtmlPage(String uri) async {
    setState(() {
      _controller.loadUrl(uri);
    });
  }

  /// Отображает webView на мобильных ОС и Web
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("LKDS Manual"),
          actions: [
            IconButton(onPressed: _goHome, icon: const Icon(Icons.home)),
            IconButton(onPressed: _update, icon: const Icon(Icons.update))
          ],
        ),
        drawer: const DrawerNavigation(),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: 'http://lkds.ru/manual/',
                onWebViewCreated: (WebViewController webViewController) {
                  _controllerCompleter.future
                      .then((value) => _controller = value);
                  _controllerCompleter.complete(webViewController);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
