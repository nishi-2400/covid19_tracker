import 'package:coronavirus_rest_api_flutter/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_flutter/app/repositories/endpoint_data.dart';
import 'package:coronavirus_rest_api_flutter/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter/app/ui/endpoint_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointData? _endpointData;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final endpointData = await dataRepository.getAllEndpointData();
    setState(() => _endpointData = endpointData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Corona virus tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointData != null
                    ? _endpointData!.values[endpoint]
                    : null,
              )
          ],
        ),
      ),
    );
  }
}
