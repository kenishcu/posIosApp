import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/model/restaurant/category_meal_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/category_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/product_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/model/table/table_model.dart';
import 'package:pos_ios_bvhn/model/user/user_model.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/service/restaurant_service.dart';
import 'package:provider/provider.dart';
import 'package:money2/money2.dart';

import '../../constants.dart';

class HomeScreen extends StatefulWidget {

  final TableModel table;

  List<bool> _canLoadMores = [];

  HomeScreen({Key key,@required this.table}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  bool _loading = false;

  bool selected = false;

  int _value;

  // tab controller
  TabController _tabController;

  ScrollController _scrollController;

  List<bool> _canLoadMores = [];

  List<List<ProductRestaurantModel>> listTabsView = [];

  List<List<CategoryMealRestaurantModel>> listTabsCategories = [];

  List<TextEditingController> listTextController = [];

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  double _scrollPosition;

  List<ItemProduct> _items = [];

  RestaurantService restaurantService = new RestaurantService();

  final vnd = Currency.create('VND', 0, symbol: '₫');

  // list categories restaurant
  List<CategoryRestaurantModel> categories = [
    CategoryRestaurantModel("1050100000000000000", "nha_bep", "Nhà bếp"),
    CategoryRestaurantModel("1050600000000000000", "quay_bar", "Quầy bar"),
    CategoryRestaurantModel("1050800000000000000", "quay_banh", "Quầy bánh"),
  ];

  // list header tab bar view
  List<Widget> listWidget = [
  ];

  @override
  void initState() {

    setState(() {
      _loading = true;
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
    initDataRestaurant();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future initDataRestaurant() async {

    String branchId = Provider.of<SettingProvider>(context, listen: false).userInfo.branchId;

    _tabController = TabController(length: categories.length, vsync: this);

    categories.forEach((element) async {

      _canLoadMores.add(false);

      setState(() {
        listWidget.add(new Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
          ),
          child:  Align(
            alignment: Alignment.center,
            child: Text( element.categoryName, style: TextStyle(
                color: PrimaryGreyColor
            )),
          ),
        ));
      });

      TextEditingController _nodeController = new TextEditingController();

      listTextController.add(_nodeController);

      // get all products
      ResultModel resProduct = await restaurantService.getProductsByParams(branchId , element.categoryId, '', "", 1, 50);

      if(resProduct.status && resProduct.data != null && resProduct.data.length > 0) {
        List<ProductRestaurantModel> products = [];

        for(int i = 0; i < resProduct.data.length; i++) {
          setState(() {
            products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
          });
        }
        List<ProductRestaurantModel> pro = products;
        listTabsView.add(pro);
        } else {
        listTabsView.add([]);
       }

      // get all categories
      ResultModel resCategories = await restaurantService.getCategoryRestaurantById(branchId, element.categoryId);
      if(resCategories.status && resCategories.data != null && resCategories.data.length > 0) {
        List<CategoryMealRestaurantModel> categories = [];
        for(int i = 0; i < resCategories.data.length - 1; i++) {
          setState(() {
            categories.add(CategoryMealRestaurantModel.fromJson(resCategories.data[i]));
          });
        }
        listTabsCategories.add(categories);
      } else {
        listTabsCategories.add([]);
      }
    });
    setState(() {
      _loading = false;
      print(listTabsCategories.length);
    });
  }

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  // TODO: build widget for view in every tab bar
  Widget _buildAnyWidgets(BuildContext context, i) {

    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: size.width * 0.5,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 0.2),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black, width: 2.0),
//                    color: kGreen,
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selected = !selected;
                      });
                    },
                    child: selected ? Icon(
                      Icons.remove,
                      color: Colors.black,
                    ):  Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedContainer(
            width: selected ? size.width * 0.7 : 0.0,
            height: selected ? 50.0 : 0.0,
            duration: Duration(seconds: 1),
            padding: EdgeInsets.all(5),
            curve: Curves.fastOutSlowIn,
            child: Container(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    listTabsCategories != null && listTabsCategories.length > 0 && i < listTabsCategories.length != null ? Container(
                      margin: EdgeInsets.only(top: 5, right: 10),
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: PrimaryGreenLightColor
                          )
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _scrollController.animateTo(_scrollPosition <= 400 ? 0 : _scrollPosition - 400, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 30,
                          color: PrimaryGreenLightColor,
                        ),
                      ),
                    ) : Container(),
                    listTabsCategories != null && listTabsCategories.length > 0 && i < listTabsCategories.length != null ? Expanded (
                      child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:  listTabsCategories[i].length,
                          itemBuilder: (BuildContext context, int index) => Container(
                            margin: EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              label: Text(listTabsCategories[i][index].categoryName),
                              selected: _value == index,
                              onSelected: (bool selected) {
                                setState(() {
                                });
                              },

                            ),
                          )),
                    ) : Container(),
                    listTabsCategories != null && listTabsCategories.length > 0 && i < listTabsCategories.length != null ? Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: PrimaryGreenLightColor
                          )
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _scrollController.animateTo(_scrollPosition != null  ? _scrollPosition + 400 : 400, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          color: PrimaryGreenLightColor,
                        ),
                      ),
                    ) : Container(),
                  ]
              ),
            ),
          ),
          AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              height: selected ? size.height - 240 : size.height - 200,
              margin: EdgeInsets.only(top: 10),
              width: size.width * 0.7,
              decoration: BoxDecoration(
                color: Color(0xfff7f7f7),
//              border: Border.all()
              ),
              child: NotificationListener(
                onNotification: (ScrollNotification scrollInfo) {
//                  if (!isLoading && scrollInfo.metrics.pixels ==
//                      scrollInfo.metrics.maxScrollExtent) {
////                   start loading data
//                    _loadData(i);
//                  }
                  return true;
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                        padding: EdgeInsets.all(1.0),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            ///no.of items in the horizontal axis
                            crossAxisCount: 4,
                            childAspectRatio: 0.96,
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          ),
                          ///Lazy building of list
                          delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                /// To convert this infinite list to a list with "n" no of items,
                                /// uncomment the following line:
                                /// if (index > n) return null;
                                return Card(
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
                                            int cnt;
                                            if( _items !=null && _items.length > 0) {
                                              for(int j = 0; j< _items.length; j++) {
                                                if(listTabsView[i][index].id.toString() == _items[j].id.toString()) {
                                                  cnt = j;
                                                }
                                              }
                                              if(cnt == null) {
                                                listKey.currentState.insertItem(0,
                                                    duration: const Duration(
                                                        milliseconds: 500));
                                                final item = new ItemProduct(listTabsView[i][index].id.toString() ,listTabsView[i][index], 1);
                                                _items = []
                                                  ..add(item)
                                                  ..addAll(_items);
                                              } else {
                                                _items[cnt].number = _items[cnt].number + 1;
                                                _items = []..addAll(_items);
                                              }
                                            } else {
                                              listKey.currentState.insertItem(0,
                                                  duration: const Duration(
                                                      milliseconds: 500));
                                              final item = new ItemProduct(listTabsView[i][index].id.toString(), listTabsView[i][index], 1);
                                              _items = []
                                                ..add(item)
                                                ..addAll(_items);
                                            }
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
                                                  image:  NetworkImage( "https://nhapi.hongngochospital.vn" + listTabsView[i][index].imageUrl),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 23,
                                              margin: EdgeInsets.only(top: 3, left: 10),
                                              child: Text(listTabsView[i][index].productName,
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
                                                  child: Text( Money.fromInt((listTabsView[i][index].price), vnd).format('###,### CCC').toString() , style: TextStyle(
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
                                );
                              },
                              childCount: listTabsView[i].length
                            /// Set childCount to limit no.of items
                            /// childCount: 100,
                          ),
                        )
                    ),
                    SliverToBoxAdapter(
                      child: _canLoadMores[i]
                          ? Container(
                        padding: EdgeInsets.only(bottom: 16),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                          : SizedBox(),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  // TODO:
  Widget _buildItem(BuildContext context, int index, animation) {
    ItemProduct item = _items[index];
    Size size = MediaQuery.of(context).size;
    return SlideTransition(
      position: Tween<Offset>(
          begin: Offset(0.0, 1.0),
          end: Offset(0.0, 0.0)
      ).animate(animation),
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Container(
          width: size.width * 0.3,
          decoration: BoxDecoration(
            color: kPrimaryLightColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 30,
                  width: size.width * 0.3,
                  child: Container(
                      height: 30,
                      padding: EdgeInsets.only(left: 4),
                      width: size.width * 0.3 - 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(item != null && item.product != null ? item.product.productName : '' ,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 17
                            )),
                      )
                  )
              ),
              Container(
                height: 40,
                width: size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: size.width * 0.13,
                      padding: EdgeInsets.only(left: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text( Money.fromInt((item.product.price * item.number), vnd).format('###,### CCC').toString() , style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                        )),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: PrimaryGreenColor
                        )
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if(_items[index].number > 1) {
                              _items[index].number = _items[index].number -1;
                              _items = []..addAll(_items);
                            } else {
                              if (_items.length == 1) {
                                listKey.currentState.removeItem(
                                    0, (BuildContext context,
                                    Animation<double> animation) {
                                  return Container();
                                });
                                _items.removeAt(0);
                                return;
                              } else {
                                listKey.currentState.removeItem(
                                    index,
                                        (_, animation) =>
                                        _buildItem(context, 0, animation),
                                    duration: const Duration(milliseconds: 200)
                                );
                                _items.removeAt(index);
                              }
                            }
                          });
                        },
                        child:  Icon(
                          Icons.remove,
                          size: 20,
                          color: PrimaryGreenColor,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 50,
                      decoration: BoxDecoration(
                        color: PrimaryGreenColor,
                      ),
                      child: Center(
                        child: Text(item != null && item.number != null ? item.number.toString(): '' , style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        )),
                      ),
                    ),
                    Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: PrimaryGreenColor
                            )
                        ),
                        child: Container(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _items[index].number = _items[index].number + 1;
                                _items = []..addAll(_items);
                              });
                            },
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: PrimaryGreenColor,
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget loading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    UserModel userInfo  =  Provider.of<SettingProvider>(context, listen: false).userInfo;

    // TODO: implement build
    return _loading ? loading() : Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF848a93),),
        backgroundColor: Color(0xFFf4f5f7),
        title: Container(
          child: Row(
            children: [
              Container(
                child: Icon(
                  Icons.fastfood,
                  color: Color(0xFF848a93),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Đặt món", style: TextStyle( color: Color(0xFF848a93),)),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
//              borderRadius: BorderRadius.only(
//                topRight: Radius.circular(10.0),
//                bottomRight:  Radius.circular(10.0),
//              ),
              color: Color(0xFF0e1e2b)
          ),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        child: Text("Tài khoản : ${userInfo.userName}", style: TextStyle(
                            color: Colors.white
                        )),
                      ),
                      Container(
                        height: 40,
                        child: Text("Quyền ${userInfo.roleName}, Chi nhánh ${userInfo.branchName}", style: TextStyle(
                            color: Color(0xFF848b92)
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF0e1e2b)
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.repeat,
                    color: Colors.white,
                  ),
                  title: Text('Chọn chi nhánh', style: TextStyle(
                    color: Colors.white,
                  )),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF0e1e2b)
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text('Đăng xuất', style: TextStyle(
                    color: Colors.white,
                  )),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: _loading ? loading() : SingleChildScrollView(
        child: Container(
          height: size.height - 50,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff7f7f7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: DefaultTabController(
                    length: categories.length,
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(50),
                        child: new Container(
                          color: Color(0xfff7f7f7),
                          child: new SafeArea(
                            child: Column(
                              children: <Widget>[
                                new TabBar(
                                  indicatorColor: PrimaryGreenColor,
                                  tabs: listWidget.toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: new TabBarView(
//                          controller: _tabController,
                          children: List.generate(
                            categories.length , (index) => _buildAnyWidgets(context, index),
                          )
                      ),
                    ),
                  ),
                ),
                flex: 4,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff7f7f7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                        ),
                        height: 50,
                        width: size.width * 0.4,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(
                                Icons.table_view_outlined
                              ),
                            ),
                            Container(
                              child: Text(" Bàn 1", style: TextStyle(
                                fontWeight: FontWeight.bold
                              )),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: size.height - 240,
                        decoration: BoxDecoration(
                        ),
                        child: Scrollbar(
                          child: Container(
                            height: double.infinity,
                            child: new AnimatedList(
                              key: listKey,
                              initialItemCount: _items.length,
                              itemBuilder: (context, index, animation) {
                                return _buildItem(context, index, animation);
                              },
                            ),
                          ),
                        )
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.redAccent
                        ),
                        child: TextButton(
                          onPressed: () {  },
                          child: Text("HỦY ĐẶT", style: TextStyle(
                            color: Colors.white
                          )),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: PrimaryGreenColor
                        ),
                        child: TextButton(
                          onPressed: () {  },
                          child: Text("ĐẶT MÓN", style: TextStyle(
                              color: Colors.white
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ItemProduct {
  String _id;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  ProductRestaurantModel _product;
  int _number;

  int get number => _number;

  set number(int value) {
    _number = value;
  }


  ItemProduct(this._id, this._product, this._number);

  ProductRestaurantModel get product => _product;

  set product(ProductRestaurantModel value) {
    _product = value;
  }

}
