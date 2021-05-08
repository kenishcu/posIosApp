import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_ios_bvhn/components/custom_grid_view.dart';
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

  // editing for product note
  TextEditingController amountProductController =  new TextEditingController();

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

    noteController.dispose();
    priceController.dispose();
    discountController.dispose();
    priceController.dispose();

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
        _order = new OrderRestaurantModel("", user.branchId, user.branchName, user.branchCode,
            _commission, 0, 0, 0,
            "CASH", [], null, 0,
            0, "CHECKIN", widget.table, 0, 0, timeOrder);
      });
    }
  }

  Future<void> _showDialogEdit (ItemProduct item) async {

    Size size = MediaQuery.of(context).size;

    setState(() {
      amountProductController.text = item.number.toString();
      discountController.text = item.product.discount != null && item.product.discount != 0 ? item.product.discount.toString():
      item.product.discountRate != null &&  item.product.discountRate != 0 ?  item.product.discountRate.toString() + "%" : "0";
      priceController.text = item.product.price.toString();
      noteController.text = item.product.note;
    });

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
                controller: amountProductController,
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
                enabled: false,
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
                                    int index = _items.indexWhere((element) => (element.id == item.id && element.product.status == "CHECKIN"));
                                    if(index != null) {
                                      _items[index].product.quantity = int.parse(amountProductController.text);

                                      // Set data for "phi dich vu"
                                      if(discountController.text.contains('%')) {
                                        var f = discountController.text.toString();
                                        f = f.replaceAll('%', '');
                                        _items[index].product.discountRate = int.parse(f);
                                        _items[index].product.discount = 0;
                                      } else {
                                        _items[index].product.discount = int.parse(discountController.text);
                                        _items[index].product.discountRate = 0;
                                      }

                                      _items[index].product.note = noteController.text;
                                      Navigator.pop(context);
                                    }
                                  });
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

  Future<void> _showDialogEditTax() async {

    setState(() {
      taxController.text = _order.tax != null && _order.tax != 0 ? _order.tax.toString():
      _order.taxRate != null && _order.taxRate != 0 ? _order.taxRate.toString() + "%" : "0";
      feeServiceController.text = _order.serviceCharge != null && _order.serviceCharge != 0 ? _order.serviceCharge.toString():
      _order.serviceChargeRate != null && _order.serviceChargeRate != 0 ? _order.serviceChargeRate.toString() + "%" : "0";
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
                child: Text("Phí dịch vụ ", style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 30,
              child: TextFormField(
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

                                        // Set data for "phi dich vu"
                                        if(feeServiceController.text.contains('%')) {
                                          var f = feeServiceController.text.toString();
                                          f = f.replaceAll('%', '');
                                          _order.serviceChargeRate = int.parse(f);
                                          _order.serviceCharge = 0;
                                        } else {
                                          _order.serviceCharge = int.parse(feeServiceController.text);
                                          _order.serviceChargeRate = 0;
                                        }

                                        // Set data for "thue"
                                        if(taxController.text.contains('%')) {
                                          var f = taxController.text.toString();
                                          f = f.replaceAll('%', '');
                                          _order.taxRate = int.parse(f);
                                          _order.tax = 0;
                                        } else {
                                          _order.tax = int.parse(taxController.text);
                                          _order.taxRate = 0;
                                        }
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

  Future<void> _showCombo(List<ProductRestaurantModel> combo) async {

    Size size = MediaQuery.of(context).size;

    int selectedNumber = 0;

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10.0),
            child: Container(
              height: size.height * 0.6,
              width: size.width * 0.8, decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: PrimaryGreenColor
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text("CHỌN MÓN THEO COMBO", style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                      )),
                    )
                  ),
                  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.8,
                    child: CustomGridView( callback: (val) => setState( () => {selectedNumber = val}), combo: combo,)
                  ),
                  Container(
                    height: size.height * 0.1 - 20,
                    width: size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120,
                        ),
                        Container(
                          width: 140,
                          height: 60,
                          margin: EdgeInsets.only(right: 10.0),
                          decoration: BoxDecoration(
                            color: PrimaryGreenLightColor,
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                ProductOrderModel selectedProduct = new ProductOrderModel(combo[0].id,
                                    combo[selectedNumber].productCode, combo[selectedNumber].productName,
                                    combo[selectedNumber].categoryParentId,combo[selectedNumber].categoryParentCode,
                                    combo[selectedNumber].categoryParentName, combo[selectedNumber].categoryId,
                                    combo[selectedNumber].categoryCode, combo[selectedNumber].categoryName,
                                    "CHECKIN",  combo[selectedNumber].price,  combo[selectedNumber].imageUrl,
                                    combo[selectedNumber].combo,  combo[selectedNumber].categoryStatus,
                                    combo[selectedNumber].supplies,  combo[selectedNumber].unitCode,
                                    combo[selectedNumber].unitId, combo[selectedNumber].unitName,
                                    combo[selectedNumber].unitStatus, 0 , '', 0, 0, false, "", 1);
                                int cnt;
                                if( _items != null && _items.length > 0) {
                                  for(int j = 0; j< _items.length; j++) {
                                    if(combo[selectedNumber].id.toString() == _items[j].id.toString()
                                        && _items[j].product.status == "CHECKIN") {
                                      cnt = j;
                                    }
                                  }
                                  print("count ${cnt.toString()}");
                                  if(cnt == null) {
                                    listKey.currentState.insertItem(0,
                                        duration: const Duration(
                                            milliseconds: 500));
                                    final item = new ItemProduct(combo[selectedNumber].id.toString() , selectedProduct, 1);
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
                                  final item = new ItemProduct(combo[selectedNumber].id.toString(), selectedProduct, 1);
                                  _items = []
                                    ..add(item)
                                    ..addAll(_items);
                                }
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Cập nhật", style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            )),
                          ),
                        )
                      ],
                    )
                  )
                ],
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
                                                if(listTabsView[i][index].id.toString() == _items[j].id.toString()
                                                 && _items[j].product.status == "CHECKIN") {
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

                                            //TODO: show combo
                                            if(listTabsView[i][index].combo != null && listTabsView[i][index].combo.length > 0) {
                                              _showCombo(listTabsView[i][index].combo);
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: size.width * 0.33,
            margin: EdgeInsets.only(bottom: 5),
            child: item.product.status == 'CHECKIN' ?
            Slidable(
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
                          width: size.width * 0.3,
                          height: 30,
                          child: Row(
                            children: [
                              Container(
                                  height: 30,
                                  padding: EdgeInsets.only(left: 4),
                                  width: size.width * 0.17 - 2,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(item != null && item.product != null ? item.product.productName : '' ,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 17
                                        )),
                                  )
                              ),
                              Container(
                                  width: size.width * 0.13,
                                  decoration: BoxDecoration(
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(' Đã giảm: ${item.product.discount != null && item.product.discount != 0 ?
                                    item.product.discount * item.number : item.product.discountRate != null && item.product.discountRate != 0 ?
                                    (item.product.discountRate * item.product.price * item.number / 100).round() : 0}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                        )),
                                  )
                              )
                            ],
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
            ) : item.product.status == "CHECKEDIN" ? Slidable(
                actionPane: SlidableScrollActionPane(),
                actionExtentRatio: 0.3,
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      setState(() {
                        if(_items.length > 0) {
                          int indexItem = _items.indexWhere((element) => element.id == item.id &&
                              element.product.status == item.product.status);
                          setState(() {
                            if (indexItem != null) {
                              _items[indexItem].product.status = "PRE-CANCELLED";
                            }
                          });
                        }
                      });
                    },
                  ),
                ],
                child: Container(
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                  ),
                  child:  Container(
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: PrimaryOrangeColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: size.width * 0.3,
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                    height: 30,
                                    padding: EdgeInsets.only(left: 4),
                                    width: size.width * 0.17 - 2,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(item != null && item.product != null ? item.product.productName : '' ,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 17
                                          )),
                                    )
                                ),
                                Container(
                                    width: size.width * 0.13,
                                    decoration: BoxDecoration(
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(' Đã giảm: ${item.product.discountRate * item.number}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                          )),
                                    )
                                )
                              ],
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
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 50,
                                decoration: BoxDecoration(
                                  // color: PrimaryGreenColor,
                                ),
                                child: Center(
                                  child: Text('SL: ${item.number}' , style: TextStyle(
                                    fontSize: 17,)),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ) : item.product.status == "CANCELLED" ? Container(
              width: size.width * 0.3,
              decoration: BoxDecoration(
              ),
              child:  Container(
                width: size.width * 0.3,
                decoration: BoxDecoration(
                  color: PrimaryGrey2Color,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: size.width * 0.3,
                        height: 30,
                        child: Row(
                          children: [
                            Container(
                                height: 30,
                                padding: EdgeInsets.only(left: 4),
                                width: size.width * 0.17 - 2,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(item != null && item.product != null ? item.product.productName : '' ,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 17
                                      )),
                                )
                            ),
                            Container(
                                width: size.width * 0.13,
                                decoration: BoxDecoration(
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(' Đã giảm: ${item.product.discountRate * item.number}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                      )),
                                )
                            )
                          ],
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
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 50,
                            decoration: BoxDecoration(),
                            child: Center(
                              child: Text( 'SL: ${item.number}' , style: TextStyle(
                                fontSize: 17,
                              )),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ): Slidable(
                actionPane: SlidableScrollActionPane(),
                actionExtentRatio: 0.3,
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Restored',
                    color: Colors.blue,
                    icon: Icons.restore,
                    onTap: () {
                      setState(() {
                        if(_items.length > 0) {
                          int indexItem = _items.indexWhere((element) => element.id == item.id &&
                              element.product.status == item.product.status);
                          setState(() {
                            if (indexItem != null) {
                              _items[indexItem].product.status = "CHECKEDIN";
                            }
                          });
                        }
                      });
                    },
                  ),
                ],
                child: Container(
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                  ),
                  child:  Container(
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: size.width * 0.3,
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                    height: 30,
                                    padding: EdgeInsets.only(left: 4),
                                    width: size.width * 0.17 - 2,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(item != null && item.product != null ? item.product.productName : '' ,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 17
                                          )),
                                    )
                                ),
                                Container(
                                    width: size.width * 0.13,
                                    decoration: BoxDecoration(
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(' Đã giảm: ${item.product.discountRate * item.number}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                          )),
                                    )
                                )
                              ],
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
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 50,
                                decoration: BoxDecoration(
                                ),
                                child: Center(
                                  child: Text('SL: ${item.number}' , style: TextStyle(
                                    fontSize: 17,)),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
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

  int roundNumber(int number) {
    int round;
    if( number % 1000 != 0) {
      round = ((number / 1000).round() * 1000) + 1000;
    } else {
      round = number;
    }
    return round;
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    int _total = 0;

    if(_items != null && _items.length > 0) {
      _items.forEach((element) {
        if (element.product.status == "CHECKEDIN" || element.product.status == "CHECKIN" ) {
          int discount = element.product.discount != null && element.product.discount != 0 ?
          element.product.discount * element.number : element.product.discountRate != null && element.product.discountRate != 0 ?
          (element.product.discountRate * element.product.price * element.number / 100).round() : 0;
          setState(() {
            _total += (element.product.price * element.number) - discount;
          });
        }
      });
    }

    int fee = _order != null && _order.serviceCharge != null && _order.serviceCharge != 0 ? _order.serviceCharge.toString():
    _order != null && _order.serviceChargeRate != null && _order.serviceChargeRate != 0 ? (_order.serviceChargeRate * _total / 100).round()  : 0;
    fee = roundNumber(fee);

    int _totalAfterFee =  _total + fee;


    int tax = _order != null && _order.tax != null && _order.tax != 0 ? (_order.tax + _totalAfterFee) :
    _order != null &&  _order.taxRate != null && _order.taxRate != 0 ? ((_order.taxRate) * _totalAfterFee / 100).round() : 0;
    tax = roundNumber(tax);

    int _totalAfterFeeAndTax = _totalAfterFee + tax;

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
                        height: size.height - 410,
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
                        height: 40,
                        margin: EdgeInsets.only(left: 20, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text("Thuế: ${tax.toString()}", style: TextStyle()),
                            ),
                            Container(
                              child: Text("Phí dịch vụ: ${fee.toString()}", style: TextStyle()),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Center(
                          child: Text("Tổng tiền: ${Money.fromInt(_totalAfterFeeAndTax , vnd).format('###,### CCC').toString()}" , style: TextStyle(
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

                            if(_order.reservationId != null) {
                              setState(() {
                                for(var i = 0; i <= _items.length - 1; i++) {
                                  if(_items[i].product.status == "CHECKIN"){
                                    listKey.currentState.removeItem( 0,
                                            (context, animation) {
                                          return Container();
                                        });
                                  }
                                }
                                _items.removeWhere((element) => element.product.status == "CHECKIN");
                              });
                            } else {
                              for(var i = 0; i <= _items.length - 1; i++) {
                                listKey.currentState.removeItem( 0,
                                        (context, animation) {
                                      return Container();
                                    });
                              }
                              setState(() {
                                _items.clear();
                              });
                            }
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
                            if(this._order.reservationId != null) {
                              //TODO: controls the order got bill
                              List<ProductOrderModel> list = [];
                              _items.forEach((element) {
                                ProductOrderModel pro = element.product;
                                if (element.product.status == "PRE-CANCELLED") {
                                  pro.status = "CANCELLED";
                                }
                                pro.quantity = element.number;
                                list.add(pro);
                              });
                              DateTime now = DateTime.now();
                              int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                              _order.products = list;
                              _order.usedAt = timeOrder;

                              // TODO: Order
                              setState(() {
                                _isLoading = true;
                              });
                              ResultModel res = await restaurantService.reOrderFood(_order.toJson(), _order.id);
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
                            } else {
                              //TODO: controls the order didn't got bill
                              List<ProductOrderModel> list = [];
                              _items.forEach((element) {
                                ProductOrderModel pro = element.product;
                                if (element.product.status == "PRE-CANCELLED") {
                                  pro.status = "CANCELLED";
                                }
                                pro.quantity = element.number;
                                list.add(pro);
                              });

                              DateTime now = DateTime.now();
                              int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                              _order.usedAt = timeOrder;
                              _order.tableInfo = widget.table;

                              // TODO: Order
                              setState(() {
                                _isLoading = true;
                              });
                              ResultModel res = await restaurantService.orderFood(_order.toJson());
                              if(res.status) {
                                _showToast();
                                //TODO: go to table screen
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => TableScreen())
                                );
                              } else {
                                _showToastError();
                              }
                            }

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
