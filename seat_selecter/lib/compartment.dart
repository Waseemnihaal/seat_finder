import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:seat_selecter/seat.dart';

Widget compartment(id, d) {
  return Column(
    children: [
      SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 174,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor('82CCFF'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Row(
                        children: [
                          //  for (var i = 0; i < 3; i++)
                          Seat(id + 1, 'Lower', 'U', d),
                          Seat(id + 2, 'MIDDLE', 'U', d),
                          Seat(id + 3, 'UPPER', 'U', d),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 174,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor('82CCFF'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            //  for (var i = 0; i < 3; i++)
                            Seat(id + 4, 'Lower', 'D', d),
                            Seat(id + 5, 'MIDDLE', 'D', d),
                            Seat(id + 6, 'UPPER', 'D', d),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor('82CCFF'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Seat(id + 7, 'SIDE LOWER', 'U', d),
                    )
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor('82CCFF'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child:
                            //  for (var i = 0; i < 3; i++)
                            Seat(id + 8, 'SIDE UPPER', 'D', d),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 2,
      )
    ],
  );
}
