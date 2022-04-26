class PlacePredictions {
  late String secondaryText;
  late String mainText;
  late String placeID;

  PlacePredictions({
    required this.secondaryText,
    required this.mainText,
    required this.placeID,
  });

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    secondaryText = json['structured_formatting']['secondary_text'] ?? "";
    mainText = json['structured_formatting']['main_text'] ?? "";
    placeID = json['place_id'] ?? "";
  }
}
