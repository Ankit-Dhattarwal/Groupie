import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groupie/services/auth_serivces.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/widgets/input_decoration.dart';

import '../../helper/helper_function.dart';
import '../home_pages.dart';
import '../register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 80),
          child: Form(
            key: formKey,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Groupie', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10,),
                  const Text('Login now to see what they are talking!', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                  Image.asset('assets/login_images/login.png'),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val){
                      setState(() {
                        email = val;
                       // print(email);
                      });
                    },
                    /// Check the validator
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    /// Check the validator
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Password must be at least 6 characters";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        password = val;
                      //  print(password);
                      });
                    },
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                        onPressed: (){
                      login();
                    }, child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16),)),
                  ),
                  const SizedBox(height: 10,),
                  Text.rich(TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(
                        color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Register here",
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const RegisterScreen());
                          }),
                    ],
                  )),
                ],
              )),
        ),
      ),
    );
  }

  login() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameAndPassword(email, password).then(
              (value) async{
            if(value == true){
              QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);

              // saving the value our shared preference
              await HelperFunctions.saveUserLoggedInStatus(true);
              await HelperFunctions.saveUserEmailSF(email);
              await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

              nextScreen(context, const HomeScreen());
            }else{
              showSnackbar(context, Colors.red, value);
              setState(() {
                _isLoading = false;
              });
            }
          });
    }
  }
}
