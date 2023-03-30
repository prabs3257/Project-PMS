import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_pms/authentication/register.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/background_painter.dart';
import 'package:project_pms/save_config.dart';


ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);
AnimationController _controller;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{



  bool _rememberMe = false;
  String email;
  String password;



  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              home: Scaffold(
                backgroundColor: Colors.white,
                body: SignIn(),
              ),
            );
          },
        );
      },
    );



  }
}
