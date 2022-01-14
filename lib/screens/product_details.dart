import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_baleh_user/database/carts.dart';
import 'package:on_baleh_user/database/products.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  final String name;
  final double price;
  final String picture;
  final List<dynamic> colors;
  final List<dynamic> sizes;
  final String brand;
  final String category;
  final List<dynamic> favoriteStatus;
  final String userId;

  const ProductDetails(
      {Key key,
      this.productId,
      this.name,
      this.price,
      this.picture,
      this.colors,
      this.sizes,
      this.brand,
      this.category,
      this.userId,
      this.favoriteStatus})
      : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  IconData favoriteIcon;

  String itemColorSelected = "Select color";
  String itemSizeSelected = "Select size";
  int qtyCount = 1;
  CartService _cartService = CartService();
  ProductsService _productsService = ProductsService();

  List<String> colorsList = [];
  List<String> sizesList = [];
  List<String> favoriteUsers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Product details"),
        backgroundColor: Colors.purple,
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  validateAndUploadCart();
                },
                color: Colors.purple,
                child: Text("Add to cart"),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(favoriteIcon),
                onPressed: () {
                  setState(() {
                    if (favoriteIcon == Icons.favorite_border) {
                      if(!favoriteUsers.contains(widget.userId)) {
                        favoriteIcon = Icons.favorite;
                        favoriteUsers.add(widget.userId);
                        _productsService.updateFavoriteStatus(
                            widget.productId, {'favorite': favoriteUsers});
                      }
                    } else if (favoriteIcon == Icons.favorite) {
                      if(favoriteUsers.contains(widget.userId)) {
                        favoriteIcon = Icons.favorite_border;
                        favoriteUsers.remove(widget.userId);
                        _productsService.updateFavoriteStatus(
                            widget.productId, {'favorite': favoriteUsers});
                      }
                      Fluttertoast.showToast(
                          msg: 'Product deleted from favorite list ..',
                          backgroundColor: Colors.purple,
                          fontSize: 15.5,
                          gravity: ToastGravity.CENTER,
                          textColor: Colors.black,);

                    }
                  });
                },
                color: Colors.purple,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                child: Image.network(
                  widget.picture,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width - 100,
                  width: MediaQuery.of(context).size.width,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width - 150,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(blurRadius: 14)]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("\$ ${widget.price}",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AwesomeDropDown(
                  dropDownList: widget.colors.cast<String>().toList(),
                  dropDownIcon: Icon(Icons.color_lens,color: Colors.purple,),
                  selectedItem: itemColorSelected,
                  numOfListItemToShow: 10,
                  onDropDownItemClick: (isClicked) {
                    setState(() {
                      itemColorSelected = isClicked;
                    });
                  },
                ),
                AwesomeDropDown(
                  dropDownList: widget.sizes.cast<String>().toList(),
                  dropDownIcon: Icon(Icons.photo_size_select_large_sharp,color: Colors.purple,),
                  selectedItem: itemSizeSelected,
                  numOfListItemToShow: 6,
                  onDropDownItemClick: (isClicked) {
                    setState(() {
                      itemSizeSelected = isClicked;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Qty : ",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_left,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                if (qtyCount > 1) qtyCount--;
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          qtyCount.toString(),
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_right,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                if (qtyCount < 10) qtyCount++;
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.purple,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Brand:",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                Text(widget.brand,
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                SizedBox(
                  width: 60,
                ),
                Text("Category:",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                Text(widget.category,
                    style: TextStyle(color: Colors.black, fontSize: 18))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    setState(() {
      favoriteUsers = widget.favoriteStatus.cast<String>().toList();
    });
    if (favoriteUsers.contains(widget.userId))
      favoriteIcon = Icons.favorite;
    else
      favoriteIcon = Icons.favorite_border;
  }

  void validateAndUploadCart() async {
    setState(() => CircularProgressIndicator(
      backgroundColor: Colors.purple,
    ));
    if ( !itemColorSelected.contains("Select color")) {
      if (!itemSizeSelected.contains("Select size")) {
        _cartService.uploadCart({
          "name": widget.name,
          'user_id': widget.userId,
          'product_id': widget.productId,
          "price_qty": widget.price * qtyCount,
          "price": widget.price,
          "size": itemSizeSelected,
          "color": itemColorSelected,
          "picture": widget.picture,
          "quantity": qtyCount,
          "cart_status": false
        });
        Fluttertoast.showToast(
            msg: 'Product added ..',
            backgroundColor: Colors.purple,
            fontSize: 15.5,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
        setState(() => CircularProgressIndicator(
          backgroundColor: Colors.purple,
        ));
        Navigator.pop(context);
      } else {
        setState(() => CircularProgressIndicator(
          backgroundColor: Colors.purple,
        ));
        Fluttertoast.showToast(
            msg: 'Please select size !',
            backgroundColor: Colors.purple,
            fontSize: 15.5,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      }
    } else {
      setState(() => CircularProgressIndicator(
        backgroundColor: Colors.purple,
      ));
      Fluttertoast.showToast(
          msg: 'Please select color !',
          backgroundColor: Colors.purple,
          fontSize: 15.5,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
    }
  }
}
