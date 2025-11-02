import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/song.dart';

class PlaylistService {
  final String url = 'https://www.rafaelamorim.com.br/mobile2/musicas/list.json';

  Future<List<Song>> fetchPlaylist() async {
    List<Song> songs = [];

    try {
      final resp = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final jsonList = json.decode(resp.body);
        if (jsonList is List) {
          songs = jsonList.map((e) => Song.fromJson(e)).toList();
        } else {
          throw Exception('Formato inesperado (no es lista).');
        }
      } else {
        songs = await _loadFromAssets();
      }
    } catch (e) {
      songs = await _loadFromAssets();
    }

    // 🐣 Easter Egg (si el usuario está cerca del campus)
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return songs;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return songs;
      }

      final pos = await Geolocator.getCurrentPosition();

      // Coordenadas del campus Livramento
      const campusLat = -30.4783;
      const campusLon = -55.7879;

      final distance = Geolocator.distanceBetween(
        pos.latitude, pos.longitude, campusLat, campusLon);

      if (distance <= 80) {
        songs.add(Song(
          id: "999",
          title: 'Nome da Faixa (Faixa 5)',
          artist: 'Os Bilias',
          duration: '03:14',
          url: 'https://www.rafaelamorim.com.br/mobile2/musicas/osbilias-nome-da-faixa-faixa-5.mp3',
        ));
        print('🎶 Easter Egg activado: Os Bilias - Nome da Faixa');
      }
    } catch (e) {
      print('No se pudo verificar ubicación: $e');
    }

    return songs;
  }

  Future<List<Song>> _loadFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/musicas.json');
    final data = json.decode(jsonString) as List<dynamic>;
    return data.map((e) => Song.fromJson(e)).toList();
  }
}
