import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'file:///C:/Users/thangcx/AndroidStudioProjects/posIosApp/lib/model/table/position_table_model.dart';
import 'package:pos_ios_bvhn/model/table/table_model.dart';

class TableScreen extends StatefulWidget {

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {

  List<PositionTableModel> positions = [];

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    PositionTableModel dropdownValue;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF848a93),),
        backgroundColor: Color(0xFFf4f5f7),
        title: Container(
          child: Row(
            children: [
              Container(
                child: Icon(
                  Icons.dashboard,
                  color: Color(0xFF848a93),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Sơ đồ bàn", style: TextStyle( color: Color(0xFF848a93),)),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
//              borderRadius: BorderRadius.only(
//                topRight: Radius.circular(10.0),
//                bottomRight:  Radius.circular(10.0),
//              ),
              color: Color(0xFF0e1e2b)
          ),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        child: Text("Tài khoản : hoaint", style: TextStyle(
                            color: Colors.white
                        )),
                      ),
                      Container(
                        height: 40,
                        child: Text("Quyền admin, Chi nhánh Yên Ninh", style: TextStyle(
                            color: Color(0xFF848b92)
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF0e1e2b)
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.repeat,
                    color: Colors.white,
                  ),
                  title: Text('Chọn chi nhánh', style: TextStyle(
                    color: Colors.white,
                  )),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF0e1e2b)
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text('Đăng xuất', style: TextStyle(
                    color: Colors.white,
                  )),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 60,
            child: Row(
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text("Chọn tầng" , style: TextStyle(
                        fontSize: 20,
                    )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 40,
                  padding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: size.width * 0.3,
                  child: DropdownButton<PositionTableModel>(
                    value: dropdownValue,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    underline: SizedBox(),
                    onChanged: (PositionTableModel newValue) async {
                    },
                    items: positions
                        .map<DropdownMenuItem<PositionTableModel>>((PositionTableModel value) {
                      return DropdownMenuItem<PositionTableModel>(
                        value: value,
                        child: Text(value.positionName),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: size.height - 150,
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color:  Color(0xFFe8eaed)
            ),
//            child: tables != null && tables.length > 0  ? CustomScrollView(
//              slivers: <Widget>[
//                SliverPadding(
//                    padding: EdgeInsets.all(5.0),
//                    sliver: SliverGrid(
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                        ///no.of items in the horizontal axis
//                        crossAxisCount: 4,
//                        childAspectRatio: 2.0,
//                        mainAxisSpacing: 4.0,
//                        crossAxisSpacing: 4.0,
//                      ),
//                      ///Lazy building of list
//                      delegate: SliverChildBuilderDelegate(
//                              (BuildContext context, int index) {
//                            /// To convert this infinite list to a list with "n" no of items,
//                            /// uncomment the following line:
//                            /// if (index > n) return null;
//                            return Container(
//                                margin: EdgeInsets.all(5.0),
//                                decoration: BoxDecoration(
//                                    color: tables[index].using ? PrimaryGreenColor : PrimaryBlackColor,
//                                    borderRadius: BorderRadius.circular(20.0),
//                                    border: Border.all(
//                                        color: PrimaryGreenColor,
//                                        width: 2.0
//                                    )
//                                ),
//                                child: TextButton(
//                                  onPressed: () {
//                                    // TODO: If in table, there are orders, It will navigator to Screen State Order
//                                  },
//                                  child: Container(
//                                    child: Column(
//                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                      mainAxisAlignment: MainAxisAlignment.start,
//                                      children: [
//                                        Container(
//                                          child: Row(
//                                            children: [
//                                              Container(
//                                                width: 150,
//                                                child: Padding(
//                                                  padding: EdgeInsets.only(left: 20, top: 10),
//                                                  child: Text(tables[index].tableName, style: TextStyle(
//                                                      fontSize: 25,
//                                                      color: Colors.white
//                                                  )),
//                                                ),
//                                              ),
//                                              Container(
//                                                  width: 50,
//                                                  child:Padding(
//                                                    padding:  EdgeInsets.only(top: 10, left: 10),
//                                                    child: Text("", style: TextStyle(
//                                                        fontSize: 20,
//                                                        color: Colors.white
//                                                    )),
//                                                  )
//                                              )
//                                            ],
//                                          ),
//                                        ),
//                                        Container(
//                                          child: Padding(
//                                            padding: EdgeInsets.only(left: 20, top: 20),
//                                            child: Text(
//                                              tables[index].using ? "Ordered" : "No Order",
//                                              style: TextStyle(
//                                                  fontSize: 20,
//                                                  color: Colors.white
//                                              ),
//                                            ),
//                                          ),
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                )
//                            );
//                          },
//                          childCount: tables.length
//                        /// Set childCount to limit no.of items
//                        /// childCount: 100,
//                      ),
//                    )
//                ),
//              ],
//            ) : Container(),
          ),
        ],
      ),
    );
  }

}
