import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:setup/app/modules/home/views/home_view.dart';

import 'app/routes/app_pages.dart';

var box;

Future<void> main() async {
  await Hive.initFlutter().then((value) async {
    await Hive.openBox('myBox').then((value) => box = Hive.box('myBox'));
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Animals',
      initialRoute: AppPages.INITIAL,
      // initialBinding: GlobalBindings(),
      transitionDuration: const Duration(milliseconds: 500),
      defaultTransition: Transition.rightToLeft,
      getPages: AppPages.routes,
      home: HomeView(),
    );

    // MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   home: const HomeView());
  }
}

//Usage off HIVE And API Calls
// Future<void> getCategoryChain() async {
//
//   List<dynamic> temp = await ApiRepo().getCategoryChain();
//
//   await box.put('categoryChain', temp);
//
//   categoryChain.assignAll(await box.get('categoryChain'));
// }
