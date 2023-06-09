import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcssp/ModelProfileData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CommonComponentWidgets.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late String userName, upiID, userID, userMail;
  late final Map requestorData;

  // void getRequestorData(String requestorID) {
  //   print("-------|||" + requestorID);
  //
  //   FirebaseDatabase.instance
  //       .ref('EVCSSP/USERS_DATA')
  //       .child(requestorID)
  //       .once()
  //       .then((value) {
  //     requestorData = value.snapshot.value as Map;
  //
  //     print("------------->" + requestorData.toString());
  //
  //     setState(() {
  //       userName = requestorData['userName'];
  //       upiID = requestorData['upiID'];
  //       userID = requestorData['userID'];
  //       userMail = firebaseAuthServices.firebaseUser!.email!;
  //     });
  //   });
  // }

  Widget RequestsListVIew() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('REQUESTS').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.black,
            ),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: CustomText(
                text: "You have no Requests...",
                textSize: 14,
                color: Colors.black),
          );
        }
        // return _buildList(context, snapshot.data!.docs);
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map((data) => RequestListViewItem(context, data))
              .toList(),
        );
      },
    );
  }

  Widget RequestListViewItem(BuildContext context, DocumentSnapshot data) {

    // getRequestorData(data.id);

    return data['chargerHostID'] == firebaseAuthServices.firebaseUser!.uid ||
            data.id == firebaseAuthServices.firebaseUser!.uid
        ? Padding(
            key: ValueKey(data.id),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: GestureDetector(
              onTap: () {},
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_outline),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                                text:  data['bookUserName'],
                                textSize: 12,
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.power),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                                text: data['chargerID'],
                                textSize: 12,
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.watch_later),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                                text: data['timeSlot'],
                                textSize: 12,
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.switch_left),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText(
                                text: data['status'],
                                textSize: 12,
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        data.id != firebaseAuthServices.firebaseUser!.uid
                            ? Row(
                                children: [
                                  Container(
                                      width: 150,
                                      child: CustomButton2(
                                          text: "ACCEPT",
                                          buttonSize: 50,
                                          context: context,
                                          function: () {
                                            FirebaseFirestore.instance
                                                .collection('CHARGERS')
                                                .doc(data['chargerID'])
                                                .collection('BOOKING REQUESTS')
                                                .doc(data.id)
                                                .set({
                                              'chargerID': data['chargerID'],
                                              'chargerHostID':
                                                  data['chargerHostID'],
                                              'bookUserMail': data['bookUserMail'],
                                              'bookUserName': data['bookUserName'],
                                              'status': 'ACCEPTED',
                                              'phoneNumber':
                                                  data['phoneNumber'],
                                              'chargerName':
                                                  data['chargerName'],
                                              'chargerRate':
                                                  data['chargerRate'],
                                              'timeSlot': data['timeSlot']
                                            });
                                            FirebaseFirestore.instance
                                                .collection('REQUESTS')
                                                .doc(data.id)
                                                .set({
                                              'chargerID': data['chargerID'],
                                              'bookUserMail': data['bookUserMail'],
                                              'bookUserName': data['bookUserName'],
                                              'chargerHostID':
                                                  data['chargerHostID'],
                                              'status': 'ACCEPTED',
                                              'phoneNumber':
                                                  data['phoneNumber'],
                                              'chargerName':
                                                  data['chargerName'],
                                              'chargerRate':
                                                  data['chargerRate'],
                                              'timeSlot': data['timeSlot']
                                            });
                                          })),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Container(
                                      width: 150,
                                      child: CustomButton2(
                                          text: "DECLINE",
                                          buttonSize: 50,
                                          context: context,
                                          function: () {
                                            FirebaseFirestore.instance
                                                .collection('CHARGERS')
                                                .doc(data['chargerID'])
                                                .collection('BOOKING REQUESTS')

                                                .doc(data.id)
                                                .set({
                                              'chargerID': data['chargerID'],
                                              'bookUserMail': data['bookUserMail'],
                                              'bookUserName': data['bookUserName'],
                                              'chargerHostID':
                                                  data['chargerHostID'],
                                              'status': 'DECLINED',
                                              'phoneNumber':
                                                  data['phoneNumber'],
                                              'chargerName':
                                                  data['chargerName'],
                                              'chargerRate':
                                                  data['chargerRate'],
                                              'timeSlot': data['timeSlot']
                                            });
                                            FirebaseFirestore.instance
                                                .collection('REQUESTS')
                                                .doc(data.id)
                                                .set({
                                              'chargerID': data['chargerID'],
                                              'chargerHostID':
                                                  data['chargerHostID'],
                                              'status': 'DECLINED',
                                              'phoneNumber':
                                                  data['phoneNumber'],
                                              'chargerName':
                                                  data['chargerName'],
                                              'chargerRate':
                                                  data['chargerRate'],
                                              'timeSlot': data['timeSlot']
                                            });
                                          })),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )),
            ))
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: RequestsListVIew(),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ));
  }
}
