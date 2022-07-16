import 'package:flutter/material.dart';
import 'package:uniapp/Services/api.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/models/subModel.dart';

import 'aspPayScreen.dart';

class PosSubHome extends StatefulWidget {
  @override
  _PosSubHomeState createState() => _PosSubHomeState();
}

class _PosSubHomeState extends State<PosSubHome> {
  String? userType;
  String? token;
  bool _loading = false;
  int index = 0;
  List<Subscription> subscription = <Subscription>[];
  @override
  void initState() async {
    userType = (await Constants.getUserTypeSharedPreference()) as String?;
    token = (await Constants.getUserTokenSharedPreference()) as String?;
    List<Subscription> data = await Api.getSubscription(userType!, token!);
    subscription = data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.star_border,
              color: Colors.white,
            ),
            onPressed: () => {}),
        title: Text("Subscription Plans"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.subscriptions), onPressed: () {}),
        ],
      ),
      body: Center(
        child: _loading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(
                height: MediaQuery.of(context).size.height - 60.0,
                child: Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SubAll(
                        spanName: subscription[index].planName,
                        spanCode: subscription[index].planCode,
                        spanPrice: subscription[index].planPrice,
                        sdescription1: subscription[index].description1,
                        sdescription2: subscription[index].description2,
                        sdescription3: subscription[index].description3,
                        sdescription4: subscription[index].description4,
                        sdescription5: subscription[index].description5,
                      ),
                      //Second ListView
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width - 40.0,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //       color: Color(0xff5a348b),
                      //       gradient: LinearGradient(
                      //           colors: [Color(0xffebac38), Color(0xffde4d2a)],
                      //           begin: Alignment.centerRight,
                      //           end: Alignment(-1.0, -2.0)), //Gradient
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: <Widget>[
                      //             //Text
                      //             Padding(
                      //               padding: const EdgeInsets.only(top: 8.0),
                      //               child: Container(
                      //                 child: Text(
                      //                   subscription[1].planName,
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontSize: 24.0,
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             //subText
                      //             Container(
                      //               child: Text(
                      //                 'Monthly subscription',
                      //                 style: TextStyle(
                      //                   color: Colors.white54,
                      //                   fontSize: 20.0,
                      //                 ),
                      //               ),
                      //             ),
                      //             //Circle Avatar
                      //             Padding(
                      //               padding: const EdgeInsets.only(top: 8.0),
                      //               child: Container(
                      //                   width: 150.0,
                      //                   height: 130.0,
                      //                   decoration: new BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                     color: Colors.white,
                      //                   ),
                      //                   child: Column(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.center,
                      //                     children: <Widget>[
                      //                       Container(
                      //                         child: Text(
                      //                           "${subscription[1].planPrice}",
                      //                           style: TextStyle(
                      //                             fontSize: 30.0,
                      //                             color: Color(0xff8d70fe),
                      //                             fontWeight: FontWeight.bold,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   )),
                      //             ),
                      //             //One Column Table
                      //             Expanded(
                      //               child: DataTable(
                      //                 columns: <DataColumn>[
                      //                   DataColumn(
                      //                     label: Text(
                      //                       '',
                      //                       style: TextStyle(
                      //                         color: Colors.white,
                      //                         fontSize: 16.0,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //                 rows: <DataRow>[
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(
                      //                           FontAwesomeIcons.video,
                      //                           "Video Tutorial"),
                      //                     ),
                      //                   ]),
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(FontAwesomeIcons.book,
                      //                           "1000+ Questions"),
                      //                     ),
                      //                   ]),
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(
                      //                           FontAwesomeIcons.folderOpen,
                      //                           "Offline Acess"),
                      //                     ),
                      //                   ]),
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(
                      //                           FontAwesomeIcons.phone,
                      //                           "24/7 Support"),
                      //                     ),
                      //                   ]),
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(
                      //                           FontAwesomeIcons.envelope,
                      //                           "Perfomance follow up"),
                      //                     ),
                      //                   ]),
                      //                 ],
                      //               ),
                      //             ),

                      //             //Button
                      //             Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: RaisedButton(
                      //                   color: new Color(0xffffffff),
                      //                   child: Text(
                      //                     'Subscribe',
                      //                     style: TextStyle(
                      //                       color: new Color(0xffde4d2a),
                      //                     ),
                      //                   ),
                      //                   onPressed: () {
                      //                     Navigator.push(
                      //                         context,
                      //                         MaterialPageRoute(
                      //                             builder: (context) =>
                      //                                 AspCheckoutMethodBank(
                      //                                   amount: subscription[1]
                      //                                       .planPrice,
                      //                                   planCode:
                      //                                       subscription[1]
                      //                                           .planCode,
                      //                                 )));
                      //                   },
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(30.0),
                      //                   )),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // //Third ListView
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width - 40.0,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //       color: Color(0xff5a348b),
                      //       gradient: LinearGradient(
                      //           colors: [Color(0xffcb3a57), Color(0xffcb3a57)],
                      //           begin: Alignment.centerRight,
                      //           end: Alignment(-1.0, -1.0)), //Gradient
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: <Widget>[
                      //             //Text
                      //             Padding(
                      //               padding: const EdgeInsets.only(top: 8.0),
                      //               child: Container(
                      //                 child: Text(
                      //                   subscription[2].planName,
                      //                   style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontSize: 24.0,
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             //subText
                      //             Container(
                      //               child: Text(
                      //                 'Full Acess till end of Post Utme',
                      //                 style: TextStyle(
                      //                   color: Colors.white54,
                      //                   fontSize: 20.0,
                      //                 ),
                      //               ),
                      //             ),
                      //             //Circle Avatar
                      //             Padding(
                      //               padding: const EdgeInsets.only(top: 8.0),
                      //               child: Container(
                      //                   width: 150.0,
                      //                   height: 130.0,
                      //                   decoration: new BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                     color: Colors.white,
                      //                   ),
                      //                   child: Column(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.center,
                      //                     children: <Widget>[
                      //                       Container(
                      //                         child: Text(
                      //                           "${subscription[2].planPrice}",
                      //                           style: TextStyle(
                      //                             fontSize: 30.0,
                      //                             color: Color(0xff8d70fe),
                      //                             fontWeight: FontWeight.bold,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   )),
                      //             ),
                      //             //One Column Table
                      //             Expanded(
                      //               child: DataTable(
                      //                 columns: <DataColumn>[
                      //                   DataColumn(
                      //                     label: Text(''),
                      //                   ),
                      //                 ],
                      //                 rows: <DataRow>[
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(
                      //                           FontAwesomeIcons.video,
                      //                           "Videos Tutorial"),
                      //                     ),
                      //                   ]),
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(FontAwesomeIcons.book,
                      //                           "Questions"),
                      //                     ),
                      //                   ]),
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(
                      //                           FontAwesomeIcons.folderOpen,
                      //                           "Offline Acess"),
                      //                     ),
                      //                   ]),
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(
                      //                           FontAwesomeIcons.phone,
                      //                           "24/7 Support"),
                      //                     ),
                      //                   ]),
                      //                   DataRow(cells: <DataCell>[
                      //                     DataCell(
                      //                       myRowDataIcon(
                      //                           FontAwesomeIcons.envelope,
                      //                           "Perfomance follow up"),
                      //                     ),
                      //                   ]),
                      //                 ],
                      //               ),
                      //             ),

                      //             //Button
                      //             Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: RaisedButton(
                      //                   color: new Color(0xffffffff),
                      //                   child: Text(
                      //                     'Subscribe',
                      //                     style: TextStyle(
                      //                       color: new Color(0xffcb3a57),
                      //                     ),
                      //                   ),
                      //                   onPressed: () {
                      //                     Navigator.push(
                      //                         context,
                      //                         MaterialPageRoute(
                      //                             builder: (context) =>
                      //                                 AspCheckoutMethodBank(
                      //                                     amount:
                      //                                         subscription[2]
                      //                                             .planPrice,
                      //                                     planCode:
                      //                                         subscription[2]
                      //                                             .planCode)));
                      //                   },
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(30.0),
                      //                   )),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class SubAll extends StatelessWidget {
  final String? spanName;
  final int? spanPrice;
  final String? spanCode;
  final String? sdescription1;
  final String? sdescription2;
  final String? sdescription3;
  final String? sdescription4;
  final String? sdescription5;

  SubAll(
      {this.spanName,
      this.spanPrice,
      this.spanCode,
      this.sdescription1,
      this.sdescription2,
      this.sdescription3,
      this.sdescription4,
      this.sdescription5});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 30.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff5a348b),
          gradient: LinearGradient(
              colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
              begin: Alignment.centerLeft,
              end: Alignment(-1.0, -1.0)), //Gradient
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Text
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    child: Text(
                      spanName!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                //subText
                Container(
                  child: Text(
                    sdescription1!,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                //Circle Avatar
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                      width: 150.0,
                      height: 130.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "$spanPrice",
                              style: TextStyle(
                                fontSize: 30.0,
                                color: Color(0xff8d70fe),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),

                //Two Column Table
                Expanded(
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(Icons.personal_video, sdescription2!),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(Icons.book, sdescription3!),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(Icons.folder_open, sdescription4!),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(Icons.event_note, sdescription5!),
                        ),
                      ]),
                    ],
                  ),
                ),

                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: RaisedButton(
                      color: new Color(0xffffffff),
                      child: Text(
                        'Subscribe',
                        style: TextStyle(
                          color: new Color(0xff6200ee),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AspCheckoutMethodBank(
                                    amount: spanPrice, planCode: spanCode)));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

ListTile myRowDataIcon(IconData iconVal, String rowVal) {
  return ListTile(
    leading: Icon(iconVal, color: new Color(0xffffffff)),
    title: Text(
      rowVal,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
