import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fazart_admin1/shared/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: MyRouter.generateRoute,
    );
  }
}
