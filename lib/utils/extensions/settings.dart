import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';

mixin WithSettings {
  Settings _settings = isar.settings.first;

  Settings get settings => _settings;

  set settings(Settings value) {
    _settings = value;

    isar.writeTxnSync(() {
      isar.settings.putSync(value);
    });
  }
}

extension Singletone on IsarCollection<Settings> {
  Settings get first => getSync(227) ?? Settings(id: 227);

  set first(Settings value) {
    isar.writeTxnSync(() {
      isar.settings.putSync(value);
    });
  }
}