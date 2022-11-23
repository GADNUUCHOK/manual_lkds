import 'package:flutter/material.dart';
import 'package:manual_lkds/navigation/fluro_router.dart';
import 'web_view_settings/register_web_webview_stub.dart'
if (dart.library.html) 'web_view_settings/register_web_webview.dart';
import 'app.dart';

void main() {
  FluroRouterNavigation.setupRouter();
  registerWebViewWebImplementation();
  runApp(const MyApp());
}
