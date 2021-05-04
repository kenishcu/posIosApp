import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_ios_bvhn/components/drawer.dart';
import 'package:pos_ios_bvhn/model/restaurant/branch_restaurant_model.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/model/user/branch_model.dart';
import 'package:pos_ios_bvhn/model/user/user_model.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/service/branch_service.dart';
import 'package:pos_ios_bvhn/sqflite/model/user_model_sqflite.dart';
import 'package:pos_ios_bvhn/sqflite/user_sqflite.dart';
import 'package:pos_ios_bvhn/ui/home/table_screen.dart';
import 'package:provider/provider.dart';

class BranchSelectionScreen extends StatefulWidget{
  @override
  _BranchSelectionScreenState createState() => _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends State<BranchSelectionScreen> {

  ScrollController _scrollController;

  BranchService branchService = new BranchService();

  List<BranchRestaurantModel> branches = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  Future initData() async {
    ResultModel res = await branchService.getAllBranches();
    if(res.status) {
      if(res.data != null && res.data.length > 0) {
        for(int i = 0; i < res.data.length; i++) {
          setState(() {
            branches.add(BranchRestaurantModel.fromJson(res.data[i]));
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;


    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF848a93),),
        backgroundColor: Color(0xFFf4f5f7),
        title: Container(
          decoration: BoxDecoration(
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 45,
                  width: 120,
                  margin: EdgeInsets.only(left: 0),

              ),
              Container(
                height: 45,
                width: 200,
                margin: EdgeInsets.only(right: 20),
                child: Stack(
                  children: [
                    Positioned(
                        top: 10,
                        left: 0,
                        child: Icon(
                          Icons.circle,
                          size: 15,
                          color: Color(0xFF2ea85b),
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: Text("Chi nhánh sẵn sàng", style: TextStyle(
                        color: Colors.grey
                      )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      drawer: DrawerCustom(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height - 60,
              width: size.width * 1,
              decoration: BoxDecoration(
                color:  Color(0xFFf4f5f7)
              ),
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:  Color(0xFFe8eaed)
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          Container(
                            child: Text("CÁC CHI NHÁNH ", style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            )),
                          ),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Color(0xFFf4f5f7)
                            ),
                            margin: EdgeInsets.only(left: 20),
                            child: Center(
                              child: Text( branches.length > 0 ? branches.length.toString() : "0", style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: size.height - 150,
//                      width: size.width * 1,
                      child: CupertinoScrollbar(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 3.0,
                          padding: const EdgeInsets.only(left:20.0, top: 4, right: 20, bottom: 4),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          children: List.generate( branches.length, (index) {
                            return Card(
                              child: Container(
                                child: TextButton(
                                  onPressed: () async {
                                    //TODO: set config branch
                                    BranchModel newBranch = BranchModel(branches[index].branchId, branches[index].branchName,  branches[index].branchCode,  branches[index].status);
                                    UserModel userInfo = Provider.of<SettingProvider>(context, listen: false).userInfo;
                                    userInfo.branch = newBranch;
                                    userInfo.branchCode = newBranch.branchCode;
                                    userInfo.branchName = newBranch.branchName;
                                    userInfo.branchId = newBranch.branchId;
                                    Provider.of<SettingProvider>(context, listen: false).setUserInfo(userInfo);

                                    //TODO: up data sqflite
                                    UserSqfLite userSqfLite = new UserSqfLite();
                                    int c = await userSqfLite.queryRowCount();

                                    if(c > 0) {
                                      UserModelSqflite userModelSqflite = await userSqfLite.findById(1);
                                      userModelSqflite.branchCode = newBranch.branchCode;
                                      userModelSqflite.branchName = newBranch.branchName;
                                      userModelSqflite.branchId = newBranch.branchId;

                                      await userSqfLite.update(userModelSqflite);
                                    }

                                    //TODO: go to table screen
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => TableScreen())
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10, top: 10),
                                          child: Text("# Chi nhánh " + branches[index].branchName, style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          )),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 120,
                                        margin: EdgeInsets.only(left: 200, top: 10),
                                        decoration: BoxDecoration(
                                            color: branches[index].status == 1 ? Color(0xFF589a1d) : Colors.redAccent,
                                            borderRadius: BorderRadius.circular(5.0)
                                        ),
                                        child: Center(
                                          child: Text(branches[index].status == 1 ? "Sẵn sàng" : "Tạm dừng", style: TextStyle(
                                              color: Colors.white
                                          )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
