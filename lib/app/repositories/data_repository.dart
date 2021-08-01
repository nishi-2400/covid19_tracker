import 'package:coronavirus_rest_api_flutter/app/repositories/endpoint_data.dart';
import 'package:coronavirus_rest_api_flutter/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter/app/services/api_service.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({required this.apiService});

  final APIService apiService;
  String? _accessToken;

  Future<int> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<int>(
          onGetData: () => apiService.getEndpointData(
              accessToken: _accessToken!, endpoint: endpoint));

  Future<EndpointData> getAllEndpointData() async =>
      await _getDataRefreshingToken<EndpointData>(
          onGetData: _getAllEndpointData);

  Future<T> _getDataRefreshingToken<T>(
      {required Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return onGetData();
    } on Response catch (response) {
      // アクセストークンが切れていたら再度取得する
      if (response.statusCode == 401) {
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<EndpointData> _getAllEndpointData() async {
    final values = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.cases),
      apiService.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.recovered)
    ]);

    return EndpointData(
      {
        Endpoint.cases: values[0],
        Endpoint.casesSuspected: values[1],
        Endpoint.casesConfirmed: values[2],
        Endpoint.deaths: values[3],
        Endpoint.recovered: values[4],
      },
    );
  }
}
