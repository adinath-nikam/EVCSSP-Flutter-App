import 'package:evcssp/AddCharger.dart';
import 'package:evcssp/MyChargers.dart';
import 'package:evcssp/MyRequestsView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChargersTabView extends StatefulWidget {
  const ChargersTabView({Key? key}) : super(key: key);

  @override
  State<ChargersTabView> createState() => _ChargersTabViewState();
}

class _ChargersTabViewState extends State<ChargersTabView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(

      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: TabBar(
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black),
                    tabs: [
                      Tab(
                        child: Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.black, width: 1)),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "My Chargers",
                              style:
                              TextStyle(fontFamily: "ProductSans-Bold"),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.black, width: 1)),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "My Requests",
                              style:
                              TextStyle(fontFamily: "ProductSans-Bold"),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              Expanded(
                flex: 1,
                child: TabBarView(
                  children: [
                    Container(
                        padding: EdgeInsets.only(
                            right: 15, left: 15, bottom: 0.0, top: 15),
                        child: MyChargers()),

                    Container(
                        padding: EdgeInsets.only(
                            right: 15, left: 15, bottom: 0.0, top: 15),
                        child: MyRequestsView()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
