import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcssp/AddCharger.dart';
import 'package:evcssp/ChargerModel.dart';
import 'package:evcssp/FirebaseService.dart';
import 'package:evcssp/ShowRequestsView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CommonComponentWidgets.dart';

class MyChargers extends StatefulWidget {
  const MyChargers({Key? key}) : super(key: key);

  @override
  State<MyChargers> createState() => _MyChargersState();
}

class _MyChargersState extends State<MyChargers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "My Chargers",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: ChargersListVIew()),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              elevation: 0.0,
              icon: const Icon(Icons.add),
              backgroundColor: Colors.black,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (builder) => AddCharger()));
              },
              label: Text("Add Charger"),
            )));
  }

  Widget ChargersListVIew() {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('CHARGERS').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.black,
                ),
              );
            }else if(snapshot.data!.docs.isEmpty){
              return Center(
                child: CustomText(text: "You have no charger added...", textSize: 14, color: Colors.black),
              );
            }
            // return _buildList(context, snapshot.data!.docs);
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs
                  .map((data) => ChargersListViewItem(context, data))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget ChargersListViewItem(BuildContext context, DocumentSnapshot data) {
    final ChargerModel chargerModel = ChargerModel.fromSnapshot(data);

    return chargerModel.userId == FirebaseAuthServices().firebaseUser!.uid ? Padding(
        key: ValueKey(chargerModel.chargerName),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {},
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 135,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.electric_bolt,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withAlpha(100),
                          ),

                          padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Text("₹ "+chargerModel.chargerRate!),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chargerModel.chargerName!),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withAlpha(50),
                              ),
                              padding:
                                  EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              child: Text(chargerModel.chargerType!),
                            ),
                            SizedBox(width: 100,),
                            GestureDetector(
                              onTap: (){
                                FirebaseFirestore.instance.collection('CHARGERS').doc(chargerModel.id).delete();
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: (){
                            String docId = chargerModel.id!;
                            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>ShowRequestsView(docId: docId,)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withAlpha(50),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            child: const Text('Requests'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            "Posted on: 16 Feb, 2023",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 10,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ))
    : const SizedBox()
    ;
  }
}
