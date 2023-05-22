import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants.dart';

class OrderedItems extends StatefulWidget {
  const OrderedItems({Key? key}) : super(key: key);

  @override
  _OrderedItemsState createState() => _OrderedItemsState();
}

class _OrderedItemsState extends State<OrderedItems> {
  Future<String> getFirebaseUserId() async {
    return FirebaseAuth.instance.currentUser!.uid;
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

            var docSnapshot = snapshot.data!.docs.first;

            var userData = docSnapshot.data();

            final items = (userData as Map<String, dynamic>)['items'];
            final finalPrice = userData['totalPrice'] as double?;

            return ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${finalPrice?.toStringAsFixed(2)}',
                          style: totalTextStyle,
                        ),
                      ],
                    ),
                  );
                }

                final item = items[index];
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
                    child: ListTile(
                      title: Text(item),
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
