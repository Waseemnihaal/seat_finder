import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:seat_selecter/compartment.dart';
import 'package:sizer/sizer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _finder = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ItemScrollController itemScrollController = ItemScrollController();

  bool _search = false;
  int _seatId = 0;
  var id = 0, subId, ind = 1.0;

  Future scroll() async {
    ind = id / 8;
    itemScrollController.scrollTo(
        index: ind.toInt(), alignment: 0, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Sizer(builder: (context, orientation, deviceType) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Seat Finder',
                    style: TextStyle(
                        color: HexColor('82CCFF'),
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _finder,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Enter Seat Number',
                          hintStyle: TextStyle(color: HexColor('82CCFF')),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: HexColor('82CCFF'))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 2, color: HexColor('82CCFF'))),
                          suffixIcon: Container(
                            width: 100,
                            height: 55,
                            padding: EdgeInsets.only(right: 2),
                            child: ElevatedButton(
                              child: Text(
                                'Find',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: _search
                                      ? HexColor('82CCFF')
                                      : HexColor('D9D9D9')),
                              onPressed: () {
                                if (_search &&
                                    _formKey.currentState!.validate()) {
                                  setState(() {
                                    subId = _finder.text;
                                    id = int.parse(subId);
                                  });
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  scroll();
                                }
                              },
                            ),
                          )),
                      onChanged: (value) {
                        if (value == '') {
                          setState(() {
                            _search = false;
                          });
                        } else {
                          setState(() {
                            _search = true;
                          });
                          print(_finder.text);
                        }
                      },
                      validator: (value) {
                        if (int.parse(value!) > 80)
                          return 'Only 80 seats available';
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        if (_search && _formKey.currentState!.validate()) {
                          setState(() {
                            subId = _finder.text;
                            id = int.parse(subId);
                          });

                          scroll();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 70.h,
                    child: ScrollablePositionedList.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return compartment(_seatId + index * 8, id);
                      },
                      itemScrollController: itemScrollController,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
