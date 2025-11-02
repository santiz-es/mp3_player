import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/playlist_vm.dart';
import '../models/song.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlaylistViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Playlist MP3')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text('Error: ${vm.error}'))
              : ListView.builder(
                  itemCount: vm.songs.length,
                  itemBuilder: (context, index) {
                    final s = vm.songs[index];
                    return ListTile(
                      title: Text(s.title),
                      subtitle: Text(s.artist),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () => vm.play(s),
                          ),
                          IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: vm.pause,
                          ),
                          IconButton(
                            icon: const Icon(Icons.stop),
                            onPressed: vm.stop,
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
