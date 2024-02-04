import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groupie/helper/helper_function.dart';
import 'package:groupie/pages/auth/login_pages.dart';
import 'package:groupie/pages/home_pages.dart';
import 'package:groupie/services/auth_serivces.dart';

import '../../widgets/input_decoration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';

  AuthService authService =AuthService();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _isLoading
          ?  Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),)
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
                  const Text('Create your account now to chat and explore', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                  Image.asset('assets/login_images/register.png'),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Full Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val){
                      setState(() {
                        fullName = val;
                        // print(email);
                      });
                    },
                    /// Check the validator
                    validator: (val) {
                      if(val!.isNotEmpty){
                        return null;
                      }else{
                        return 'Name already taken';
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
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
                          register();
                        }, child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 16),)),
                  ),
                  const SizedBox(height: 10,),
                  Text.rich(TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(
                        color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Login here",
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const LoginScreen());
                            }),
                    ],
                  )),
                ],
              )),
        ),
      ),
    );
  }

  register() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password).then(
              (value) async{
                if(value == true){
                  /// Saving the shared preference state
                  await HelperFunctions.saveUserLoggedInStatus(true);
                  await HelperFunctions.saveUserEmailSF(email);
                  await HelperFunctions.saveUserNameSF(fullName);
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
