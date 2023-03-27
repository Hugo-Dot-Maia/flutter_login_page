import 'package:flutter/material.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../entities/user_form.dart';
import '../../Login/login_screen.dart';
import 'gender_radio_button.dart';

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
  String _gender = '';
  String _role = '';
  final TextEditingController _emailController = TextEditingController();
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    super.dispose();
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
              hintText: "Your email",
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
                hintText: "Your password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
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
                hintText: "Confirm password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
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
            decoration: const InputDecoration(
              hintText: "Date of birth (dd/mm/yyyy)",
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
            decoration: const InputDecoration(
              hintText: "Phone number",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Center(
            child: ElevatedButton(
              onPressed: () {
                SignUpData signUpData = SignUpData(
                  email: _emailController.text,
                  password: _passwordController.text,
                  gender: _gender == '' ? "Other" : _gender,
                  dateOfBirth: _dateOfBirthController.text,
                  phone: _phoneController.text,
                );
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
