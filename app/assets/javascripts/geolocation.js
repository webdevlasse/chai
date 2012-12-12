
// Geolocation object that gets Users current position by
// longitude & latitude + some additional functions to help with
// providing data and populating the main page and google map

function setLatLong(lat, lng) {
  console.log("This should happen first.")

  var locationString = document.location.toString();
  var newString = '?' + 'latitude=' + lat + '&' + 'longitude=' + lng;
  if (locationString.indexOf(newString) == -1) {
    console.log('pushing state');
    history.pushState({}, '', newString);
  }
}

function hasCoordinates() {
  var locationString = document.location.toString();
  return /latitude/.test(locationString) && /longitude/.test(locationString);
}

function getLatLng() {
  lat = parseFloat(getParameterByName('latitude'));
  lng = parseFloat(getParameterByName('longitude'));
  return { latitude: lat, longitude: lng };
}

var Geolocation = {
  init: function() {
    var that = this;

    $('#map-native-results').on('ajax:success',this.shopListFromDB);
    $('#searchRemoteResults').on('click', this.findRemoteResultsBySearch);
    $('#map-native-results').on('click', '.show_rating_row', this.showRatingRow);
    //$('#find-shops').on('click', this.findRemoteResultsBySearch);
    // this.currentPosition();
    // this.sendCurrentPositionAndGetCoffeshopResults();
    $(window).bind('popstate', function() {
      console.log('pop pop')
      var myLatlng = new google.maps.LatLng(getLatLng().latitude, getLatLng().longitude);
      map.setCenter(myLatlng);
      Geolocation.sendPositionAndGetRemoteResults();
    });

    Geolocation.setLatLngFromCurrentPosition(function() {
      console.log("This should happen second.")
      var latLng = getLatLng();
      var myLatlng = new google.maps.LatLng(latLng.latitude, latLng.longitude);
        var marker = new google.maps.Marker({
          position: myLatlng,
          map: Geolocation.createMap(myLatlng),
          animation: google.maps.Animation.DROP,
          icon: 'https://chart.googleapis.com/chart?chst=d_map_xpin_icon&chld=pin_star|home|00FFFF|FF0000',
          title: "You're here", //name
        });
      that.sendPositionAndGetRemoteResults();
    });
  },


  showRatingRow: function() {
    $next_row = $(this).parents('tr').next();
    $button = $(this)
    if($next_row.is(':visible') ){
      $next_row.hide('fast');
      $button.html("<button class='btn btn-small'><i class='icon-eye-open'></button>");
    }else{
      $('.visit_rating').hide('slow');
      $next_row.show('slow');
      $button.html("<button class='btn btn-small'><i class='icon-eye-close'></button>");
    }
  },

  triggerClickEventOnMarker: function() {
    var index = $(this).data('id');
    google.maps.event.trigger(markers[index], 'click');
  },

  clearStateHistory: function() {
    history.pushState({}, '', '');
  },
  createMap: function(lngLat) {
    var mapOptions = {
      zoom: 16,
      center: lngLat,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
    };
    map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
    return map;
  },
  shopListFromDB: function(event, data) {
    $('#map-native-results').html(data.html_content);
    $('.shop-info-row').on('click', Geolocation.triggerClickEventOnMarker); //attach the event to the list row
    // highlights table rows
    $(".shop-info-row").click(function() {
       $('.shop-info-row.highlight').removeClass('highlight');
       $(this).addClass('highlight');
    });
    var infowindow = new google.maps.InfoWindow();

    markers = new Array();
    for (var i = 0; i < data.businesses.length; i++) {
      var myLatlng = new google.maps.LatLng(data.businesses[i].latitude, data.businesses[i].longitude);
      var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        icon: "http://chart.apis.google.com/chart?chst=d_map_pin_icon&chld=cafe%7C996600",
        //title: data.businesses[i].name,
        html: data.html_marker_info[i], // taking an element from an array of rendered HTML - done in the create function in the shop controller
      });

      // "this" refers to the marker. the function that is executed on click,
          // attaches the html content from the marker into the info window.
      google.maps.event.addListener(marker, 'click', function() {
        infowindow.setContent(this.html);
        infowindow.open(map,this);
      });

      markers.push(marker);
      $('.visit_rating').hide();
    }
  },

// function to get the users current position based on geolocation
// also adds a pin to the google map with a hover text that reads 'You're here
  setLatLngFromCurrentPosition: function(callback)  {
    if(hasCoordinates()) {
      callback();
      return;
    }

    navigator.geolocation.getCurrentPosition(function(position){
      setLatLong(position.coords.latitude, position.coords.longitude);
      callback();
    });

  },
  sendPositionAndGetRemoteResults: function() {
    var coords = getLatLng();
    $.ajax({
        type: 'post',
        url: '/native_results',
        dataType: 'json',
        data: coords,
        success: function(data, status, xhr) {
          $('#map-native-results').trigger('ajax:success', [data, status, xhr]);

        },
        error: function(xhr, status, error) {
          $('#map-native-results').trigger('ajax:error', [xhr, status, error]);
        },
        complete: function(xhr, status) {
          $('#map-native-results').trigger('ajax:complete', [xhr, status]);
        }
      });
  },


// function that sends an Ajaxs request to our rails sever and waits for a reply
// on successful reply triggers a 'success' which causes the displaying of our query items
  getGeoLocation: function() {

    //$('#find-shops button').attr("disabled", true);
    //$('#find-shops').fadeTo(500, 0.2);
    $('body').addClass("loading");
    navigator.geolocation.getCurrentPosition(function(position){
      $.ajax({
        type: 'post',
        url: '/native_results',
        dataType: 'json',
        data: {longitude: position.coords.longitude, latitude: position.coords.latitude},
        success: function(data, status, xhr) {
          $('#map-native-results').trigger('ajax:success', [data, status, xhr]);
        },
        error: function(xhr, status, error) {
          $('#map-native-results').trigger('ajax:error', [xhr, status, error]);
        },
        complete: function(xhr, status) {
          $('body').removeClass("loading");
          //$('#find-shops button').attr("disabled", false);
          //$('#find-shops').fadeTo(500, 1);
        }
      });
    });
  },


  findRemoteResultsBySearch: function(){
    var address = document.getElementById("address").value;
    geocoder = new google.maps.Geocoder();
    geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        var marker = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location,
            icon: 'https://chart.googleapis.com/chart?chst=d_map_xpin_icon&chld=pin_star|home|00FFFF|FF0000',
        });
        var latitude = results[0].geometry.location.Za;
        var longitude = results[0].geometry.location.$a;
        setLatLong(latitude, longitude);
        Geolocation.sendPositionAndGetRemoteResults()
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    });
  }

};

function getParameterByName(name) {
  name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
  var regexS = "[\\?&]" + name + "=([^&#]*)";
  var regex = new RegExp(regexS);
  console.log(window.location.search);
  var results = regex.exec(window.location.search);
  if (results == null) {
    return "";
  } else {
    return decodeURIComponent(results[1].replace(/\+/g, " "));
  }
}

// document ready wrapper for our Geolocation object
$(document).ready(function(){

});



