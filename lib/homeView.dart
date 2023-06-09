import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:evcssp/FirebaseService.dart';
import 'package:evcssp/ModelProfileData.dart';
import 'package:evcssp/NotificationsView.dart';
import 'package:evcssp/ProfileView.dart';
import 'package:evcssp/RouteView.dart';
import 'package:evcssp/reviews.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_marker/marker_icon.dart';
import 'CommonComponentWidgets.dart';
import 'SignInView.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final LatLng _center = const LatLng(15.849363993462724, 74.50009735933146);

  late LatLng currentLocationLatLng;

  late String userName, upiID, userID, userMail;
  late final Map requestorData;

  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();

  late String selectedTime;
  late String selectedDate;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  late String _mapStyle;

  Future<void> _onMapCreated(controller) async {
    setState(() {
      mapController = controller;
      // mapController.setMapStyle(_mapStyle);
      _customInfoWindowController.googleMapController = controller;
    });
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Widget slotAlertDialog(BuildContext context, String SlotDate) {
    return AlertDialog(
      title: const Text('This Slot is Already Booked!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 120,
              width: 300,
              child: Column(
                children: [
                  Icon(
                    Icons.access_time_sharp,
                    color: Colors.black,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                      text: currentDate.day.toString() +
                          '-' +
                          currentDate.month.toString() +
                          '-' +
                          currentDate.year.toString() +
                          ', ' +
                          currentTime.hour.toString() +
                          ' Hrs',
                      textSize: 18,
                      color: Colors.black),
                ],
              )),
        ],
      ),
      actions: <Widget>[
        CustomButton2(
            text: 'OK',
            buttonSize: 50,
            context: context,
            function: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }

  Widget bookedAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Slot Booked Successfully!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 120,
              width: 300,
              child: Column(
                children: [
                  Icon(
                    Icons.done_all,
                    color: Colors.black,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                      text: 'Successfully Booked!',
                      textSize: 18,
                      color: Colors.black),
                ],
              )),
        ],
      ),
      actions: <Widget>[
        CustomButton2(
            text: 'OK',
            buttonSize: 50,
            context: context,
            function: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }

  static Future<bool> checkExist(String docID) async {
    var a =
        await FirebaseFirestore.instance.collection('SLOTS').doc(docID).get();
    if (a.exists) {
      print('Exists');
      return true;
    } else {
      print('Not exists');
      return false;
    }
  }

  void getRequestorData() {
    FirebaseDatabase.instance
        .ref('EVCSSP/USERS_DATA')
        .child(firebaseAuthServices.firebaseUser!.uid)
        .once()
        .then((value) {
      requestorData = value.snapshot.value as Map;

      print("------------->" + requestorData.toString());

      setState(() {
        userName = requestorData['userName'];
        upiID = requestorData['upiID'];
        userID = requestorData['userID'];
        userMail = requestorData['userEmail'];
      });
    });
  }

  displayTimePicker(
      BuildContext context,
      String chargerID,
      String chargerName,
      String chargerRate,
      String phoneNumber,
      String chargerHostID,
      String bookUserMail,
      String userName) async {
    var time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      setState(() {
        // selectedTime = "${time.hour}:${time.minute}";
        selectedTime = "${time.hour}";
        selectedDate = chargerID + selectedDate + selectedTime;
        print("---------------->  ${time.hour}${time.minute}");
        print("---------------->  $selectedDate");
      });

      if (await checkExist(selectedDate)) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              slotAlertDialog(context, selectedDate),
        );

        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Booked");
      } else {
        FirebaseFirestore.instance
            .collection('SLOTS')
            .doc(selectedDate)
            .set({'selectedDate': selectedDate});
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Free");
        FirebaseFirestore.instance
            .collection('CHARGERS')
            .doc(chargerID)
            .collection('BOOKING REQUESTS')
            .doc(FirebaseAuthServices().firebaseUser!.uid)
            .set({
          'chargerID': chargerID,
          'chargerHostID': chargerHostID,
          'bookUserMail': bookUserMail,
          'bookUserName': userName,
          'status': 'PENDING',
          "chargerName": chargerName,
          "phoneNumber": phoneNumber,
          'chargerRate': chargerRate,
          "timeSlot": currentDate.day.toString() +
              '-' +
              currentDate.month.toString() +
              '-' +
              currentDate.year.toString() +
              ', ' +
              selectedTime
        });

        FirebaseFirestore.instance
            .collection('REQUESTS')
            .doc(FirebaseAuthServices().firebaseUser!.uid)
            .set({
          "chargerID": chargerID,
          'chargerHostID': chargerHostID,
          'bookUserMail': bookUserMail,
          'bookUserName': userName,
          "status": "PENDING",
          "chargerName": chargerName,
          "phoneNumber": phoneNumber,
          "chargerRate": chargerRate,
          "timeSlot": currentDate.day.toString() +
              '-' +
              currentDate.month.toString() +
              '-' +
              currentDate.year.toString() +
              ', ' +
              selectedTime
        }).then((value) {
          showDialog(
            context: context,
            builder: (BuildContext context) => bookedAlertDialog(context),
          );
        });
      }
    }
  }

  _selectDate(
      BuildContext context,
      String docID,
      String chargerName,
      String phoneNumber,
      String chargerRate,
      String chargerHostID,
      String bookUserMail,
      String userName) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != currentDate)
      setState(() async {
        currentDate = picked;

        selectedDate =
            "${currentDate.day}${currentDate.month}${currentDate.year}";

        print("------->" + currentDate.toString());

        displayTimePicker(context, docID, chargerName, chargerRate, phoneNumber,
            chargerHostID, bookUserMail, userName);

        // FirebaseFirestore.instance
        //     .collection('CHARGERS')
        //     .doc(docID)
        //     .collection('BOOKING REQUESTS')
        //     .doc(FirebaseAuthServices().firebaseUser!.uid)
        //     .set({
        //   'chargerID': docID,
        //   'status': 'PENDING',
        //   "chargerName": chargerName,
        //   "phoneNumber": phoneNumber,
        //   'chargerRate': chargerRate
        // });

        // FirebaseFirestore.instance
        //     .collection('REQUESTS')
        //     .doc(FirebaseAuthServices().firebaseUser!.uid)
        //     .set({
        //   "chargerID": docID,
        //   "status": "PENDING",
        //   "chargerName": chargerName,
        //   "phoneNumber": phoneNumber,
        //   "chargerRate": chargerRate,
        // }).then((value) {
        //   SnackBar(
        //       backgroundColor: Colors.black,
        //       content: Text(
        //         'Request Sent.',
        //       ));
        // });
      });
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(specify['chargerLocation'].latitude,
            specify['chargerLocation'].longitude),
        // icon: await BitmapDescriptor.fromAssetImage(
        //     ImageConfiguration(size: Size(48, 48)), 'temp.jpg'),

        icon: specify['chargerType'] == 'Level 3'
            ? await MarkerIcon.downloadResizePicture(
                url:
                    'https://firebasestorage.googleapis.com/v0/b/cse-final-year-project.appspot.com/o/marker1.png?alt=media&token=d0af8f1e-6e6f-4c2f-99fe-c0bc888afeb8',
                imageSize: 100)
            : specify['chargerType'] == 'Level 2'
                ? await MarkerIcon.downloadResizePicture(
                    url:
                        'https://firebasestorage.googleapis.com/v0/b/cse-final-year-project.appspot.com/o/marker2.png?alt=media&token=c7fe995b-02d8-496e-860c-f6a46a20e944',
                    imageSize: 100)
                : await MarkerIcon.downloadResizePicture(
                    url:
                        'https://firebasestorage.googleapis.com/v0/b/cse-final-year-project.appspot.com/o/marker3.png?alt=media&token=aff3fe6a-de04-40bd-a7e2-601feaa01226',
                    imageSize: 100),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.electric_bolt_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.power,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    specify['chargerName'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.account_circle,
                              //       color: Colors.white,
                              //     ),
                              //     SizedBox(
                              //       width: 10,
                              //     ),
                              //     Text(
                              //       'Demom Name',
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 10.0,
                              // ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_tree,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Level : ' + specify['chargerType'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.currency_rupee_sharp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    specify['chargerRate'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        _selectDate(
                                            context,
                                            specifyId,
                                            specify['chargerName'],
                                            specify['phoneNumber'],
                                            specify['chargerRate'],
                                            specify['userId'],
                                            userMail,
                                            userName);

                                        // displayTimePicker(context);
                                      },
                                      child: Text('Book')),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (builder) => reviews(
                                                    chargerID: specifyId)));
                                      },
                                      child: Text('Reviews'))
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>RouteView(sourceLatLng: LatLng(15.867134924701068, 74.51060127037066), destLatLng: LatLng(15.368829115568952, 75.12012918871982),)));

                                    getUserCurrentLocation().then((value) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (builder) => RouteView(
                                                    sourceLatLng: LatLng(
                                                        value.latitude,
                                                        value.longitude),
                                                    destLatLng: LatLng(
                                                        specify['chargerLocation']
                                                            .latitude,
                                                        specify['chargerLocation']
                                                            .longitude),
                                                  )));
                                    });
                                  },
                                  child: Text('Direction'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            LatLng(specify['chargerLocation'].latitude,
                specify['chargerLocation'].longitude),
          );
        },
        infoWindow: InfoWindow(
          title: 'Charger',
          snippet: specify['chargerRate'],
        ));
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('CHARGERS').get().then((value) {
      print(">>>>>  " + value.docs.first.data().toString());

      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          initMarker(value.docs[i].data(), value.docs[i].id);
        }
      }
    });
  }

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    getMarkerData();
    getUserCurrentLocation();
    getRequestorData();

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      rootBundle.loadString('assets/style/map_style.txt').then((string) {
        _mapStyle = string;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                compassEnabled: true,
                onTap: (position) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                markers: Set<Marker>.of(markers.values),
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 300,
                width: 300,
                offset: 50,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.account_circle,
                      size: 25,
                    ),
                    backgroundColor: Colors.black,
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => ProfileView()));
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: FloatingActionButton(
                    mini: true,
                    child: Icon(
                      Icons.notifications,
                      size: 20,
                    ),
                    backgroundColor: Colors.black,
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => NotificationsView()));
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: FloatingActionButton(
                    mini: true,
                    child: Icon(
                      Icons.power_settings_new_sharp,
                      size: 20,
                    ),
                    backgroundColor: Colors.red,
                    onPressed: () async {
                      FirebaseAuthServices().signOut(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (builder) => SignInView()));
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.my_location),
            backgroundColor: Colors.black,
            onPressed: () async {
              getUserCurrentLocation().then((value) async {
                print(value.latitude.toString() +
                    " " +
                    value.longitude.toString());

                initMarker(GeoPoint(value.latitude, value.longitude) as dynamic,
                    "My Location");

                // specified current users location
                CameraPosition cameraPosition = new CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 14,
                );

                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));
                setState(() {
                  currentLocationLatLng =
                      LatLng(value.latitude, value.longitude);
                });
              });
            },
          )),
    );
  }
}
