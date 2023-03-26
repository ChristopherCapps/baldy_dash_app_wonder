import 'package:flutter/foundation.dart';
import 'package:baldy_dash_app/utils/json_prefs_file.dart';
import 'package:baldy_dash_app/utils/throttler.dart';

mixin FilePersistenceMixin {
  late final _file = JsonPrefsFile(fileName);
  final _throttle = Throttler(const Duration(seconds: 2));

  Future<void> load() async {
    debugPrint("loading ${_file.name}");
    final results = await _file.load();
    try {
      fromJson(results);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> save() async {
    debugPrint('saving ${_file.name}');
    try {
      await _file.save(toJson());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> scheduleSave() async => _throttle.call(save);

  /// Serialization
  String get fileName;
  Map<String, dynamic> toJson();
  void fromJson(Map<String, dynamic> map);
}
