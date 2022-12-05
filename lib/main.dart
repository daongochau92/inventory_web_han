import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_web/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Web',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
