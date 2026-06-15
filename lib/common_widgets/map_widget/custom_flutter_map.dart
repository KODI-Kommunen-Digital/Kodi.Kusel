import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class CustomFlutterMap extends ConsumerStatefulWidget {
  final double? latitude;
  final double? longitude;
  final double height;
  final double width;
  final double initialZoom;
  final Function() onMapTap;
  final List<Marker> markersList;

  const CustomFlutterMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.height,
    required this.width,
    required this.initialZoom,
    required this.onMapTap,
    required this.markersList,
  });

  @override
  ConsumerState<CustomFlutterMap> createState() => _CustomFlutterMapState();
}

class _CustomFlutterMapState extends ConsumerState<CustomFlutterMap> {
  late final MapController _mapController;
  double _currentRotation = 0;
  bool _isMapReady = false;

  static const double _defaultLat = 49.5400;
  static const double _defaultLng = 7.4000;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _initializeMap();

    _mapController.mapEventStream.listen((event) {
      if (mounted) {
        setState(() {
          _currentRotation = _mapController.camera.rotation;
        });
      }
    });
  }

  Future<void> _initializeMap() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _isMapReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = widget.latitude ?? _defaultLat;
    final lng = widget.longitude ?? _defaultLng;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child:
          _isMapReady ? _customMapWidget(lat, lng) : _buildLoadingPlaceholder(),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Loading map...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customMapWidget(double lat, double lng) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        onTap: (tapPosition, latLong) => widget.onMapTap(),
        initialCenter: LatLng(lat, lng),
        initialZoom: widget.initialZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.flingAnimation |
              InteractiveFlag.doubleTapZoom |
              InteractiveFlag.scrollWheelZoom,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "de.landkreiskusel.app",
          tileProvider: ImprovedNetworkTileProvider(),
          keepBuffer: 3,
          panBuffer: 1,
          errorTileCallback: (tile, error, stackTrace) {
            debugPrint('Tile load error: ${tile.coordinates} - $error');
          },
          maxNativeZoom: 19,
          maxZoom: 19,
          minZoom: 2,
          tileSize: 256,
          retinaMode: false,
        ),
        MarkerLayer(
          markers: widget.markersList,
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant CustomFlutterMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isMapReady) return;

    final oldLat = oldWidget.latitude ?? _defaultLat;
    final oldLng = oldWidget.longitude ?? _defaultLng;
    final newLat = widget.latitude ?? _defaultLat;
    final newLng = widget.longitude ?? _defaultLng;

    final oldLatLng = LatLng(oldLat, oldLng);
    final newLatLng = LatLng(newLat, newLng);

    if (oldLatLng != newLatLng) {
      _mapController.move(newLatLng, widget.initialZoom);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

class ImprovedNetworkTileProvider extends TileProvider {
  ImprovedNetworkTileProvider() : super();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final url = getTileUrl(coordinates, options);

    return NetworkImage(
      url,
      headers: {
        'User-Agent': 'de.landkreiskusel.app',
      },
    );
  }
}
