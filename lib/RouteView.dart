import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteView extends StatefulWidget {
  LatLng sourceLatLng, destLatLng;
  RouteView({Key? key, required LatLng this.sourceLatLng, required LatLng this.destLatLng}) : super(key: key);


  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {

  late GoogleMapController mapController;
  // double _originLatitude = widget.sou, _originLongitude = 74.52;
  // double _destLatitude = 15.82, _destLongitude = 74.49;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyCZP7cB5o0LMyT7kDm1mPExWnGRiwtWRtY";

  @override
  void initState() {
    super.initState();
    _addMarker(widget.sourceLatLng, "origin",
        BitmapDescriptor.defaultMarker);
    _addMarker(widget.destLatLng, "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blueAccent, points: polylineCoordinates, width: 10);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(widget.sourceLatLng.latitude, widget.sourceLatLng.longitude),
        PointLatLng(widget.destLatLng.latitude, widget.destLatLng.longitude),
        travelMode: TravelMode.driving,);

    print(">>>>>>>>>>>>>> "+result.points.toString());

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
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
          title: Text("Shortest Path", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: widget.sourceLatLng, zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          )),
    );
  }
}
