//
// Copyright 2024 Esri
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';

import '../../utils/sample_state_support.dart';

class ApplyUniqueValueRendererSample extends StatefulWidget {
  const ApplyUniqueValueRendererSample({super.key});

  @override
  State<ApplyUniqueValueRendererSample> createState() =>
      _ApplyUniqueValueRendererSampleState();
}

class _ApplyUniqueValueRendererSampleState
    extends State<ApplyUniqueValueRendererSample> with SampleStateSupport {
  // create a controller for the map view.
  final _mapViewController = ArcGISMapView.createController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // add a map view to the widget tree and set a controller.
      body: ArcGISMapView(
        controllerProvider: () => _mapViewController,
        onMapViewReady: onMapViewReady,
      ),
    );
  }

  void onMapViewReady() {
    // create a map with a Basemap style and an initial viewpoint.
    final map = ArcGISMap.withBasemapStyle(BasemapStyle.arcGISTopographic);
    map.initialViewpoint = Viewpoint.fromCenter(
      ArcGISPoint(x: -12356253.6, y: 3842795.4),
      scale: 52681563.2,
    );

    // create a feature layer from a service feature table
    // and set a unique value renderer.
    final uri = Uri.parse(
        'https://sampleserver6.arcgisonline.com/arcgis/rest/services/Census/MapServer/3');
    final serviceFeatureTable = ServiceFeatureTable.withUri(uri);
    final featureLayer = FeatureLayer.withFeatureTable(serviceFeatureTable);
    featureLayer.renderer = _configureUniqueValueRenderer();

    // add the feature layer to the map.
    map.operationalLayers.add(featureLayer);
    // set the map to the MapViewController.
    _mapViewController.arcGISMap = map;
  }

  /// Configure a unique value renderer.
  Renderer? _configureUniqueValueRenderer() {
    final stateOutlineSymbol = SimpleLineSymbol(
        style: SimpleLineSymbolStyle.solid, color: Colors.white, width: 0.7);

    // create fill symbols for each region.
    final pacificFillSymbol = SimpleFillSymbol(
        style: SimpleFillSymbolStyle.solid,
        color: const Color.fromARGB(255, 0, 0, 255),
        outline: stateOutlineSymbol);
    final mountainFillSymbol = SimpleFillSymbol(
        style: SimpleFillSymbolStyle.solid,
        color: const Color.fromARGB(255, 0, 255, 0),
        outline: stateOutlineSymbol);
    final westSouthCentralFillSymbol = SimpleFillSymbol(
        style: SimpleFillSymbolStyle.solid,
        color: const Color.fromARGB(255, 250, 125, 0),
        outline: stateOutlineSymbol);

    // create unique values for each region.
    final pacificValue = UniqueValue(
        description: 'Pacific Region',
        label: 'Pacific',
        symbol: pacificFillSymbol,
        values: ['Pacific']);
    final mountainValue = UniqueValue(
        description: 'Rocky Mountain Region',
        label: 'Mountain',
        symbol: mountainFillSymbol,
        values: ['Mountain']);
    final westSouthCentralValue = UniqueValue(
        description: 'West South Central Region',
        label: 'West South Central',
        symbol: westSouthCentralFillSymbol,
        values: ['West South Central']);

    final defaultFillSymbol = SimpleFillSymbol(
        style: SimpleFillSymbolStyle.cross, color: Colors.grey, outline: null);

    // create a unique value renderer with the unique values.
    return UniqueValueRenderer(
      fieldNames: ['SUB_REGION'],
      uniqueValues: [
        pacificValue,
        mountainValue,
        westSouthCentralValue,
      ],
      defaultLabel: 'Other',
      defaultSymbol: defaultFillSymbol,
    );
  }
}
