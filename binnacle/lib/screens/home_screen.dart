import 'package:flutter/material.dart';
import 'package:sos/screens/binnacle_screen.dart';
import 'package:sos/screens/map_screen.dart';
import 'package:sos/screens/settings_screen.dart';
import 'package:sos/ui/navigation/panel.dart';

class ScreenWidget extends StatefulWidget {
  ScreenWidget({Key key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<ScreenWidget> {
  int _selectedIndex = 1;
  PageController _pageController = new PageController(initialPage: 1);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 250), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            children: <Widget>[SettingsScreen(), BinnacleScreen(), MapScreen()],
            controller: _pageController,
            pageSnapping: true,
            physics: new NeverScrollableScrollPhysics(),
          ),
          NavigationPanel(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold, height: 0.0),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_boat),
              title: Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold, height: 0.0),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold, height: 0.0),
              )),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
