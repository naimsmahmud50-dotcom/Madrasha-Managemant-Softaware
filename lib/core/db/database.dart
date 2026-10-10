import 'package:drift/drift.dart';
part 'database.g.dart';

// PHASE 1 REQUIREMENT: Local SQLite Table Schema for Outbox Pattern
class LocalAttendance extends Table {
  TextColumn get id => text()();
  TextColumn get madrasahId => text()();
  TextColumn get studentId => text()();
  TextColumn get status => text()(); // PRESENT, ABSENT, LATE
  DateTimeColumn get date => dateTime()();
  
  // State machine values: LOCAL_ONLY -> PENDING -> SYNCING -> SYNCED / CONFLICT
  TextColumn get syncStatus => text()(); 
  
  TextColumn get syncId => text()(); // Stable UUID idempotency key
  DateTimeColumn get markedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// NOTE: To generate the database code, run: flutter pub run build_runner build
@DriftDatabase(tables: [LocalAttendance])
class AppDatabase extends _$AppDatabase {
  // In a real app, this connects to the actual SQLite database file using path_provider
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}

