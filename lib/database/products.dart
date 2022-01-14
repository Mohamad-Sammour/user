import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String table = "products";
  String getProductsNum;

  Future<List<DocumentSnapshot>> getProducts() =>
      firestore.collection(table).get().then((snaps) {
        getProductsNum = snaps.docs.length.toString();
        return snaps.docs;
      });

  updateFavoriteStatus(selectedDoc, newValues) {
    FirebaseFirestore.instance
        .collection(table)
        .doc(selectedDoc)
        .update(newValues)
        .catchError((e) {
      print(e);
    });
  }
}
