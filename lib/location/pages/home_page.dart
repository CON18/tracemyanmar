import 'dart:async';
import 'package:TraceMyanmar/location/helpers/map_helper.dart';
import 'package:TraceMyanmar/location/helpers/map_marker.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:TraceMyanmar/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // //---->
  // GoogleMapController myMapController;
  // final Set<Marker> _markers1 = new Set();
  // static const LatLng _mainLocation = const LatLng(22.9087267, 96.4237433);
  // //---->

  var dbHelper;
  var data = [];
  var test;
  final Completer<GoogleMapController> _mapController = Completer();
  final Map<String, Marker> _new_markers = {};

  /// Set of displayed markers and cluster markers on the map
  // final Set<Marker> _markers = Set();

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
  String checklang = '';
  List textMyan = ["​မြေပုံ"];
  List textEng = ["Map"];
  
  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }
  // Example marker coordinates
  // final List<LatLng> _markerLocations = [];
  // final List<LatLng> _markerLocations = [
  //   LatLng(16.8822700, 96.121611),
  //   LatLng(16.8822782, 96.121694),
  //   LatLng(16.8822600, 96.121530),
  //   LatLng(16.8822720, 96.121870),
  //   LatLng(16.8822400, 96.121370),
  // ];

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;
  testing() async {
      var setList = [];
      setList = await dbHelper.getEmployees();
    setState(() {

      // List<Marker> markers = data.map((n) {
      //   LatLng point = LatLng(n.latitude, n.longitude);
      // }).toList();
      // print(markers);
      for (var i = 0; i < setList.length; i++) {
        var index = setList[i].location.toString().indexOf(',');

        data.add({
          "latitude": setList[i].location.toString().substring(0, index),
          "longitude": setList[i].location.toString().substring(index + 1),
        });
        // double lat =
        //     double.parse(setList[i].location.toString().substring(0, index));
        // double long =
        //     double.parse(setList[i].location.toString().substring(index + 1));
        // LatLng loc = LatLng(lat, long);
        // _markerLocations.add(loc);
      }
      // print("LAT/LONG >> $_markerLocations");
    });
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
    dbHelper = DBHelper();
    testing();
  }

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
    // final List<MapMarker> markers = [];

    var dbHelper = DBHelper();
    final setList = await dbHelper.getEmployees();
    setState(() {
      _new_markers.clear();
      for (final list in setList) {
        var index = list.location.toString().indexOf(',');
        var lat = list.location.toString().substring(0, index);
        var long = list.location.toString().substring(index + 1);
        // print("Lth >> "+list.length.toString())
        print("ML >> " + lat + "|" + long);
        final marker = Marker(
          markerId: MarkerId(list.id.toString()),
          position: LatLng(double.parse(lat), double.parse(long)),
          infoWindow: InfoWindow(
            title: list.time,
            // snippet: office.address,
          ),
        );
        _new_markers[list.id.toString()] = marker;
      }
    });

    // for (LatLng markerLocation in _markerLocations) {
    // final BitmapDescriptor markerImage =
    //     await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

    // markers.add(
    //   MapMarker(
    //     id: _markerLocations.indexOf(markerLocation).toString(),
    //     position: markerLocation,
    //     // icon: markerImage,
    //     icon: BitmapDescriptor.defaultMarker,
    //   ),
    // );
    //   print("haha $markerLocation");
    // }

    // _clusterManager = await MapHelper.initClusterManager(
    //   markers,
    //   _minClusterZoom,
    //   _maxClusterZoom,
    // );

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

    // _markers
    //   ..clear()
    //   ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(checklang=="Eng" ? textEng[0]: textMyan[0], style: TextStyle(fontWeight: FontWeight.w300)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            //   child: GoogleMap(
            //     initialCameraPosition: CameraPosition(
            //       target: _mainLocation,
            //       zoom: 12.0,
            //     ),
            //     // markers: this.myMarker(),
            //     markers: {

            //       newyork1Marker,
            //       newyork2Marker
            //     },
            //     mapType: MapType.normal,
            //     onMapCreated: (controller) {
            //       setState(() {
            //         myMapController = controller;
            //       });
            //     },
            //   ),

            child: GoogleMap(
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(22.908325, 96.4234917),
                zoom: _currentZoom,
              ),
              markers: _new_markers.values.toSet(),
              onMapCreated: _onMapCreated,
              onCameraMove: (position) => _updateMarkers(position.zoom),
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

  // Set<Marker> myMarker() {
  //   setState(() {
  //     //   // new Timer(const Duration(milliseconds: 50), () {
  //     //   // print("marker>>>>" +
  //     //   //     data[0]["latitude"].toString() +
  //     //   //     "|" +
  //     //   //     data[0]["longitude"].toString());
  //     //   _markers1.add(Marker(
  //     //     // This marker id can be anything that uniquely identifies each marker.
  //     //     markerId: MarkerId(_mainLocation.toString()),
  //     //     // position: LatLng(double.parse(data[0]["latitude"].toString()),
  //     //     //     double.parse(data[0]["longitude"].toString())),
  //     //     position: LatLng(22.908325, 96.4234917),
  //     //     infoWindow: InfoWindow(
  //     //       title: 'Historical City',
  //     //       snippet: '5 Star Rating',
  //     //     ),
  //     //     icon: BitmapDescriptor.defaultMarker,
  //     //   ));
  //     //   return _markers1;
  //     // });
  //   });
  // }
}
