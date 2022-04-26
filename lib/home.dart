import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uber/search_location.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// Get user current location & Geocoding the current location
  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPadding = 0;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(LatLng(position.latitude, position.longitude));
    currentPosition = position;
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );
    googleMc.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await searchCoordinateAddress(position);
    dev.log(address, name: 'This is Your address');
  }

  /// Reversing the location

  final Completer<GoogleMapController> completerGmc = Completer();

  late GoogleMapController googleMc;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.6812168, 46.7380791),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Home"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text("Hello"),
                accountEmail: const Text("ali"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Image.asset(
                    'assets/images/user_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              completerGmc.complete(controller);
              googleMc = controller;
              setState(() {
                bottomPadding = 300;
              });
              locatePosition();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    const Text(
                      "Hi there, ",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      "Where to?",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Brand Bold",
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SearchLocation(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(height: 10),
                              Text("Search Drop off"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Add Home"),
                            SizedBox(height: 4),
                            Text(
                              "Your living home address",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.work,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Add Word"),
                            SizedBox(height: 4),
                            Text(
                              "Your office address",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude}, ${position.longitude}=map_api_key&language=ar";
    var response = await getRequest(url);
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
    }
    return placeAddress;
  }

  static Future<dynamic> getRequest(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String jSonData = response.body;
        var decodedData = jsonDecode(jSonData);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (exp) {
      return 'failed';
    }
  }
}
