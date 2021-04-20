import 'package:pos_ios_bvhn/model/restaurant/category_restaurant_model.dart';

class CategoryMealRestaurantModel {

  String _categoryId;
  String _categoryCode;
  String _categoryName;
  int _status;
  int _createAt;
  int _updateAt;

  CategoryMealRestaurantModel(this._categoryId, this._categoryCode, this._categoryName, this._status, this._createAt, this._updateAt);

  factory CategoryMealRestaurantModel.fromJson(dynamic json) {
    return CategoryMealRestaurantModel(json['_id'] as String, json['category_code'] as String, json['category_name'] as String,
      json['status'] as int, json['created_at'] as int, json['updated_at'] as int);
  }

  String get categoryId => _categoryId;

  set categoryId(String value) {
    _categoryId = value;
  }

  String get categoryCode => _categoryCode;

  set categoryCode(String value) {
    _categoryCode = value;
  }

  int get updateAt => _updateAt;

  set updateAt(int value) {
    _updateAt = value;
  }

  int get createAt => _createAt;

  set createAt(int value) {
    _createAt = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }


  String get categoryName => _categoryName;

  set categoryName(String value) {
    _categoryName = value;
  }
}