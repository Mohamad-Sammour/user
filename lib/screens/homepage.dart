import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_baleh_user/component/search.dart';
import 'package:on_baleh_user/database/products.dart';
import 'package:on_baleh_user/provider/user_provider.dart';
import 'package:on_baleh_user/screens/about.dart';
import 'package:on_baleh_user/screens/favorites.dart';
import 'package:on_baleh_user/screens/login.dart';
import 'package:on_baleh_user/screens/my_orders.dart';
import 'package:on_baleh_user/screens/product_details.dart';
import 'package:on_baleh_user/screens/setting.dart';
import 'package:on_baleh_user/screens/shopping_cart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  String getEmail = "";
  String getUserName = "";
  String getUserId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ProductsService _productsService = ProductsService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    void logout() {
      User u = _firebaseAuth.currentUser;
      user.signOut();
      user.onStateChanged(u);

      FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("On-Baleh",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingCart(
                                userId: getUserId,
                              )));
                }),
          ),
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                getUserName ?? "",
                style: const TextStyle(fontSize: 16),
              ),
              accountEmail: Text(
                getUserName == null ? "" : getEmail,
                style: const TextStyle(fontSize: 16),
              ),
              decoration: const BoxDecoration(color: Colors.purple),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyOrders(
                              userId: getUserId,
                            )));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.purple,
                ),
                title: Text("My orders"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShoppingCart(
                              userId: getUserId,
                            )));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.purple,
                ),
                title: Text("Shopping cart"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Favorites(
                              userId: getUserId,
                            )));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Colors.purple,
                ),
                title: Text("Favorite"),
              ),
            ),
            const Divider(
              color: Colors.purple,
              height: 35,

            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Setting(
                              uid: getUserId,
                            )));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.green,
                ),
                title: Text("Setting"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const About()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.help,
                  color: Colors.blue,
                ),
                title: Text("About"),
              ),
            ),
            InkWell(
              onTap: () {
                logout();
              },
              child: const ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                title: Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Search(
              userId: getUserId,
            ),
            SizedBox(
              height: 200,
              child: Carousel(
                images: const [
                  AssetImage('images/10.jpeg'),
                  AssetImage('images/99.jpeg'),
                  AssetImage('images/70.jpeg'),
                  AssetImage('images/999.jpeg'),
                  AssetImage('images/777.jpeg'),
                  AssetImage('images/76.jpeg'),
                  AssetImage('images/55.jpeg'),
                  AssetImage('images/30.jpeg'),
                ],
                boxFit: BoxFit.cover,
                borderRadius: true,
                dotColor: Colors.purple,
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Featured products",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _productsService.firestore
                    .collection('products')
                    .where('featured', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: snapshot.data.docs.map((doc) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                            userId: getUserId,
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
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.purple.shade600,
                                  boxShadow: const [BoxShadow(blurRadius: 5)]),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      doc['picture'],
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 220,
                                    ),
                                  ),
                                  Positioned(
                                    top: 180,
                                    child: Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: Colors.purple.withOpacity(0.5),
                                          boxShadow: const [
                                            BoxShadow(blurRadius: 14)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      child: Column(
                                        children: [
                                          Text(
                                            doc['name'],
                                            style: const TextStyle(
                                                color: Colors.limeAccent,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "\$ ${doc['price']}",
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Recent products",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _productsService.firestore
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        children: snapshot.data.docs
                            .map((doc) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                  userId: getUserId,
                                                  name: doc['name'],
                                                  brand: doc['brand'],
                                                  category: doc['category'],
                                                  colors: doc['colors'],
                                                  sizes: doc['sizes'],
                                                  picture: doc['picture'],
                                                  price: doc['price'],
                                                  productId: doc['id'],
                                                  favoriteStatus:
                                                      doc['favorite'],
                                                )));
                                  },
                                  child: ListTile(
                                    leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.network(
                                          doc['picture'],
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: 60,
                                        )),
                                    title: Text(
                                      doc['name'],
                                      style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("By : ${doc['brand']}"),
                                        Text("\$ ${doc['price']}",
                                            style: const TextStyle(
                                                fontSize: 19,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                    trailing: doc['sale'] == true
                                        ? Image.asset(
                                            "images/sale.png",
                                            width: 70,
                                          )
                                        : const SizedBox(),
                                  ),
                                ))
                            .toList());
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.purple,
                    ));
                  }
                })
          ],
        ),
      ),
    );
  }

  Future<void> getName(var id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot data) {
      setState(() {
        getUserName = data['name'];
      });
    });
  }

  getUserInfo() async {
    final User user = _firebaseAuth.currentUser;
    await getName(user.uid);
    setState(() {
      final uid = user.uid;
      getUserId = uid;

      final email = user.email;
      getEmail = email;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getUserInfo();
  }
}
