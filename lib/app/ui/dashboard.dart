import 'dart:io';

import 'package:coronavirus_rest_api_flutter/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_flutter/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter/app/ui/endpoint_card.dart';
import 'package:coronavirus_rest_api_flutter/app/ui/last_updated_status_text.dart';
import 'package:coronavirus_rest_api_flutter/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData? _endpointsData;

  @override
  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endpointsData = dataRepository.getAllEndpointsCachedData();
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointData();
      setState(() => _endpointsData = endpointsData);
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connetion Error',
        content: 'Could not retrieve data. Please try again later',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDataFormatter(
      lastUpdated: _endpointsData != null
          ? _endpointsData!.values[Endpoint.cases]?.date
          : null,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Corona virus tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            LastUpdatedStatusText(text: formatter.lastUpdatedStatusText()),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointsData != null
                    ? _endpointsData!.values[endpoint]!.value
                    : null,
              )
          ],
        ),
      ),
    );
  }
}
