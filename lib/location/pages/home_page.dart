import 'dart:async';
import 'package:TraceMyanmar/location/helpers/map_helper.dart';
import 'package:TraceMyanmar/location/helpers/map_marker.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:TraceMyanmar/db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
<<<<<<< HEAD
  //---->
  GoogleMapController myMapController;
  final Set<Marker> _markers1 = new Set();
  static const LatLng _mainLocation = const LatLng(22.9087267, 96.4237433);
  //---->

  var dbHelper;
=======
  var dbHelper;   
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
  var data = [];
  var test;
  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;
<<<<<<< HEAD
  testing() async {
    var setList = [];
    setList = await dbHelper.getEmployees();
    // List<Marker> markers = data.map((n) {
    //   LatLng point = LatLng(n.latitude, n.longitude);
    // }).toList();
    // print(markers);
    for (var i = 0; i < setList.length; i++) {
      var index = setList[i].location.toString().indexOf(',');
      data.add({
        "latitude": setList[i].location.toString().substring(0, index),
        "longitude": setList[i].location.toString().substring(index + 1),
=======
  testing() async{
    var setList = [];
    setList = await dbHelper.getEmployees();
  // List<Marker> markers = data.map((n) {
  //   LatLng point = LatLng(n.latitude, n.longitude);
  // }).toList();
  // print(markers);
    for (var i = 0; i < setList.length; i++) {
      var index = setList[i].location.toString().indexOf(',');
      data.add({
        "latitude":setList[i].location.toString().substring(0, index),
        "longitude":setList[i].location.toString().substring(index + 1),
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
      });
    }
    print(data);
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    testing();
  }
<<<<<<< HEAD

=======
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
  // / Example marker coordinates
  final List<LatLng> _markerLocations = [
    LatLng(16.8822700, 96.121611),
    LatLng(16.8822782, 96.121694),
    LatLng(16.8822600, 96.121530),
    LatLng(16.8822720, 96.121870),
    LatLng(16.8822400, 96.121370),
  ];
<<<<<<< HEAD

=======
  
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();   
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
        ),
      );
      print("haha $markerLocation");
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text('Trace Location',
            style: TextStyle(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _mainLocation,
                zoom: 10.0,
              ),
              markers: this.myMarker(),
              mapType: MapType.normal,
              onMapCreated: (controller) {
                setState(() {
                  myMapController = controller;
                });
              },
            ),
          ),
        ],
      ),
      //--->>Old
      // Stack(
      //   children: <Widget>[
      //     // Google Map widget
      //     Opacity(
      //       opacity: _isMapLoading ? 0 : 1,
      //       child: GoogleMap(
      //         mapToolbarEnabled: false,
      //         initialCameraPosition: CameraPosition(
      //           target: LatLng(16.8822782, 96.121694),
      //           zoom: _currentZoom,
      //         ),
      //         markers: _markers,
      //         onMapCreated: (controller) => _onMapCreated(controller),
      //         onCameraMove: (position) => _updateMarkers(position.zoom),
      //       ),
      //     ),

      //     // Map loading indicator
      //     Opacity(
      //       opacity: _isMapLoading ? 1 : 0,
      //       child: Center(child: CircularProgressIndicator()),
      //     ),

      //     // Map markers loading indicator
      //     if (_areMarkersLoading)
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Align(
      //           alignment: Alignment.topCenter,
      //           child: Card(
      //             elevation: 2,
      //             color: Colors.grey.withOpacity(0.9),
      //             child: Padding(
      //               padding: const EdgeInsets.all(4),
      //               child: Text(
      //                 'Loading',
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
    );
  }

  Set<Marker> myMarker() {
    setState(() {
      _markers1.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_mainLocation.toString()),
        position: _mainLocation,
        infoWindow: InfoWindow(
          title: 'Historical City',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    return _markers1;
  }
=======
        title: Text('Trace Location',style: TextStyle(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
      
      body: Stack(
        children: <Widget>[
          // Google Map widget
          Opacity(
            opacity: _isMapLoading ? 0 : 1,
            child: GoogleMap(
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(16.8822782, 96.121694),
                zoom: _currentZoom,
              ),
              markers: _markers,
              onMapCreated: (controller) => _onMapCreated(controller),
              onCameraMove: (position) => _updateMarkers(position.zoom),
            ),
          ),

          // Map loading indicator
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: Center(child: CircularProgressIndicator()),
          ),

          // Map markers loading indicator
          if (_areMarkersLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 2,
                  color: Colors.grey.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Loading',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
}
