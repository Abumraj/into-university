import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/models/departCoursesModel.dart';
import 'package:uniapp/screens/paymentScreen.dart';

import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());
  List<DepartCourse> _departCourse = [];
  int _totalPrice = 0;
  @override
  void initState() {
    _loadDepartCourse();
    super.initState();
  }

  _loadDepartCourse() async {
    final result = await _apiRepository.getCart();
    if (result.isNotEmpty) {
      setState(() {
        _departCourse = result;
      });
      print(_departCourse);
    }
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        showCheckboxColumn: false,
        dataTextStyle:
            TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        columns: [
          // DataColumn(
          //   label: Text("COURSE NAME"),
          //   numeric: false,),
          DataColumn(
            label: Text("COURSE CODE"),
            numeric: false,
          ),
          // DataColumn(
          //   label: Text("UNIT"),
          //   numeric: true,
          // ),
          DataColumn(
            label: Text("PRICE"),
            numeric: true,
          ),
        ],
        rows: _departCourse.map((course) {
          _totalPrice += course.coursePrice;
          return DataRow(
              selected: _departCourse.contains(course),
              onSelectChanged: (b) {},
              cells: [
                // DataCell(
                //   Text(course.courseName),
                //   onTap: () {
                //     print('Selected ${course.courseName}');
                //   },
                // ),
                DataCell(
                  Text(course.coursecode.toString()),
                ),
                // DataCell(
                //   Center(
                //     child: Badge(
                //       toAnimate: true,
                //       shape: BadgeShape.square,
                //       badgeColor: Colors.purple,
                //       borderRadius: BorderRadius.circular(8),
                //       badgeContent: Text("${course.courseUnit}",
                //           style: TextStyle(color: Colors.white)),
                //     ),
                //   ),
                // ),
                DataCell(
                  Center(
                      child: Text(course.coursePrice < 1
                          ? "FREE"
                          : "₦${course.coursePrice}")),
                ),
              ]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          "CART VIEW",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _departCourse.isEmpty
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                    child: Text(
                      "SELECTED COURSE(S)",
                      style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                Expanded(
                  child: dataBody(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: RaisedButton(
                            color: Colors.purple,
                            child: Text(
                              'Pay ₦' + "$_totalPrice  now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CheckoutMethodBank(amount: _totalPrice),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
