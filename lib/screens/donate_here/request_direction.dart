import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:raktkhoj/components/ripple_indicator.dart';
import 'package:raktkhoj/screens/nearby_hospitals/find_nearby_hospitals.dart';
import 'package:raktkhoj/services/network_helper.dart';

import '../../Colors.dart';

class RequestDirection extends StatefulWidget {
  final  location;
  final String address;

  RequestDirection({this.location,this.address});
  @override
  _RequestDirectionState createState() => _RequestDirectionState();

}

class _RequestDirectionState extends State<RequestDirection> {
  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  double startLat, startLng;
  Position currentPosition;
  var data;
  Widget _child;
  void initState() {
    super.initState();
    _child = RippleIndicator("");
    // getIcon();
    getCurrentLocation();

  }

  Future<Null> getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: startLat,
      startLng: startLng,
      endLat: widget.location.latitude,
      endLng: widget.location.longitude,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls =
      LineString(data['features'][0]['geometry']['coordinates']);
      if (polyPoints.isNotEmpty)
        polyPoints.clear();
      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();

      }
    } catch (e) {
      print(e);
    }
  }

//for direction b/w 2 places
  setPolyLines() {
    // to refresh
    if (polyLines.isNotEmpty)
      polyLines.clear();
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
    );
    polyLines.add(polyline);
  }

  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    print(Position);
    setState(() {
      currentPosition = res;
      startLat = currentPosition.latitude;
      startLng = currentPosition.longitude;
      _child = mapWidget();
    });

    //print(currentPosition.latitude);
    //print(currentPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }

  Widget mapWidget() {
    return FutureBuilder(
        future: getJsonData(),
        builder: (context, snapshot) {
          try {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentPosition.latitude, currentPosition.longitude),
                zoom: 18.0,
              ),
              markers: <Marker>[
                Marker(
                  markerId: MarkerId("requestLocation"),
                  position: LatLng(widget.location.latitude, widget.location.longitude),
                    infoWindow: InfoWindow(
                        title: widget.address.toString())
                ),
              ].toSet(),
              polylines: polyLines,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
            );
          }
          catch (e){
            return Padding(
                padding: EdgeInsets.only(top: 50),
                child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(
                          kMainRed),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Loading...')
                  ],
                ));
          }
        }
    );
  }
}
