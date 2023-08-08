import 'package:fispawn/routes/home.dart';
import 'package:fispawn/routes/sign_in.dart';
import 'package:fispawn/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error occured'),
            ),
          );
        } else if (snapshot.hasData) {
          return Home();
        } else {
          return const MyScaffold(widget: SignIn());
        }
      },
    );
  }
}
