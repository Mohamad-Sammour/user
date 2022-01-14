import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_baleh_user/provider/user_provider.dart';
import 'package:on_baleh_user/screens/homepage.dart';
import 'package:on_baleh_user/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.purple),
        home: const ScreensController(),
      )));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

class ScreensController extends StatelessWidget {
  const ScreensController({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.Uninitialized:
        return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
          backgroundColor: Colors.purple,
        )));
      case Status.Unauthenticated:
      case Status.Authenticating:
        return const Login();
      case Status.Authenticated:
        return const HomePage();
      default:
        return const Login();
    }
  }
}
