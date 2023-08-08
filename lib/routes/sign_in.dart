import 'package:fispawn/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const Spacer(),
          Container(
            child: Text(
              'Sign in with your Google account to get started',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () => {
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .signInWithGoogle()
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(1000),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'images/sam.jpg',
                  //   height: 30,
                  //   width: 30,
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sign up with Google',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
