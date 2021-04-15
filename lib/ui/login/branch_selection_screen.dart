import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BranchSelectionScreen extends StatefulWidget{
  @override
  _BranchSelectionScreenState createState() => _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends State<BranchSelectionScreen> {

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60,
              width: size.width * 1,
              decoration: BoxDecoration(
                color: Color(0xFFf4f5f7)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: 120,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white
                    ),
                    child: TextButton(
                      onPressed: () {  },
                      child: Text("Đăng nhập lại", style: TextStyle(

                      )),
                    )
                  ),
                  Container(
                    height: 45,
                    width: 150,
                    margin: EdgeInsets.only(right: 20),
                    child: Stack(
                      children: [
                        Positioned(
                            top: 10,
                            left: 20,
                            child: Icon(
                          Icons.circle,
                          size: 15,
                          color: Color(0xFF2ea85b),
                        )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 40, top: 10),
                          child: Text("Restaurant open", style: TextStyle(

                          )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
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
                            child: Text("Accepted", style: TextStyle(
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
                              child: Text("10", style: TextStyle(
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
                          children: List.generate(10, (index) {
                            return Card(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10, top: 10),
                                        child: Text("# Chi nhánh " + index.toString(), style: TextStyle(
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
                                        color: Color(0xFF589a1d),
                                        borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      child: Center(
                                        child: Text("Sẵn sàng", style: TextStyle(
                                            color: Colors.white
                                        )),
                                      ),
                                    )
                                  ],
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
