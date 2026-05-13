import 'package:flutter/material.dart';

class expanded_listen extends StatelessWidget {
  const expanded_listen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).width,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Container(height: 100, width: 200, color: Colors.red),
            Container(height: 100, width: 200, color: Colors.blue),
            Container(height: 100, width: 200, color: Colors.blueGrey),
            Expanded(
              // child: Container( color: Colors.green),
              child: Container( height: 100, width: 200,color: Colors.green),
            ),
          ],
        ),


          //       child: Row(
          // children: [
          //   Container(height: 100, width: 200, color: Colors.red),
          //   Container(height: 100, width: 200, color: Colors.blue),
          //   Container(height: 100, width: 200, color: Colors.blueGrey),
          //   Expanded(
          //     // child: Container( color: Colors.green),
          //     child: Container( height: 100, width: 200,color: Colors.green),
          //   ),
          // ],
        // ),
      ),
    );
  }
}
