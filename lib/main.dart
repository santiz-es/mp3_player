import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'services/playlist_service.dart';
import 'services/player_service.dart';
import 'viewmodels/playlist_vm.dart';
import 'views/playlist_page.dart';

Future<void> main() async {
 
  WidgetsFlutterBinding.ensureInitialized();


  await FlutterDownloader.initialize(
    debug: true, 
    ignoreSsl: true, 
  );


  final playerService = PlayerService();
  await playerService.init();

 
  runApp(MyApp(playerService: playerService));
}

class MyApp extends StatelessWidget {
  final PlayerService playerService;
  const MyApp({super.key, required this.playerService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => PlaylistService()),
        ChangeNotifierProvider(
          create: (context) => PlaylistViewModel(
            playlistService: context.read<PlaylistService>(),
            playerService: playerService,
          )..loadPlaylist(),
        ),
      ],
      child: MaterialApp(
        title: 'MP3 Player 🎵',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
        ),
        home: const PlaylistPage(),
      ),
    );
  }
}
