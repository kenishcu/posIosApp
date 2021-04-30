import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_ios_bvhn/components/drawer.dart';
import 'package:pos_ios_bvhn/model/restaurant/category_meal_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/category_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/commission_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/order_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/product_order_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/product_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/model/table/table_model.dart';
import 'package:pos_ios_bvhn/model/user/user_model.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/service/restaurant_service.dart';
import 'package:pos_ios_bvhn/ui/home/table_screen.dart';
import 'package:provider/provider.dart';
import 'package:money2/money2.dart';

import '../../constants.dart';

class HomeScreen extends StatefulWidget {

  final TableModel table;

  HomeScreen({Key key,@required this.table}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin, TickerProviderStateMixin{

  bool _loading = false;

  bool _isLoading = false;

  bool selected = false;

  int _value;

  // tab controller
  TabController _tabController;

  ScrollController _scrollController;

  List<bool> _canLoadMores = [];

  List<List<ProductRestaurantModel>> listTabsView = [];

  List<List<CategoryMealRestaurantModel>> listTabsCategories = [];

  List<TextEditingController> listTextController = [];

  TextEditingController _nodeTextController =  new TextEditingController();

  CategoryMealRestaurantModel selectedCategoryMealRestaurant;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  double _scrollPosition;

  List<ItemProduct> _items = [];

  RestaurantService restaurantService = new RestaurantService();

  TextEditingController emailController =  new TextEditingController();

  TextEditingController discountController =  new TextEditingController();

  TextEditingController priceController =  new TextEditingController();

  TextEditingController noteController =  new TextEditingController();

  // editing for tax and service fee
  TextEditingController taxController =  new TextEditingController();

  TextEditingController feeServiceController =  new TextEditingController();

  // editing for commission
  TextEditingController receiveController = new TextEditingController();

  TextEditingController customerController = new TextEditingController();

  TextEditingController commissionController = new TextEditingController();

  TextEditingController noteCommissionController = new TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black26);

  final vnd = Currency.create('VND', 0, symbol: '₫');

  CommissionRestaurantModel _commission;

  // list categories restaurant
  List<CategoryRestaurantModel> categories = [
    CategoryRestaurantModel("1050100000000000000", "nha_bep", "Nhà bếp"),
    CategoryRestaurantModel("1050600000000000000", "quay_bar", "Quầy bar"),
    CategoryRestaurantModel("1050800000000000000", "quay_banh", "Quầy bánh"),
  ];

  // list header tab bar view
  List<Widget> listWidget = [
  ];

  FToast fToast;

  final _formKey = GlobalKey<FormState>();

  OrderRestaurantModel _order;

  @override
  void initState() {

    setState(() {
      _loading = true;
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);


    fToast = FToast();
    fToast.init(context);

    super.initState();
    initDataRestaurant();
    initTableData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    commissionController.dispose();
    receiveController.dispose();
    customerController.dispose();
    noteCommissionController.dispose();
    discountController.dispose();
    taxController.dispose();
    feeServiceController.dispose();
    super.dispose();
  }

  Future initDataRestaurant() async {

    String branchId = Provider.of<SettingProvider>(context, listen: false).userInfo.branchId;

    _tabController = TabController(length: categories.length, vsync: this);

    categories.forEach((element) async {

      _canLoadMores.add(false);

      if(element.categoryCode == "nha_bep") {

        print("Nha bep");
        TextEditingController _nodeController = new TextEditingController();

        listTextController.add(_nodeController);

        // get all products
        ResultModel resProduct = await restaurantService.getProductsByParams(branchId , element.categoryId, '', "", 1, 50);

        if(resProduct.status && resProduct.data != null && resProduct.data.length > 0) {
          List<ProductRestaurantModel> products = [];

          for(int i = 0; i < resProduct.data.length; i++) {
            setState(() {
              ProductRestaurantModel product = ProductRestaurantModel.fromJson(resProduct.data[i]);
              // if(product.status == 1) {
              //   products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
              // }
              products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
            });
          }
          setState(() {
            List<ProductRestaurantModel> pro = products;

            if(listTabsView.length >= 1) {
              listTabsView.insert(0, pro);
            } else {
              listTabsView.add(pro);
            }
          });
        } else {
          setState(() {
            if(listTabsView.length >= 1) {
              listTabsView.insert(0, []);
            } else {
              listTabsView.add([]);
            }
          });
        }

        setState(() {
          listWidget.add(new Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            child:  Align(
              alignment: Alignment.center,
              child: Text( element.categoryName, style: TextStyle(
                  color: PrimaryGreyColor,
                  fontSize: 18
              )),
            ),
          ));
        });
      } else if(element.categoryCode == "quay_bar") {
        TextEditingController _nodeController = new TextEditingController();

        listTextController.add(_nodeController);

        // get all products
        ResultModel resProduct = await restaurantService.getProductsByParams(branchId , element.categoryId, '', "", 1, 50);

        if(resProduct.status && resProduct.data != null && resProduct.data.length > 0) {
          List<ProductRestaurantModel> products = [];

          for(int i = 0; i < resProduct.data.length; i++) {
            setState(() {
              ProductRestaurantModel product = ProductRestaurantModel.fromJson(resProduct.data[i]);
              // if(product.status == 1) {
              //   products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
              // }
              products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
            });
          }
          setState(() {
            List<ProductRestaurantModel> pro = products;

            if(listTabsView.length >= 2) {
              listTabsView.insert(1, pro);
            } else {
              listTabsView.add(pro);
            }
          });
        } else {
          setState(() {
            if(listTabsView.length >= 2) {
              listTabsView.insert(1, []);
            } else {
              listTabsView.add([]);
            }
          });
        }

        setState(() {
          listWidget.add(new Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            child:  Align(
              alignment: Alignment.center,
              child: Text( element.categoryName, style: TextStyle(
                  color: PrimaryGreyColor,
                  fontSize: 18
              )),
            ),
          ));
        });
      } else if(element.categoryCode == "quay_banh") {
        TextEditingController _nodeController = new TextEditingController();

        listTextController.add(_nodeController);

        // get all products
        ResultModel resProduct = await restaurantService.getProductsByParams(branchId , element.categoryId, '', "", 1, 50);

        if(resProduct.status && resProduct.data != null && resProduct.data.length > 0) {
          List<ProductRestaurantModel> products = [];

          for(int i = 0; i < resProduct.data.length; i++) {
            setState(() {
              ProductRestaurantModel product = ProductRestaurantModel.fromJson(resProduct.data[i]);
              // if(product.status == 1) {
              //   products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
              // }
              products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
            });
          }
          List<ProductRestaurantModel> pro = products;

          if(listTabsView.length >= 3) {
            listTabsView.insert(2, pro);
          } else {
            listTabsView.add(pro);
          }
          setState(() {});
        } else {
          if(listTabsView.length >= 3) {
            listTabsView.insert(2, []);
          } else {
            listTabsView.add([]);
          }
          setState(() {});
        }

        setState(() {
          listWidget.add(new Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            child:  Align(
              alignment: Alignment.center,
              child: Text( element.categoryName, style: TextStyle(
                  color: PrimaryGreyColor,
                  fontSize: 18
              )),
            ),
          ));
        });
      } else {
        TextEditingController _nodeController = new TextEditingController();

        listTextController.add(_nodeController);

        // get all products
        ResultModel resProduct = await restaurantService.getProductsByParams(branchId , element.categoryId, '', "", 1, 50);

        if(resProduct.status && resProduct.data != null && resProduct.data.length > 0) {
          List<ProductRestaurantModel> products = [];

          for(int i = 0; i < resProduct.data.length; i++) {
            setState(() {
              ProductRestaurantModel product = ProductRestaurantModel.fromJson(resProduct.data[i]);
              // if(product.status == 1) {
              //   products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
              // }
              products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
            });
          }
          List<ProductRestaurantModel> pro = products;
          listTabsView.add(pro);
          setState(() {});
        } else {
          listTabsView.add([]);
          setState(() {});
        }

        setState(() {
          listWidget.add(new Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
            ),
            child:  Align(
              alignment: Alignment.center,
              child: Text( element.categoryName, style: TextStyle(
                  color: PrimaryGreyColor,
                  fontSize: 18
              )),
            ),
          ));
        });
      }

      // get all categories
      ResultModel resCategories = await restaurantService.getCategoryRestaurantByParams(branchId, element.categoryId, '', 1);
      if(resCategories.status && resCategories.data != null && resCategories.data.length > 0) {
        List<CategoryMealRestaurantModel> categories = [];
        for(int i = 0; i < resCategories.data.length - 1; i++) {
          setState(() {
            CategoryMealRestaurantModel category = CategoryMealRestaurantModel.fromJson(resCategories.data[i]);
            if(category.status == 1) {
              categories.add(category);
            }
          });
        }
        listTabsCategories.add(categories);
      } else {
        listTabsCategories.add([]);
      }
    });
    var future = new Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _loading = false;
      });
    });
  }

  Future initTableData() async {

    String tableId = widget.table.id;

    ResultModel res = await restaurantService.getOrderByTable(tableId);

    if(res.status) {
      setState(() {
        this._order = OrderRestaurantModel.fromJson(res.data[0]);
        _commission = this._order.commissionRestaurantModel;

        // set _items to list payments
        if (this._order.products != null && this._order.products.length > 0) {
          for(int i = 0; i < this._order.products.length; i++) {

            final item = new ItemProduct( this._order.products[i].id, this._order.products[i], this._order.products[i].quantity);
            setState(() {
              _items = []
                ..add(item)
                ..addAll(_items);
            });
          }
        }
      });
    } else {
      UserModel user = Provider.of<SettingProvider>(context, listen: false).userInfo;
      DateTime now = DateTime.now();
      int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
      setState(() {
        _commission = new CommissionRestaurantModel("", "", "", 0);
        _order = new OrderRestaurantModel(user.branchId, user.branchName, user.branchCode,
            _commission, 0, 0, 0,
            "CASH", [], null, 0,
            0, "CHECKIN", widget.table, 0, 0, timeOrder);
      });
    }
  }

  Future<void> _showDialogEdit (ItemProduct item) async {

    Size size = MediaQuery.of(context).size;

    final amountField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Số lượng", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: emailController,
                style: style,
                decoration: InputDecoration(
                    hintText: "Điền sl...",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final discountField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Giảm giá/SP", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: discountController,
                style: style,
                decoration: InputDecoration(
                    hintText: "...",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final priceField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Giá tiền", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: priceController,
                style: style,
                decoration: InputDecoration(
                    hintText: "...",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final noteField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Ghi chú", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: noteController,
                style: style,
                decoration: InputDecoration(
                    hintText: "...",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final updateButton = Container(
      margin: EdgeInsets.only(top: 10, left: 680),
      height: 50,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: PrimaryGreenLightColor
      ),
      child: TextButton(
        onPressed: () async {
        },
        child: Text("Cập nhật",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 14,
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10.0),
            child: Container(
              height: size.height * 0.6,
              width: size.width * 0.8,
              padding: EdgeInsets.only(top: 20 , left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Container(
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              child: Text("Ghi chú sản phẩm", style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )),
                            ),
                            amountField,
                            discountField,
                            priceField,
                            noteField,
                            updateButton
                          ],
                        ),
                      ),
                    )
                  ),
                )
              ),
            ),
          );
        });
  }

  Future<void> _showDialogEditTax() async {

    setState(() {
      taxController.text = _order.taxRate.toString();
      feeServiceController.text = _order.serviceCharge.toString();
    });

    Size size = MediaQuery.of(context).size;

    final taxField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Thuế (%)", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: taxController,
                style: style,
                decoration: InputDecoration(
                    hintText: "0%",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final serviceField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Phí dịch vụ (Số)", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: feeServiceController,
                style: style,
                decoration: InputDecoration(
                    hintText: "...",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10.0),
            child: Container(
              height: size.height * 0.4,
              width: size.width * 0.8,
              padding: EdgeInsets.only(top: 20 , left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Container(
                  child: SingleChildScrollView(
                    child: Center(
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  child: Text("Cập nhật thuế dịch vụ", style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  )),
                                ),
                                taxField,
                                serviceField,
                                Container(
                                  margin: EdgeInsets.only(top: 10, left: 680),
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: PrimaryGreenLightColor
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        int f = feeServiceController != null && feeServiceController.text != "" ? int.parse(feeServiceController.text) : 0;
                                        int t = taxController != null && taxController.text != "" ? int.parse(taxController.text) : 0;
                                        _order.serviceCharge = f;
                                        _order.taxRate = t;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cập nhật",
                                        textAlign: TextAlign.center,
                                        style: style.copyWith(
                                            fontSize: 14,
                                            color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                  )
              ),
            ),
          );
        });
  }

  Future<void> _showCommission() async {

    setState(() {
      receiveController.text = _commission.receiveName;
      customerController.text = _commission.customerName;
      commissionController.text = _commission.rosesPercent.toString();
      noteCommissionController.text = _commission.rosesNote;
    });

    Size size = MediaQuery.of(context).size;

    final receiveField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Người nhận", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: receiveController,
                style: style,
                decoration: InputDecoration(
                    hintText: "",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final customerField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Khách hàng", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: customerController,
                style: style,
                decoration: InputDecoration(
                    hintText: "",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final commissionField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Chi % ( đơn vị %)", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: commissionController,
                style: style,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "0%",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final noteField = Container(
        height: 70,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text("Ghi chú chi % cho ai", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
                obscureText: false,
                controller: noteCommissionController,
                style: style,
                decoration: InputDecoration(
                    hintText: "",
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: PrimaryBlackColor,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10.0),
            child: Container(
              height: size.height * 0.6,
              width: size.width * 0.8,
              padding: EdgeInsets.only(top: 20 , left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Container(
                  child: SingleChildScrollView(
                    child: Center(
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  child: Text("Cập nhật khách hàng, hoa hồng", style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  )),
                                ),
                                receiveField,
                                customerField,
                                commissionField,
                                noteField,
                                Container(
                                  margin: EdgeInsets.only(top: 10, left: 680),
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: PrimaryGreenLightColor
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        _commission.receiveName = receiveController.text;
                                        _commission.customerName = customerController.text;
                                        int c = commissionController != null && commissionController.text != "" ? int.parse(commissionController.text) : 0;
                                        _commission.rosesPercent = c;
                                        _commission.rosesNote = noteCommissionController.text;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cập nhật",
                                        textAlign: TextAlign.center,
                                        style: style.copyWith(
                                            fontSize: 14,
                                            color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                  )
              ),
            ),
          );
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
                  child: TextField(
                    controller: i < listTextController.length - 1 && listTextController[i] != null ? listTextController[i] : _nodeTextController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Tìm kiếm',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.systemGrey,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                    onChanged: (value) => _searchItems(value, i),
                  ),
                ),
                Container(
                  height: 40,
                  width: 45,
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
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: selected ? Icon(
                        Icons.remove,
                        color: Colors.black,
                      ):  Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
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
                      height: 40,
                      width: 50,
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
                        style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              alignment: Alignment.center),
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
                                  _value = selected ? index : null;
                                  _updateProductions(i, listTabsCategories[i][index].categoryId);
                                  setState(() {
                                    selectedCategoryMealRestaurant = listTabsCategories[i][index];
                                  });
                                });
                              },

                            ),
                          )),
                    ) : Container(),
                    listTabsCategories != null && listTabsCategories.length > 0 && i < listTabsCategories.length != null ? Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
                      height: 40,
                      width: 50,
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
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            alignment: Alignment.center),
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
              height: selected ? size.height - 242 : size.height - 204,
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
                                            ProductOrderModel productOrder = new ProductOrderModel(listTabsView[i][index].id,
                                                listTabsView[i][index].productCode, listTabsView[i][index].productName,
                                                listTabsView[i][index].categoryParentId, listTabsView[i][index].categoryParentCode,
                                                listTabsView[i][index].categoryParentName, listTabsView[i][index].categoryId,
                                                listTabsView[i][index].categoryCode, listTabsView[i][index].categoryName,
                                                "CHECKIN",  listTabsView[i][index].price,  listTabsView[i][index].imageUrl,
                                                listTabsView[i][index].combo,  listTabsView[i][index].categoryStatus,
                                                listTabsView[i][index].supplies,  listTabsView[i][index].unitCode,
                                                listTabsView[i][index].unitId, listTabsView[i][index].unitName,
                                                listTabsView[i][index].unitStatus, 0 , '', 0, 0, false, "", 1);
                                            if( _items != null && _items.length > 0) {
                                              for(int j = 0; j< _items.length; j++) {
                                                if(listTabsView[i][index].id.toString() == _items[j].id.toString()) {
                                                  cnt = j;
                                                }
                                              }
                                              if(cnt == null) {
                                                listKey.currentState.insertItem(0,
                                                    duration: const Duration(
                                                        milliseconds: 500));
                                                final item = new ItemProduct(listTabsView[i][index].id.toString() , productOrder, 1);
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
                                              final item = new ItemProduct(listTabsView[i][index].id.toString(), productOrder, 1);
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
    return Container(
      child: SlideTransition(
        position: Tween<Offset>(
            begin: Offset(0.0, 0.0),
            end: Offset(0.0, 0.0)
        ).animate(animation),
        child: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Slidable(
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 0.3,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  setState(() {
                    if(_items.length == 1) {
                      listKey.currentState.removeItem( 0,
                              (BuildContext context, animation) {
                            return Container();
                          });
                      _items.removeAt(0);
                      return;
                    } else {
                      listKey.currentState.removeItem(index,
                              (context, animation) => _buildItem(context, 0, animation),
                          duration: const Duration(milliseconds: 300));
                      _items.removeAt(index);
                    }
                  });
                },
              ),
              Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: PrimaryGreenColor
                  ),
                  child: TextButton(
                    onPressed: () {
                      _showDialogEdit(item);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25, right: 15),
                          child: Text("Edit", style: TextStyle(
                              color: Colors.white
                          )),
                        )
                      ],
                    ),
                  )
              ),
            ],
            child: Container(
              width: size.width * 0.3,
              decoration: BoxDecoration(
              ),
              child:  Container(
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
                              width: size.width * 0.15,
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
          ),
        ),
      ),
    );
  }

  void _updateProductions(int index, String id) async {

    String branchId = Provider.of<SettingProvider>(context, listen: false).userInfo.branchId;

    ResultModel res = await restaurantService.getProductsByParams(branchId, "", id, listTextController[index].text, 1, 50);

    if(res.status && res.data != null && res.data.length > 0) {
      List<ProductRestaurantModel> product = [];
      print('length: ${res.data.length}');
      for(int i = 0; i < res.data.length ; i++) {
        setState(() {
          product.add(ProductRestaurantModel.fromJson(res.data[i]));
        });
      }
      setState(() {
        listTabsView[index].clear();
        listTabsView[index] = []..addAll(product);
      });
    } else {
      setState(() {
        listTabsView[index].clear();
      });
    }
  }

  void _searchItems(String keySearch, int i) async {

    String branchId = Provider.of<SettingProvider>(context, listen: false).userInfo.branchId;

    String categoryId = selectedCategoryMealRestaurant != null ? selectedCategoryMealRestaurant.categoryId : "";

    ResultModel res = await restaurantService.getProductsByParams(branchId, categories[i].categoryId, categoryId, keySearch, 1, 50);

    setState(() {
      if(res.status && res.data != null && res.data.length > 0) {
        List<ProductRestaurantModel> product = [];
        for(int i = 0; i < res.data.length ; i++) {
          setState(() {
            product.add(ProductRestaurantModel.fromJson(res.data[i]));
          });
        }
        setState(() {
          listTabsView[i].clear();
          listTabsView[i] = []..addAll(product);
        });
      } else {
        setState(() {
          listTabsView[i].clear();
        });
      }
    });
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.blue,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Đặt đồ thành công.", style: TextStyle(
            color: Colors.white
          )),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM_RIGHT,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToastError() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Đặt đồ không thành công."),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM_RIGHT,
      toastDuration: Duration(seconds: 2),
    );
  }

  Widget loading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget loadingOrder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    int _total = 0;

    if(_items != null && _items.length > 0) {
      _items.forEach((element) {
        _total += element.product.price * element.number;
      });
    }

    // TODO: implement build
    return _loading ? loading() : Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF848a93),),
        backgroundColor: Color(0xFFf4f5f7),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.fastfood,
                        color: Color(0xFF848a93),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 40),
                      child: Text("Đặt món", style: TextStyle(
                        color: Color(0xFF848a93)),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF848a93),
                    width: 4.0
                  )
                ),
                child: TextButton(
                  onPressed: () {
                    //TODO: go to table screen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TableScreen())
                    );
                  },
                  child: Container(
                    child: Text(
                        "Danh sách bàn",
                        style: TextStyle(
                            color: Color(0xFF848a93),
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerCustom(),
      body: _isLoading ? loadingOrder() : SingleChildScrollView(
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
                        preferredSize: Size.fromHeight(70),
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
                                Icons.table_view_outlined,
                                size: 30,
                                color: PrimaryGreenColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("${widget.table.tableName}", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 50
                              ),
                              child: Text(
                                this._order != null && this._order.reservationId != null ? "Bill: ${this._order.reservationId}" : "",
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: size.height - 360,
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
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 5),
                              height: 50,
                              width: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: PrimaryGreenLightColor
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  _showDialogEditTax();
                                },
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/img/edit.svg",
                                        color: Colors.white,
                                        width: 20,
                                        height: 20,
                                        allowDrawingOutsideViewBox: true,
                                        semanticsLabel: 'Edit Tax'
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 30,
                                        ),
                                        child: Text(
                                          "Phí dịch vụ, thuế", style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16
                                        ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 40,
                              margin: EdgeInsets.only(top: 10, left: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: PrimaryGreenLightColor
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _showCommission();
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      child: Icon(
                                        Icons.attach_money,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20, top: 0),
                                      child: Text("Hoa hồng",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Center(
                          child: Text("Tổng tiền: ${Money.fromInt(_total, vnd).format('###,### CCC').toString()}" , style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )),
                        ),
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
                          onPressed: () {
                            for(var i = 0; i <= _items.length - 1; i++) {
                              listKey.currentState.removeItem( 0,
                                      (context, animation) {
                                        return Container();
                                      });
                            }
                            setState(() {
                              _items.clear();
                            });
                          },
                          child: Text("XOÁ TẤT CẢ", style: TextStyle(
                            color: Colors.white
                          )),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40),
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: PrimaryGreenColor
                        ),
                        child: TextButton(
                          onPressed: () async {
                            List<Map<String, dynamic>> list = [];
                            _items.forEach((element) {
                              ProductOrderModel pro = new ProductOrderModel(element.product.id, element.product.productCode,
                                  element.product.productName, element.product.categoryParentId, element.product.categoryParentCode,
                                  element.product.categoryParentName, element.product.categoryId, element.product.categoryCode,
                                  element.product.categoryName, "CHECKIN", element.product.price, element.product.imageUrl,
                                  element.product.combo, element.product.categoryStatus, element.product.supplies, element.product.unitCode,
                                  element.product.unitId, element.product.unitName, element.product.unitStatus, 0,
                                  "", 0, 0,
                                  false, "", element.number);
                              list.add(pro.toJson());
                            });

                            UserModel user = Provider.of<SettingProvider>(context, listen: false).userInfo;
                            DateTime now = DateTime.now();
                            int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                            Map<String, dynamic> order = {
                              'branch_code': user.branchCode,
                              'branch_id': user.branchId,
                              'branch_name': user.branchName,
                              'discount': 0,
                              'discount_rate': 0,
                              'group_payment': 0,
                              'payment_result': "CASH",
                              'products': [],
                              'service_charge': 0,
                              'service_change_rate': 0,
                              'status': 'CHECKIN',
                              'table': widget.table.toJson(),
                              'tax': 0,
                              'tax_rate': 0,
                              'used_at': timeOrder
                            };

                            // TODO: Order
                            setState(() {
                              _isLoading = true;
                            });
                            ResultModel res = await restaurantService.orderFood(order);
                            if(res.status) {
                              _showToast();
                              //TODO: go to table screen
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => TableScreen())
                              );
                            } else {
                              _showToastError();
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
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

  ProductOrderModel _product;

  int _number;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  int get number => _number;

  set number(int value) {
    _number = value;
  }

  ItemProduct(this._id, this._product, this._number);

  ProductOrderModel get product => _product;

  set product(ProductOrderModel value) {
    _product = value;
  }

}
