import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerMapPage extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  MarkerMapPage({required this.onLocationSelected});

  @override
  _MarkerMapPageState createState() => _MarkerMapPageState();
}

class _MarkerMapPageState extends State<MarkerMapPage> {
  late GoogleMapController _controller;
  LatLng jordanLocation = LatLng(31.9632, 35.9304);

  Set<Marker> _markers = {};
  bool _autoZoomEnabled = false;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jordan Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
            },
            initialCameraPosition: CameraPosition(
              target: jordanLocation,
              zoom: 7.0,
            ),
            markers: _markers,
            onTap: _addMarkerFromTap,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedLocation != null) {
                  widget.onLocationSelected(_selectedLocation!);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a location on the map.'),
                    ),
                  );
                }
              },
              child: Text('Confirm Location'),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: SearchBar(_zoomToLocation, toggleAutoZoom),
          ),
        ],
      ),
    );
  }

  void _zoomToLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      LatLng position =
          LatLng(locations.first.latitude, locations.first.longitude);

      // Zoom to the location
      _controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15.0));
    } catch (e) {
      print('Error searching for location: $e');
    }
  }

  void _addMarkerFromTap(LatLng position) {
    _selectedLocation = position;
    _showAddMarkerDialog(position);
  }

  void _showAddMarkerDialog(LatLng position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Marker"),
          content: Text("Do you want to add a marker at this location?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _addMarker(position); // Add the marker
                Navigator.of(context).pop(); // Close the dialog

                // Auto-zoom if enabled
                if (_autoZoomEnabled) {
                  _controller.animateCamera(
                      CameraUpdate.newLatLngZoom(position, 15.0));
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _addMarker(LatLng position) {
    final String markerIdVal = 'marker';
    final MarkerId markerId = MarkerId(markerIdVal);

    // Clear existing markers
    setState(() {
      _markers.clear();
    });

    // Create a new marker
    final Marker marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: 'Marker'),
    );

    // Add the new marker
    setState(() {
      _markers.add(marker);
    });
  }

  void toggleAutoZoom(bool value) {
    setState(() {
      _autoZoomEnabled = value;
    });
  }

  void _saveLocation(LatLng position) async {
    try {
      await FirebaseFirestore.instance.collection('locations').add({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location saved!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save location: $e'),
      ));
    }
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function(bool) onToggleAutoZoom;

  SearchBar(this.onSearch, this.onToggleAutoZoom);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();
  bool _autoZoomEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search location',
                    border: InputBorder.none,
                  ),
                  textDirection:
                      TextDirection.rtl, // Set text direction to right-to-left
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  widget.onSearch(_controller.text);
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('Auto-Zoom'),
              Switch(
                value: _autoZoomEnabled,
                onChanged: (value) {
                  setState(() {
                    _autoZoomEnabled = value;
                    widget.onToggleAutoZoom(value);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
