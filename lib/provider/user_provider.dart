import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  final FirebaseAuth _auth;
  User userr;
  Status statuss = Status.Uninitialized;
  Status get status => statuss;
  User get user => userr;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.authStateChanges().listen(onStateChanged);
  }

  Future<bool> signIn(String email, String password)async{
    try{
      statuss = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }catch(e){
      statuss = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }


  Future<bool> signUp(String name,String email, String password)async{
    try{
      statuss = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user){
        firestore.collection('users').doc(userr.uid).set({
          'name':name,
          'email':email,
          'uid':userr.uid
        });
      });
      return true;
    }catch(e){
      statuss = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    _auth.signOut();
    statuss = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }



  Future<void> onStateChanged(User user) async{
    if(user == null){
      statuss = Status.Unauthenticated;
    }else{
      userr = user;
      statuss = Status.Authenticated;
    }
    notifyListeners();
  }

}