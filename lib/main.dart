import 'package:channab/farm_animal_form.dart';
import 'package:channab/home.dart';
import 'package:channab/pages/auth/create_pin.dart';
import 'package:channab/pages/auth/forgot_password.dart';
import 'package:channab/pages/auth/reset_password.dart';
import 'package:channab/pages/auth/signin.dart';
import 'package:channab/pages/auth/signup.dart';
import 'package:channab/pages/landing/landing.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins-Regular',
        primaryColor: Color.fromRGBO(0, 178, 45, 1.0)
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Landing(),
        '/signin': (context) => SignIn(),
        '/forgotpassword': (context) => ForgotPassword(),
        '/resetpassword': (context) => ResetPassword(),
        '/signup': (context) => SignUp(),
        '/createpin': (context) => CreatePin(),
        '/home': (context) => Home(),
        '/farm_animal_form': (context) => FarmAnimalForm(),
      },
    );
  }
}