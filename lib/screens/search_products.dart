import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_baleh_user/database/products.dart';
import 'package:on_baleh_user/screens/product_details.dart';

class SearchProducts extends StatefulWidget {
  @override
  SearchProductsState createState() => new SearchProductsState();
  final String userId;
  final String category;

  SearchProducts({@required this.userId, @required this.category});
}

class SearchProductsState extends State<SearchProducts> {
  ProductsService _productsService = ProductsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text('Results'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _productsService.firestore.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  Column(
                    /*scrollDirection: Axis.horizontal,*/
                    children: snapshot.data.docs.map((doc) {
                      return doc['category'] == widget.category
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProductDetails(
                                              name: doc['name'],
                                              price: doc['price'],
                                              picture: doc['picture'],
                                              brand: doc['brand'],
                                              colors: doc['colors'],
                                              sizes: doc['sizes'],
                                              productId: doc['id'],
                                              userId: widget.userId,
                                              category: doc['category'],
                                              favoriteStatus:
                                                  doc['favorite'],
                                            )));
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          doc['picture'],
                                          height: 90,
                                          width: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: doc['name'] + '\n',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        TextSpan(
                                          text:
                                              'By: ' + doc['brand'] + '\n',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        TextSpan(
                                          text: '\$' +
                                              doc['price'].toString() +
                                              '\t',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: doc['sale'] == true
                                              ? 'ON SALE '
                                              : '',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red),
                                        ),
                                      ], style: TextStyle(color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox();
                    }).toList(),
                  )
                ],
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }
}
