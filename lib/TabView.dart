import 'package:evcssp/ChargersTabView.dart';
import 'package:evcssp/MyChargers.dart';
import 'package:evcssp/homeView.dart';
import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final buildBody = <Widget>[
      MapScreen(),
      ChargersTabView(),
    ];

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        child: SizedBox(
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: BottomNavigationBar(
              backgroundColor: Colors.black,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: index,
              onTap: (x) {
                setState(() {
                  index = x;
                });
              },
              elevation: 20,
              selectedItemColor: Colors.white,
              showSelectedLabels: false,
              unselectedItemColor: Colors.white.withAlpha(100),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.map,
                      size: 28,
                    ),
                    label: "Map"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.electric_bolt_outlined, size: 28),
                    label: "Chargers"),
              ],
            ),
          ),
        ),
      ),
      // body: IndexedStack(
      //   index: index,
      //   children: buildBody,
      // ),
          body: Center(
            child: buildBody.elementAt(index), //New
          ),
    ));
  }
}
