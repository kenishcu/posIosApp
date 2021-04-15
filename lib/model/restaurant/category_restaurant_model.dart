class CategoryRestaurantModel {
  String _categoryId;
  String _categoryCode;
  String _categoryName;

  CategoryRestaurantModel(this._categoryId, this._categoryCode, this._categoryName);

  factory CategoryRestaurantModel.fromJson(dynamic json) {
    return CategoryRestaurantModel(json['category_id'] as String,
        json['category_code'] as String, json['category_name'] as String);
  }

  String get categoryId => _categoryId;

  set categoryId(String value) {
    _categoryId = value;
  }

  String get categoryCode => _categoryCode;

  set categoryCode(String value) {
    _categoryCode = value;
  }

  String get categoryName => _categoryName;

  set categoryName(String value) {
    _categoryName = value;
  }
}
