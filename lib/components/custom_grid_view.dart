import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/model/restaurant/product_restaurant_model.dart';
import 'package:money2/money2.dart';

typedef void IntCallBack(int val);

class CustomGridView extends StatefulWidget {

  CustomGridView({this.callback, this.combo, key}) : super(key: key);

  final IntCallBack callback;

  final List<ProductRestaurantModel> combo;

  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<CustomGridView> {

  // set an int with value -1 since no card has been selected
  int selectedCard = 0;

  final vnd = Currency.create('VND', 0, symbol: '₫');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        itemCount: widget.combo.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                // ontap of each card, set the defined int to the grid view index
                selectedCard = index;
              });
            },
            child: Card(
              child: new Container(
                  decoration: BoxDecoration(
                    color: selectedCard == index ? Colors.blue : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCard = index;
                        widget.callback(index);
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Container(
                      height: 80,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image:  NetworkImage( "https://nhapi.hongngochospital.vn" + widget.combo[index].imageUrl),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      height: 23,
                      margin: EdgeInsets.only(top: 3, left: 10),
                      child: Text(widget.combo[index].productName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black
                            )),
                      ),
                      Container(
                        height: 20,
                        margin: EdgeInsets.only(left: 10),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 0, right: 5),
                          child:  Align(
                            alignment: Alignment.bottomRight,
                            child: Text( Money.fromInt((widget.combo[index].price), vnd).format('###,### CCC').toString() , style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                            )),
                          ),
                        ),
                      ),
                      ],
                    ),
                  )
              ),
            ),
          );
        });
  }
}
