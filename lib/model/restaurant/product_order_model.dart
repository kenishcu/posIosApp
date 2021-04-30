class ProductOrderModel {

  String _id;
  String _productCode;
  String _productName;
  String _categoryParentId;
  String _categoryParentCode;
  String _categoryParentName;
  String _categoryId;
  String _categoryCode;
  String _categoryName;
  String _status;
  int _price;
  String _imageUrl;
  dynamic _combo;
  int _categoryStatus;
  dynamic _supplies;
  String _unitCode;
  String _unitId;
  String _unitName;
  int _unitStatus;

  int _discount;
  String _discountField;
  int _discountRate;
  int _discountValue;
  bool _isEdit;
  String _note;
  int _quantity;

  ProductOrderModel(this._id, this._productCode, this._productName, this._categoryParentId,
      this._categoryParentCode, this._categoryParentName, this._categoryId, this._categoryCode,
      this._categoryName, this._status, this._price, this._imageUrl, this._combo, this._categoryStatus,
      this._supplies, this._unitCode, this._unitId, this._unitName, this._unitStatus,
      this._discount, this._discountField, this._discountRate, this._discountValue, this._isEdit,
      this._note, this._quantity);

  factory ProductOrderModel.fromJson(dynamic json) {
    return ProductOrderModel(json['_id'] as String, json['product_code'] as String, json['product_name'] as String,
        json['category_parent_id'] as String, json['category_parent_code'] as String, json['category_parent_name'] as String,
        json['category_id'] as String, json['category_code'] as String, json['category_name'] as String, json['status'] as String, json['price'] as int,
        json['image_url'] as String, json['combo'] as dynamic, json['category_status'] as int, json['supplies'] as dynamic,
        json['unit_code'] as String, json['unit_id'] as String, json['unit_name'] as String, json['unit_status'] as int,
        json['discount'] as int, json['discount_field'] as String, json['discount_rate'] as int, json['discount_value'] as int,
        json['is_edit'] as bool, json['note'] as String, json['quantity'] as int);
  }

  toJson() {
    return {
      '_id': _id,
      'product_code': _productCode,
      'product_name': _productName,
      'category_parent_id': _categoryParentId,
      'category_parent_code': _categoryParentCode,
      'category_parent_name': _categoryParentName,
      'category_id': _categoryId,
      'category_code': _categoryCode,
      'category_name': _categoryName,
      'status': _status,
      'price': _price,
      'image_url': _imageUrl,
      'combo': _combo,
      'category_status': _categoryStatus,
      'supplies': _supplies,
      'unit_code': _unitCode,
      'unit_id': _unitId,
      'unit_name': _unitName,
      'unit_status': _unitStatus,
      'discount': _discount,
      'discount_field': _discountField,
      'discount_rate': _discountRate,
      'discount_value': _discountValue,
      'is_edit': _isEdit,
      'note': _note,
      'quantity': _quantity
    };
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

  String get status => _status;

  set status(String value) {
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

  dynamic get combo => _combo;

  set combo(dynamic value) {
    _combo = value;
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

  int get discount => _discount;

  set discount(int value) {
    _discount = value;
  }

  String get discountField => _discountField;

  set discountField(String value) {
    _discountField = value;
  }

  int get discountRate => _discountRate;

  set discountRate(int value) {
    _discountRate = value;
  }

  int get discountValue => _discountValue;

  set discountValue(int value) {
    _discountValue = value;
  }

  bool get isEdit => _isEdit;

  set isEdit(bool value) {
    _isEdit = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }
}
