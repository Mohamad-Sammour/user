import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String table = "users";

  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('users');

  createUser(String uid, Map data) {
    var id = const Uuid();
    String userId = id.v1();
    data["id"] = userId;

    _firestore.collection(table).doc(userId).set(data);
  }

  deleteUser(String uid) {
    _firestore.collection(table).doc(uid).delete();
  }
}
