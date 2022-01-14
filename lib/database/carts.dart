import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CartService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String table = 'carts';
  String getProductsNum;
  String cartId;

  void uploadCart(Map<String, dynamic> data) {
    var id = const Uuid();
    cartId = id.v1();
    data["id"] = cartId;
    firestore.collection(table).doc(cartId).set(data);
  }

  Future<List<DocumentSnapshot>> getCarts() {
    return firestore.collection(table).get().then((snaps) {
      getProductsNum = snaps.docs.length.toString();
      return snaps.docs;
    });
  }


  updateCarts(selectedDoc, newValues) {
    FirebaseFirestore.instance
        .collection(table)
        .doc(selectedDoc)
        .update(newValues)
        .catchError((e) {
    });
  }

  Future updateAllCartStatus() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(table).get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      updateCarts(a.id, {'cart_status': true});
    }
  }

}
