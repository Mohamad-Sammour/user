import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("About",style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.purple.withOpacity(0.5)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This application is a graduation project for students of AlZaytoonah University of Jordan,\nLaith Tannirah, Mohamad Al-Hmouz, Mohamad Sammour and Zaina Assaf.\nFrom the departments of Software Engineering and Computer Science,\nUnder the supervision of Dr. Hani Mimi.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 19,
                    height: 3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
