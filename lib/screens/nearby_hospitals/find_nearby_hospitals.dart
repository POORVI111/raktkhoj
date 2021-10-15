import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:raktkhoj/Colors.dart';
import 'package:raktkhoj/Constants.dart';
import 'package:raktkhoj/model/hospitals.dart';
import 'package:raktkhoj/services/add_marker.dart';
import 'package:raktkhoj/services/network_helper.dart';


class FindNearbyHospitals extends StatefulWidget {
  @override
  _FindHearbyHospitalsState createState() => _FindHearbyHospitalsState();
}

class _FindHearbyHospitalsState extends State<FindNearbyHospitals>
{
  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  double startLat, startLng, endLat, endLng;
  Position currentPosition;
  var data;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

  }

  Widget build(BuildContext context) {


    final markerservice = MarkerService();

//fetch nearby hospitals(tomtom api) and return as list
    Future<List<Hospital>> fetchPlace() async {
      List<Hospital> lists = [];
      if (currentPosition != null) {
        var key = TOMTOM_API_KEY,
            lat = currentPosition.latitude.toString(),
            lng = currentPosition.longitude.toString();
        var radius = '100000';

        var url =
            'https://api.tomtom.com/search/2/search/hospital.json?key=$key&limit=30&lat=$lat&lon=$lng&radius=$radius';
        var response =
        await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
        var jsonuse = json.decode(response.body);
        var listsjson = jsonuse['results'];
        for (var h in listsjson) {
          var poi = h['poi'];
          var name = poi['name'];
          var score = h['score'];
          var dist = h['dist'];
          var pos = h['position'];
          var lat = pos['lat'];
          var lng = pos['lon'];
          var addpoi = h['address'];
          var add = addpoi['freeformAddress'];
          var id = h['id'];
          Hospital vari = Hospital(name, score, dist, lat, lng, add, id);
          lists.add(vari);
        }
      }
      return lists;
    }

    return Scaffold(
      body: Container(
          child: (currentPosition != null)
              ? FutureBuilder(
            future: fetchPlace(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var markers = (snapshot.data != null)
                  ? markerservice.getMarkers(snapshot.data)
                  : List<Marker>();
              return (snapshot.data != null)
                  ? Column(
                children: <Widget>[
                  Container(
                    height:
                    MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          zoom: 16),
                      zoomControlsEnabled: true,
                      myLocationEnabled: true,
                      markers: Set<Marker>.of(markers),
                      polylines: polyLines,

                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                title:
                                Text(snapshot.data[index].name),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ((snapshot.data[index].dist) <
                                        1000)
                                        ? Text(
                                        '${snapshot.data[index].freeformAddress} \u00b7 ${(snapshot.data[index].dist).round()} Meters',style:
                                      TextStyle(color:kMainRed))
                                        : Text(
                                        '${snapshot.data[index].freeformAddress} \u00b7 ${double.parse((snapshot.data[index].dist / 1000).toStringAsFixed(2))} Kms'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.directions),
                                  color: Theme.of(context)
                                      .primaryColor,
                                  onPressed: (snapshot.data[index].lat!=null) ?()
                                  async{
                                    setState(() {


                                      startLat= currentPosition.latitude;
                                      startLng=currentPosition.longitude;
                                      endLat= snapshot.data[index].lat;
                                      endLng=snapshot.data[index].lng;
                                    });
                                    getJsonData();
                                  }:null,

                                ),
                                onTap: () async {


                                },
                              ),
                            );
                          }))
                ],
              )
                  : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
              : Center(
            child: CircularProgressIndicator(),
          )),
    );
  }

  /* used when google maps billing account present */
  // _createPolylines(
  //     double startLatitude,
  //     double startLongitude,
  //     double destinationLatitude,
  //     double destinationLongitude,
  //     ) async {
  //   polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     API_KEY, // Google Maps API Key
  //     PointLatLng(startLatitude, startLongitude),
  //     PointLatLng(destinationLatitude, destinationLongitude),
  //     travelMode: TravelMode.transit,
  //   );
  //            print(result);
  //   if (result.points.isNotEmpty) {
  //     print(result);
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }
  //
  //   PolylineId id = PolylineId('poly');
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.red,
  //     points: polylineCoordinates,
  //     width: 3,
  //   );
  //   polylines[id] = polyline;
  // }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls =
      LineString(data['features'][0]['geometry']['coordinates']);
      if(polyPoints.isNotEmpty)
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
    setState(() {});
  }

  _getCurrentLocation() async {
    await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        currentPosition = position;

      });
    }).catchError((e) {
      print(e);
    });
  }


}

//Create a new class to hold the Co-ordinates we've received from the response data
class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
