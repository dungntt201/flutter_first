import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:device_apps/device_apps.dart';
// import 'dart:convert';
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:external_app_launcher/external_app_launcher.dart';
// import 'package:android_intent_plus/flag.dart';

// import 'package:appcheck/appcheck.dart';
// import 'package:installed_apps/installed_apps.dart';
// import 'package:appcheck/appcheck.dart';
// import 'package:store_checker/store_checker.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  const WebViewPage(this.url, {super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  Uri addUriParameter(Uri uri, String key, String newValue) {
    var params = uri.queryParameters;
    var newUri = uri.replace(queryParameters: {});
    params.forEach((key, value) {
      newUri = newUri.replace(queryParameters: {key: value});
    });
    newUri.replace(queryParameters: {key: newValue});

    return newUri;
  }

  static const platform = MethodChannel('nguyenvana');

  Future<void> openBrowser(String url) async {
    try {
      print("ĐÃ VÀO ĐÂY RỒI");
      final int result = await platform.invokeMethod('abc', {'url': url});
      print("ĐÃ VÀO ĐÂY RỒI2");
    } on PlatformException catch (e) {
      // Unable to open the browser
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {},
          onNavigationRequest: (NavigationRequest request) async {
            print("Request: " + request.url);
            if (request.url.startsWith('intent://')) {
              // String requestUrl = request.url;
              // int startIndex =
              //     requestUrl.lastIndexOf('package=') + 'package='.length;
              // int lastIndex = requestUrl.lastIndexOf(';');
              // String packageApp = requestUrl.substring(startIndex, lastIndex);

              // bool isInstalled = await DeviceApps.isAppInstalled(packageApp);
              // if (isInstalled) {
              //   print('ĐÃ VÀO');

              //   openBrowser(request.url);

              //   // Uri uri = Uri.parse(request.url);
              //   // print('uri: $uri');

              //   // try {
              //   //   AndroidIntent intent = AndroidIntent(
              //   //     action: 'action_view',
              //   //     package: packageApp,
              //   //     data:
              //   //         "//view?data=000201010212262200069084050108VNPAY0015204123453037045405100005802VN5904VBAN6005HANOI626803082QXUI4J40519012305091357220328507082QXUI4J40817Thanh%20toan%20Qrcode63043CC2&callbackurl=https%3A%2F%2Fsandbox.vnpayment.vn%2Fpaymentv2%2Fqrback.html%3Ftoken%3Dcc165c8b5fc34965b841d1b277676537",
              //   //     arguments: uri.queryParameters,
              //   //   );
              //   //   await intent.launch();
              //   //   print(2);
              //   // } catch (e) {
              //   //   print(e);
              //   // }
              //   //
              //   // print(intent.arguments);

              //   // try {
              //   // Uri uri = Uri.parse(request.url);
              //   // print('URI: $uri');
              //   // print(uri.queryParametersAll);

              //   //   launchUrl(uri);
              //   // } catch (e) {
              //   //   print(e);
              //   // }
              //   // DeviceApps.openApp(packageApp);
              //   // // AndroidIntent intent;
              //   // // LaunchApp;
              //   // Map data = {"Amount": "1200", "Operation": "operation"};
              //   // AndroidIntent intent = AndroidIntent(
              //   //   action: 'action_view',
              //   //   data: data.toString(),
              //   //   arguments: uri.queryParameters,
              //   // );
              //   // print(intent.arguments);
              //   // await intent.launch();
              //   // intent.launch();
              // } else {
              //   String urlString = "market://details?id=$packageApp";
              //   Uri uri = Uri.parse(urlString);
              //   launchUrl(uri);
              // }
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: WebViewWidget(controller: _controller),
    ));
  }
}
