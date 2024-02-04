import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupie/firebase_options.dart';
import 'package:groupie/pages/auth/login_pages.dart';
import 'package:groupie/pages/home_pages.dart';
import 'package:groupie/shared/constant.dart';


import 'helper/helper_function.dart';
Future<void> main()  async{
  /// Widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();


  // Todo : Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

 @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async{
await HelperFunctions.getUserLoggedInStatus().then((value) => {
  if(value != null){
    setState((){
  _isSignedIn = value;
    }),
  }
});
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}

/*

 */