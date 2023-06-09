import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcssp/CommonComponentWidgets.dart';
import 'package:evcssp/FirebaseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MyRequestsView extends StatefulWidget {
  const MyRequestsView({Key? key}) : super(key: key);

  @override
  State<MyRequestsView> createState() => _MyRequestsViewState();
}

class _MyRequestsViewState extends State<MyRequestsView> {
  Razorpay _razorpay = Razorpay();

  late int chargedUnits;

  final TextEditingController reviewStar = TextEditingController();
  final TextEditingController reviewComment = TextEditingController();
  final TextEditingController unitsCharged = TextEditingController();
  final GlobalKey<FormState> reviewFormKey = GlobalKey();
  final GlobalKey<FormState> unitsFormKey = GlobalKey();

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void openCheckout(int chargerAmount, int phoneNumber, String uid) async {
    print('---------------------->'+chargerAmount.toString());
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': chargerAmount*100,
      'name': uid,
      'description': 'Payment',
      'prefill': {'contact': phoneNumber, 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, timeInSecForIosWeb: 4);
  }



  showAlertDialog(BuildContext context, double chargerAmount, int phoneNumber, String uid) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {

        if(unitsFormKey.currentState!.validate()){
          chargedUnits = int.parse(unitsCharged.text);
          chargedUnits = chargedUnits * chargerAmount.toInt();
          openCheckout(chargedUnits, phoneNumber, uid);
        }


      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("How Many Units Charged ?"),
      content: Form(
        key: unitsFormKey,
        child: TextFormField(
          controller: unitsCharged,
          decoration: InputDecoration(
            hintText: "Enter Charged Units...",
            prefixIcon: const Icon(Icons.electric_bolt),
            contentPadding: const EdgeInsets.all(25.0),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.1),
          ),

          onSaved: (value){

            print("chargrrrrrr: "+value.toString());

              chargedUnits = int.parse(value!);

              chargedUnits = chargedUnits * chargerAmount.toInt();

          },

          validator: (value) {


            // value == null ? '* Required' : null;
          },
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


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
                text: "Your Requests Appear here...",
                textSize: 14,
                color: Colors.black),
          );
        }
        // return _buildList(context, snapshot.data!.docs);
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((data) {
            if (data.id == FirebaseAuthServices().firebaseUser!.uid) {
              return RequestListViewItem(context, data);
            } else {
              return SizedBox();
            }
          }).toList(),
        );
      },
    );
  }

  // Widget unitsDialog(BuildContext context, String chargerID) {
  //   return AlertDialog(
  //     title: const Text('How Many Units ?'),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Container(
  //             height: 170,
  //             width: 300,
  //             child: Column(
  //               children: [
  //                 Form(
  //                     key: reviewFormKey,
  //                     child: Column(
  //                       children: [
  //                         TextFormField(
  //                           controller: reviewStar,
  //                           decoration: InputDecoration(
  //                             hintText: "Enter Rating (Out of 5)..",
  //                             prefixIcon:
  //                             const Icon(Icons.star_border_outlined),
  //                             contentPadding: const EdgeInsets.all(25.0),
  //                             border: const OutlineInputBorder(
  //                               borderSide: BorderSide.none,
  //                               borderRadius: BorderRadius.all(
  //                                 Radius.circular(10.0),
  //                               ),
  //                             ),
  //                             filled: true,
  //                             fillColor: Colors.black.withOpacity(0.1),
  //                           ),
  //                           validator: (value) {},
  //                         ),
  //
  //                       ],
  //                     )),
  //               ],
  //             )),
  //       ],
  //     ),
  //     actions: <Widget>[
  //       CustomButton2(
  //           text: 'Done',
  //           buttonSize: 50,
  //           context: context,
  //           function: () {
  //             if (reviewFormKey.currentState!.validate()) {
  //               FirebaseFirestore.instance
  //                   .collection('CHARGERS')
  //                   .doc(chargerID)
  //                   .collection('REVIEWS')
  //                   .doc(FirebaseAuthServices().firebaseUser!.uid)
  //                   .set({
  //                 'chargerID': 'temp',
  //                 'reviewStar': reviewStar.text,
  //                 'reviewComment': reviewComment.text
  //               }).whenComplete(() {
  //                 Navigator.of(context).pop();
  //               });
  //             }
  //           })
  //     ],
  //   );
  // }

  Widget addreviewAlertBox(BuildContext context, String chargerID) {
    return AlertDialog(
      title: const Text('Write Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 170,
              width: 300,
              child: Column(
                children: [
                  Form(
                      key: reviewFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: reviewStar,
                            decoration: InputDecoration(
                              hintText: "Enter Rating (Out of 5)..",
                              prefixIcon:
                                  const Icon(Icons.star_border_outlined),
                              contentPadding: const EdgeInsets.all(25.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                            ),
                            validator: (value) {},
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.reviews_outlined),
                              contentPadding: const EdgeInsets.all(25.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.1),
                              hintText: 'Write Review...',
                              // Here is key idea
                            ),
                            controller: reviewComment,
                            validator: (value) {},
                          ),
                        ],
                      )),
                ],
              )),
        ],
      ),
      actions: <Widget>[
        CustomButton2(
            text: 'Done',
            buttonSize: 50,
            context: context,
            function: () {
              if (reviewFormKey.currentState!.validate()) {
                FirebaseFirestore.instance
                    .collection('CHARGERS')
                    .doc(chargerID)
                    .collection('REVIEWS')
                    .doc(FirebaseAuthServices().firebaseUser!.uid)
                    .set({
                  'chargerID': 'temp',
                  'reviewStar': reviewStar.text,
                  'reviewComment': reviewComment.text
                }).whenComplete(() {
                  Navigator.of(context).pop();
                });
              }
            })
      ],
    );
  }

  Widget RequestListViewItem(BuildContext context, DocumentSnapshot data) {
    return Padding(
        key: ValueKey(data.id),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {},
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.electric_bolt_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.power,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                    text: data['chargerName'],
                                    textSize: 14,
                                    color: Colors.black),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                    text: data['timeSlot'],
                                    textSize: 14,
                                    color: Colors.black),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    height: 45,
                                    width: 125,
                                    child: CustomButton2(
                                        text: 'Cancel Request',
                                        buttonSize: 10,
                                        context: context,
                                        function: () {
                                          FirebaseFirestore.instance
                                              .collection('REQUESTS')
                                              .doc(FirebaseAuthServices()
                                                  .firebaseUser!
                                                  .uid)
                                              .delete();

                                          FirebaseFirestore.instance
                                              .collection('CHARGERS')
                                              .doc(data['chargerID'])
                                              .collection('BOOKING REQUESTS')
                                              .doc(FirebaseAuthServices()
                                                  .firebaseUser!
                                                  .uid)
                                              .delete();
                                        })),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                    height: 45,
                                    width: 125,
                                    child: CustomButton2(
                                        text: 'Add Review',
                                        buttonSize: 10,
                                        context: context,
                                        function: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                addreviewAlertBox(
                                                    context, data['chargerID']),
                                          );
                                        })),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            (data['status'] == 'ACCEPTED')
                                ? SizedBox(
                                    height: 45,
                                    width: 260,
                                    child: CustomButton2(
                                        text: 'Pay',
                                        buttonSize: 10,
                                        context: context,
                                        function: () {


                                          showAlertDialog(context,

                                              double.parse(
                                              data['chargerRate'] + '00'),
                                              int.parse(data['phoneNumber']),
                                              data.id);

                                          // openCheckout(
                                          //    double.parse(
                                          //         data['chargerRate'] + '00'),
                                          //     int.parse(data['phoneNumber']),
                                          //     data.id
                                          //
                                          // );



                                        }))
                                : SizedBox(),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
      body: RequestsListVIew(),
    ));
  }
}
