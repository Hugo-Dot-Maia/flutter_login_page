import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_page/screens/signUp/components/role_radio_button.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import 'gender_radio_button.dart';
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
  bool dateOfBirthValid = true;
  bool phoneValid = true;
  bool _authCreated = false;
  String _gender = '';
  String _role = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _setGender(String? value) {
    setState(() {
      _gender = value!;
    });
  }

  void _setRole(String? value) {
    setState(() {
      _role = value!;
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

  bool _validateDateOfBirth() {
    // Regular expression pattern for the date format '##/##/####'
    RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    // Check if the date matches the pattern
    if (!regex.hasMatch(_dateOfBirthController.text)) {
      setState(() {
        dateOfBirthValid = false;
      });
      return false;
    }

    // Split the date into day, month, and year
    List<String> parts = _dateOfBirthController.text.split('/');
    int? day = int.tryParse(parts[0]);
    int? month = int.tryParse(parts[1]);
    int? year = int.tryParse(parts[2]);

    // Check if the day, month, and year are valid
    if (day == null || month == null || year == null) {
      setState(() {
        dateOfBirthValid = false;
      });
      return false;
    }

    // Perform additional validation on the day, month, and year if needed
    // For example, you can check if the day is within a valid range, if the month is between 1 and 12, etc.

    // If all checks pass, the date of birth is valid
    setState(() {
      dateOfBirthValid = true;
    });
    return true;
  }

  bool _validatePhoneNumber() {
    // Regular expression pattern for the phone number format '## (##) #####-####'
    RegExp regex = RegExp(r'^\d{2} \(\d{2}\) \d{5}-\d{4}$');

    // Check if the phone number matches the pattern
    if (!regex.hasMatch(_phoneController.text)) {
      setState(() {
        phoneValid = false;
      });
      return false;
    }

    setState(() {
      phoneValid = true;
    });
    // If all checks pass, the phone number is valid
    return true;
  }

  bool _validateInputs() {
    return _validatePassword() &&
        _validateDateOfBirth() &&
        _validatePhoneNumber();
  }

  void _setAuthCreated(bool value) {
    setState(() {
      _authCreated = value;
    });
  }

  void _createUser() {
    if (!_authCreated) {
      return;
    }
    var db = FirebaseFirestore.instance;

    final user = <String, dynamic>{
      "email": _emailController.text,
      "name": _nameController.text,
      "dateOfBirth": _dateOfBirthController.text,
      "phone": _phoneController.text,
      "gender": _gender,
      "role": _role,
    };
    // Generate a unique ID for the user
    final newUserId = FirebaseAuth.instance.currentUser?.uid;

    // Save the user data with the generated ID
    db.collection("users").doc(newUserId).set(user);
  }

  Future<void> _createAuth() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) =>
              showWarningDialog(context, 'User successfully signed up'));

      _setAuthCreated(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showWarningDialog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showWarningDialog(
            context, 'The account already exists for that email.');
      }
      _setAuthCreated(false);
    } catch (e) {
      showWarningDialog(context, 'An error occurred. Please try again later.');
      _setAuthCreated(false);
    }
  }

  _signUp() async {
    await _createAuth();
    _createUser();
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
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Your name",
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoleSelectionWidget(
                role: _role,
                setRole: _setRole,
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
            decoration: InputDecoration(
              labelText: "Date of birth (dd/mm/yyyy)",
              errorText: dateOfBirthValid ? null : "Date of birth invalid",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.calendar_today,
                    color: dateOfBirthValid ? null : Colors.red),
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
            decoration: InputDecoration(
              labelText: "Phone number",
              errorText: phoneValid ? null : "Phone invalid",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone, color: phoneValid ? null : Colors.red),
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

                await _signUp();
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
