import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_baleh_user/screens/search_products.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
  final String userId;

   const Search({Key key, @required this.userId}) : super(key: key);
}

class _SearchState extends State<Search> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.blueGrey[300],
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "E.g: formal dress",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blueGrey[300],
                ),
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.blueGrey[300],
                ),
              ),
              maxLines: 1,
              onChanged: (val) => initiateSearch(val),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: name == ''
              ? null
              : FirebaseFirestore.instance
                  .collection('categories')
                  .where("name", isGreaterThanOrEqualTo: name)
                  .orderBy('name', descending: false)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data.docs.map((DocumentSnapshot document) {
                    return ListTile(
                      title: Text(document['name']),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchProducts(
                                      userId: widget.userId,
                                      category: document['name'],
                                    )));
                      },
                    );
                  }).toList(),
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.trim();
    });
  }
}
