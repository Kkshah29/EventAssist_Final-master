
// ignore_for_file: unused_import

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testing/UI/events/add_events.dart';
import 'package:testing/common/theme_helper.dart';
import 'package:testing/utils/utils.dart';
import 'events/show_events.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';



class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  String? email_add;
  String? pass;


  FirebaseAuth _auth = FirebaseAuth.instance;

 void login()
 {
       _auth.signInWithEmailAndPassword(email: email_add.toString(), password: pass.toString()).then((value){
        }).then((value) {
         if((email_add=="aryan.dalvi@somaiya.edu" && pass=="12345678") || (email_add=="swadit@somaiya.edu" && pass=="qwertyuioo") || (email_add=="kunal29@somaiya.edu" && pass=="qwertyuioi"))
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
          }
         else
           {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ShowEvents()));
           }
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Login Successfully"))));
       }).onError((error, stackTrace) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
             backgroundColor: Colors.black,
             content: Center(
               child: Text("Invalid Credentials",style: TextStyle(
                   color: Colors.red,
                   fontSize: 20
               ),
               ),
             )
         )
         );
       });

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
              ),
              SafeArea(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                    child: Column(
                      children: [
                        const Text(
                          'Event Assist',
                          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Sign in into your account',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30.0),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                    decoration: ThemeHelper().textInputDecoration('Email', 'Enter your Email'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(r'^[a-zA-Z0-9_.+-]+@somaiya\.edu$').hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      email_add = value!;
                                      print(email_add);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter valid Password';
                                        }
                                        if (value.length<8) {
                                          return "Password should be minimum of 8 characters";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        pass = value!;

                                      },
                                    obscureText: true,
                                    decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10,0,10,20),
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push( context, MaterialPageRoute( builder: (context) => const ForgotPasswordPage()), );
                                    },
                                    child: const Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: Text('Sign In'.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                    ),
                                    onPressed: (){
                                      //After successful login we will redirect to profile page. Let's create profile page now
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        // Do something with the email
                                        login();
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10,20,10,20),
                                  //child: Text('Don\'t have an account? Create'),
                                  child: Text.rich(
                                      TextSpan(
                                          children: [
                                            const TextSpan(text: "Don't have an account? "),
                                            TextSpan(
                                              text: 'Create',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage()));
                                                },
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                                            ),
                                          ]
                                      )
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
        ),
    );

  }
}