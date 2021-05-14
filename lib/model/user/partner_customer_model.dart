class ListPartnerCustomer {

  List<PartnerCustomer> _results;

  List<PartnerCustomer> get results => _results;

  set results(List<PartnerCustomer> value) {
    _results = value;
  }

  ListPartnerCustomer(this._results);

  factory ListPartnerCustomer.fromJson(dynamic data) {
    List<PartnerCustomer> partners = [];
    if(data != null && data.length > 0) {
      for(int i = 0; i < data.length; i++) {
        partners.add(PartnerCustomer.fromJson(data[i]));
      }
    }
    return ListPartnerCustomer(partners);
  }
}

class PartnerCustomer {
  String _id;
  int _partnerCustomerId;
  String _partnerCustomerCode;
  String _partnerCustomerName;

  PartnerCustomer(this._id, this._partnerCustomerId, this._partnerCustomerCode,
      this._partnerCustomerName);

  factory PartnerCustomer.fromJson(dynamic json) {
    return PartnerCustomer(json['_id'] as String , json['partner_customer_id'] as int,
        json['partner_customer_code'] as String, json['partner_customer_name'] as String);
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  int get partnerCustomerId => _partnerCustomerId;

  set partnerCustomerId(int value) {
    _partnerCustomerId = value;
  }

  String get partnerCustomerCode => _partnerCustomerCode;

  set partnerCustomerCode(String value) {
    _partnerCustomerCode = value;
  }

  String get partnerCustomerName => _partnerCustomerName;

  set partnerCustomerName(String value) {
    _partnerCustomerName = value;
  }

}
