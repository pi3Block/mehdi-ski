import 'package:drift/web.dart';
import 'package:les_mehdi_font_du_ski/database/database.dart';

///Create database
MehdiSkiDatabase constructDb() {
  return MehdiSkiDatabase(
    WebDatabase.withStorage(
      DriftWebStorage.indexedDb(
        'db',
        migrateFromLocalStorage: false,
      ),
    ),
  );
}
