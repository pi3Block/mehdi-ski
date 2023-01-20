import '/database/database.dart';
import 'package:drift/web.dart';

///Create database
MehdiSkiGameDatabase constructDb() {
  return MehdiSkiGameDatabase(
    WebDatabase.withStorage(
      DriftWebStorage.indexedDb(
        'db',
        migrateFromLocalStorage: false,
      ),
    ),
  );
}
