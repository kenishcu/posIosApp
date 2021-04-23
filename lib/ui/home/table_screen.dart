import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/components/drawer.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/model/table/position_table_model.dart';
import 'package:pos_ios_bvhn/model/table/table_model.dart';
import 'package:pos_ios_bvhn/model/user/branch_model.dart';
import 'package:pos_ios_bvhn/model/user/role_model.dart';
import 'package:pos_ios_bvhn/model/user/user_model.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/service/table_service.dart';
import 'package:pos_ios_bvhn/sqflite/model/user_model_sqflite.dart';
import 'package:pos_ios_bvhn/sqflite/user_sqflite.dart';
import 'package:pos_ios_bvhn/ui/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class TableScreen extends StatefulWidget {

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {

  // services
  TableService tableService = new TableService();

  List<PositionTableModel> positions = [];

  List<TableModel> tables = [];

  PositionTableModel dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  Future initData() async {

    //TODO:
    UserSqfLite userSqfLite = new UserSqfLite();
    int c = await userSqfLite.queryRowCount();

    if(c > 0) {
      UserModelSqflite userModelSqflite = await userSqfLite.findById(1);
      BranchModel newBranchModel = new BranchModel(userModelSqflite.branchId,
          userModelSqflite.branchName, userModelSqflite.branchCode, 1);
      RoleModel newRoleModel = new RoleModel(userModelSqflite.roleId,
          userModelSqflite.roleCode, userModelSqflite.roleName);
      UserModel userInfo = new UserModel(userModelSqflite.name, userModelSqflite.email, userModelSqflite.userName,
          newBranchModel, userModelSqflite.branchId, userModelSqflite.branchCode,  userModelSqflite.branchName,
          newRoleModel, userModelSqflite.roleId,
          userModelSqflite.roleCode, userModelSqflite.roleName);
      Provider.of<SettingProvider>(context, listen: false).setUserInfo(userInfo);
      // update user information from cache sqflite
    }

    String branchId = Provider.of<SettingProvider>(context, listen: false).userInfo.branchId;

    ResultModel resPosition = await tableService.getTablePositions(branchId);
    if(resPosition.status && resPosition.data != null && resPosition.data.length > 0) {
      for (int i = 0; i < resPosition.data.length; i++) {
        setState(() {
          if(resPosition.data[i]['status'] == 1) {
            positions.add(PositionTableModel.fromJson(resPosition.data[i]));
          }
        });
      }
    }
    setState(() {
      dropdownValue = positions.first;
    });

    ResultModel resTableData = await tableService.getTableDataByPosition(branchId, dropdownValue.id);
    if (resTableData.status && resTableData.data != null && resTableData.data.length > 0) {
      for (int i = 0; i < resTableData.data.length; i++) {
        setState(() {
          tables.add(TableModel.fromJson(resTableData.data[i]));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

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
      drawer: DrawerCustom(),
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
                      ResultModel resTableData = await tableService.getTableDataByPosition(newValue.branchId, newValue.id);
                      setState(() {
                        dropdownValue = newValue;
                        tables = [];
                        if (resTableData.status && resTableData.data != null && resTableData.data.length > 0) {
                          for (int i = 0; i < resTableData.data.length ; i++) {
                            tables.add(TableModel.fromJson(resTableData.data[i]));
                          }
                        }
                      });
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
            child: tables != null && tables.length > 0  ? CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                    padding: EdgeInsets.all(5.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        ///no.of items in the horizontal axis
                        crossAxisCount: 4,
                        childAspectRatio: 2.0,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                      ///Lazy building of list
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            /// To convert this infinite list to a list with "n" no of items,
                            /// uncomment the following line:
                            /// if (index > n) return null;
                            return Container(
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: tables[index].using ?  PrimaryOrangeColor : PrimaryGreenColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: PrimaryGreenColor,
                                        width: 2.0
                                    )
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: If in table, there are orders, It will navigator to Screen State Order
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => HomeScreen(table: tables[index],))
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 120,
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 20, top: 10),
                                                  child: Text(tables[index].tableName, style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.white
                                                  )),
                                                ),
                                              ),
                                              Container(
                                                  width: 50,
                                                  child:Padding(
                                                    padding:  EdgeInsets.only(top: 10, left: 10),
                                                    child: Text("", style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white
                                                    )),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 20, top: 10),
                                            child: Text(
                                              tables[index].using ? "Đã Đặt" : "Chưa Đặt",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            );
                          },
                          childCount: tables.length
                        /// Set childCount to limit no.of items
                        /// childCount: 100,
                      ),
                    )
                ),
              ],
            ) : Container(),
          ),
        ],
      ),
    );
  }

}
