import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/model/restaurant/category_meal_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/category_restaurant_model.dart';


typedef void IntCallBack(CategoryMealRestaurantModel val);

class DrawerCategory extends StatefulWidget {

  DrawerCategory({this.callback, this.categories, key}) : super(key: key);

  final IntCallBack callback;

  final List<CategoryMealRestaurantModel> categories;

  @override
  _DrawerCategoryState createState() => _DrawerCategoryState();
}


class _DrawerCategoryState extends State<DrawerCategory> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 500,
      height: size.width,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: GridView.builder(
          shrinkWrap: false,
          scrollDirection: Axis.vertical,
          itemCount: widget.categories.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
              },
              child: Card(
                child: new Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                          widget.callback(widget.categories[index]);
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 120,
                        child: Text( widget.categories[index].categoryName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            )),
                      ),
                    )
                ),
              ),
            );
          }),
    );
  }
}
