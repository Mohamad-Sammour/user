import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_baleh_user/database/products.dart';
import 'package:on_baleh_user/screens/product_details.dart';

class Favorites extends StatefulWidget {
  final String userId;

  const Favorites({Key key, this.userId}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final ProductsService _productsService = ProductsService();


  List<String> favoriteUsers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Favorites",style: TextStyle(fontSize: 25),),
          backgroundColor: Colors.purple,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _productsService.firestore
                .collection('products')
                .where("favorite", arrayContains: widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      children: snapshot.data.docs.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                        userId: widget.userId,
                                        name: doc['name'],
                                        brand: doc['brand'],
                                        category: doc['category'],
                                        colors: doc['colors'],
                                        sizes: doc['sizes'],
                                        picture: doc['picture'],
                                        price: doc['price'],
                                        productId: doc['id'],
                                        favoriteStatus: doc['favorite'],
                                      )));
                        },
                        child: Card(
                          elevation: 15,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                doc['picture'],
                                fit: BoxFit.cover,
                                height: 180,
                                width: 60,
                              ),
                            ),
                            title: Text(
                              doc['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("\$ ${doc['price']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 16)),
                            trailing: IconButton(
                              onPressed: () {


                                setState(() {
                                  favoriteUsers = doc['favorite'].cast<String>().toList();
                                });
                                if(favoriteUsers.contains(widget.userId)) {

                                  favoriteUsers.remove(widget.userId);
                                  _productsService.updateFavoriteStatus(
                                      doc['id'], {'favorite': favoriteUsers});
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList()),
                );
              } else {
                return const SizedBox();
              }
            }));
  }

}
