class ProductRestaurantModel {
  String _id;
  String _productCode;
  String _productName;
  String _categoryParentId;
  String _categoryParentCode;
  String _categoryParentName;
  String _categoryId;
  String _categoryCode;
  String _categoryName;
  int _status;
  int _price;
  String _imageUrl;
  List<ProductRestaurantModel> _combo;
  int _categoryStatus;
  dynamic _supplies;
  String _unitCode;
  String _unitId;
  String _unitName;
  int _unitStatus;

  ProductRestaurantModel(this._id, this._productCode, this._productName, this._categoryParentId,
      this._categoryParentCode, this._categoryParentName, this._categoryId, this._categoryCode,
      this._categoryName, this._status, this._price, this._imageUrl, this._combo, this._categoryStatus,
      this._supplies, this._unitCode, this._unitId, this._unitName, this._unitStatus);

  factory ProductRestaurantModel.fromJson(dynamic json) {

    List<ProductRestaurantModel> combo = [];

    if (json['combo'] != null && json['combo'].length > 0) {
      for(int i = 0; i < json['combo'].length; i++) {
        combo.add(ProductRestaurantModel.fromJson(json['combo'][i]));
      }
    }

    return ProductRestaurantModel(json['_id'] as String, json['product_code'] as String, json['product_name'] as String,
    json['category_parent_id'] as String, json['category_parent_code'] as String, json['category_parent_name'] as String,
    json['category_id'] as String, json['category_code'] as String, json['category_name'] as String, json['status'] as int, json['price'] as int,
    json['image_url'] as String, combo, json['category_status'] as int, json['supplies'] as dynamic,
    json['unit_code'] as String, json['unit_id'] as String, json['unit_name'] as String, json['unit_status'] as int);
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get productCode => _productCode;

  set productCode(String value) {
    _productCode = value;
  }

  String get productName => _productName;

  set productName(String value) {
    _productName = value;
  }

  String get categoryParentId => _categoryParentId;

  set categoryParentId(String value) {
    _categoryParentId = value;
  }

  String get categoryParentCode => _categoryParentCode;

  set categoryParentCode(String value) {
    _categoryParentCode = value;
  }

  String get categoryParentName => _categoryParentName;

  set categoryParentName(String value) {
    _categoryParentName = value;
  }


  List<ProductRestaurantModel> get combo => _combo;

  set combo(List<ProductRestaurantModel> value) {
    _combo = value;
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

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  int get price => _price;

  set price(int value) {
    _price = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  int get categoryStatus => _categoryStatus;

  set categoryStatus(int value) {
    _categoryStatus = value;
  }

  dynamic get supplies => _supplies;

  set supplies(dynamic value) {
    _supplies = value;
  }

  String get unitCode => _unitCode;

  set unitCode(String value) {
    _unitCode = value;
  }

  String get unitId => _unitId;

  set unitId(String value) {
    _unitId = value;
  }

  String get unitName => _unitName;

  set unitName(String value) {
    _unitName = value;
  }

  int get unitStatus => _unitStatus;

  set unitStatus(int value) {
    _unitStatus = value;
  }
}
