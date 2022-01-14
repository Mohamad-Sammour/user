import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String table = 'order';
  String orderId;

  void uploadOrder(Map<String, dynamic> data) {
    var id = const Uuid();
    orderId = id.v1();
    data["id"] = orderId;
    firestore.collection(table).doc(orderId).set(data);
  }

  Future<List<DocumentSnapshot>> getOrder() =>
      firestore.collection(table).get().then((snaps) {
        return snaps.docs;
      });

//Future Function
  void deleteOrder() {
    firestore.collection('order').doc(orderId).delete();
  }
}
