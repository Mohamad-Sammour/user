import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:on_baleh_user/database/users.dart';
import 'package:on_baleh_user/provider/user_provider.dart';
import 'login.dart';

class Setting extends StatefulWidget {
  final String uid;

  const Setting({Key key, this.uid}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    void deleteAccount() async {
      User u = FirebaseAuth.instance.currentUser;
      u.delete();
      user.signOut();
      UserServices _userServices = UserServices();
      await _userServices.deleteUser(widget.uid);
      user.onStateChanged(u);

      FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      });
    }

    void _confirmDeleteAccount(BuildContext context) {
      var alert = AlertDialog(
        content: const Form(
          child: Text(
            'Are you sure to delete your account?',
            style: TextStyle(color: Colors.red),
          ),
          autovalidateMode: AutovalidateMode.always,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
            color: Colors.green,
          ),
          FlatButton(
            onPressed: () {
              deleteAccount();
            },
            child: const Text('Yes'),
            color: Colors.red,
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 20.0,
      );

      showDialog(context: context, builder: (context) => alert);
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Setting",style: TextStyle(fontSize: 25),),
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.withOpacity(0.7)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Warning You may lose your data if you delete your account",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      onPressed: () {
                        _confirmDeleteAccount(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          "Delete my account",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      color: Colors.red.shade900,
                      height: 50,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
