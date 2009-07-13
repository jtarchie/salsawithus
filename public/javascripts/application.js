function log(message) {
	if (console && console.log) {
		console.log(message);
	}
}
function submitAddVenue(event) {
	var valid = new Validation('add_form',{onSubmit:false});
	if (valid.validate()) {
		var fields = $H($('add_form').serialize(true));
		formal_address(fields.get('address'), function(update_fields) {
			new Ajax.Request('/api/venues',{
				method: 'post',
				parameters: fields.merge(update_fields),
				onSuccess: function(transport) {
					$('address_start').hide();
					$('address_successful_message').show();
					//myLightWindow.deactivate();
				},
				onFailure: function(transport) {
					$('address_unsuccessful_message').show();
				}
			});
		});
	}
	return false;	
}

function formal_address(address, callback) {
	var fields = {};
	new GClientGeocoder().getLocations(address, function(response){
		if (response && response.Status.code == 200) {
			var place = response.Placemark[0];
			var fields = {
				lat : place.Point.coordinates[1],
				lng : place.Point.coordinates[0],
				address : place.address
			};
			if (typeof(fields.address) == "undefined") {
				callback({lat : 0, lng : 0, address : address});
			} else {
				callback(fields);
			}
		} else {callback({lat : 0, lng : 0, address : address});}
	});
	return fields;
}
var map = null;
function update_map_with_address(address) {
	var geocoder = new GClientGeocoder();
	geocoder.getLatLng(address, function(point) {
		if (point) {
			$('address').value = address;
			update_map_lat_lng(point.lat(), point.lng());
		} else {
			alert("Sorry, but the address you entered is not valid, so we cannot find it on the map.");
		}
	});
}
function update_map_with_venue_id(venue_id) {
	var url = '/api/venues/' + venue_id;
	new Ajax.Request(url, {
		method: 'get',
		onSuccess: function(transport) {
			var json = transport.responseText.evalJSON();
			var venue = json.venue;
			update_map_lat_lng(venue.lat, venue.lng);
		}
	});
}
function update_map_lat_lng(lat, lng) {
	var url = '/api/venues?lat=' + lat + "&lng=" + lng;
	map.setCenter(new GLatLng(lat,lng), 11);
	new Ajax.Request(url, {
		method: 'get',
		onSuccess: function(transport) {
			update_venues(map,transport.responseText.evalJSON());
		}
	});
}
function update_venues(map, items) {
	//reset the elements
	map.clearOverlays();
	$$('ul#list_venues .venue').each(function(venue) {venue.remove();});
	//$('list_venues').innerHTML = '';
	items.each(function(item) {
		var venue = item.venue;
		addVenueMapMarker(venue);
		addVenueListItem(venue);
	});
	$$('.list_venue_count').each(function(count) {count.innerHTML = items.size();});
}
function addVenueListItem(venue) {
	//append to list of venues on nav bar
	var element = new Element('li', {'class':'venue'});
	var link = new Element('a',{href: '#'});
	link.onclick = function(event) {
		var latlng = new GLatLng(venue.lat, venue.lng);
		map.panTo(latlng);
		displayVenueMessage(venue.name, latlng);
		return false;
	};
	link.appendChild(document.createTextNode(venue.name));
	element.insert(link);
	//element.innerHTML = '<a href="#" onclick="displayVenue('+ venue.id +')">' + venue.name + "</span>";
	$$('ul#list_venues').first().insert(element);
}

function addVenueMapMarker(venue) {
	var latlng = new GLatLng(venue.lat, venue.lng);
	var marker = new GMarker(latlng);
	//setup the marker to have behaviors
	GEvent.addListener(marker, "mouseover", function() {
		if (latlng) {
			displayVenueMessage(venue.name, latlng);
		}
	});
	GEvent.addListener(marker, "click", function() {
		map.panTo(latlng);
		displayVenue(venue.id);
	});
	map.addOverlay(marker);
}

function displayVenueMessage(message, latlng) {
	if (typeof(this.label) != "undefined") {this.label.remove();}
	this.label = new ELabel(latlng, message, "map_label_style", {height:0,width:0}, 80);
	map.addOverlay(this.label);
	/*var element = $('venue_title');
	if (element) {
		var point = map.fromLatLngToDivPixel(latlng);
		element.hide();
		element.innerHTML = message;
		element.setStyle({
			top: point.y,
			left: point.x
		});
		element.show();
	}*/
}

function displayVenue(venueID) {
	myLightWindow.activateWindow({
		href: '/venues/' + venueID,
		width: 800
	});
	return false;
}

function editVenue(venueID) {
	window.parent.myLightWindow.activateWindow({
		href: '/venues/' + venueID + '/edit',
		type: 'page'
	});
	return false;
}

function addVenuePopup() {
	myLightWindow.activateWindow({
		href: '/venues/new',
		type: 'page'
	});
	return false;
}

function addEventPopup(venueID) {
	//window.parent.myLightWindow.deactivate();
	window.parent.myLightWindow.activateWindow({
		href: '/events/new?venue_id=' + venueID,
		type: 'page'
	});
}

google.setOnLoadCallback(function() {
	var element = $('map_canvas');
	if(element) {
		//load up the map to the user's current location
	    map = new GMap2(element);
		map.addControl(new GLargeMapControl());
		var params = window.location.search.substring(1).toQueryParams();
		if (params.id) {
			update_map_with_venue_id(params.id);
		} else if (params.lng && params.lat) {
			$('address').value = params.lat + "," + params.lng;
			update_map_lat_lng(params.lat, params.lng);
		} else if (params.address) {
			update_map_with_address(params.address.replace('+',''));
		} else if (google.loader.ClientLocation){
			$('address').value = google.loader.ClientLocation.address.city + ", " + google.loader.ClientLocation.address.region;
			update_map_lat_lng(google.loader.ClientLocation.latitude, google.loader.ClientLocation.longitude);
		} else{
			update_map_with_address("San Francisco, CA");
		}
	}
});

Event.observe(window, 'load', function() {
	//if($('venue_title')) {$('venue_title').insert(map.getPane(G_MAP_FLOAT_SHADOW_PANE));}
	$$('.requirelogin').each(function(tag) {
		var onclick = tag.onclick;
		tag.onclick = function(event) {
			FB.Connect.requireSession(function(exception) {
				onclick(event);
			});
			return false;
		};
	});	
});