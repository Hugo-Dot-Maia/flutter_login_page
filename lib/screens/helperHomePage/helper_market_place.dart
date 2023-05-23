import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_page/entities/userOrder.dart';

import '../../Utils/sign_up_alert.dart';
import '../../constants.dart';

class HelperMarketPlace extends StatefulWidget {
  const HelperMarketPlace({Key? key}) : super(key: key);

  @override
  _HelperMarketPlaceState createState() => _HelperMarketPlaceState();
}

class _HelperMarketPlaceState extends State<HelperMarketPlace> {
  List<UserOrder> userOrderedItems = [];
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    fetchOrdersFromFirestore();
  }

  Future<void> fetchOrdersFromFirestore() async {
    try {
      final QuerySnapshot querySnapshot =
          await db.collectionGroup('userOrders').get();

      if (querySnapshot.docs.isNotEmpty) {
        final List<UserOrder> userOrders = [];
        querySnapshot.docs.forEach((doc) {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final List<dynamic> orderItems = data['items'];

          userOrders.add(
            UserOrder(
              helpedEmail: data['userEmail'],
              items: (orderItems).cast<String>(),
              totalPrice: data['totalPrice'],
              status: data['status'],
            ),
          );
        });

        setState(() {
          userOrderedItems = userOrders;
        });
      } else {
        showWarningDialog(context, 'No orders found ');
      }
    } catch (e) {
      showWarningDialog(context, 'Error fetching orders ');
    }
  }

  _showDetailsDialog(UserOrder item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.helpedEmail),
          content: Text(item.status),
          actions: [
            TextButton(
              child: const Text('CANCEL', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child:
                  const Text('ATTEND', style: TextStyle(color: Colors.green)),
              onPressed: () {
                // _addToCart(item);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helper Market Place'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: userOrderedItems.length,
        itemBuilder: (BuildContext context, int index) {
          UserOrder item = userOrderedItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(item.helpedEmail),
                subtitle: Text(item.status),
                trailing: InkWell(
                  onTap: () => _showDetailsDialog(item),
                  child: const Icon(
                    Icons.info,
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
