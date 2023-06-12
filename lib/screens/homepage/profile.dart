import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
import '../welcome/welcome_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool showForm = false;
  bool dateOfBirthValid = true;
  bool phoneValid = true;

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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String> getFirebaseUserEmail() async {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  Future<String> getUser() async {
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
      name = userData['name'];
    }

    return name;
  }

  Future<void> updateUserData() async {
    String newName = nameController.text.trim();
    String newPhone = _phoneController.text.trim();
    String newDateOfBirth = _dateOfBirthController.text.trim();
    String email = await getFirebaseUserEmail();

    var querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var docSnapshot = querySnapshot.docs.first;
      var userData = docSnapshot.data();

      userData['name'] = newName;
      userData['phone'] = newPhone;
      userData['dateOfBirth'] = newDateOfBirth;

      try {
        await docSnapshot.reference.update(userData);
        _showToast('User data updated successfully!', Colors.green);
      } catch (e) {
        print('Error updating user data: $e');
        _showToast('Failed to update user data.', Colors.red);
      }

      await docSnapshot.reference.update(userData);
    }
  }

  bool _validateInputs() {
    return _validateDateOfBirth() &&
        _validatePhoneNumber() &&
        nameController.text.trim().isNotEmpty;
  }

  Widget buildUserName() {
    return FutureBuilder<String>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text(
            snapshot.data ?? 'Unknown User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }

  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50'),
            ),
            const SizedBox(height: 16),
            buildUserName(),
            const SizedBox(height: 32),
            Visibility(
              visible: showForm,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'New Name',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    cursorColor: kPrimaryColor,
                    onSaved: (dateOfBirth) {},
                    controller: _dateOfBirthController,
                    inputFormatters: [dateFormatter],
                    decoration: InputDecoration(
                      labelText: "Date of birth (dd/mm/yyyy)",
                      errorText:
                          dateOfBirthValid ? null : "Date of birth invalid",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.calendar_today,
                            color: dateOfBirthValid ? null : Colors.red),
                      ),
                    ),
                  ),
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
                        child: Icon(Icons.phone,
                            color: phoneValid ? null : Colors.red),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_validateInputs()) {
                        await updateUserData();
                        // Show a success message or perform any additional actions after updating the data
                      }
                    },
                    child: const Text('Update Name'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Hide the form when the "Cancel" button is clicked
                      setState(() {
                        showForm = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Visibility(
              visible: !showForm,
              child: TextButton(
                onPressed: () {
                  // Show the form when the "Change Data" button is clicked
                  setState(() {
                    showForm = true;
                  });
                },
                child: const Text('Update Data'),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await signOut();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const WelcomeScreen();
                    },
                  ),
                );
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
