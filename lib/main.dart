import 'package:coronavirus_rest_api_flutter/app/repositories/data_repository.dart';
import 'package:coronavirus_rest_api_flutter/app/services/api.dart';
import 'package:coronavirus_rest_api_flutter/app/services/api_service.dart';
import 'package:coronavirus_rest_api_flutter/app/services/data_cache_service.dart';
import 'package:coronavirus_rest_api_flutter/app/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'ja_JP';
  await initializeDateFormatting();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
        apiService: APIService(API.sandbox()),
        dataCacheService: DataCacheService(
          sharedPreferences: sharedPreferences,
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Corona Virus Tracker',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF101010),
          cardColor: Color(0xFF222222),
        ),
        home: Dashboard(),
      ),
    );
  }
}
