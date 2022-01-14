import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_baleh_user/screens/order_details.dart';

class MyOrders extends StatefulWidget {
  final String userId;

  const MyOrders({Key key, this.userId}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Orders"),
          backgroundColor: Colors.purple,
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Confirmed', icon: Icon(Icons.done,color: Colors.black,)),
              Tab(text: "Delivered", icon: Icon(Icons.directions_car,color: Colors.black,)),
              Tab(text: "Cancelled", icon: Icon(Icons.cancel,color: Colors.black,)),
            ],
          ),
        ),
        body: TabBarView(children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('order')
                  .where('status', isEqualTo: 'Confirmed')
                  .where('user_id', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data.docs.map((doc) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetails(
                                            orderId: doc.id,
                                          )));
                            },
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Image.asset(
                                              "images/confirmed.jpg")),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "The order will be delivered within 3 days",
                                                style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            const Text(
                                              "Confirmed",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                              doc['username'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(doc['phone_number'],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ListTile(
                                    leading: Text(
                                      "\$ ${doc['total_price'].toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    title: Text(doc['address']),
                                    subtitle: Text(
                                        "${doc['create_time'].toString().substring(0, 10)}  |  ${doc['create_time'].toString().substring(11, 16)}"),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios_outlined),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('order')
                  .where('status', isEqualTo: 'Delivered')
                  .where('user_id', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data.docs.map((doc) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OrderDetails()));
                            },
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Image.asset(
                                              "images/delivery.png")),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "The order has been successfully delivered",
                                                style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            const Text(
                                              "Delivered",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                              doc['username'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(doc['phone_number'],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ListTile(
                                    leading: Text(
                                      "\$ ${doc['total_price'].toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    title: Text(doc['address']),
                                    subtitle: Text(
                                        "${doc['create_time'].toString().substring(0, 10)}  |  ${doc['create_time'].toString().substring(11, 16)}"),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios_outlined),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('order')
                  .where('status', isEqualTo: 'Cancelled')
                  .where('user_id', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data.docs.map((doc) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OrderDetails()));
                            },
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Image.asset(
                                        "images/cancel.png",
                                        height: 150,
                                      )),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Your order has been cancelled",
                                                style: TextStyle(
                                                  color: Colors.grey.shade800,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            const Text(
                                              "Cancelled",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                              doc['username'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(doc['phone_number'],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ListTile(
                                    leading: Text(
                                      "\$ ${doc['total_price'].toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    title: Text(doc['address']),
                                    subtitle: Text(
                                        "${doc['create_time'].toString().substring(0, 10)}  |  ${doc['create_time'].toString().substring(11, 16)}"),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios_outlined),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ]),
      ),
    );
  }
}
