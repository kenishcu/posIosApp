import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/model/restaurant/order_payment_type_model.dart';

typedef void PaymentCallBack(OrderPaymentTypeModel val, bool checked);

class CustomPopup extends StatefulWidget {

  CustomPopup({this.callback, key}): super(key: key);

  final PaymentCallBack callback;
  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {

  List<OrderPaymentTypeModel> paymentTypes = [
    OrderPaymentTypeModel("Thanh toán tổng hợp", 'OTHER'),
    OrderPaymentTypeModel("Khách nợ", 'DEBT'),
    OrderPaymentTypeModel("Thanh toán thẻ", 'CREDIT_CARD'),
    OrderPaymentTypeModel("Miễn phí", 'FREE'),
  ];

  bool checkedValue = false;

  OrderPaymentTypeModel dropdownPaymentTypeValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownPaymentTypeValue = paymentTypes.first;
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
                widget.callback(newValue, checkedValue);
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
        dropdownPaymentTypeValue != null && dropdownPaymentTypeValue.value == "ROOM" ? Container(
          height: 50,
          margin: EdgeInsets.only(left: 30),
          child: Container(
              height: 50,
              width: size.width * 0.3,
              child: CheckboxListTile(
                title: Text('Group payment', style: TextStyle(

                )),
                value: checkedValue,
                onChanged: (value) {
                  setState(() {
                    widget.callback(dropdownPaymentTypeValue, checkedValue);
                    checkedValue = value;
                  });
                },
              )
          ),
        ): Container(
          height: 50,
        ),
      ],
    );
  }

}
