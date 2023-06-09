import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcssp/ModelProfileData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CommonComponentWidgets.dart';

class ShowRequestsView extends StatefulWidget {
  final String docId;

  const ShowRequestsView({Key? key, required String this.docId})
      : super(key: key);

  @override
  State<ShowRequestsView> createState() => _ShowRequestsViewState();
}

class _ShowRequestsViewState extends State<ShowRequestsView> {
  late String userName, upiID, userID, userMail;
  late final Map requestorData;

  Widget RequestsListVIew(String docId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('CHARGERS')
          .doc(docId)
          .collection('BOOKING REQUESTS')
          .snapshots(),
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

  // Future<void> getRequestorData(String requestorID) async {
  //
  //
  //   print(">>Requestor ID "+ requestorID);
  //
  //
  //   await  FirebaseDatabase.instance
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
  //       userMail = requestorData['userEmail'];
  //     });
  //   });
  //
  //
  //
  // }

  Widget RequestListViewItem(BuildContext context, DocumentSnapshot data) {

    // getRequestorData(data.id);

    return Padding(
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: data['status'] == 'DECLINED'
                            ? Colors.red.withAlpha(50)
                            : data['status'] == 'ACCEPTED'
                                ? Colors.green.withAlpha(50)
                                : Colors.yellow.withAlpha(50),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              text: 'requested by: ',
                              textSize: 12,
                              color: Colors.black),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(Icons.person_outline),
                              SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                  text: data['bookUserName'],
                                  textSize: 12,
                                  color: Colors.black),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.mail_outline_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                  text:  data['bookUserMail'],
                                  textSize: 12,
                                  color: Colors.black),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.watch_later_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                  text: data['timeSlot'],
                                  textSize: 12,
                                  color: Colors.black),
                            ],
                          ),
                        ],
                      ),
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
                    Row(
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
                                      .doc(widget.docId)
                                      .collection('BOOKING REQUESTS')
                                      .doc(data.id)
                                      .set({
                                    'chargerID': data['chargerID'],
                                    'chargerHostID': data['chargerHostID'],
                                    'bookUserMail': data['bookUserMail'],
                                    'bookUserName': data['bookUserName'],
                                    'chargerHostID': data['chargerHostID'],
                                    'status': 'ACCEPTED',
                                    'phoneNumber': data['phoneNumber'],
                                    'chargerName': data['chargerName'],
                                    'chargerRate': data['chargerRate'],
                                    'timeSlot': data['timeSlot'],
                                  });
                                  FirebaseFirestore.instance
                                      .collection('REQUESTS')
                                      .doc(data.id)
                                      .set({
                                    'chargerID': data['chargerID'],
                                    'chargerHostID': data['chargerHostID'],
                                    'bookUserMail': data['bookUserMail'],
                                    'bookUserName': data['bookUserName'],
                                    'status': 'ACCEPTED',
                                    'phoneNumber': data['phoneNumber'],
                                    'chargerName': data['chargerName'],
                                    'chargerRate': data['chargerRate'],
                                    'timeSlot': data['timeSlot'],
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
                                      .doc(widget.docId)
                                      .collection('BOOKING REQUESTS')
                                      .doc(data.id)
                                      .set({
                                    'chargerID': data['chargerID'],
                                    'chargerHostID': data['chargerHostID'],
                                    'bookUserMail': data['bookUserMail'],
                                    'bookUserName': data['bookUserName'],
                                    'status': 'DECLINED',
                                    'phoneNumber': data['phoneNumber'],
                                    'chargerName': data['chargerName'],
                                    'chargerRate': data['chargerRate'],
                                    'timeSlot': data['timeSlot'],
                                  });
                                  FirebaseFirestore.instance
                                      .collection('REQUESTS')
                                      .doc(data.id)
                                      .set({
                                    'chargerID': data['chargerID'],
                                    'chargerHostID': data['chargerHostID'],
                                    'bookUserMail': data['bookUserMail'],
                                    'bookUserName': data['bookUserName'],
                                    'status': 'DECLINED',
                                    'phoneNumber': data['phoneNumber'],
                                    'chargerName': data['chargerName'],
                                    'chargerRate': data['chargerRate'],
                                    'timeSlot': data['timeSlot'],
                                  });
                                })),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: RequestsListVIew(widget.docId),
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
          "Requests",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ));
  }
}
