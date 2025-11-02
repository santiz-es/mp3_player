import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import '../models/song.dart';

class PlayerService {
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<Duration>? _bufferSub;
  StreamSubscription<PlayerState>? _stateSub;

  Future<void> init() async {
    // Configura la sesión de audio
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Inicializa el servicio en segundo plano
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.example.mp3player.audio',
      androidNotificationChannelName: 'Reproducción de audio',
      androidNotificationOngoing: true,
    );
  }

  Future<void> playSong(Song song) async {
    final mediaItem = MediaItem(
      id: song.id,
      album: 'Playlist',
      title: song.title,
      artist: song.artist,
    );

    final source = AudioSource.uri(Uri.parse(song.url), tag: mediaItem);
    await _player.setAudioSource(source);
    await _player.play();

    // Inicia el monitoreo del buffer
    startBufferMonitoring();
  }

  Future<void> pause() async => _player.pause();
  Future<void> stop() async => _player.stop();

  void startBufferMonitoring() {
    // Cancela streams previos para evitar duplicados
    _bufferSub?.cancel();
    _stateSub?.cancel();

    _bufferSub = _player.bufferedPositionStream.listen((buffered) async {
      final pos = await _player.position;
      final gap = buffered - pos;

      if (gap < const Duration(seconds: 1) && _player.playing) {
        // Si el buffer se vacía, pausa automáticamente
        await _player.pause();
        print('🔴 Auto-paused (buffer underrun)');
      } else if (gap > const Duration(seconds: 3) && !_player.playing) {
        // Si vuelve a haber suficiente buffer, reanuda
        await _player.play();
        print('🟢 Auto-resumed playback');
      }
    });

    _stateSub = _player.playerStateStream.listen((state) {
      print('Estado del reproductor: ${state.processingState}');
    });
  }

  void dispose() {
    _bufferSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
  }
}
