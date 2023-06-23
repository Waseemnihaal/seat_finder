import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final myTransformer = Xml2Json();
var _district = 'All', _taluk = 'All', disres, takres, vilres;
bool flag = true, talukb = true, villb = true;

List<_dis> _districtList = [];
List<_tal> _talukList = [];

class _MyAppState extends State<MyApp> {
  Future dis() async {
    try {
      var response = await http.post(
          Uri.parse(
              'https://lgdirectory.gov.in/webservices/lgd/napix/districts/v1/status/active'),
          body: {});
      if (response.statusCode == 200) {
        disres = jsonDecode(response.body);
        print(disres);
        for (var i = 0; i < disres.length; i++) {
          _districtList.add(_dis(
              disres[i]['districtNameEnglish'], disres[i]['districtCode']));
        }
        setState(() {
          flag = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future Tal(n) async {
    var k = '';
    try {
      for (var i = 0; i < _districtList.length; i++) {
        if (n == _districtList[i].disName.toString()) {
          k = _districtList[i].disCode.toString();
        }
      }
      var response = await http.post(
        Uri.parse('https://lgdirectory.gov.in/webservice/lgdws/blockList'),
        body: {"districtCode": k},
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        //  encoding: Encoding.getByName("utf-8"),
      );
      myTransformer.parse(response.body);
      takres = myTransformer.toGData();
      takres = jsonDecode(takres);
      if (response.statusCode == 200) {
        for (var i = 1; i < takres['sdp']['response'].length; i++) {
          _talukList.add(_tal(takres['sdp']['response'][i]['value'],
              takres['sdp']['response'][i]['name']));
        }
        setState(() {
          talukb = false;
        });
        print(takres);
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  Future vill() async {
    try {
      var response = await http.post(
          Uri.parse(
              'https://lgdirectory.gov.in/webservices/lgd/napix/state/7/villages/v1/status/active'),
          body: {});
      if (response.statusCode == 200) {
        vilres = jsonDecode(response.body);
        print(vilres);
        setState(() {
          villb = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (flag) {
      dis();
    }
    return MaterialApp(
        home: Scaffold(
            body: SingleChildScrollView(
      child: Center(
        child: flag
            ? Container()
            : Container(
                // height: 400,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('District:'),
                        SizedBox(
                          width: 150,
                          child: SearchField(
                            suggestions: _districtList.map((_dis val) {
                              return SearchFieldListItem(
                                val.disName,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(val.disName),
                                ),
                              );
                            }).toList(),
                            onSuggestionTap: (p0) {
                              Tal(p0.searchKey);
                              // _district = p0;
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Taluk:'),
                        talukb
                            ? Container(
                                width: 150,
                              )
                            : SizedBox(
                                width: 150,
                                child: SearchField(
                                  suggestions: _talukList.map((_tal val) {
                                    return SearchFieldListItem(
                                      val.talName,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(val.talName),
                                      ),
                                    );
                                  }).toList(),
                                  onSuggestionTap: (p0) {
                                    // _district = p0;
                                    vill();
                                  },
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Villages:'),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: {0: FixedColumnWidth(50)},
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('SI.No'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Village Name'),
                            ),
                          ]),
                          if (!villb)
                            for (var i = 0; i < vilres.length; i++)
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${i + 1}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${vilres[i]['villageNameEnglish']}'),
                                ),
                              ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    )));
  }
}

class _dis {
  _dis(this.disName, this.disCode);
  final String disName;
  final int disCode;
}

class _tal {
  _tal(this.talName, this.talCode);
  final String talName;
  final String talCode;
}
