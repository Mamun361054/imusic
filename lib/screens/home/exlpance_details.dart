import 'package:flutter/material.dart';

class ExpanseDetails extends StatelessWidget {
  const ExpanseDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 4,
          centerTitle: true,
          backgroundColor: const Color(0xFF00a8e6),
          title: const Text('Expense Details')),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(width: 130, child: Text("Requested Amount")),
                  Spacer(),
                  Text(
                    '\$600',
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(width: 130, child: Text("Approved Amount")),
                  Spacer(),
                  Text(
                    '\$600',
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(width: 130, child: Text("Date Show")),
                  Spacer(),
                  Text(
                    '4th Sep, 2022',
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(width: 130, child: Text("Payment")),
                  Spacer(),
                  Text(
                    'Unpaid',
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(width: 130, child: Text("Status")),
                  Spacer(),
                  Text(
                    'Unpaid',
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(width: 130, child: Text("Reason")),
                  Spacer(),
                  Text(
                    'No reason',
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
      // body: SafeArea(
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Card(
      //           elevation: 8,
      //           child: Container(
      //             height: 450,
      //             width: 350,
      //             child: Column(
      //               children: [
      //                 const Text(
      //                   'Advance Salary',
      //                   style: TextStyle(
      //                       fontSize: 24, fontWeight: FontWeight.bold),
      //                 ),
      //                 const Divider(
      //                   thickness: 1,
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Container(
      //                     decoration: const BoxDecoration(
      //                       borderRadius: BorderRadius.all(Radius.circular(5)),
      //                       gradient: LinearGradient(
      //                           colors: [
      //                             Color(0xFFFB7159),
      //                             Color(0xFF00a8e6),
      //                           ],
      //                           begin: FractionalOffset(3.0, 5.0),
      //                           end: FractionalOffset(0.0, 9.0),
      //                           stops: [0.0, 1.0],
      //                           tileMode: TileMode.clamp),
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Row(
      //                         children: const [
      //                           Text(
      //                             'Requested Amount :',
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 20,
      //                             ),
      //                           ),
      //                           Spacer(),
      //                           Text(
      //                             '\$600',
      //                             style: TextStyle(
      //                                 fontSize: 20, color: Colors.white),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Container(
      //                     decoration: const BoxDecoration(
      //                       borderRadius: BorderRadius.all(Radius.circular(5)),
      //                       gradient: LinearGradient(
      //                           colors: [
      //                             Color(0xFFFB7159),
      //                             Color(0xFF00a8e6),
      //                           ],
      //                           begin: FractionalOffset(3.0, 5.0),
      //                           end: FractionalOffset(0.0, 9.0),
      //                           stops: [0.0, 1.0],
      //                           tileMode: TileMode.clamp),
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Row(
      //                         children: const [
      //                           Text(
      //                             'Approved Anount :',
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 20,
      //                             ),
      //                           ),
      //                           Spacer(),
      //                           Text(
      //                             '\$600',
      //                             style: TextStyle(
      //                                 fontSize: 20, color: Colors.white),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Container(
      //                     decoration: const BoxDecoration(
      //                       borderRadius: BorderRadius.all(Radius.circular(5)),
      //                       gradient: LinearGradient(
      //                           colors: [
      //                             Color(0xFFFB7159),
      //                             Color(0xFF00a8e6),
      //                           ],
      //                           begin: FractionalOffset(3.0, 5.0),
      //                           end: FractionalOffset(0.0, 9.0),
      //                           stops: [0.0, 1.0],
      //                           tileMode: TileMode.clamp),
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Row(
      //                         children: const [
      //                           Text(
      //                             'Date Show :',
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 20,
      //                             ),
      //                           ),
      //                           Spacer(),
      //                           Text(
      //                             '4th Sep, 2022',
      //                             style: TextStyle(
      //                                 fontSize: 20, color: Colors.white),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Container(
      //                     decoration: const BoxDecoration(
      //                       borderRadius: BorderRadius.all(Radius.circular(5)),
      //                       gradient: LinearGradient(
      //                           colors: [
      //                             Color(0xFFFB7159),
      //                             Color(0xFF00a8e6),
      //                           ],
      //                           begin: FractionalOffset(3.0, 5.0),
      //                           end: FractionalOffset(0.0, 9.0),
      //                           stops: [0.0, 1.0],
      //                           tileMode: TileMode.clamp),
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Row(
      //                         children: const [
      //                           Text(
      //                             'Payment :',
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 20,
      //                             ),
      //                           ),
      //                           Spacer(),
      //                           Text(
      //                             'Unpaid',
      //                             style: TextStyle(
      //                                 fontSize: 20, color: Colors.white),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Container(
      //                     decoration: const BoxDecoration(
      //                       borderRadius: BorderRadius.all(Radius.circular(5)),
      //                       gradient: LinearGradient(
      //                           colors: [
      //                             Color(0xFFFB7159),
      //                             Color(0xFF00a8e6),
      //                           ],
      //                           begin: FractionalOffset(3.0, 5.0),
      //                           end: FractionalOffset(0.0, 9.0),
      //                           stops: [0.0, 1.0],
      //                           tileMode: TileMode.clamp),
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Row(
      //                         children: const [
      //                           Text(
      //                             'Status',
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 20,
      //                             ),
      //                           ),
      //                           Spacer(),
      //                           Text(
      //                             'Pending',
      //                             style: TextStyle(
      //                                 fontSize: 20, color: Colors.white),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Container(
      //                     decoration: const BoxDecoration(
      //                       borderRadius: BorderRadius.all(Radius.circular(5)),
      //                       gradient: LinearGradient(
      //                           colors: [
      //                             Color(0xFFFB7159),
      //                             Color(0xFF00a8e6),
      //                           ],
      //                           begin: FractionalOffset(3.0, 5.0),
      //                           end: FractionalOffset(0.0, 9.0),
      //                           stops: [0.0, 1.0],
      //                           tileMode: TileMode.clamp),
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Row(
      //                         children: const [
      //                           Text(
      //                             'Reason',
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 20,
      //                             ),
      //                           ),
      //                           Spacer(),
      //                           Text(
      //                             'desc',
      //                             style: TextStyle(
      //                                 fontSize: 20, color: Colors.white),
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
