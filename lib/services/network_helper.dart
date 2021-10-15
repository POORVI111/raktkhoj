import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:raktkhoj/Constants.dart';

class NetworkHelper{
  NetworkHelper({this.startLng,this.startLat,this.endLng,this.endLat});

  final String url ='https://api.openrouteservice.org/v2/directions/';
  final String apiKey = OPENSERVICE_API_KEY;
  final String journeyMode = 'driving-car'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async{
    http.Response response = await http.get(Uri.parse('$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));
    print("$url$journeyMode?$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");

    if(response.statusCode !=null) {
      String data = response.body;
      return jsonDecode(data);

    }
    else{
      print(response.statusCode);
    }
  }
}