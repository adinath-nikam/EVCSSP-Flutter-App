import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CommonComponentWidgets.dart';

class reviews extends StatefulWidget {
  String chargerID;
  reviews({Key? key, required this.chargerID}) : super(key: key);

  @override
  State<reviews> createState() => _reviewsState();
}

class _reviewsState extends State<reviews> {

  Widget reviewListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('CHARGERS').doc(widget.chargerID).collection('REVIEWS').snapshots(),
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
            child: CustomText(text: "You have no Reviews...", textSize: 14, color: Colors.black),
          );
        }
        // return _buildList(context, snapshot.data!.docs);
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map((data) => reviewListViewItem(context, data))
              .toList(),
        );
      },
    );
  }

  Widget reviewListViewItem(BuildContext context, DocumentSnapshot data) {
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
                        Icon(Icons.person_outline),
                        SizedBox(width: 10,),
                        CustomText(text: data.id, textSize: 12, color: Colors.black),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.star_border_purple500_outlined),
                        SizedBox(width: 10,),
                        CustomText(text: data['reviewStar'], textSize: 12, color: Colors.black),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.reviews_outlined),
                        SizedBox(width: 10,),
                        CustomText(text: data['reviewComment'], textSize: 12, color: Colors.black),
                      ],
                    ),


                  ],
                ),
              )),
        ));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text("Reviews", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        child: reviewListView(),
      ),

    ));
  }
}
