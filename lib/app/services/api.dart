import 'package:coronavirus_rest_api_flutter/app/services/api_keys.dart';

class API {
  API({required this.apiKey});
  final String apiKey;

  factory API.sandbox() => API(apiKey: APIKeys.ncovSandboxKey);
  static final String host = "ncov2019-admin.fiorebaseapp.com";

  Uri tokenUri() => Uri(
    scheme: 'https',
    host: host,
    path: 'token',
  );
}