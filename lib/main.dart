import 'package:flutter/material.dart';
import 'package:nez/themes/color.dart';
import './pages/index.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


InAppLocalhostServer localhostServer = new InAppLocalhostServer();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localhostServer.start();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dicom webviewer test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    InAppWebViewController webView;
    // WebViewController? _webViewController;

    return MaterialApp(
      theme: ThemeData(
        primaryColor: primary,
      ),
      home: IndexPage(),
    );
    
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }
}
