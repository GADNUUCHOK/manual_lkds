import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:manual_lkds/page/library_page.dart';
import 'package:manual_lkds/page/web_view_page.dart';

class FluroRouterNavigation {
  static final router = FluroRouter();

  static final Handler _libraryHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const LibraryPage();
  });

  static final Handler _webViewHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const WebViewPage();
  });

  static void setupRouter() {
    router.define(WebViewPage.routeManual, handler: _webViewHandler);
    router.define(LibraryPage.routeLibrary, handler: _libraryHandler);
  }
}