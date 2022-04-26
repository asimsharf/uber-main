import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uber/place_redictions.dart';

import 'address.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({Key? key}) : super(key: key);

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  TextEditingController txtPick = TextEditingController();
  TextEditingController txtDrop = TextEditingController();

  List<PlacePredictions> placePredictionsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 215,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 25,
                top: 50,
                right: 25,
                bottom: 10,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const Center(
                        child: Text(
                          "Set Drop off",
                          style: TextStyle(
                            fontFamily: 'Brand Bold',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/pickicon.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: TextField(
                              controller: txtPick,
                              decoration: InputDecoration(
                                hintText: "PickUp location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                  left: 11,
                                  top: 8,
                                  bottom: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/desticon.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: TextField(
                              controller: txtDrop,
                              onChanged: (val) {
                                findPlace(val);
                              },
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                  left: 11,
                                  top: 8,
                                  bottom: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          (placePredictionsList.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.separated(
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {
                          findPlaceDetails(placePredictionsList[i].placeID);
                        },
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.add_location),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        placePredictionsList[i].mainText,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        placePredictionsList[i].secondaryText,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (ctx, i) => const Divider(),
                    itemCount: placePredictionsList.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&types=geocode&key=map_api_key&components=country:SA&language=ar";

      var res = await getRequest(autoCompleteUrl);
      if (res == 'failed') {
        return;
      }

      if (res['status'] == 'OK') {
        var predictions = res['predictions'];
        var placeList = (predictions as List).map((e) {
          return PlacePredictions.fromJson(e);
        }).toList();

        setState(() {
          placePredictionsList = placeList;
        });
      }
    }
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

  void findPlaceDetails(String placeID) async {
    String placeDetails =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=map_api_key&language=ar";

    var res = await getRequest(placeDetails);
    if (res == 'failed') {
      return;
    }

    if (res['status'] == 'OK') {
      var address = Address.fromJson(res);
      dev.log(
        {
          'placeName': address.placeName,
          'latitude': '${address.latitude}',
          'longitude': '${address.longitude}',
          'placeID': address.placeID,
          'placeFormattedAddress': address.placeFormattedAddress,
        }.toString(),
        name: 'address_details',
      );
      setState(() {
        txtDrop.text = address.placeFormattedAddress;
      });
    }
  }
}
