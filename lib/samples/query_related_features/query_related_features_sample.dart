import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';

import '../../utils/sample_state_support.dart';

class QueryRelatedFeaturesSample extends StatefulWidget {
  const QueryRelatedFeaturesSample({super.key});

  @override
  State<QueryRelatedFeaturesSample> createState() =>
      _QueryRelatedFeaturesSampleState();
}

class _QueryRelatedFeaturesSampleState extends State<QueryRelatedFeaturesSample>
    with SampleStateSupport {
  // Create a controller for the map view.
  final _mapViewController = ArcGISMapView.createController();
  // A flag for when the map view is ready and controls can be used.
  var _ready = false;

  late final FeatureLayer _alaskaNationalParksLayer;
  late final FeatureLayer _alaskaNationalPreservesLayer;
  late final ServiceFeatureTable _alaskaNationalParksSpeciesTable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            ArcGISMapView(
              controllerProvider: () => _mapViewController,
              onMapViewReady: onMapViewReady,
              onTap: onTap,
            ),
            // Display a progress indicator and prevent interaction until state is ready.
            Visibility(
              visible: !_ready,
              child: SizedBox.expand(
                child: Container(
                  color: Colors.white30,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onMapViewReady() async {
    final map = ArcGISMap.withBasemapStyle(BasemapStyle.arcGISTopographic);
    _mapViewController.arcGISMap = map;

    _alaskaNationalParksLayer = FeatureLayer.withFeatureTable(
      ServiceFeatureTable.withUri(
        Uri.parse(
          'https://services2.arcgis.com/ZQgQTuoyBrtmoGdP/ArcGIS/rest/services/AlaskaNationalParksPreservesSpecies_List/FeatureServer/1',
        ),
      ),
    );

    _alaskaNationalPreservesLayer = FeatureLayer.withFeatureTable(
      ServiceFeatureTable.withUri(
        Uri.parse(
          'https://services2.arcgis.com/ZQgQTuoyBrtmoGdP/ArcGIS/rest/services/AlaskaNationalParksPreservesSpecies_List/FeatureServer/0',
        ),
      ),
    );

    _alaskaNationalParksSpeciesTable = ServiceFeatureTable.withUri(
      Uri.parse(
        'https://services2.arcgis.com/ZQgQTuoyBrtmoGdP/ArcGIS/rest/services/AlaskaNationalParksPreservesSpecies_List/FeatureServer/2',
      ),
    );

    map.operationalLayers.addAll([
      _alaskaNationalParksLayer,
      _alaskaNationalPreservesLayer,
    ]);

    map.tables.add(_alaskaNationalParksSpeciesTable);

    // Set the ready state variable to true to enable the sample UI.
    setState(() => _ready = true);
  }

  void onTap(Offset offset) {
    print('Tapped at $offset');
  }
}
