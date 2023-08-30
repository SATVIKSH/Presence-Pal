import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart';

import 'package:presence_pal/models/subject_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:presence_pal/models/subject_time_model.dart';
import 'package:presence_pal/views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(SubjectModelAdapter());

  Hive.registerAdapter(SubjectTimeModelAdapter());
  await Hive.openBox<SubjectModel>('subjects');
  await Hive.openBox<SubjectTimeModel>('days');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
