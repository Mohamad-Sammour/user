import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_baleh_user/database/carts.dart';
import 'package:on_baleh_user/database/order.dart';
import 'package:on_baleh_user/database/order_items.dart';

class ShoppingCart extends StatefulWidget {
  final String userId;
  final String email;

  const ShoppingCart({Key key, this.userId, this.email}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();
  final OrderItemsService _orderItemsService = OrderItemsService();
  final GlobalKey<FormState> _userInfoFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  double total = 0.0;
  List<String> productIdList = <String>[];
  String orderStatus = 'Confirmed';
  String address;
  String phone;
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart",style: TextStyle(fontSize: 25),),
          backgroundColor: Colors.purple,
        ),
        bottomNavigationBar: Container(
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text("Total:"),
                  subtitle: Text('\$ ' + (getTotalPrice().toStringAsFixed(2))),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    _userInfoAlert();
                  },
                  child: const Text(
                    "Check out",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple,
                ),
              )
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('carts')
                .where('user_id', isEqualTo: widget.userId)
                .where('cart_status', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: snapshot.data.docs.map((doc) {
                      return Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Image.network(
                                    doc['picture'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      IconButton(
                                          icon: const Icon(Icons.arrow_drop_up),
                                          onPressed: () {
                                            setState(() {
                                              if (doc['quantity'] < 10) {
                                                _cartService.updateCarts(
                                                    doc['id'], {
                                                  'quantity':
                                                      doc['quantity'] +1
                                                });
                                                _cartService.updateCarts(
                                                    doc['id'], {
                                                  'price_qty': doc
                                                          ['price'] *
                                                      (doc['quantity'] + 1)
                                                });
                                              }
                                            });
                                          }),
                                      Text(
                                        doc['quantity'].toString(),
                                        style: const TextStyle(
                                            color: Colors.purple,
                                            fontSize: 18),
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.arrow_drop_down),
                                          onPressed: () {
                                            setState(() {
                                              if (doc['quantity'] > 1) {
                                                _cartService.updateCarts(
                                                    doc['id'], {
                                                  'quantity':
                                                      doc['quantity'] -1
                                                });
                                                _cartService.updateCarts(
                                                    doc['id'], {
                                                  'price_qty': doc
                                                          ['price'] *
                                                      (doc['quantity'] - 1)
                                                });
                                              }
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await _cartService.firestore
                                            .collection('carts')
                                            .doc(doc.id)
                                            .delete();
                                      },
                                    )),
                              ],
                            ),
                            ListTile(
                              leading: Text(
                                '\$' + doc['price_qty'].toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.purple,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Text(
                                doc['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  const Text("Size:"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    doc['size'],
                                    style: const TextStyle(color: Colors.purple),
                                  ),
                                  const SizedBox(
                                    width: 40.0,
                                  ),
                                  const Text("Color:"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(doc['color'],
                                      style:
                                          const TextStyle(color: Colors.purple))
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }));
  }

  void validateAndUploadOrder() async {
    setState(() => const CircularProgressIndicator());
    if (getTotalPrice().toString() != '0.0') {
      _orderService.uploadOrder({
        "user_id": widget.userId,
        "total_price": getTotalPrice(),
        "status": orderStatus,
        "create_time": DateTime.now().toIso8601String(),
        "username": name,
        "address": address,
        "phone_number": phone,
      });
      Fluttertoast.showToast(
          msg: 'Order placed ..',
          backgroundColor: Colors.purple,
          fontSize: 15.5,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: 'Your cart is empty , Go shopping',
          backgroundColor: Colors.purple,
          fontSize: 15.5,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
    }

    setState(() => const CircularProgressIndicator());
  }

  void _userInfoAlert() {
    var alert = AlertDialog(
      content: Form(
        key: _userInfoFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name cannot be empty';
                }
                return null;
              },
              decoration: const InputDecoration(hintText: "Enter your full name"),
            ),
            TextFormField(
              controller: addressController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Address cannot be empty';
                }
                return null;
              },
              decoration: const InputDecoration(hintText: "Enter your address"),
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value.isNotEmpty) {
                  Pattern pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Please make sure your\nphone number is valid';
                  }
                } else {
                  return 'Phone number cannot be empty';
                }
                return null;
              },
              decoration: const InputDecoration(hintText: "Enter your phone number"),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Expanded(
          child: MaterialButton(
              color: Colors.purple,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL')),
        ),
        Expanded(
          child: MaterialButton(
              onPressed: () {
                if (_userInfoFormKey.currentState.validate()) {
                  if (addressController.text != '' &&
                      phoneController.text != '' &&
                      nameController.text != '') {
                    setState(() {
                      name = nameController.text;
                      address = addressController.text;
                      phone = phoneController.text;
                    });
                    validateAndUploadOrder();
                    uploadOrderItems();
                    _cartService.updateAllCartStatus();
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                  /*Fluttertoast.showToast(
                        msg: 'Failed',
                        backgroundColor: Colors.purple,
                        fontSize: 15.5,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white);*/
                }
              },
              color: Colors.pinkAccent,
              child: const Text('ADD')),
        ),
      ],
      backgroundColor: Colors.white,
      title: const Text('Enter your information'),
      elevation: 20.0,
      contentTextStyle: const TextStyle(color: Colors.yellow),
    );

    showDialog(context: context, builder: (context) => alert);
  }

  double getTotalPrice() {
    FirebaseFirestore.instance
        .collection('carts')
        .where('cart_status', isEqualTo: false)
        .where('user_id', isEqualTo: widget.userId)
        .snapshots()
        .listen((snapshot) {
      double tempTotal =
          snapshot.docs.fold(0, (tot, doc) => tot + doc['price_qty']);
      setState(() {
        total = tempTotal;
      });
      /*debugPrint(total.toString());*/
    });
    return total;
  }

  Future uploadOrderItems() async {
    QuerySnapshot querySnapshotCart = await FirebaseFirestore.instance
        .collection("carts")
        .where('user_id', isEqualTo: widget.userId)
        .where('cart_status', isEqualTo: false)
        .get();

    for (int i = 0; i < querySnapshotCart.docs.length; i++) {
      var cart = querySnapshotCart.docs[i];
      _orderItemsService.uploadOrder({
        "order_id": _orderService.orderId,
        "product_id": cart['product_id'],
        "quantity": cart['quantity'],
        "price_qty": cart['price_qty'],
        "picture": cart['picture'],
        "price": cart['price'],
        "color": cart['color'],
        "size": cart['size'],
        "name": cart['name'],
      });
    }
  }
}
