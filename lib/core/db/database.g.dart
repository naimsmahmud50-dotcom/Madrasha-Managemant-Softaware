// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalAttendanceTable extends LocalAttendance
    with TableInfo<$LocalAttendanceTable, LocalAttendanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _madrasahIdMeta = const VerificationMeta(
    'madrasahId',
  );
  @override
  late final GeneratedColumn<String> madrasahId = GeneratedColumn<String>(
    'madrasah_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _markedAtMeta = const VerificationMeta(
    'markedAt',
  );
  @override
  late final GeneratedColumn<DateTime> markedAt = GeneratedColumn<DateTime>(
    'marked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    madrasahId,
    studentId,
    status,
    date,
    syncStatus,
    syncId,
    markedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_attendance';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAttendanceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('madrasah_id')) {
      context.handle(
        _madrasahIdMeta,
        madrasahId.isAcceptableOrUnknown(data['madrasah_id']!, _madrasahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_madrasahIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    } else if (isInserting) {
      context.missing(_syncIdMeta);
    }
    if (data.containsKey('marked_at')) {
      context.handle(
        _markedAtMeta,
        markedAt.isAcceptableOrUnknown(data['marked_at']!, _markedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_markedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAttendanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAttendanceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      madrasahId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}madrasah_id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      markedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}marked_at'],
      )!,
    );
  }

  @override
  $LocalAttendanceTable createAlias(String alias) {
    return $LocalAttendanceTable(attachedDatabase, alias);
  }
}

class LocalAttendanceData extends DataClass
    implements Insertable<LocalAttendanceData> {
  final String id;
  final String madrasahId;
  final String studentId;
  final String status;
  final DateTime date;
  final String syncStatus;
  final String syncId;
  final DateTime markedAt;
  const LocalAttendanceData({
    required this.id,
    required this.madrasahId,
    required this.studentId,
    required this.status,
    required this.date,
    required this.syncStatus,
    required this.syncId,
    required this.markedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['madrasah_id'] = Variable<String>(madrasahId);
    map['student_id'] = Variable<String>(studentId);
    map['status'] = Variable<String>(status);
    map['date'] = Variable<DateTime>(date);
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_id'] = Variable<String>(syncId);
    map['marked_at'] = Variable<DateTime>(markedAt);
    return map;
  }

  LocalAttendanceCompanion toCompanion(bool nullToAbsent) {
    return LocalAttendanceCompanion(
      id: Value(id),
      madrasahId: Value(madrasahId),
      studentId: Value(studentId),
      status: Value(status),
      date: Value(date),
      syncStatus: Value(syncStatus),
      syncId: Value(syncId),
      markedAt: Value(markedAt),
    );
  }

  factory LocalAttendanceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAttendanceData(
      id: serializer.fromJson<String>(json['id']),
      madrasahId: serializer.fromJson<String>(json['madrasahId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      status: serializer.fromJson<String>(json['status']),
      date: serializer.fromJson<DateTime>(json['date']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncId: serializer.fromJson<String>(json['syncId']),
      markedAt: serializer.fromJson<DateTime>(json['markedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'madrasahId': serializer.toJson<String>(madrasahId),
      'studentId': serializer.toJson<String>(studentId),
      'status': serializer.toJson<String>(status),
      'date': serializer.toJson<DateTime>(date),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncId': serializer.toJson<String>(syncId),
      'markedAt': serializer.toJson<DateTime>(markedAt),
    };
  }

  LocalAttendanceData copyWith({
    String? id,
    String? madrasahId,
    String? studentId,
    String? status,
    DateTime? date,
    String? syncStatus,
    String? syncId,
    DateTime? markedAt,
  }) => LocalAttendanceData(
    id: id ?? this.id,
    madrasahId: madrasahId ?? this.madrasahId,
    studentId: studentId ?? this.studentId,
    status: status ?? this.status,
    date: date ?? this.date,
    syncStatus: syncStatus ?? this.syncStatus,
    syncId: syncId ?? this.syncId,
    markedAt: markedAt ?? this.markedAt,
  );
  LocalAttendanceData copyWithCompanion(LocalAttendanceCompanion data) {
    return LocalAttendanceData(
      id: data.id.present ? data.id.value : this.id,
      madrasahId: data.madrasahId.present
          ? data.madrasahId.value
          : this.madrasahId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      status: data.status.present ? data.status.value : this.status,
      date: data.date.present ? data.date.value : this.date,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      markedAt: data.markedAt.present ? data.markedAt.value : this.markedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAttendanceData(')
          ..write('id: $id, ')
          ..write('madrasahId: $madrasahId, ')
          ..write('studentId: $studentId, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncId: $syncId, ')
          ..write('markedAt: $markedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    madrasahId,
    studentId,
    status,
    date,
    syncStatus,
    syncId,
    markedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAttendanceData &&
          other.id == this.id &&
          other.madrasahId == this.madrasahId &&
          other.studentId == this.studentId &&
          other.status == this.status &&
          other.date == this.date &&
          other.syncStatus == this.syncStatus &&
          other.syncId == this.syncId &&
          other.markedAt == this.markedAt);
}

class LocalAttendanceCompanion extends UpdateCompanion<LocalAttendanceData> {
  final Value<String> id;
  final Value<String> madrasahId;
  final Value<String> studentId;
  final Value<String> status;
  final Value<DateTime> date;
  final Value<String> syncStatus;
  final Value<String> syncId;
  final Value<DateTime> markedAt;
  final Value<int> rowid;
  const LocalAttendanceCompanion({
    this.id = const Value.absent(),
    this.madrasahId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncId = const Value.absent(),
    this.markedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAttendanceCompanion.insert({
    required String id,
    required String madrasahId,
    required String studentId,
    required String status,
    required DateTime date,
    required String syncStatus,
    required String syncId,
    required DateTime markedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       madrasahId = Value(madrasahId),
       studentId = Value(studentId),
       status = Value(status),
       date = Value(date),
       syncStatus = Value(syncStatus),
       syncId = Value(syncId),
       markedAt = Value(markedAt);
  static Insertable<LocalAttendanceData> custom({
    Expression<String>? id,
    Expression<String>? madrasahId,
    Expression<String>? studentId,
    Expression<String>? status,
    Expression<DateTime>? date,
    Expression<String>? syncStatus,
    Expression<String>? syncId,
    Expression<DateTime>? markedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (madrasahId != null) 'madrasah_id': madrasahId,
      if (studentId != null) 'student_id': studentId,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncId != null) 'sync_id': syncId,
      if (markedAt != null) 'marked_at': markedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAttendanceCompanion copyWith({
    Value<String>? id,
    Value<String>? madrasahId,
    Value<String>? studentId,
    Value<String>? status,
    Value<DateTime>? date,
    Value<String>? syncStatus,
    Value<String>? syncId,
    Value<DateTime>? markedAt,
    Value<int>? rowid,
  }) {
    return LocalAttendanceCompanion(
      id: id ?? this.id,
      madrasahId: madrasahId ?? this.madrasahId,
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
      date: date ?? this.date,
      syncStatus: syncStatus ?? this.syncStatus,
      syncId: syncId ?? this.syncId,
      markedAt: markedAt ?? this.markedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (madrasahId.present) {
      map['madrasah_id'] = Variable<String>(madrasahId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (markedAt.present) {
      map['marked_at'] = Variable<DateTime>(markedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAttendanceCompanion(')
          ..write('id: $id, ')
          ..write('madrasahId: $madrasahId, ')
          ..write('studentId: $studentId, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncId: $syncId, ')
          ..write('markedAt: $markedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalAttendanceTable localAttendance = $LocalAttendanceTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [localAttendance];
}

typedef $$LocalAttendanceTableCreateCompanionBuilder =
    LocalAttendanceCompanion Function({
      required String id,
      required String madrasahId,
      required String studentId,
      required String status,
      required DateTime date,
      required String syncStatus,
      required String syncId,
      required DateTime markedAt,
      Value<int> rowid,
    });
typedef $$LocalAttendanceTableUpdateCompanionBuilder =
    LocalAttendanceCompanion Function({
      Value<String> id,
      Value<String> madrasahId,
      Value<String> studentId,
      Value<String> status,
      Value<DateTime> date,
      Value<String> syncStatus,
      Value<String> syncId,
      Value<DateTime> markedAt,
      Value<int> rowid,
    });

class $$LocalAttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $LocalAttendanceTable> {
  $$LocalAttendanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get madrasahId => $composableBuilder(
    column: $table.madrasahId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get markedAt => $composableBuilder(
    column: $table.markedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalAttendanceTable> {
  $$LocalAttendanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get madrasahId => $composableBuilder(
    column: $table.madrasahId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get markedAt => $composableBuilder(
    column: $table.markedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalAttendanceTable> {
  $$LocalAttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get madrasahId => $composableBuilder(
    column: $table.madrasahId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get markedAt =>
      $composableBuilder(column: $table.markedAt, builder: (column) => column);
}

class $$LocalAttendanceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalAttendanceTable,
          LocalAttendanceData,
          $$LocalAttendanceTableFilterComposer,
          $$LocalAttendanceTableOrderingComposer,
          $$LocalAttendanceTableAnnotationComposer,
          $$LocalAttendanceTableCreateCompanionBuilder,
          $$LocalAttendanceTableUpdateCompanionBuilder,
          (
            LocalAttendanceData,
            BaseReferences<
              _$AppDatabase,
              $LocalAttendanceTable,
              LocalAttendanceData
            >,
          ),
          LocalAttendanceData,
          PrefetchHooks Function()
        > {
  $$LocalAttendanceTableTableManager(
    _$AppDatabase db,
    $LocalAttendanceTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> madrasahId = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncId = const Value.absent(),
                Value<DateTime> markedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAttendanceCompanion(
                id: id,
                madrasahId: madrasahId,
                studentId: studentId,
                status: status,
                date: date,
                syncStatus: syncStatus,
                syncId: syncId,
                markedAt: markedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String madrasahId,
                required String studentId,
                required String status,
                required DateTime date,
                required String syncStatus,
                required String syncId,
                required DateTime markedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalAttendanceCompanion.insert(
                id: id,
                madrasahId: madrasahId,
                studentId: studentId,
                status: status,
                date: date,
                syncStatus: syncStatus,
                syncId: syncId,
                markedAt: markedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalAttendanceTable, LocalAttendanceData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalAttendanceTable,
                    LocalAttendanceData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAttendanceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalAttendanceTable,
      LocalAttendanceData,
      $$LocalAttendanceTableFilterComposer,
      $$LocalAttendanceTableOrderingComposer,
      $$LocalAttendanceTableAnnotationComposer,
      $$LocalAttendanceTableCreateCompanionBuilder,
      $$LocalAttendanceTableUpdateCompanionBuilder,
      (
        LocalAttendanceData,
        BaseReferences<
          _$AppDatabase,
          $LocalAttendanceTable,
          LocalAttendanceData
        >,
      ),
      LocalAttendanceData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalAttendanceTableTableManager get localAttendance =>
      $$LocalAttendanceTableTableManager(_db, _db.localAttendance);
}

