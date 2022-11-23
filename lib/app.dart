import 'package:flutter/material.dart';
import 'package:manual_lkds/navigation/fluro_router.dart';
import 'package:manual_lkds/page/web_view_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      onGenerateRoute: FluroRouterNavigation.router.generator,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        /// Отображает webView на мобильных ОС и Web
      home: const WebViewPage()
    );
  }
}