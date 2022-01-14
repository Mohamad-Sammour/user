import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class OrderItemsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String table = 'order_items';
  String orderItemsId;

  void uploadOrder(Map<String, dynamic> data) {
    var id = const Uuid();
    orderItemsId = id.v1();
    data["id"] = orderItemsId;
    firestore.collection(table).doc(orderItemsId).set(data);
  }

  Future<List<DocumentSnapshot>> getOrdeItemsr() =>
      firestore.collection(table).get().then((snaps) {
        return snaps.docs;
      });

//Future Function
  void deleteOrder() {
    firestore.collection('order_items').doc(orderItemsId).delete();
  }
}
