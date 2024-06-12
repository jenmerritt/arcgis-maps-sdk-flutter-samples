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

import 'dart:io';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/sample_data.dart';

class DisplayMapFromMobileMapPackageSample extends StatefulWidget {
  const DisplayMapFromMobileMapPackageSample({super.key});

  @override
  State<DisplayMapFromMobileMapPackageSample> createState() =>
      _DisplayMapFromMobileMapPackageSampleState();
}

class _DisplayMapFromMobileMapPackageSampleState
    extends State<DisplayMapFromMobileMapPackageSample> {
  final _mapViewController = ArcGISMapView.createController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArcGISMapView(
        controllerProvider: () => _mapViewController,
        onMapViewReady: onMapViewReady,
      ),
    );
  }

  void onMapViewReady() async {
    await downloadSampleData(['e1f3a7254cb845b09450f54937c16061']);
    final appDir = await getApplicationDocumentsDirectory();
    final mmpkFile = File('${appDir.absolute.path}/Yellowstone.mmpk');
    final mmpk = MobileMapPackage.withFileUri(mmpkFile.uri);
    await mmpk.load();
    if (mmpk.maps.isNotEmpty) {
      _mapViewController.arcGISMap = mmpk.maps.first;
    }
  }
}