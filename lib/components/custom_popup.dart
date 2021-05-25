import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/model/restaurant/order_payment_type_model.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/model/user/partner_customer_model.dart';
import 'package:pos_ios_bvhn/service/partner_customer_service.dart';
import 'package:select_dialog/select_dialog.dart';

import '../constants.dart';

typedef void PaymentCallBack(OrderPaymentTypeModel val, String receiver, String customer);

class CustomPopup extends StatefulWidget {

  CustomPopup({this.callback, this.receiver, this.customer, key}): super(key: key);

  final PaymentCallBack callback;

  final String receiver;

  final String customer;

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {

  List<OrderPaymentTypeModel> paymentTypes = [
    OrderPaymentTypeModel("Thanh toán khác", 'OTHER'),
    OrderPaymentTypeModel("Khách nợ", 'DEBT'),
    OrderPaymentTypeModel("Thanh toán thẻ", 'CREDIT_CARD'),
    OrderPaymentTypeModel("Miễn phí", 'FREE'),
  ];

  bool checkedValue = false;

  OrderPaymentTypeModel dropdownPaymentTypeValue;

  TextEditingController receiverController =  new TextEditingController();

  TextEditingController customerController =  new TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.black87);

  PartnerCustomer ex1;

  final PartnerCustomerService partnerCustomerService = new PartnerCustomerService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownPaymentTypeValue = paymentTypes.first;
    receiverController.text = widget.receiver;
    customerController.text = widget.customer;
  }

  @override
  void dispose() {
    receiverController.dispose();
    customerController.dispose();
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

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30, top: 10),
          height: 50,
          padding:
          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)),
          width: size.width * 0.3,
          child: DropdownButton<OrderPaymentTypeModel>(
            value: dropdownPaymentTypeValue,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            underline: SizedBox(),
            onChanged: (OrderPaymentTypeModel newValue) async {
              setState(() {
                dropdownPaymentTypeValue = newValue;
                widget.callback(newValue, receiverController.text, customerController.text);
              });
            },
            items: paymentTypes
                .map<DropdownMenuItem<OrderPaymentTypeModel>>((OrderPaymentTypeModel value) {
              return DropdownMenuItem<OrderPaymentTypeModel>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
        dropdownPaymentTypeValue != null && dropdownPaymentTypeValue.value == "DEBT" ? Container(
          height: 50,
          margin: EdgeInsets.only(left: 30, top: 10, bottom: 20),
          child: Container(
              height: 50,
              width: size.width * 0.3,
              child: Form(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all()
                  ),
                  child: TextFormField(
                    obscureText: false,
                    controller: receiverController,
                    style: style,
                    onChanged: (val) {
                      widget.callback(dropdownPaymentTypeValue, val, customerController.text);
                    },
                    decoration: InputDecoration(
                        hintText: "Điền người nhận",
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
              )
          ),
        ): Container(
        ),
        dropdownPaymentTypeValue != null && (dropdownPaymentTypeValue.value == "OTHER" || dropdownPaymentTypeValue.value == "CREDIT_CARD")
            ? Container(
          height: 70,
        ): Container(),
        dropdownPaymentTypeValue != null && dropdownPaymentTypeValue.value == "FREE" ?  Container(
          width: size.width * 0.5,
          height: 50,
          margin: EdgeInsets.only(left: 30, top: 10, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: size.width * 0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all()
                ),
                child: TextFormField(
                  obscureText: false,
                  controller: customerController,
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 14.0, color: Colors.black87),
                  decoration: InputDecoration(
                      hintText: "",
                      enabled: false,
                      contentPadding: EdgeInsets.only(left: 10),
                      fillColor: PrimaryBlackColor,
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: PrimaryGreyColor
                      ),
                      border: InputBorder.none
                  ),
                ),
              ),
              Container(
                height: 50,
                width: size.width * 0.15,
                margin: EdgeInsets.only(left: 10),
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
                            widget.callback(dropdownPaymentTypeValue, receiverController.text, customerController.text);
                          });
                        }
                    );
                  },
                ),
              ),
              Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.0)
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      customerController.text = "";
                      widget.callback(dropdownPaymentTypeValue, receiverController.text, customerController.text);
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ) : Container()
      ],
    );
  }

}