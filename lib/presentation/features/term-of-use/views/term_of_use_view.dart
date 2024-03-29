import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermOfUseView extends StatelessWidget {
  TermOfUseView({super.key});

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {

        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse("https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: context.paddingNormal,
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
