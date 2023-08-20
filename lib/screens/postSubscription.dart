import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/models/subModel.dart';

import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';
import '../widgets/introvideopopup.dart';
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
  List<Subscription> _subscription = [];
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  @override
  void initState() {
    _loadDepartCourse();
    super.initState();
  }

  _loadDepartCourse() async {
    setState(() {
      _loading = true;
    });
    final result = await _apiRepository.getSubscription();
    if (result.isNotEmpty) {
      setState(() {
        _subscription = result;
      });

      setState(() {
        _loading = false;
      });
    }
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
        centerTitle: true,
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
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _subscription.length,
                    itemBuilder: (BuildContext context, int index) {
                      Subscription subscription = _subscription[index];

                      return SubAll(
                        spanName: subscription.planName,
                        spanCode: subscription.planCode,
                        spanPrice: subscription.planPrice,
                        sdescription1: subscription.description1,
                        sdescription2: subscription.description2,
                        sdescription3: subscription.description3,
                        sdescription4: subscription.description4,
                        sdescription5: subscription.description5,
                        introUrl: subscription.introUrl,
                      );
                    }),
              ),
      ),
    );
  }
}

class SubAll extends StatelessWidget {
  final String? spanName;
  final String? spanPrice;
  final String? spanCode;
  final String? sdescription1;
  final String? sdescription2;
  final String? sdescription3;
  final String? sdescription4;
  final String? sdescription5;
  final String? introUrl;

  SubAll(
      {this.spanName,
      this.spanPrice,
      this.spanCode,
      this.sdescription1,
      this.sdescription2,
      this.sdescription3,
      this.sdescription4,
      this.sdescription5,
      this.introUrl});
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
                      height: 100.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AspCheckoutMethodBank(
                                              planCode: spanCode)));
                            },
                            child: Container(
                              child: Text(
                                "$spanPrice",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Color(0xff8d70fe),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: new Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
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
                              builder: (context) =>
                                  AspCheckoutMethodBank(planCode: spanCode)));
                    },
                  ),
                ),
                //Two Column Table
                DataTable(
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
                    DataRow(cells: <DataCell>[
                      DataCell(
                        InkWell(
                          child: myRowDataIcon(Icons.preview, "Preview Course"),
                          onTap: () {
                            showDownloadPopup(context,
                                videoUrl: introUrl, description: spanName);
                          },
                        ),
                      )
                    ]),
                  ],
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
