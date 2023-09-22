
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'address/todos_object_box.dart';
import 'app.dart';

late TodosObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // AppScreenPrivacyService().enableScreenPrivacy();
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  objectBox = await TodosObjectBox.create();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollbarTheme = ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(true),
    );

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      title: 'InvoiceCraft',
      home: const MyApp(),
    );
  }
}
