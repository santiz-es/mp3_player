import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/playlist_service.dart';
import '../services/player_service.dart';

class PlaylistViewModel extends ChangeNotifier {
  final PlaylistService playlistService;
  final PlayerService playerService;

  List<Song> songs = [];
  bool loading = false;
  String? error;

  PlaylistViewModel({
    required this.playlistService,
    required this.playerService,
  });

  Future<void> loadPlaylist() async {
    loading = true;
    notifyListeners();
    try {
      songs = await playlistService.fetchPlaylist();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> play(Song song) async {
    await playerService.playSong(song);
  }

  Future<void> pause() async {
    await playerService.pause();
  }

  Future<void> stop() async {
    await playerService.stop();
  }
}
