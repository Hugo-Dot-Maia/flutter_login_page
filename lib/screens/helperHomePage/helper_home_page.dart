import 'package:flutter/material.dart';
import 'package:flutter_login_page/screens/helperHomePage/user_accepted_orders.dart';

import '../../constants.dart';
import '../homepage/profile.dart';
import 'helper_market_place.dart';

class HelperHomePage extends StatefulWidget {
  const HelperHomePage({Key? key}) : super(key: key);

  @override
  _HelperHomePageState createState() => _HelperHomePageState();
}

class _HelperHomePageState extends State<HelperHomePage> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      const HelperMarketPlace(),
      const UserAcceptedOrders(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: kPrimaryColor),
    );
  }
}
