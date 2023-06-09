import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evcssp/ChargerModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'CommonComponentWidgets.dart';
import 'FirebaseService.dart';

import 'package:flutter_geocoder/geocoder.dart';

class AddCharger extends StatefulWidget {
  const AddCharger({Key? key}) : super(key: key);

  @override
  State<AddCharger> createState() => _AddChargerState();
}

class _AddChargerState extends State<AddCharger> {
  bool isActive = false;

  ChargerModel chargerModel = ChargerModel();

  String DD_Charger_Type = 'Select Charger Type....';

  final addChargerFormKey = GlobalKey<FormState>();

  late GoogleMapController mapController;

  String chargerLocation = "0.0, 0.0";

  String elecUnitPrice = '0.0';
  String elecUnitPrice2 = '0.0';
  String chargerLoc = 'Select Location..';

  LatLng currentLocationLatLng = LatLng(45.521563, -122.677433);

  final LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

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
    getUserCurrentLocation();
    super.initState();
  }

  Widget chargerAddedAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Charger Added Successfully!'),
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

  void _onMapCreated(controller) {
    late Marker marker;

    getUserCurrentLocation().then((value) async {
      print(value.latitude.toString() + " " + value.longitude.toString());

      currentLocationLatLng = LatLng(value.latitude, value.longitude);

      // specified current users location
      CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });

    setState(() {
      mapController = controller;
    });
  }

  void _onAddMarkerButtonPressed(LatLng latlang) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("test"),
        position: latlang,
        infoWindow: InfoWindow(
          title: 'New Charger',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Charger Location'),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              chargerLoc,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              elecUnitPrice2,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 350,
              width: 300,
              child: GoogleMap(
                onTap: (latlng) async {
                  if (_markers.length >= 1) {
                    _markers.clear();
                  }

                  _onAddMarkerButtonPressed(latlng);

                  chargerModel.chargerLocation =
                      GeoPoint(latlng.latitude, latlng.longitude);

                  chargerLocation = latlng.toString();

                  // From coordinates
                  final coordinates =
                      new Coordinates(latlng.latitude, latlng.longitude);
                  List addresses = await Geocoder.local
                      .findAddressesFromCoordinates(coordinates);
                  String state = addresses.first.adminArea;

                  FirebaseDatabase.instance
                      .ref('EVCSSP/ELECTRICITY_UNIT_PRICES/STATES')
                      .once()
                      .then((value) {
                    late final Map data = value.snapshot.value as Map;

                    print(
                        "------------------ ${data[state]} -------------------------");

                    setState(() {
                      elecUnitPrice =  data[state].toString();

                      elecUnitPrice2 = state +
                          ': ₹' +
                          data[state].toString() +
                          ' / ' +
                          'Unit';

                      chargerLoc = addresses.first.addressLine;
                    });
                  });

                  print(
                      "------------------ ${state} -------------------------");

                  // print("------------------ ${unitPrice} -------------------------");

                  print(">>>>>>>>>>>>>>" + chargerLocation);
                },
                markers: _markers,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
          ],
        );
      }),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
          "Add Charger",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Card(
              elevation: 10,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Form(
                  key: addChargerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Charger Name...",
                          prefixIcon: const Icon(Icons.electric_bolt_outlined),
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
                        onSaved: (value) {
                          chargerModel.chargerName = value;
                        },
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context),
                          );
                        },
                        initialValue: chargerLocation,
                        decoration: InputDecoration(
                          hintText: "Select Charger Location...",
                          prefixIcon: const Icon(Icons.map),
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
                        onSaved: (value) {},
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            elecUnitPrice2,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          )),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Charger Per Unit Rate...",
                          prefixIcon: const Icon(Icons.monetization_on),
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
                        onSaved: (value) {

                          if(value==null){
                            '* Required';
                          }
                          else if(double.parse(value) > double.parse(elecUnitPrice)){
                            'Cannot Exceed Regulated Price';
                          }
                          else{
                            chargerModel.chargerRate = value;
                          }


                        },
                        validator: (value) {


                          if(value==null){
                           return '* Required';
                          }
                          else if(double.parse(value) > double.parse(elecUnitPrice)){
                            return 'Cannot Exceed Regulated Price';
                          }
                            else{
                            return null;
                          }

                            // value == null ? '* Required' : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Phone Number...",
                          prefixIcon: const Icon(Icons.phone),
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
                        onSaved: (value) {
                          chargerModel.phoneNumber = value;
                        },
                        validator: (value) {
                          return value == null ? '* Required' : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: DropdownButton<String>(
                          // Step 3.
                          value: DD_Charger_Type,
                          // Step 4.
                          items: <String>[
                            'Select Charger Type....',
                            'Level 1',
                            'Level 2',
                            'Level 3'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          }).toList(),
                          // Step 5.
                          onChanged: (String? newValue) {
                            setState(() {
                              DD_Charger_Type = newValue!;
                              chargerModel.chargerType = DD_Charger_Type;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              //
                              if (addChargerFormKey.currentState!.validate()) {
                                addChargerFormKey.currentState!.save();

                                chargerModel.userId =
                                    FirebaseAuthServices().firebaseUser!.uid;

                                //chargerModel.chargerLocation = GeoPoint(50, 50);

                                if (addChargerFormKey.currentState!
                                    .validate()) {
                                  FirebaseFirestore.instance
                                      .collection('CHARGERS')
                                      .doc()
                                      .set(chargerModel.toMap())
                                      .whenComplete(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          chargerAddedAlertDialog(context),
                                    );
                                  });
                                } else {}
                              }
                              //
                            },
                            child: Text("Add Charger"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    ));
  }
}
