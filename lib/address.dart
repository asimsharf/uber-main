class Address {
  late String placeName;
  late double latitude;
  late double longitude;
  late String placeID;
  late String placeFormattedAddress;

  Address({
    required this.latitude,
    required this.longitude,
    required this.placeID,
    required this.placeFormattedAddress,
  });

  Address.fromJson(Map<String, dynamic> json) {
    placeName = json['result']['name'] ?? "";
    latitude = json['result']['geometry']['location']['lat'] ?? "";
    longitude = json['result']['geometry']['location']['lng'] ?? "";
    placeID = json['result']['place_id'] ?? "";
    placeFormattedAddress = json['result']['formatted_address'] ?? "";
  }
}
