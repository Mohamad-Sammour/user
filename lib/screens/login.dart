import 'package:flutter/material.dart';
import 'package:on_baleh_user/provider/user_provider.dart';
import 'package:on_baleh_user/screens/signup.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();

  final TextEditingController _controllerPass = TextEditingController();

  bool hideShow = true;

  Icon hideShowIcon = const Icon(Icons.remove_red_eye);

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _key,
        body: user.status == Status.Authenticating
            ? const Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.purple,
              ))
            : Stack(
                children: [
                  Center(
                    child: Container(
                      width: 330,
                      height: 650,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius:
                                20.0, // has the effect of softening the shadow
                          )
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset("images/logo.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: ListTile(
                                    leading:
                                        const Icon(Icons.alternate_email_outlined),
                                    title: TextFormField(
                                      controller: _controllerEmail,
                                      decoration: const InputDecoration(
                                          hintText: "Email",
                                          border: InputBorder.none),
                                      validator: (value) {
                                        Pattern pattern =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                        RegExp regex = RegExp(pattern);
                                        if (value.isNotEmpty) {
                                          if (!regex.hasMatch(value)) {
                                            return 'Please make sure your\nemail address is valid';
                                          } else {
                                            return null;
                                          }
                                        }
                                        return 'The email field\ncannot be empty';
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: ListTile(
                                    title: TextFormField(
                                        controller: _controllerPass,
                                        obscureText: hideShow,
                                        decoration: const InputDecoration(
                                          hintText: "Password",
                                          icon: Icon(Icons.lock_open_outlined),
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "The password field\ncannot be empty";
                                          } else if (value.length < 6) {
                                            return "the password has to be at\nleast 6 characters long";
                                          }
                                          return null;
                                        }),
                                    trailing: IconButton(
                                      icon: hideShowIcon,
                                      onPressed: () {
                                        if (hideShow == true) {
                                          setState(() {
                                            hideShow = false;
                                            hideShowIcon =
                                                const Icon(Icons.visibility_off);
                                          });
                                        } else if (hideShow == false) {
                                          setState(() {
                                            hideShow = true;
                                            hideShowIcon =
                                                const Icon(Icons.visibility);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, right: 14.0, left: 14),
                              child: Material(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(20.0),
                                child: MaterialButton(
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (!await user.signIn(
                                          _controllerEmail.text,
                                          _controllerPass.text)) {
                                        _key.currentState.showSnackBar(const SnackBar(
                                            content: Text("Sign in failed")));
                                        return;
                                      }
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()));
                                    }
                                  },
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: InkWell(
                                  child: const Text("Create an account"),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SignUp()));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
