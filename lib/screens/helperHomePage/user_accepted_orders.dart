import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_page/entities/userOrder.dart';

import '../../Utils/sign_up_alert.dart';
import '../../constants.dart';

class UserAcceptedOrders extends StatefulWidget {
  const UserAcceptedOrders({Key? key}) : super(key: key);

  @override
  _UserAcceptedOrdersState createState() => _UserAcceptedOrdersState();
}

class _UserAcceptedOrdersState extends State<UserAcceptedOrders> {
  List<UserOrder> userAcceptedOrders = [];
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    fetchAcceptedOrdersFromFirestore();
  }

  Future<void> fetchAcceptedOrdersFromFirestore() async {
    try {
      final QuerySnapshot userSnapshots =
          await db.collectionGroup('userOrders').get();

      if (userSnapshots.docs.isEmpty) {
        showWarningDialog(context, 'No accepted orders found');
        return;
      }

      String attenderEmail = await getFirebaseUserEmail();

      List<UserOrder> acceptedOrders = [];

      for (var userSnapshot in userSnapshots.docs) {
        final Map<String, dynamic> data =
            userSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> orderItems = data['items'];

        if (data['attenderEmail'] == attenderEmail) {
          acceptedOrders.add(
            UserOrder(
              helpedEmail: data['userEmail'],
              items: (orderItems).cast<String>(),
              totalPrice: data['totalPrice'],
              status: data['status'],
            ),
          );
        }
      }

      setState(() {
        userAcceptedOrders = acceptedOrders;
      });
    } catch (e) {
      showWarningDialog(context, 'Error fetching accepted orders');
    }
  }

  Future<String> getFirebaseUserEmail() async {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted Orders'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: userAcceptedOrders.length,
        itemBuilder: (BuildContext context, int index) {
          UserOrder item = userAcceptedOrders[index];
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
                subtitle: Text(
                  item.status,
                  style: item.status == "pending"
                      ? const TextStyle(color: Colors.orange)
                      : const TextStyle(color: Colors.green),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Order Details'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Items: ${item.items.join(", ")}'),
                                  Text('Status: ${item.status}'),
                                  Text(
                                    'Total Price: ${item.totalPrice.toStringAsFixed(2)}',
                                    style: totalTextStyle,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    'CLOSE',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.info,
                        color: Colors.yellow,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        // Handle map icon tap
                        // Do something when the map icon is tapped
                      },
                      child: const Icon(
                        Icons.map,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
