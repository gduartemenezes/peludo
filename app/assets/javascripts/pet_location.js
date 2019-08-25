var ENTER_KEY_CODE = 13;

function initializeLocationServices() {
  var addressInput = document.getElementById('pet_address');
  var isExistingRecord = addressInput.dataset.existingRecord;
  var autocomplete = new google.maps.places.Autocomplete(
    addressInput,
    { types: ['geocode', 'establishment'] }
  );

  toggleButtonState('#btn-submit', { 'disabled': true });
  preventFormSubmitOnEnter(addressInput);

  autocomplete.setFields(['geometry']);
  autocomplete.addListener('place_changed', handlePlaceSelect.bind(this, autocomplete));

  if (isExistingRecord === 'true') {
    google.maps.event.trigger(autocomplete, 'place_changed');
  }
}

function preventFormSubmitOnEnter(addressInput) {
  google.maps.event.addDomListener(addressInput, 'keydown', function (event) {
    if (event.keyCode === ENTER_KEY_CODE) {
      event.preventDefault();
    }
  });
}

function initializeMap(latitude, longitude) {
  return new google.maps.Map(document.getElementById('pet-map'), {
    center: { lat: latitude, lng: longitude },
    zoom: 15
  });
}

function createMarker(map, latitude, longitude) {
  return new google.maps.Marker({
    map: map,
    draggable: true,
    position: { lat: latitude, lng: longitude }
  });
}

function handlePlaceSelect(autocomplete) {
  var addressInput = $('#pet_address');
  var latitudeInput = $('#pet_latitude');
  var longitudeInput = $('#pet_longitude');
  var mapDiv = $('#pet-map');
  var place = autocomplete.getPlace();

  if (place) {
    var coordinates = place.geometry.location;
    latitudeInput.val(coordinates.lat());
    longitudeInput.val(coordinates.lng());
  }

  toggleButtonState('#btn-submit', { 'disabled': false });

  var latitude = parseFloat(latitudeInput.val());
  var longitude = parseFloat(longitudeInput.val());
  var map = initializeMap(latitude, longitude);
  var marker = createMarker(map, latitude, longitude);

  mapDiv.show();

  google.maps.event.addListener(marker, 'dragend', function () {
    var newCoordinates = marker.getPosition();
    var geocoder = new google.maps.Geocoder();
    map.panTo(newCoordinates);
    latitudeInput.val(newCoordinates.lat());
    longitudeInput.val(newCoordinates.lng());
    geocoder.geocode({ latLng: newCoordinates }, function (results) {
        addressInput.val(results[0].formatted_address);
      }
    );
  });
}
