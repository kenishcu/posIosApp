import 'package:pos_ios_bvhn/model/restaurant/commission_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/restaurant/product_order_model.dart';
import 'package:pos_ios_bvhn/model/table/table_model.dart';

class OrderRestaurantModel {

  String _branchId;
  String _branchName;
  String _branchCode;

  CommissionRestaurantModel _commissionRestaurantModel;

  // discount order info
  int _discount;
  int _discountRate;
  int _groupPayment;
  String _paymentResult;

  List<ProductOrderModel> _products;

  int _reservationId;
  // service order info
  int _serviceCharge;
  int _serviceChargeRate;
  String _status;
  int _tax;
  int _taxRate;
  TableModel _tableInfo;
  int _usedAt;

  OrderRestaurantModel(this._branchId, this._branchName, this._branchCode,
      this._commissionRestaurantModel, this._discount, this._discountRate,
      this._groupPayment, this._paymentResult, this._products, this._reservationId,
      this._serviceCharge, this._serviceChargeRate, this._status, this._tableInfo,
      this._tax, this._taxRate, this._usedAt);

  factory OrderRestaurantModel.fromJson(dynamic json) {
    List<ProductOrderModel> products = [];
    if (json['products'] != null && json['products'].length > 0) {
      for(int i = 0; i< json['products'].length; i++) {
        products.add(ProductOrderModel.fromJson(json['products'][i]));
      }
    }
    return OrderRestaurantModel(json['branch_id'] as String, json['branch_name'] as String,
    json['branch_code'] as String, CommissionRestaurantModel.fromJson(json['commission']), json['discount'] as int,
    json['discount_rate'] as int, json['group_payment'] as int, json['payment_result'] as String,
    products, json['reservation_id'] as int, json['service_charge'] as int,
    json['service_charge_rate'] as int, json['status'] as String, TableModel.fromJson(json['table']),
    json['tax'] as int, json['tax_rate'] as int, json['used_at'] as int);
  }

  toJson() {
    List<Map<String, dynamic>> list = [];
    _products.forEach((element) {
      list.add(element.toJson());
    });
    return {
      'branch_code': _branchCode,
      'branch_id': _branchId,
      'branch_name': _branchName,
      'commission': _commissionRestaurantModel.toJson(),
      'discount': _discount,
      'discount_rate': _discountRate,
      'group_payment': _groupPayment,
      'payment_result': _paymentResult,
      'products': list,
      'service_charge': _serviceCharge,
      'service_change_rate': _serviceChargeRate,
      'status': _status,
      'table': _tableInfo.toJson(),
      'tax': _tax,
      'tax_rate': _taxRate,
      'used_at': _usedAt
    };
  }

  String get branchId => _branchId;

  set branchId(String value) {
    _branchId = value;
  }

  String get branchName => _branchName;

  set branchName(String value) {
    _branchName = value;
  }

  String get branchCode => _branchCode;

  set branchCode(String value) {
    _branchCode = value;
  }

  CommissionRestaurantModel get commissionRestaurantModel =>
      _commissionRestaurantModel;

  set commissionRestaurantModel(CommissionRestaurantModel value) {
    _commissionRestaurantModel = value;
  }

  int get discount => _discount;

  set discount(int value) {
    _discount = value;
  }

  int get discountRate => _discountRate;

  set discountRate(int value) {
    _discountRate = value;
  }

  int get groupPayment => _groupPayment;

  set groupPayment(int value) {
    _groupPayment = value;
  }

  String get paymentResult => _paymentResult;

  set paymentResult(String value) {
    _paymentResult = value;
  }

  List<ProductOrderModel> get products => _products;

  set products(List<ProductOrderModel> value) {
    _products = value;
  }

  int get reservationId => _reservationId;

  set reservationId(int value) {
    _reservationId = value;
  }

  int get serviceCharge => _serviceCharge;

  set serviceCharge(int value) {
    _serviceCharge = value;
  }

  int get serviceChargeRate => _serviceChargeRate;

  set serviceChargeRate(int value) {
    _serviceChargeRate = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  int get tax => _tax;

  set tax(int value) {
    _tax = value;
  }

  int get taxRate => _taxRate;

  set taxRate(int value) {
    _taxRate = value;
  }

  TableModel get tableInfo => _tableInfo;

  set tableInfo(TableModel value) {
    _tableInfo = value;
  }

  int get usedAt => _usedAt;

  set usedAt(int value) {
    _usedAt = value;
  }
}
