import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/base.dart';
import '../../../config/functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../../config/constants.dart';
import '../../models/revenuestreamspaginated.dart';
import 'dart:ui' as ui;

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends Base<MapPage> {
  late String _mapStyleString;
  late GoogleMapController mapsController;
  List<RevenueStreams> _streams = [];
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _initialLocation =
      CameraPosition(target: LatLng(0.0568633, 32.4697474), zoom: 11);
  List<Marker> _markers = [];
  bool showMaps = true;

  //get incidents and filter those near me
  Future<List<RevenueStreams>> getStreams() async {
    List<RevenueStreams> returnValue = [];
    var url = Uri.parse(
        AppConstants.baseUrl + "revenuestreams/default?page=1&size=50");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      RevenueStreamsPaginatedModel incidentsmodel =
          RevenueStreamsPaginatedModel.fromJson(items);

      returnValue = incidentsmodel.items;
      setState(() {
        _streams = incidentsmodel.items;
        addMarkers();
        // _streamsNearMe = incidentsmodel;
      });
      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void addMarkers() async {
    if (_streams.isNotEmpty) {
      for (var i in _streams) {
        final Uint8List markIcons =
            await getImages("assets/images/shuttlebus.png", 30);
        setState(() {
          _markers.add(
            Marker(
                icon: BitmapDescriptor.fromBytes(markIcons),
                markerId: MarkerId(i.id),
                position: LatLng(
                    i.addresslat ?? 0.0935335, i.addresslong ?? 32.4944694),
                infoWindow: InfoWindow(title: i.regno, snippet: i.model)),
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_styles/map_style.json').then((string) {
      _mapStyleString = string;
    });
    getStreams();
    _markers.add(
      Marker(
          markerId: MarkerId("Municipal HQ"),
          position: LatLng(0.0568633, 32.4697474),
          infoWindow: InfoWindow(title: "Entebbe Municipality HQ")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(bottom: 20),
      // padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map View
          SizedBox(
            height: 300,
            width: double.infinity,
            child: _streams.isNotEmpty
                ? GoogleMap(
                    markers: Set<Marker>.from(_markers),
                    initialCameraPosition: _initialLocation!,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    // polylines: Set<Polyline>.of(polylines.values),
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        mapsController = controller;
                      });
                      _controller.complete(controller);
                      _controller.future.then((value) {
                        value.setMapStyle(_mapStyleString);
                      });
                    },
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text("No Vehicles to view on the map."),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
