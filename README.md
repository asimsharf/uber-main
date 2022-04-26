# Search coordinate address
https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude}, ${position.longitude}=$mapKey&language=ar

# Find place
https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&types=geocode&key=$mapKey&components=country:SA&language=ar

# Find place address details
https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeID}&key=$mapKey&language=ar

