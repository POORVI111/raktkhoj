/*
 add marker in google maps.
 */
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:raktkhoj/model/hospitals.dart';


class MarkerService {
  List<Marker> getMarkers(List<Hospital> hospitalList) {
    var markers = List<Marker>();

    hospitalList.forEach((hospital) {
      Marker marker = Marker(
          markerId: MarkerId(hospital.id),
          draggable: false,
          infoWindow: InfoWindow(
              title: hospital.name, snippet: hospital.freeformAddress),
          position: LatLng(hospital.lat, hospital.lng));
      markers.add(marker);
    });
    return markers;
  }
}
