import 'package:flutter/material.dart';
import 'package:on_baleh_user/provider/user_provider.dart';
import 'package:on_baleh_user/screens/homepage.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _controllerEmail = TextEditingController();

  final TextEditingController _controllerPass = TextEditingController();

  final TextEditingController _controllerFullName = TextEditingController();

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
                              child: Image.asset("images/logo.png", height: MediaQuery.of(context).size.width/1.5),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: ListTile(
                                    leading: const Icon(Icons.person_outline),
                                    title: TextFormField(
                                      controller: _controllerFullName,
                                      decoration: const InputDecoration(
                                          hintText: "Full Name",
                                          border: InputBorder.none),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "The name field cannot be empty";
                                          }
                                          return null;
                                        }
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:const EdgeInsets.symmetric(horizontal: 16 , vertical: 16),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: ListTile(
                                    leading: const Icon(Icons.alternate_email_outlined),
                                    title: TextFormField(
                                      controller: _controllerEmail,
                                      decoration: const InputDecoration(
                                          hintText: "Email",
                                          border: InputBorder.none),
                                      validator: (value) {
                                        Pattern pattern =
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
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
                              padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 0),
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
                                          return "The password field cannot be empty";
                                        } else if (value.length < 6) {
                                          return "the password has to be at least 6 characters long";
                                        }
                                        return null;
                                      },
                                    ),
                                    trailing: IconButton(
                                      icon: hideShowIcon,
                                      onPressed: () {
                                        if (hideShow == true) {
                                          setState(() {
                                            hideShow = false;
                                            hideShowIcon = const Icon(Icons.dangerous);
                                          });
                                        } else if (hideShow == false) {
                                          setState(() {
                                            hideShow = true;
                                            hideShowIcon =
                                                const Icon(Icons.remove_red_eye);
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
                                  top: 16.0, bottom: 8.0, right: 14.0, left: 14),
                              child: Material(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(20.0),
                                child: MaterialButton(
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (!await user.signUp(_controllerFullName.text,
                                          _controllerEmail.text, _controllerPass.text)) {
                                        _key.currentState.showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Sign up failed")));
                                        return;
                                      }
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: InkWell(
                                  child: const Text(
                                    "I already have an account",
                                    style: TextStyle(
                                        color: Colors.purple,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
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
