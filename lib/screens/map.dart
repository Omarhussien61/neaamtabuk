import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_pos/model/RecipentModel.dart';
import 'package:flutter_pos/model/direction_model.dart';
import 'package:flutter_pos/screens/delegateOrders.dart';
import 'package:flutter_pos/service/api.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/local/LanguageTranslated.dart';
import 'package:flutter_pos/utils/navigator.dart';
import 'package:flutter_pos/widget/OrderOverlay.dart';
import 'package:flutter_pos/widget/ResultOverlay.dart';
import 'package:flutter_pos/widget/custom_loading.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  String donation_id;
  String longitude;
  String latitude;

  MapPage(this.donation_id, this.longitude, this.latitude);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController _googleMapController;
  var initialCameraPosition =CameraPosition(
      zoom: 11.5,
      target: LatLng(30.44, 30.4));
  static const kGoogleApiKey = "AIzaSyCExg6JM8XtlBiccaYYssvALQujX9NA3xs";
  Marker _origin;
  Marker _destination;
  Directions _info;
  Location location = new Location();

  @override
  void initState() {

    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        initialCameraPosition = CameraPosition(
            zoom: 11.5,
            target: LatLng(currentLocation.latitude, currentLocation.latitude));
        _origin = Marker(
            markerId: MarkerId('start'),
            position:
            LatLng(currentLocation.latitude, currentLocation.latitude));
      });

      DirectionsRepository();
    });
    setState(() {
      _destination = Marker(
          markerId: MarkerId('Place'),
          position: LatLng(
              double.parse(widget.latitude), double.parse(widget.longitude)));
    });
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(getTransrlate(context, 'LocationSelected'))),
        backgroundColor: theme.getColor(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: initialCameraPosition == null
                ? Custom_Loading()
                : GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: {
                if (_origin != null) _origin,
                if (_destination != null) _destination
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('طريق الى المستفيد'),
                    color: theme.getColor(),
                    width: 5,
                    points: _info.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (controller) =>
              _googleMapController = controller,
            ),
          ),
          if (_info != null)
            Positioned(
              top: 10.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (_origin != null)
                          TextButton(
                            onPressed: () => _googleMapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: _origin.position,
                                  zoom: 14.5,
                                  tilt: 50.0,
                                ),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.green,
                              textStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            child: const Text('مندوب'),
                          ),
                        SizedBox(
                          width: 50,
                        ),
                        if (_destination != null)
                          TextButton(
                            onPressed: () => _googleMapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: _destination.position,
                                  zoom: 14.5,
                                  tilt: 50.0,
                                ),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.blue,
                              textStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            child: const Text('مستفيد'),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'وقت',
                              style: const TextStyle(
                                fontSize: 18.0,
                                //  color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${_info.totalDuration}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                //  color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          children: [
                            Text(
                              'مسافة',
                              style: const TextStyle(
                                fontSize: 18.0,
                                //  color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${_info.totalDistance}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                //  color: Colors.white,

                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 10,
            child: Container(
              margin: EdgeInsets.only(top: 12, bottom: 0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(1.0),
                ),
                color: theme.getColor(),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) => OrderOverlay(donation_id: widget.donation_id,));
                },
                child: Text(
                  "تم الوصول الى المتطوع",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          // CameraUpdate.newCameraPosition(initialCameraPosition)
          _info != null
              ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
              : CameraUpdate.newCameraPosition(initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    location = null;
    super.dispose();
  }

  DirectionsRepository() async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_origin.position.latitude},${_origin.position.longitude}&destination=${_destination.position.latitude},${_destination.position.longitude}&key=$kGoogleApiKey';
    print(url);
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      print(response.body);
      setState(() {
        _info = Directions.fromMap(jsonDecode(response.body));
      });
    } catch (exception, stackTrace) {
      showDialog(
        context: context,
        builder: (_) =>
            ResultOverlay("${getTransrlate(context, 'ConnectionFailed')}"),
      );
    } finally {}
  }

  Future<void> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      initialCameraPosition = CameraPosition(
          zoom: 11.5,
          target: LatLng(_locationData.latitude, _locationData.latitude));
      _origin = Marker(
          markerId: MarkerId('start'),
          position: LatLng(_locationData.latitude, _locationData.latitude));
    });

    DirectionsRepository();
  }


}