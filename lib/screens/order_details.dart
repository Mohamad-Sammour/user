import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final String orderId;
  const OrderDetails({Key key, this.orderId}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order details"),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('order_items')
              .where('order_id', isEqualTo: widget.orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: snapshot.data.docs.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 15,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Image.network(
                                      doc['picture'],
                                      fit: BoxFit.cover,
                                    )),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                          "Qty: ${doc['quantity'].toString()}",
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        )))
                              ],
                            ),
                            ListTile(
                              leading: Text("\$ ${doc['price_qty'].toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800)),
                              title: Text(doc['name']),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Size:"),
                                  Text(doc['size'], style: TextStyle(color: Colors.purple)),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text("Color:"),
                                  Text(doc['color'], style: TextStyle(color: Colors.purple))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return SizedBox();
            }
          })
    );
  }
}
