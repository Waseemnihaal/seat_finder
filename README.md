# seat_finder

Methodology used to create seat_finder app:

There are 3 dart file used to create the project,
-main.dart
-seat.dart
-compartment.dart

Packages used:
-hexcolor: ^3.0.1
-crollable_positioned_list: ^0.3.8
-sizer: ^2.0.15

main.dart:

-This is the main file where all funtions and methodologies are implemented to build the application.
-MyApp is the class which extends StatefulWidget and calls of compartment.dart to render the required UI.
-This compartment.dart file has been called in an ScrollablePositionedList.builder.
-Auto scroll to selected seat has implemented.

compartment.dart:

-This is the file which consist of a compartment has a set of 8 seats in it.
-compartment is the Widget name and returns 8 seats to the main.dart to render UI.
-This Widget get seat number and user input as parameters and used in seat.dart.

seat.dart:
-It is the file where a single seat UI is created and called as per requirement.
-This file consists of Widget called Seat which returns UI for a seat.
-It get num(seat number), type(type of seat), side(upper or lower), id(user input).


