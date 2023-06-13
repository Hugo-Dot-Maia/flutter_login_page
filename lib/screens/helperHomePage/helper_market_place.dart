import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<String> getFirebaseUserEmail() async {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  Future<void> updateOrderStatus(UserOrder order) async {
    String attenderEmail = await getFirebaseUserEmail();
    final QuerySnapshot userSnapshots =
        await db.collectionGroup('userOrders').get();

    if (userSnapshots.docs.isEmpty) {
      return;
    }

    for (var userSnapshot in userSnapshots.docs) {
      var path = userSnapshot.reference.path;
      List<String> components = path.split('/');

      Map<String, dynamic> orderData =
          userSnapshot.data() as Map<String, dynamic>;

      UserOrder currentOrder = UserOrder(
        helpedEmail: orderData['userEmail'],
        totalPrice: orderData['totalPrice'],
        status: orderData['status'],
        items: List<String>.from(orderData['items']),
      );

      if (currentOrder == order) {
        // Found the matching order
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(components[1])
            .collection('userOrders')
            .doc(components[3])
            .update({
          'status': 'Attended',
          'attenderEmail': attenderEmail,
        });
        break; // Exit the loop after updating the order
      }
    }
  }

  Future<void> _attendOrder(UserOrder item) async {
    await updateOrderStatus(item);
  }

  void navigateToFullView(UserOrder item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Item Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Items: ${item.items.join(", ")}'),
              Text('Status: ${item.status}'),
              Text('Total Price: ${item.totalPrice.toStringAsFixed(2)}',
                  style: totalTextStyle),
            ],
          ),
          actions: [
            TextButton(
              child:
                  const Text('ATTEND', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                await _attendOrder(item);

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('CLOSE', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
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
                _attendOrder(item);

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
                subtitle: Text(item.status,
                    style: item.status == "pending"
                        ? const TextStyle(color: Colors.orange)
                        : const TextStyle(color: Colors.green)),
                trailing: InkWell(
                  onTap: () => navigateToFullView(item),
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
