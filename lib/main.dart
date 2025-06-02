import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_assignment/controllers/note_controller.dart';
import 'package:notes_app_assignment/pages/home_page.dart';
import 'package:notes_app_assignment/pages/note_edit_screen.dart';
import 'package:notes_app_assignment/service/database_helper.dart';

void main() {
  Get.put(DatabaseService());
  Get.put(NoteController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      initialBinding: BindingsBuilder(() async {
        await Get.putAsync(() => DatabaseService().init());
        Get.put(NoteController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/edit', page: () => NoteEditScreen()),
      ],
    );
  }
}
