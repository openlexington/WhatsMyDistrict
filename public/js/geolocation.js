var address_field = document.getElementById("address");

function getLocation(){
  if (navigator.geolocation)
    {
    navigator.geolocation.getCurrentPosition(showPosition);
    }
  else{
    // Fail quietly
  }
};
function showPosition(position)
  {
  var lat = position.coords.latitude;
  var lng = position.coords.longitude;
  var geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(lat, lng);
  geocoder.geocode({'latLng': latlng}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[0]) {
          address_field.value = results[0].formatted_address.split(',')[0];
        }
      } else {
        // Geocode Failed, fail quietly
      }
    });
};

jQuery(document).ready(function($) {
  getLocation();
});
