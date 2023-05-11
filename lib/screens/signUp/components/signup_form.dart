import 'package:flutter/material.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../entities/user_form.dart';
import '../../Login/login_screen.dart';
import 'gender_radio_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Utils/sign_up_alert.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool passWordMatch = true;
  String _gender = '';
  String _role = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final phoneFormatter = MaskTextInputFormatter(
      mask: '## (##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final dateFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  void _setGender(String? value) {
    setState(() {
      _gender = value!;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validatePassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        passWordMatch = false;
      });
      return false;
    }
    return true;
  }

  bool _validateInputs() {
    return _validatePassword();
  }

  void _signUp() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) =>
              showWarningDialog(context, 'User successfully signed up'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showWarningDialog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showWarningDialog(
            context, 'The account already exists for that email.');
      }
    } catch (e) {
      showWarningDialog(context, 'An error occurred. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: defaultPadding),
          const SizedBox(height: defaultPadding),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _emailController,
            onSaved: (email) {},
            decoration: const InputDecoration(
              labelText: "Your email",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
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
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                errorText: passWordMatch ? null : "Password does not match",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock,
                      color: passWordMatch ? null : Colors.red),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: !_confirmPasswordVisible,
              cursorColor: kPrimaryColor,
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: "Confirm password",
                errorText: passWordMatch ? null : "Password does not match",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock,
                      color: passWordMatch ? null : Colors.red),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color:
                        _confirmPasswordVisible ? kPrimaryColor : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenderSelectionWidget(
                gender: _gender,
                setGender: _setGender,
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            keyboardType: TextInputType.datetime,
            cursorColor: kPrimaryColor,
            onSaved: (dateOfBirth) {},
            controller: _dateOfBirthController,
            inputFormatters: [dateFormatter],
            decoration: const InputDecoration(
              labelText: "Date of birth (dd/mm/yyyy)",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.calendar_today),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            keyboardType: TextInputType.phone,
            cursorColor: kPrimaryColor,
            onSaved: (phone) {},
            controller: _phoneController,
            inputFormatters: [phoneFormatter],
            decoration: const InputDecoration(
              labelText: "Phone number",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (!_validateInputs()) {
                  return;
                }
                _signUp();
              },
              child: Text("Sign Up".toUpperCase()),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
