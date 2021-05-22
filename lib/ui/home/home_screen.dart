import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_ios_bvhn/components/custom_grid_view.dart';
import 'package:pos_ios_bvhn/components/custom_popup.dart';
import 'package:pos_ios_bvhn/components/drawer.dart';
import 'package:pos_ios_bvhn/components/drawer_category.dart';
import 'package:pos_ios_bvhn/model/restaurant/category_meal_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/category_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/commission_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/order_payment_type_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/order_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/payment_other_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/product_order_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/product_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/model/table/table_model.dart';
import 'package:pos_ios_bvhn/model/user/partner_customer_model.dart';
import 'package:pos_ios_bvhn/model/user/user_model.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/service/partner_customer_service.dart';
import 'package:pos_ios_bvhn/service/restaurant_service.dart';
import 'package:pos_ios_bvhn/ui/home/table_screen.dart';
import 'package:provider/provider.dart';
import 'package:money2/money2.dart';
import 'package:select_dialog/select_dialog.dart';

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

  String receiver = "";

  String customer = "";

  List<ProductRestaurantModel> listProductView = [];

  List<CategoryMealRestaurantModel> listCateBep = [];

  List<CategoryMealRestaurantModel> listCateBar = [];

  List<CategoryMealRestaurantModel> listCateBanh = [];

  List<CategoryMealRestaurantModel> categoriesMeal = [];

  List<TextEditingController> listTextController = [];

  TextEditingController _nodeTextController =  new TextEditingController();

  CategoryMealRestaurantModel selectedCategoryMealRestaurant;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  List<ItemProduct> _items = [];

  RestaurantService restaurantService = new RestaurantService();

  PartnerCustomer ex1;

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

  // editting for payment other
  TextEditingController roomPaymentController = new TextEditingController();

  TextEditingController debitPaymentController = new TextEditingController();

  TextEditingController cardPaymentController = new TextEditingController();

  TextEditingController freePaymentController = new TextEditingController();

  TextEditingController bankPaymentController = new TextEditingController();

  TextEditingController voucherPaymentController = new TextEditingController();

  TextEditingController cashPaymentController = new TextEditingController();

  TextEditingController tipPaymentController = new TextEditingController();

  TextEditingController totalPaymentController = new TextEditingController();

  TextEditingController totalBillPaymentController = new TextEditingController();

  TextEditingController differentTotalBillPaymentController = new TextEditingController();


  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black26);

  final vnd = Currency.create('VND', 0, symbol: '₫');

  List<OrderPaymentTypeModel> paymentTypes = [
    OrderPaymentTypeModel("Thanh toán khác", 'OTHER'),
    OrderPaymentTypeModel("Khách nợ", 'DEBT'),
    OrderPaymentTypeModel("Thanh toán thẻ", 'CREDIT_CARD'),
    OrderPaymentTypeModel("Miễn phí", 'FREE'),
  ];

  OrderPaymentTypeModel dropdownPaymentTypeValue;

  CommissionRestaurantModel _commission;

  // list categories restaurant
  List<CategoryRestaurantModel> categories = [
    CategoryRestaurantModel("", "tat_ca", "Tất cả"),
    CategoryRestaurantModel("1050100000000000000", "nha_bep", "Nhà bếp"),
    CategoryRestaurantModel("1050600000000000000", "quay_bar", "Quầy bar"),
    CategoryRestaurantModel("1050800000000000000", "quay_banh", "Quầy bánh"),
  ];

  final SlidableController slidableController = new SlidableController();

  // list header tab bar view
  List<Widget> listWidget = [
    new Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
      ),
      child:  Align(
        alignment: Alignment.center,
        child: Text( 'Tất cả', style: TextStyle(
            color: PrimaryGreyColor,
            fontSize: 18
        )),
      ),
    ),
    new Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
      ),
      child:  Align(
        alignment: Alignment.center,
        child: Text( 'Nhà bếp', style: TextStyle(
            color: PrimaryGreyColor,
            fontSize: 18
        )),
      ),
    ),
    new Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
      ),
      child:  Align(
        alignment: Alignment.center,
        child: Text( 'Quầy bar', style: TextStyle(
            color: PrimaryGreyColor,
            fontSize: 18
        )),
      ),
    ),
    new Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
      ),
      child:  Align(
        alignment: Alignment.center,
        child: Text( 'Quầy bánh', style: TextStyle(
            color: PrimaryGreyColor,
            fontSize: 18
        )),
      ),
    )
  ];

  FToast fToast;

  final _formKey = GlobalKey<FormState>();

  OrderRestaurantModel _order;

  final PartnerCustomerService partnerCustomerService = new PartnerCustomerService();

  @override
  void initState() {

    setState(() {
      _loading = true;
      // dropdownPaymentTypeValue = paymentTypes.first;
    });

    fToast = FToast();
    fToast.init(context);

    super.initState();
    initDataRestaurant();
    initTableData();
  }


  @override
  void dispose() {

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

  Future<List<PartnerCustomer>> getPartnerCustomer(String filter) async {
    ResultModel res = await partnerCustomerService.getPartners(filter);
    if (res.status) {
      ListPartnerCustomer list  = ListPartnerCustomer.fromJson(res.data);
      List<PartnerCustomer> modelPartnerCustomers = list.results;
      return modelPartnerCustomers;
    } else {
      return [];
    }
  }

  Future initDataRestaurant() async {

    String branchId = Provider.of<SettingProvider>(context, listen: false).userInfo.branchId;

    ResultModel resProduct = await restaurantService.getProductsByParams(branchId , '', '', "", 1, 50);

    if(resProduct.status && resProduct.data != null && resProduct.data.length > 0) {
      List<ProductRestaurantModel> products = [];

      for (int i = 0; i < resProduct.data.length; i++) {
        setState(() {
          products.add(ProductRestaurantModel.fromJson(resProduct.data[i]));
        });
      }
      setState(() {
        listProductView = products;
      });
    }

    ResultModel resCategoriesBep = await restaurantService.getCategoryRestaurantByParams(branchId, '1050100000000000000', '', 1);
    if(resCategoriesBep.status && resCategoriesBep.data != null && resCategoriesBep.data.length > 0) {
      List<CategoryMealRestaurantModel> categoriesBep = [];
      for(int i = 0; i < resCategoriesBep.data.length; i++) {
        setState(() {
          CategoryMealRestaurantModel category = CategoryMealRestaurantModel.fromJson(resCategoriesBep.data[i]);
          categoriesBep.add(category);
        });
      }
      setState(() {
        listCateBep = categoriesBep;
      });
    }

    ResultModel resCategoriesBar = await restaurantService.getCategoryRestaurantByParams(branchId, '1050600000000000000', '', 1);
    if(resCategoriesBar.status && resCategoriesBar.data != null && resCategoriesBar.data.length > 0) {
      List<CategoryMealRestaurantModel> categoriesBar = [];
      for(int i = 0; i < resCategoriesBar.data.length; i++) {
        setState(() {
          CategoryMealRestaurantModel category = CategoryMealRestaurantModel.fromJson(resCategoriesBar.data[i]);
          categoriesBar.add(category);
        });
      }
      setState(() {
        listCateBar = categoriesBar;
      });
    }

    ResultModel resCategoriesBanh = await restaurantService.getCategoryRestaurantByParams(branchId, '1050800000000000000', '', 1);
    if(resCategoriesBanh.status && resCategoriesBanh.data != null && resCategoriesBanh.data.length > 0) {
      List<CategoryMealRestaurantModel> categoriesBanh = [];
      for(int i = 0; i < resCategoriesBanh.data.length; i++) {
        setState(() {
          CategoryMealRestaurantModel category = CategoryMealRestaurantModel.fromJson(resCategoriesBanh.data[i]);
          categoriesBanh.add(category);
        });
      }
      setState(() {
        listCateBanh = categoriesBanh;
      });
    }

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
        PaymentOtherModel  paymentOther = new PaymentOtherModel(
          0,0,0,0,0,0,0,0
        );
        _commission = new CommissionRestaurantModel("", "", "", 0);
        _order = new OrderRestaurantModel("", user.branchId, user.branchName, user.branchCode,
            _commission, 0, 0, 0,
            "RESTAURANT","CASH", [], null, 0,
            0, "CHECKIN", widget.table, 0, 0, timeOrder, paymentOther);
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

                                      _items[index].number = int.parse(amountProductController.text);

                                      // Set data for "phi dich vu"
                                      if (discountController.text.contains('%')) {
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
                                    slidableController.activeState.close();
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
                child: Text("Thuế", style: TextStyle(
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
                                  child: Text("Cập nhật thuế dịch vụ (thêm dấu % nếu muốn tính theo % hoá đơn)", style: TextStyle(
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
                                Container(
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
                                            height: 43,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 520,
                                                  child: TextFormField(
                                                    obscureText: false,
                                                    controller: customerController,
                                                    style: style,
                                                    decoration: InputDecoration(
                                                        hintText: "",
                                                        enabled: false,
                                                        contentPadding: EdgeInsets.only(left: 10),
                                                        fillColor: PrimaryBlackColor,
                                                        hintStyle: TextStyle(
                                                            fontSize: 16,
                                                            color: PrimaryGreyColor
                                                        ),
                                                        border: InputBorder.none
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 45,
                                                  width: 200,
                                                  padding: EdgeInsets.only(bottom: 5, right: 20),
                                                  child: ElevatedButton(
                                                    child: Text("Chọn khách hàng"),
                                                    onPressed: () async {
                                                      await SelectDialog.showModal<PartnerCustomer>(
                                                          context,
                                                          label: "Cập nhật khách hàng hoa hồng",
                                                          titleStyle: TextStyle(color: Colors.brown),
                                                          selectedValue: ex1,
                                                          onFind: (String value) => getPartnerCustomer(value),
                                                          backgroundColor: Colors.white,
                                                          itemBuilder: (BuildContext context, PartnerCustomer partner, bool isSelected) {
                                                            return Container(
                                                              height: 50,
                                                              child: Center(
                                                                child: Text(partner.partnerCustomerName),
                                                              ),
                                                            );
                                                          },
                                                          onChange: (PartnerCustomer selected) {
                                                            setState(() {
                                                              ex1 = selected;
                                                              customerController.text = selected.partnerCustomerName;
                                                            });
                                                          }
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  margin: EdgeInsets.only(bottom: 5,right: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        customerController.text = "";
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    )
                                ),
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

                                        _order.commissionRestaurantModel = _commission;
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

  Future<void> _showDialogPayment() async {

    Size size = MediaQuery.of(context).size;

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10.0),
              child: Container(
                height: size.height * 0.45,
                width: size.width * 0.5, decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: size.height * 0.1,
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            color: PrimaryGreenColor
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text("PHƯƠNG THỨC THANH TOÁN", style: TextStyle(
                              color: Colors.white,
                              fontSize: 24
                          )),
                        )
                    ),
                    Container(
                      height: 30,
                      child: Padding(
                        padding: EdgeInsets.only(left: 40, top: 10),
                        child: Text("Chọn phương thức thanh toán",
                            style: TextStyle(
                              fontSize: 16,
                              color: PrimaryGreenColor
                            )),
                      ),
                    ),
                    CustomPopup(customer: _order.commissionRestaurantModel.customerName ,
                        receiver : _order.commissionRestaurantModel.receiveName,
                        callback: (val, val2, val3) => setState( () => {dropdownPaymentTypeValue = val, receiver = val2, customer = val3})),
                    Container(
                      height: 60,
                      width: 150,
                      margin: EdgeInsets.only(left: 330, top: 10),
                      decoration: BoxDecoration(
                        color: PrimaryGreenColor,
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if(dropdownPaymentTypeValue != null && dropdownPaymentTypeValue.value != "OTHER") {
                            if (_items.length < 1) {
                              Navigator.pop(context);
                              _showToastError("Vui lòng chọn đồ để đặt." );
                              return;
                            }
                            if((dropdownPaymentTypeValue.value == "FREE") && (customer == null || customer.isEmpty)) {
                              _showToastError("Vui lòng chọn khách hàng." );
                              return;
                            }
                            if((dropdownPaymentTypeValue.value == "DEBT") && (receiver == null || receiver.isEmpty)) {
                              _showToastError("Vui lòng điền người nhận." );
                              return;
                            }

                            if(dropdownPaymentTypeValue.value == "FREE") {
                              setState(() {
                                _order.commissionRestaurantModel.customerName = customer;
                              });
                            }

                            if(dropdownPaymentTypeValue.value == "DEBT") {
                              setState(() {
                                _order.commissionRestaurantModel.receiveName = receiver;
                              });
                            }

                            if(this._order.reservationId != null) {
                              //TODO: controls the order got bill
                              List<ProductOrderModel> list = [];
                              _items.forEach((element) {
                                ProductOrderModel pro = element.product;
                                if (element.product.status == "PRE-CANCELLED") {
                                  pro.status = "CANCEL";
                                }
                                pro.quantity = element.number;
                                list.add(pro);
                              });
                              DateTime now = DateTime.now();
                              int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                              _order.products = list;
                              _order.usedAt = timeOrder;
                              // groupPayment ? _order.groupPayment = 1 : _order.groupPayment = 0;
                              _order.paymentResult = dropdownPaymentTypeValue.value;
                              _order.status = "CHECKOUT";

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
                                _showToastError("Đặt đồ không thành công." );
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
                                  pro.status = "CANCEL";
                                }
                                pro.quantity = element.number;
                                list.add(pro);
                              });

                              DateTime now = DateTime.now();
                              int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                              _order.usedAt = timeOrder;
                              _order.status = "CHECKOUT";
                              _order.paymentResult = dropdownPaymentTypeValue.value;
                              _order.products = list;
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
                                _showToastError("Đặt đồ không thành công." );
                              }
                            }
                          } else {
                            if (_items.length < 1) {
                              Navigator.pop(context);
                              _showToastError("Vui lòng chọn đồ để đặt." );
                              return;
                            }
                            setState(() {
                              dropdownPaymentTypeValue = paymentTypes.first;
                            });
                            await _showOtherPayment();
                          }
                        },
                        child: Text('THANH TOÁN', style: TextStyle(
                          color: Colors.white
                        )),
                      ),
                    ),
                  ],
                ),
              )
          );
    });
  }

  Future<void> _showOtherPayment() async {

    Size size = MediaQuery.of(context).size;

    int _total = 0;

    int _totalEdit = 0;

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

    int fee = _order != null && _order.serviceCharge != null && _order.serviceCharge != 0 ? _order.serviceCharge:
    _order != null && _order.serviceChargeRate != null && _order.serviceChargeRate != 0 ? (_order.serviceChargeRate * _total / 100).round()  : 0;

    int _totalAfterFee =  _total + fee;


    int tax = _order != null && _order.tax != null && _order.tax != 0 ? (_order.tax) :
    _order != null &&  _order.taxRate != null && _order.taxRate != 0 ? ((_order.taxRate) * _totalAfterFee / 100).round() : 0;

    int _totalAfterFeeAndTax = roundNumber(_totalAfterFee + tax);

    setState(() {
      roomPaymentController.text = "";
      debitPaymentController.text = "";
      cardPaymentController.text = "";
      freePaymentController.text = "";
      bankPaymentController.text = "";
      voucherPaymentController.text = "";
      cashPaymentController.text = "";
      tipPaymentController.text = "";
      totalPaymentController.text = _totalEdit.toString();
      totalBillPaymentController.text = _totalAfterFeeAndTax.toString();
      differentTotalBillPaymentController.text = (_totalAfterFeeAndTax - _totalEdit).toString();
    });

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10.0),
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: SingleChildScrollView(
                  child: Container(
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
                              child: Text("THANH TOÁN KHÁC", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24
                              )),
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          height: size.height * 0.05,
                          child: Row(
                            children: [
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('TT cùng tiền phòng', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: roomPaymentController,
                                  style: style,
                                  onChanged: (value) {
                                    updateTotal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.15,
                                  margin: EdgeInsets.only(left: 0.04 * size.width),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Khách nợ', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: debitPaymentController,
                                  style: style,
                                  onChanged: (value) {
                                    updateTotal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          height: size.height * 0.05,
                          child: Row(
                            children: [
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.15 + 10,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Thanh toán thẻ', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2 - 10,
                                margin: EdgeInsets.only(left: 0.04 * size.width),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: cardPaymentController,
                                  style: style,
                                  onChanged: (value) {
                                    updateTotal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.15,
                                  margin: EdgeInsets.only(left: 0.04 * size.width),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Miễn phí', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: freePaymentController,
                                  style: style,
                                  onChanged: (value) {
                                    updateTotal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          height: size.height * 0.05,
                          child: Row(
                            children: [
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Chuyển khoản', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: bankPaymentController,
                                  style: style,
                                  onChanged: (value) {
                                    updateTotal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.15,
                                  margin: EdgeInsets.only(left: size.width * 0.04),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Voucher', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: voucherPaymentController,
                                  style: style,
                                  onChanged: (value) {
                                    updateTotal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          height: size.height * 0.05,
                          child: Row(
                            children: [
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Tiền mặt', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: cashPaymentController,
                                  style: style,
                                  onChanged: (value) {
                                    updateTotal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.15,
                                  margin: EdgeInsets.only(left: size.width * 0.04),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Tiền TIP', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: tipPaymentController,
                                  style: style,
                                  onChanged: (value) {
                                    updateTotal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          height: size.height * 0.05,
                          child: Row(
                            children: [
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Tổng cộng', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.4 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: totalPaymentController,
                                  style: style,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      enabled: false,
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          height: size.height * 0.05,
                          child: Row(
                            children: [
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Số tiền trên hoá đơn', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.4 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: totalBillPaymentController,
                                  style: style,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          height: size.height * 0.05,
                          child: Row(
                            children: [
                              Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 10
                                    ),
                                    child: Text('Lệch ', style: TextStyle(
                                        fontSize: 18
                                    )),
                                  )
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.4 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: differentTotalBillPaymentController,
                                  style: style,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.only(left: 10,bottom: 10),
                                      fillColor: PrimaryBlackColor,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryGreyColor
                                      ),
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 0.05 * size.height,
                          width: size.width * 0.8,
                        ),
                        Container(
                            height: size.height * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    height: 50,
                                    width: 120,
                                    margin: EdgeInsets.only(right: 30),
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Huỷ", style: TextStyle(
                                          color: Colors.white
                                      )),
                                    )
                                ),
                                Container(
                                    height: 50,
                                    width: 120,
                                    margin: EdgeInsets.only(right: 30),
                                    decoration: BoxDecoration(
                                        color: PrimaryGreenColor,
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        if(this._order.reservationId != null) {
                                          //TODO: controls the order got bill
                                          List<ProductOrderModel> list = [];
                                          _items.forEach((element) {
                                            ProductOrderModel pro = element.product;
                                            if (element.product.status == "PRE-CANCELLED") {
                                              pro.status = "CANCEL";
                                            }
                                            pro.quantity = element.number;
                                            list.add(pro);
                                          });
                                          DateTime now = DateTime.now();
                                          int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                                          _order.products = list;
                                          _order.usedAt = timeOrder;
                                          _order.groupPayment = 0;
                                          _order.paymentOtherModel.room = int.parse(roomPaymentController.text.isEmpty ? "0" : roomPaymentController.text);
                                          _order.paymentOtherModel.debit = int.parse(debitPaymentController.text.isEmpty ? "0" : debitPaymentController.text);
                                          _order.paymentOtherModel.card = int.parse(cardPaymentController.text.isEmpty ? "0" : cardPaymentController.text);
                                          _order.paymentOtherModel.free = int.parse(freePaymentController.text.isEmpty ? "0" : freePaymentController.text);
                                          _order.paymentOtherModel.bank = int.parse(bankPaymentController.text.isEmpty ? "0" : bankPaymentController.text);
                                          _order.paymentOtherModel.voucher = int.parse(voucherPaymentController.text.isEmpty ? "0" : voucherPaymentController.text);
                                          _order.paymentOtherModel.cash = int.parse(cashPaymentController.text.isEmpty ? "0" : cashPaymentController.text);
                                          _order.paymentOtherModel.tip = int.parse(tipPaymentController.text.isEmpty ? "0" : tipPaymentController.text);
                                          _order.paymentResult = dropdownPaymentTypeValue.value;
                                          _order.status = "CHECKOUT";
                                          int totalEditing = _order.paymentOtherModel.room + _order.paymentOtherModel.debit + _order.paymentOtherModel.card
                                                           + _order.paymentOtherModel.free + _order.paymentOtherModel.bank + _order.paymentOtherModel.voucher
                                                           + _order.paymentOtherModel.cash;
                                          if(totalEditing != _total) {
                                            _showToastError("Đặt đồ không thành công." );
                                            return;
                                          }
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
                                            _showToastError("Tổng tiền không khớp với hoá đơn !");
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
                                              pro.status = "CANCEL";
                                            }
                                            pro.quantity = element.number;
                                            list.add(pro);
                                          });

                                          DateTime now = DateTime.now();
                                          int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                                          _order.usedAt = timeOrder;
                                          _order.status = "CHECKOUT";
                                          _order.groupPayment = 0;
                                          _order.paymentResult = dropdownPaymentTypeValue.value;
                                          _order.paymentOtherModel.room = int.parse(roomPaymentController.text == "" ? "0" : roomPaymentController.text);
                                          _order.paymentOtherModel.debit = int.parse(debitPaymentController.text == "" ? "0" : debitPaymentController.text);
                                          _order.paymentOtherModel.card = int.parse(cardPaymentController.text == "" ? "0" : cardPaymentController.text);
                                          _order.paymentOtherModel.free = int.parse(freePaymentController.text == "" ? "0" : freePaymentController.text);
                                          _order.paymentOtherModel.bank = int.parse(bankPaymentController.text == "" ? "0" : bankPaymentController.text);
                                          _order.paymentOtherModel.voucher = int.parse(voucherPaymentController.text == "" ? "0" : voucherPaymentController.text);
                                          _order.paymentOtherModel.cash = int.parse(cashPaymentController.text == "" ? "0" : cashPaymentController.text);
                                          _order.paymentOtherModel.tip = int.parse(tipPaymentController.text == "" ? "0" : tipPaymentController.text);
                                          _order.products = list;
                                          _order.tableInfo = widget.table;

                                          int totalEditing = _order.paymentOtherModel.room + _order.paymentOtherModel.debit + _order.paymentOtherModel.card
                                              + _order.paymentOtherModel.free + _order.paymentOtherModel.bank + _order.paymentOtherModel.voucher
                                              + _order.paymentOtherModel.cash;
                                          if(totalEditing != _total) {
                                            _showToastError("Tổng tiền không khớp với hoá đơn !" );
                                            return;
                                          }

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
                                            _showToastError("Đặt đồ không thành công." );
                                          }
                                        }
                                      },
                                      child: Text("Thanh toán", style: TextStyle(
                                          color: Colors.white
                                      )),
                                    )
                                )
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        }
  );
  }

  void updateTotal() {
    int totalEdit = 0;

    int total = 0;

    if(_items != null && _items.length > 0) {
      _items.forEach((element) {
        if (element.product.status == "CHECKEDIN" || element.product.status == "CHECKIN" ) {
          int discount = element.product.discount != null && element.product.discount != 0 ?
          element.product.discount * element.number : element.product.discountRate != null && element.product.discountRate != 0 ?
          (element.product.discountRate * element.product.price * element.number / 100).round() : 0;
          setState(() {
            total += (element.product.price * element.number) - discount;
          });
        }
      });
    }

    int room = roomPaymentController.text ==  "" ? 0 : int.parse(roomPaymentController.text);
    int debit = debitPaymentController.text == "" ? 0 : int.parse(debitPaymentController.text);
    int card = cardPaymentController.text == "" ? 0 : int.parse(cardPaymentController.text);
    int free = freePaymentController.text == "" ? 0 : int.parse(freePaymentController.text);
    int bank = bankPaymentController.text == "" ? 0 : int.parse(bankPaymentController.text);
    int cash = cashPaymentController.text == "" ? 0 : int.parse(cashPaymentController.text);
    int voucher = voucherPaymentController.text == "" ? 0 : int.parse(voucherPaymentController.text);
    int tip = tipPaymentController.text == "" ? 0 : int.parse(tipPaymentController.text);

    totalEdit = room + debit + card + cash + free + bank + voucher + tip;
    setState(() {
      totalPaymentController.text = totalEdit.toString();
      totalBillPaymentController.text = total.toString();
      differentTotalBillPaymentController.text = (total - totalEdit).toString();
    });
  }

  // TODO: build widget for view in every tab bar
  Widget _buildAnyWidgets(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: size.width * 0.6,
                  margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 0.2),
                  ),
                  child: TextField(
                    controller: _nodeTextController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Tìm kiếm',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: CupertinoColors.systemGrey,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                    onChanged: (value) => _searchItems(value),
                  ),
                ),
              ],
            ),
          ),
          listProductView.length > 0 ? AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              height: size.height - 170,
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
                                            ProductOrderModel productOrder = new ProductOrderModel(listProductView[index].id,
                                                listProductView[index].productCode, listProductView[index].productName,
                                                listProductView[index].categoryParentId, listProductView[index].categoryParentCode,
                                                listProductView[index].categoryParentName, listProductView[index].categoryId,
                                                listProductView[index].categoryCode, listProductView[index].categoryName,
                                                "CHECKIN",  listProductView[index].price,  listProductView[index].imageUrl,
                                                listProductView[index].combo,  listProductView[index].categoryStatus,
                                                listProductView[index].supplies,  listProductView[index].unitCode,
                                                listProductView[index].unitId, listProductView[index].unitName,
                                                listProductView[index].unitStatus, 0 , '', 0, 0, false, "", 1);
                                            if( _items != null && _items.length > 0) {
                                              for(int j = 0; j< _items.length; j++) {
                                                if(listProductView[index].id.toString() == _items[j].id.toString()
                                                 && _items[j].product.status == "CHECKIN") {
                                                  cnt = j;
                                                }
                                              }
                                              if(cnt == null) {
                                                listKey.currentState.insertItem(0,
                                                    duration: const Duration(
                                                        milliseconds: 500));
                                                final item = new ItemProduct(listProductView[index].id.toString() , productOrder, 1);
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
                                              final item = new ItemProduct(listProductView[index].id.toString(), productOrder, 1);
                                              _items = []
                                                ..add(item)
                                                ..addAll(_items);
                                            }

                                            //TODO: show combo
                                            if(listProductView[index].combo != null && listProductView[index].combo.length > 0) {
                                              _showCombo(listProductView[index].combo);
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
                                                  image:  NetworkImage( "https://nhapi.hongngochospital.vn" +listProductView[index].imageUrl),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 23,
                                              margin: EdgeInsets.only(top: 3, left: 10),
                                              child: Text(listProductView[index].productName,
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
                                                  child: Text( Money.fromInt((listProductView[index].price), vnd).format('###,### CCC').toString() , style: TextStyle(
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
                              childCount: listProductView.length
                            /// Set childCount to limit no.of items
                            /// childCount: 100,
                          ),
                        )
                    ),
                  ],
                ),
              )
          ): Container(
              height: size.height - 170,
              child: Center(
                  child: Text("Không có dữ liệu. !", style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey
                  ))
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
              actionPane: SlidableDrawerActionPane(),
              controller: slidableController,
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

  void _updateProductions(CategoryMealRestaurantModel cate) async {

    String branchId = Provider.of<SettingProvider>(context, listen: false).userInfo.branchId;

    ResultModel res = await restaurantService.getProductsByParams(branchId, "", cate.categoryId, "", 1, 50);

    if(res.status && res.data != null && res.data.length > 0) {
      List<ProductRestaurantModel> product = [];
      for(int i = 0; i < res.data.length ; i++) {
        setState(() {
          product.add(ProductRestaurantModel.fromJson(res.data[i]));
        });
      }
      setState(() {
        listProductView.clear();
        listProductView = []..addAll(product);
      });
    } else {
      setState(() {
        listProductView.clear();
      });
    }
  }

  void _searchItems(String keySearch) async {

    String branchId = Provider.of<SettingProvider>(context, listen: false).userInfo.branchId;

    String categoryId = selectedCategoryMealRestaurant != null ? selectedCategoryMealRestaurant.categoryId : "";

    ResultModel res = await restaurantService.getProductsByParams(branchId, "", categoryId, keySearch, 1, 50);

    setState(() {
      if(res.status && res.data != null && res.data.length > 0) {
        List<ProductRestaurantModel> product = [];
        for(int i = 0; i < res.data.length ; i++) {
          setState(() {
            product.add(ProductRestaurantModel.fromJson(res.data[i]));
          });
        }
        setState(() {
          listProductView.clear();
          listProductView = []..addAll(product);
        });
      } else {
        setState(() {
          listProductView.clear();
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

  _showToastError(String message) {
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
          Text(message),
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
      int r  = number % 1000;
      if(r >= 500) {
        round = ((number / 1000 ).round() * 1000);
      } else {
        round = ((number / 1000 ).round() * 1000) + 1000;
      }
    } else {
      round = number;
    }
    return round;
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.pop(context);
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

    int fee = _order != null && _order.serviceCharge != null && _order.serviceCharge != 0 ? _order.serviceCharge:
    _order != null && _order.serviceChargeRate != null && _order.serviceChargeRate != 0 ? (_order.serviceChargeRate * _total / 100).round()  : 0;

    int _totalAfterFee =  _total + fee;


    int tax = _order != null && _order.tax != null && _order.tax != 0 ? (_order.tax) :
    _order != null &&  _order.taxRate != null && _order.taxRate != 0 ? ((_order.taxRate) * _totalAfterFee / 100).round() : 0;

    int _totalAfterFeeAndTax = roundNumber(_totalAfterFee + tax);

    // TODO: implement build
    return _loading ? loading() : Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF848a93),),
        backgroundColor: Color(0xFFf4f5f7),
        actions: <Widget>[
          new Container(),
        ],
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
                              width: 90,
                              margin: EdgeInsets.only(left: 10),
                              child: Text("${widget.table.tableName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                            ),
                            Container(
                              width: 140,
                              margin: EdgeInsets.only(
                                  left: 10
                              ),
                              child: Text(
                                this._order != null && this._order.reservationId != null ? "Bill: ${this._order.reservationId}" : "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: PrimaryGreenLightColor
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    _showCommission();
                                  },
                                  color: Colors.white,
                                  icon:  Icon((_order.commissionRestaurantModel.customerName != "" && _order.commissionRestaurantModel.customerName != null) ||
                                      (_order.commissionRestaurantModel.receiveName != "" && _order.commissionRestaurantModel.receiveName != null) ? Icons.done : Icons.add)
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          height: size.height - 450,
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
                        width: size.width * 0.4,
                        margin: EdgeInsets.only(left: 20, right: 10),
                        child: Text("Khách hàng: ${_order.commissionRestaurantModel.customerName != null ? _order.commissionRestaurantModel.customerName: "" }",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle()),
                      ),
                      Container(
                        height: 30,
                        width: size.width * 0.4,
                        margin: EdgeInsets.only(left: 20, right: 10),
                        child: Text("Người nhận: ${_order.commissionRestaurantModel.receiveName != null ? _order.commissionRestaurantModel.receiveName: ""}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle()),
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
                        width: size.width * 0.4,
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 150,
                              margin: EdgeInsets.only(left: 10, right: 20),
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
                              margin: EdgeInsets.only(),
                              width: 150,
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
                                        pro.status = "CANCEL";
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
                                      _showToastError("Đặt đồ không thành công." );
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
                                        pro.status = "CANCEL";
                                      }
                                      pro.quantity = element.number;
                                      list.add(pro);
                                    });

                                    DateTime now = DateTime.now();
                                    int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                                    _order.usedAt = timeOrder;
                                    _order.products = list;
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
                                      _showToastError("Đặt đồ không thành công." );
                                    }
                                  }

                                },
                                child: Text("ĐẶT MÓN", style: TextStyle(
                                    color: Colors.white
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: size.width * 0.4,
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(left: 10, right: 20),
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: PrimaryGreenColor
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  if(_items.length < 0) {
                                    _showToastError("Vui lòng chọn món ăn ." );
                                    return;
                                  }
                                  if(this._order.reservationId != null) {
                                    //TODO: controls the order got bill
                                    List<ProductOrderModel> list = [];
                                    _items.forEach((element) {
                                      ProductOrderModel pro = element.product;
                                      if (element.product.status == "PRE-CANCELLED") {
                                        pro.status = "CANCEL";
                                      }
                                      pro.quantity = element.number;
                                      list.add(pro);
                                    });
                                    DateTime now = DateTime.now();
                                    int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                                    _order.products = list;
                                    _order.usedAt = timeOrder;
                                    _order.status = "CHECKOUT";

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
                                      _showToastError("Đặt đồ không thành công." );
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
                                        pro.status = "CANCEL";
                                      }
                                      pro.quantity = element.number;
                                      list.add(pro);
                                    });

                                    DateTime now = DateTime.now();
                                    int timeOrder = (now.microsecondsSinceEpoch / 1000).round();
                                    _order.usedAt = timeOrder;
                                    _order.status = "CHECKOUT";
                                    _order.products = list;
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
                                      _showToastError("Đặt đồ không thành công." );
                                    }
                                  }

                                },
                                child: Text("THANH TOÁN NHANH", style: TextStyle(
                                    color: Colors.white
                                )),
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(),
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: PrimaryGreenColor
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  _showDialogPayment();
                                },
                                child: Text("THANH TOÁN", style: TextStyle(
                                    color: Colors.white
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 2,
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
                  child: _buildAnyWidgets(context),
                ),
                flex: 4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        height: 500,
        width: 60,
        child: Column(
          children: [
            Container(
                height: 140,
                width: 50,
                margin: EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                    setState(() {
                      categoriesMeal = listCateBar;
                    });
                    _openEndDrawer();
                  },
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text("Quầy bar", style: TextStyle(
                          fontSize: 18
                      ))
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                )
            ),
            Container(
                height: 140,
                width: 50,
                margin: EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    setState(() {
                      categoriesMeal = listCateBep;
                    });
                    _openEndDrawer();
                  },
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text("Nhà bếp", style: TextStyle(
                          fontSize: 18
                      ))
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                )
            ),
            Container(
                height: 140,
                width: 50,

                child: FloatingActionButton(
                  backgroundColor: Colors.yellowAccent,
                  onPressed: () {
                    setState(() {
                      categoriesMeal = listCateBanh;
                    });
                    _openEndDrawer();
                  },
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text("Quầy bánh", style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey
                      ))
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                )
            )
          ],
        ),
      ),
      endDrawer: DrawerCategory(categories: categoriesMeal, callback: (val) {
        _updateProductions(val);
        _closeEndDrawer();
      })
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
