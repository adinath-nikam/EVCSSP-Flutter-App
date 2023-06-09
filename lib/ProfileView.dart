import 'package:evcssp/FirebaseService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final double circleRadius = 120.0;

  late String userName, upiID, userID;
  late final Map data;

  @override
  void initState() {
    // TODO: implement initState

    FirebaseDatabase.instance.ref('EVCSSP/USERS_DATA').child(FirebaseAuthServices().firebaseUser!.uid)
    .once()
    .then((value) {
      data = value.snapshot.value as Map;

      print("------------->"+data.toString());

      setState(() {
        userName = data['userName'];
        upiID = data['upiID'];
        userID = data['userID'];
      });



    });
    super.initState();
  }

  // Custom Text Widget
  Widget CustomText(
      {required String text, required double textSize, required Color color, bool? softwrap}) {
    return Text(
      text,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      softWrap: softwrap,
      style: TextStyle(
        fontSize: textSize,
        fontFamily: "ProductSans-Bold",
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    CustomText(
                        text: "ACCOUNT", textSize: 24, color: Colors.black),

                    Icon(
                      Icons.manage_accounts,
                      size: 30,
                      color: Colors.black,
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    // height: MediaQuery.of(context).size.height,
                    // width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 25),
                    color: Colors.white,
                    child: Stack(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                top: circleRadius / 2.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8.0,
                                      offset: Offset(0.0, 5.0),
                                    ),
                                  ],
                                ),
                                width: double.infinity,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 25),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: circleRadius / 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: CustomText(
                                                    text: userName,
                                                    textSize: 24,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            // isVerified(),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: [

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.token,
                                                      size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: CustomText(
                                                          text: userID,
                                                          textSize: 12,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.mail_outline_outlined,
                                                      size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: CustomText(
                                                          text: FirebaseAuthServices().firebaseUser!.email!,
                                                          textSize: 16,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.monetization_on,
                                                      size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: CustomText(
                                                          text: upiID,
                                                          textSize: 16,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                height: 10,
                                                indent: 20,
                                                endIndent: 20,
                                                color: Colors.black,
                                                thickness: 1,
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              CustomText(text: 'Scan to Pay', textSize: 18, color: Colors.black),
                                              Container(
                                                child: UPIPaymentQRCode(upiDetails: UPIDetails(upiID: upiID, payeeName: userName, amount: 1), size: 150,

                                                  embeddedImagePath: 'assets/images/bar_logo.jpg',
                                                  embeddedImageSize: const Size(60, 60),),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Divider(
                                          height: 10,
                                          indent: 20,
                                          endIndent: 20,
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                      ],
                                    )),
                              ),
                            ),

                            ///Image Avatar
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 56,
                                backgroundColor: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(8), // Border radius
                                  child: ClipOval(
                                      child: Image.network(
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/2048px-Circle-icons-profile.svg.png')),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
