import 'package:dsanotes/providers/audio_provider.dart';
import 'package:dsanotes/services/audio_service.dart';
import 'package:dsanotes/services/database_service.dart';
import 'package:dsanotes/services/hive_adapters/notes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'di/di.dart';
import 'features/DSA NOTES/view/screens/notes.dart';

void main() async {
  await configureDependencies();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter()); // Register the NotesAdapter
  await GetIt.I<DataBaseService>().openBox('sound_box');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AudioProvider(
              GetIt.I<AudioService>(), GetIt.I<DataBaseService>()),
        )
      ],
      child: MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        home: const NotesView(),
      ),
    );
  }
}
