import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleMarker extends StatefulWidget {
  final String id;
  final String location;
  final String time;
  final String ride;

  SingleMarker(
      {Key key,
      @required this.id,
      @required this.location,
      @required this.time,
      @required this.ride})
      : super(key: key);

  @override
  _SingleMarkerState createState() => _SingleMarkerState();
}

class _SingleMarkerState extends State<SingleMarker> {
  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  LatLng _mainLocation;
  // = const LatLng(22.9087267, 96.4237433);
  // LatLng _mainLocation = LatLng(22.908325, 96.4234917);

  @override
  void initState() {
    super.initState();
    var index = widget.location.toString().indexOf(',');
    var lat = widget.location.toString().substring(0, index);
    var long = widget.location.toString().substring(index + 1);
    _mainLocation = LatLng(double.parse(lat), double.parse(long));
    print("ML >> " + lat + "|" + long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('​မြေပုံ (Map)', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _mainLocation,
                zoom: 18.0,
              ),
              // markers: this.myMarker(),
              markers: {
                Marker(
                  markerId: MarkerId(widget.id.toString()),
                  position: _mainLocation,
                  infoWindow: InfoWindow(title: widget.time),                  
                  icon: BitmapDescriptor.defaultMarker,
                )
              },
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
    );
  }

  // Marker singleMarker = Marker(
  //   markerId: MarkerId(widget.id.toString()),
  //   position: LatLng(22.9087267, 96.4237433),
  //   infoWindow: InfoWindow(title: 'Los Tacos'),
  //   icon: BitmapDescriptor.defaultMarkerWithHue(
  //     BitmapDescriptor.hueViolet,
  //   ),
  // );

  // Set<Marker> myMarker() {
  //   setState(() {
  //     _markers.add(Marker(
  //       // This marker id can be anything that uniquely identifies each marker.
  //       markerId: MarkerId(_mainLocation.toString()),
  //       // position: LatLng(double.parse(data[0]["latitude"].toString()),
  //       //     double.parse(data[0]["longitude"].toString())),
  //       position: _mainLocation,
  //       infoWindow: InfoWindow(
  //         title: "HELLO MAP",
  //         snippet: '5 Star Rating',
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));

  //     return _markers;
  //     // });
  //   });
  // }
}
