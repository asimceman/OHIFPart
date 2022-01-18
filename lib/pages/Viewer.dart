import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Viewer extends StatefulWidget {
  final String? studyInstanceUID;
  //const Viewer({ Key? key, this.studyInstanceUID }) : super(key: key);
  const Viewer(this.studyInstanceUID);
  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {

  @override
  Widget build(BuildContext context) {
    InAppWebViewController webView;
    return Scaffold(
      appBar: AppBar(title: Text("Embedding")),
      body: InAppWebView(
        initialUrlRequest: new URLRequest(url: Uri.parse("http://localhost:8080/assets/website/index.html")) ,

        onWebViewCreated: (controller) {
          print("Study: " + widget.studyInstanceUID.toString());
                      controller.addJavaScriptHandler(handlerName: 'getStudyID', callback: (args) {
                        // return data to the JavaScript side!
                        return widget.studyInstanceUID;
                      });

                      controller.addJavaScriptHandler(handlerName: 'handlerFooWithArgs', callback: (args) {
                        print(args);
                        // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                      // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                    },
),

    );
  }
}