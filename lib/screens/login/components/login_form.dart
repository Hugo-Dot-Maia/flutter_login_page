import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../helperHomePage/helper_home_page.dart';
import '../../homepage/home_page.dart';
import '../../signUp/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _passwordVisible = false;
  bool loginSucces = true;
  User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _changeLoginState(bool state) {
    setState(() {
      loginSucces = state;
    });
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      user = userCredential.user;
      _changeLoginState(true);
    } catch (e) {
      _changeLoginState(false);
    }
  }

  Future<String> getFirebaseUserEmail() async {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  Future<String> getRole() async {
    String email = await getFirebaseUserEmail();
    String name = '';

    var querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var docSnapshot = querySnapshot.docs.first;
      var userData = docSnapshot.data();
      name = userData['role'];
    }

    return name;
  }

  void _navigateToHomePage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }

  void _login() async {
    if (!loginSucces) return;

    var role = await getRole();

    role == 'Helper'
        ? _navigateToHomePage(const HelperHomePage())
        : _navigateToHomePage(const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _emailController,
            onSaved: (email) {},
            decoration: InputDecoration(
              labelText: "Your email",
              errorText: loginSucces ? null : "Error on Login",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child:
                    Icon(Icons.person, color: loginSucces ? null : Colors.red),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: !_passwordVisible,
              cursorColor: kPrimaryColor,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Your password",
                errorText: loginSucces ? null : "Error on Login",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child:
                      Icon(Icons.lock, color: loginSucces ? null : Colors.red),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: _passwordVisible ? kPrimaryColor : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                await _signInWithEmailAndPassword();
                _login();
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignUpScreen();
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
