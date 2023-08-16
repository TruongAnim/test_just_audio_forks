import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screen/home_screen/home_binding.dart';
import 'screen/home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => HomeScreen(), binding: HomeBinding())
      ],
    );
  }
}
