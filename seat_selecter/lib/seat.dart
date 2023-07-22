import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget Seat(num, type, side, id) {
  return Row(
    children: [
      Container(
        width: 50,
        height: 50,
        color: num == id ? HexColor('5595DB') : HexColor('CEEAFF'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (side == 'U')
              SizedBox(
                height: 5,
              ),
            if (side == 'D')
              Text(
                '$type',
                style: TextStyle(
                    color: num == id ? Colors.white : HexColor('5595DB'),
                    fontSize: 8,
                    fontWeight: FontWeight.w800),
              ),
            Text(
              '$num',
              style: TextStyle(
                  color: num == id ? Colors.white : HexColor('5595DB'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            if (side == 'U')
              Text(
                '$type',
                style: TextStyle(
                    color: num == id ? Colors.white : HexColor('5595DB'),
                    fontSize: 8,
                    fontWeight: FontWeight.w800),
              ),
            if (side == 'D')
              SizedBox(
                height: 5,
              ),
          ],
        ),
      ),
      SizedBox(
        width: 2,
      ),
    ],
  );
}
