import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants.dart';
import '../../Utils/sign_up_alert.dart';
import '../../entities/userOrder.dart';

class OrderedItems extends StatefulWidget {
  const OrderedItems({Key? key}) : super(key: key);

  @override
  _OrderedItemsState createState() => _OrderedItemsState();
}

class _OrderedItemsState extends State<OrderedItems> {
  Future<String> getFirebaseUserId() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  double _calculateTotalPrice(List<UserOrder> userOrders) {
    double total = 0;

    userOrders.forEach((element) {
      total += element.totalPrice;
    });
    return total;
  }

  void cancelOrder(UserOrder item) async {
    try {
      // Get the reference to the Firestore document for the order
      final userId = FirebaseAuth.instance.currentUser?.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(userId)
          .collection('userOrders')
          .where('userEmail', isEqualTo: item.helpedEmail)
          .get();

      // If there is a matching document, delete it
      if (querySnapshot.docs.isNotEmpty) {
        final userOrderDocRef = querySnapshot.docs.first.reference;
        await userOrderDocRef.delete();
        showWarningDialog(context, 'Order canceled: ${userOrderDocRef.id}');
      } else {
        showWarningDialog(context, 'No matching order found.');
      }
    } catch (error) {
      // Handle any errors that occur during the deletion process
      showWarningDialog(context, 'Failed to cancel order: $error');
    }
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
            ElevatedButton(
              onPressed: () {
                cancelOrder(item);
                Navigator.pop(context); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Set the button's background color to red
                foregroundColor:
                    Colors.white, // Set the button's text color to white
              ),
              child: const Text('Cancel Order'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getFirebaseUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final userId = snapshot.data;

        if (userId == null) {
          return const Text('No userId found.');
        }

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('orders')
              .doc(userId)
              .collection('userOrders')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return const Text('No items found.');
            }

            final List<UserOrder> userOrders = [];
            snapshot.data!.docs.forEach((doc) {
              final Map<String, dynamic> data =
                  doc.data() as Map<String, dynamic>;
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

            return ListView.builder(
              itemCount: userOrders.length + 1,
              itemBuilder: (context, index) {
                if (index == userOrders.length) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${_calculateTotalPrice(userOrders).toStringAsFixed(2)}',
                          style: totalTextStyle,
                        ),
                      ],
                    ),
                  );
                }

                final item = userOrders[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    child: GestureDetector(
                      onTap: () {
                        navigateToFullView(item);
                      },
                      child: ListTile(
                        title: Text(item.helpedEmail),
                        subtitle: Text(item.status),
                        trailing: const Icon(
                          Icons.info,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
