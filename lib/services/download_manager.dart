import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DownloadRecord {
  int? id;
  String songId;
  String url;
  String filePath;
  int downloaded;
  int total;
  String status; // pending, downloading, paused, completed, error

  DownloadRecord({
    this.id,
    required this.songId,
    required this.url,
    required this.filePath,
    this.downloaded = 0,
    this.total = -1,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'songId': songId,
    'url': url,
    'filePath': filePath,
    'downloaded': downloaded,
    'total': total,
    'status': status,
  };

  static DownloadRecord fromMap(Map<String, dynamic> m) => DownloadRecord(
    id: m['id'],
    songId: m['songId'],
    url: m['url'],
    filePath: m['filePath'],
    downloaded: m['downloaded'],
    total: m['total'],
    status: m['status'],
  );
}

class DownloadManager {
  static final DownloadManager instance = DownloadManager._();
  DownloadManager._();

  late Database _db;
  bool _initialized = false;
  final _dio = Dio();
  final Map<String, StreamController<DownloadRecord>> _controllers = {};

  Future<void> init() async {
    if (_initialized) return;
    final documents = await getApplicationDocumentsDirectory();
    final dbPath = p.join(documents.path, 'downloads.db');
    _db = await openDatabase(dbPath, version: 1, onCreate: (db, v) {
      return db.execute('''
        CREATE TABLE downloads (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          songId TEXT,
          url TEXT,
          filePath TEXT,
          downloaded INTEGER,
          total INTEGER,
          status TEXT
        );
      ''');
    });
    _initialized = true;
  }

  Stream<DownloadRecord> controllerFor(String songId) {
    _controllers[songId] ??= StreamController.broadcast();
    // seed with existing record if any
    _getRecordBySongId(songId).then((r) {
      if (r != null) _controllers[songId]!.add(r);
    });
    return _controllers[songId]!.stream;
  }

  Future<DownloadRecord?> _getRecordBySongId(String songId) async {
    final l = await _db.query('downloads', where: 'songId = ?', whereArgs: [songId]);
    if (l.isEmpty) return null;
    return DownloadRecord.fromMap(l.first);
  }

  Future<List<DownloadRecord>> allRecords() async {
    final rows = await _db.query('downloads');
    return rows.map((r) => DownloadRecord.fromMap(r)).toList();
  }

  Future<void> _upsertRecord(DownloadRecord r) async {
    if (r.id == null) {
      r.id = await _db.insert('downloads', r.toMap());
    } else {
      await _db.update('downloads', r.toMap(), where: 'id = ?', whereArgs: [r.id]);
    }
    _controllers[r.songId]?.add(r);
  }

  Future<String> _localFilePathFor(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, fileName);
  }

  Future<void> startDownload(String songId, String url, {String? fileName}) async {
    await init();
    final safeName = fileName ?? p.basename(Uri.parse(url).path);
    final path = await _localFilePathFor(safeName);
    var rec = await _getRecordBySongId(songId);
    if (rec == null) {
      rec = DownloadRecord(songId: songId, url: url, filePath: path, downloaded: 0, total: -1, status: 'pending');
      await _upsertRecord(rec);
    }

    rec.status = 'downloading';
    await _upsertRecord(rec);

    final file = File(path);
    int downloaded = 0;
    if (await file.exists()) downloaded = await file.length();

    final headers = downloaded > 0 ? {'range': 'bytes=$downloaded-'} : null;
    Response<ResponseBody> response;
    try {
      response = await _dio.get<ResponseBody>(
        url,
        options: Options(
          headers: headers,
          responseType: ResponseType.stream,
          followRedirects: true,
        ),
      );
    } catch (e) {
      rec.status = 'error';
      await _upsertRecord(rec);
      rethrow;
    }

    final totalHeader = response.headers.value(HttpHeaders.contentLengthHeader);
    final total = totalHeader != null ? (downloaded + int.parse(totalHeader)) : -1;
    rec.total = total;
    rec.downloaded = downloaded;
    await _upsertRecord(rec);

    final raf = file.openSync(mode: FileMode.append);
    try {
      await for (final chunk in response.data!.stream) {
        raf.writeFromSync(chunk);
        downloaded += chunk.length;
        rec.downloaded = downloaded;
        rec.status = 'downloading';
        await _upsertRecord(rec);
      }
      await raf.close();
      rec.downloaded = total != -1 ? total : downloaded;
      rec.status = 'completed';
      await _upsertRecord(rec);
    } catch (e) {
      await raf.close();
      rec.status = 'error';
      await _upsertRecord(rec);
      rethrow;
    }
  }

  Future<void> pauseDownload(String songId) async {
    // Our simple implementation: set status to paused; the running Dio request will still run unless you cancel tokens.
    // For real cancel: store CancelToken per task and call cancel.
    final rec = await _getRecordBySongId(songId);
    if (rec != null) {
      rec.status = 'paused';
      await _upsertRecord(rec);
    }
  }

  Future<String?> localFileFor(String songId) async {
    final rec = await _getRecordBySongId(songId);
    if (rec == null) return null;
    final f = File(rec.filePath);
    if (await f.exists()) return rec.filePath;
    return null;
  }
}
