import 'package:best_phone_log/screen/home_screen.dart';
import 'package:best_phone_log/screen/last_page.dart';
import 'package:best_phone_log/screen/phone_log_screen.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';


void main() {
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [PhonelogsScreen(),HomeScreen(),HomeScreen()];
  void _onTap(int index){
    setState((){
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onTap,
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(
                icon: Icon(Icons.call ),
                label: "as"

            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.today),

                label: "as2"

            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: "as3"

            )
          ],
        ),
      )
    );
  }
}