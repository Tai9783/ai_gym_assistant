// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSessionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [id, startedAt, endedAt, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSessionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSessionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSessionRecord extends DataClass
    implements Insertable<WorkoutSessionRecord> {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  const WorkoutSessionRecord({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
    );
  }

  factory WorkoutSessionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionRecord(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(status),
    };
  }

  WorkoutSessionRecord copyWith({
    String? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
  }) => WorkoutSessionRecord(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
  );
  WorkoutSessionRecord copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSessionRecord(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionRecord(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionRecord &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSessionRecord> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> status;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<WorkoutSessionRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExerciseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, exerciseId, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExerciseRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExerciseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExerciseRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutExerciseRecord extends DataClass
    implements Insertable<WorkoutExerciseRecord> {
  final String id;
  final String sessionId;
  final String exerciseId;
  final int order;
  const WorkoutExerciseRecord({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order'] = Variable<int>(order);
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      order: Value(order),
    );
  }

  factory WorkoutExerciseRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExerciseRecord(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'order': serializer.toJson<int>(order),
    };
  }

  WorkoutExerciseRecord copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    int? order,
  }) => WorkoutExerciseRecord(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    order: order ?? this.order,
  );
  WorkoutExerciseRecord copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExerciseRecord(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseRecord(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, exerciseId, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExerciseRecord &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.order == this.order);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExerciseRecord> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> exerciseId;
  final Value<int> order;
  final Value<int> rowid;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int order,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       order = Value(order);
  static Insertable<WorkoutExerciseRecord> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? exerciseId,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseSetsTable extends ExerciseSets
    with TableInfo<$ExerciseSetsTable, ExerciseSetRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutExerciseIdMeta = const VerificationMeta(
    'workoutExerciseId',
  );
  @override
  late final GeneratedColumn<String> workoutExerciseId =
      GeneratedColumn<String>(
        'workout_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_exercises (id)',
        ),
      );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suggestedWeightMeta = const VerificationMeta(
    'suggestedWeight',
  );
  @override
  late final GeneratedColumn<double> suggestedWeight = GeneratedColumn<double>(
    'suggested_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suggestedRepsMeta = const VerificationMeta(
    'suggestedReps',
  );
  @override
  late final GeneratedColumn<int> suggestedReps = GeneratedColumn<int>(
    'suggested_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualWeightMeta = const VerificationMeta(
    'actualWeight',
  );
  @override
  late final GeneratedColumn<double> actualWeight = GeneratedColumn<double>(
    'actual_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualRepsMeta = const VerificationMeta(
    'actualReps',
  );
  @override
  late final GeneratedColumn<int> actualReps = GeneratedColumn<int>(
    'actual_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutExerciseId,
    setNumber,
    suggestedWeight,
    suggestedReps,
    actualWeight,
    actualReps,
    status,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseSetRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_exercise_id')) {
      context.handle(
        _workoutExerciseIdMeta,
        workoutExerciseId.isAcceptableOrUnknown(
          data['workout_exercise_id']!,
          _workoutExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('suggested_weight')) {
      context.handle(
        _suggestedWeightMeta,
        suggestedWeight.isAcceptableOrUnknown(
          data['suggested_weight']!,
          _suggestedWeightMeta,
        ),
      );
    }
    if (data.containsKey('suggested_reps')) {
      context.handle(
        _suggestedRepsMeta,
        suggestedReps.isAcceptableOrUnknown(
          data['suggested_reps']!,
          _suggestedRepsMeta,
        ),
      );
    }
    if (data.containsKey('actual_weight')) {
      context.handle(
        _actualWeightMeta,
        actualWeight.isAcceptableOrUnknown(
          data['actual_weight']!,
          _actualWeightMeta,
        ),
      );
    }
    if (data.containsKey('actual_reps')) {
      context.handle(
        _actualRepsMeta,
        actualReps.isAcceptableOrUnknown(data['actual_reps']!, _actualRepsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseSetRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseSetRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      suggestedWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}suggested_weight'],
      ),
      suggestedReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}suggested_reps'],
      ),
      actualWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_weight'],
      ),
      actualReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_reps'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ExerciseSetsTable createAlias(String alias) {
    return $ExerciseSetsTable(attachedDatabase, alias);
  }
}

class ExerciseSetRecord extends DataClass
    implements Insertable<ExerciseSetRecord> {
  final String id;
  final String workoutExerciseId;
  final int setNumber;
  final double? suggestedWeight;
  final int? suggestedReps;
  final double? actualWeight;
  final int? actualReps;
  final String status;
  final String? note;
  const ExerciseSetRecord({
    required this.id,
    required this.workoutExerciseId,
    required this.setNumber,
    this.suggestedWeight,
    this.suggestedReps,
    this.actualWeight,
    this.actualReps,
    required this.status,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_exercise_id'] = Variable<String>(workoutExerciseId);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || suggestedWeight != null) {
      map['suggested_weight'] = Variable<double>(suggestedWeight);
    }
    if (!nullToAbsent || suggestedReps != null) {
      map['suggested_reps'] = Variable<int>(suggestedReps);
    }
    if (!nullToAbsent || actualWeight != null) {
      map['actual_weight'] = Variable<double>(actualWeight);
    }
    if (!nullToAbsent || actualReps != null) {
      map['actual_reps'] = Variable<int>(actualReps);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ExerciseSetsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseSetsCompanion(
      id: Value(id),
      workoutExerciseId: Value(workoutExerciseId),
      setNumber: Value(setNumber),
      suggestedWeight: suggestedWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedWeight),
      suggestedReps: suggestedReps == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedReps),
      actualWeight: actualWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(actualWeight),
      actualReps: actualReps == null && nullToAbsent
          ? const Value.absent()
          : Value(actualReps),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory ExerciseSetRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseSetRecord(
      id: serializer.fromJson<String>(json['id']),
      workoutExerciseId: serializer.fromJson<String>(json['workoutExerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      suggestedWeight: serializer.fromJson<double?>(json['suggestedWeight']),
      suggestedReps: serializer.fromJson<int?>(json['suggestedReps']),
      actualWeight: serializer.fromJson<double?>(json['actualWeight']),
      actualReps: serializer.fromJson<int?>(json['actualReps']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutExerciseId': serializer.toJson<String>(workoutExerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'suggestedWeight': serializer.toJson<double?>(suggestedWeight),
      'suggestedReps': serializer.toJson<int?>(suggestedReps),
      'actualWeight': serializer.toJson<double?>(actualWeight),
      'actualReps': serializer.toJson<int?>(actualReps),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
    };
  }

  ExerciseSetRecord copyWith({
    String? id,
    String? workoutExerciseId,
    int? setNumber,
    Value<double?> suggestedWeight = const Value.absent(),
    Value<int?> suggestedReps = const Value.absent(),
    Value<double?> actualWeight = const Value.absent(),
    Value<int?> actualReps = const Value.absent(),
    String? status,
    Value<String?> note = const Value.absent(),
  }) => ExerciseSetRecord(
    id: id ?? this.id,
    workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    setNumber: setNumber ?? this.setNumber,
    suggestedWeight: suggestedWeight.present
        ? suggestedWeight.value
        : this.suggestedWeight,
    suggestedReps: suggestedReps.present
        ? suggestedReps.value
        : this.suggestedReps,
    actualWeight: actualWeight.present ? actualWeight.value : this.actualWeight,
    actualReps: actualReps.present ? actualReps.value : this.actualReps,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
  );
  ExerciseSetRecord copyWithCompanion(ExerciseSetsCompanion data) {
    return ExerciseSetRecord(
      id: data.id.present ? data.id.value : this.id,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      suggestedWeight: data.suggestedWeight.present
          ? data.suggestedWeight.value
          : this.suggestedWeight,
      suggestedReps: data.suggestedReps.present
          ? data.suggestedReps.value
          : this.suggestedReps,
      actualWeight: data.actualWeight.present
          ? data.actualWeight.value
          : this.actualWeight,
      actualReps: data.actualReps.present
          ? data.actualReps.value
          : this.actualReps,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSetRecord(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('suggestedWeight: $suggestedWeight, ')
          ..write('suggestedReps: $suggestedReps, ')
          ..write('actualWeight: $actualWeight, ')
          ..write('actualReps: $actualReps, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutExerciseId,
    setNumber,
    suggestedWeight,
    suggestedReps,
    actualWeight,
    actualReps,
    status,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseSetRecord &&
          other.id == this.id &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.setNumber == this.setNumber &&
          other.suggestedWeight == this.suggestedWeight &&
          other.suggestedReps == this.suggestedReps &&
          other.actualWeight == this.actualWeight &&
          other.actualReps == this.actualReps &&
          other.status == this.status &&
          other.note == this.note);
}

class ExerciseSetsCompanion extends UpdateCompanion<ExerciseSetRecord> {
  final Value<String> id;
  final Value<String> workoutExerciseId;
  final Value<int> setNumber;
  final Value<double?> suggestedWeight;
  final Value<int?> suggestedReps;
  final Value<double?> actualWeight;
  final Value<int?> actualReps;
  final Value<String> status;
  final Value<String?> note;
  final Value<int> rowid;
  const ExerciseSetsCompanion({
    this.id = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.suggestedWeight = const Value.absent(),
    this.suggestedReps = const Value.absent(),
    this.actualWeight = const Value.absent(),
    this.actualReps = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseSetsCompanion.insert({
    required String id,
    required String workoutExerciseId,
    required int setNumber,
    this.suggestedWeight = const Value.absent(),
    this.suggestedReps = const Value.absent(),
    this.actualWeight = const Value.absent(),
    this.actualReps = const Value.absent(),
    required String status,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutExerciseId = Value(workoutExerciseId),
       setNumber = Value(setNumber),
       status = Value(status);
  static Insertable<ExerciseSetRecord> custom({
    Expression<String>? id,
    Expression<String>? workoutExerciseId,
    Expression<int>? setNumber,
    Expression<double>? suggestedWeight,
    Expression<int>? suggestedReps,
    Expression<double>? actualWeight,
    Expression<int>? actualReps,
    Expression<String>? status,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (suggestedWeight != null) 'suggested_weight': suggestedWeight,
      if (suggestedReps != null) 'suggested_reps': suggestedReps,
      if (actualWeight != null) 'actual_weight': actualWeight,
      if (actualReps != null) 'actual_reps': actualReps,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutExerciseId,
    Value<int>? setNumber,
    Value<double?>? suggestedWeight,
    Value<int?>? suggestedReps,
    Value<double?>? actualWeight,
    Value<int?>? actualReps,
    Value<String>? status,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return ExerciseSetsCompanion(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      setNumber: setNumber ?? this.setNumber,
      suggestedWeight: suggestedWeight ?? this.suggestedWeight,
      suggestedReps: suggestedReps ?? this.suggestedReps,
      actualWeight: actualWeight ?? this.actualWeight,
      actualReps: actualReps ?? this.actualReps,
      status: status ?? this.status,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<String>(workoutExerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (suggestedWeight.present) {
      map['suggested_weight'] = Variable<double>(suggestedWeight.value);
    }
    if (suggestedReps.present) {
      map['suggested_reps'] = Variable<int>(suggestedReps.value);
    }
    if (actualWeight.present) {
      map['actual_weight'] = Variable<double>(actualWeight.value);
    }
    if (actualReps.present) {
      map['actual_reps'] = Variable<int>(actualReps.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('suggestedWeight: $suggestedWeight, ')
          ..write('suggestedReps: $suggestedReps, ')
          ..write('actualWeight: $actualWeight, ')
          ..write('actualReps: $actualReps, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseDefinitionsTable extends ExerciseDefinitions
    with TableInfo<$ExerciseDefinitionsTable, ExerciseDefinitionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _muscleGroupMeta = const VerificationMeta(
    'muscleGroup',
  );
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
    'muscle_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, muscleGroup];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseDefinitionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
        _muscleGroupMeta,
        muscleGroup.isAcceptableOrUnknown(
          data['muscle_group']!,
          _muscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_muscleGroupMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseDefinitionRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseDefinitionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      muscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_group'],
      )!,
    );
  }

  @override
  $ExerciseDefinitionsTable createAlias(String alias) {
    return $ExerciseDefinitionsTable(attachedDatabase, alias);
  }
}

class ExerciseDefinitionRecord extends DataClass
    implements Insertable<ExerciseDefinitionRecord> {
  final String id;
  final String name;
  final String muscleGroup;
  const ExerciseDefinitionRecord({
    required this.id,
    required this.name,
    required this.muscleGroup,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['muscle_group'] = Variable<String>(muscleGroup);
    return map;
  }

  ExerciseDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseDefinitionsCompanion(
      id: Value(id),
      name: Value(name),
      muscleGroup: Value(muscleGroup),
    );
  }

  factory ExerciseDefinitionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseDefinitionRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      muscleGroup: serializer.fromJson<String>(json['muscleGroup']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'muscleGroup': serializer.toJson<String>(muscleGroup),
    };
  }

  ExerciseDefinitionRecord copyWith({
    String? id,
    String? name,
    String? muscleGroup,
  }) => ExerciseDefinitionRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    muscleGroup: muscleGroup ?? this.muscleGroup,
  );
  ExerciseDefinitionRecord copyWithCompanion(
    ExerciseDefinitionsCompanion data,
  ) {
    return ExerciseDefinitionRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseDefinitionRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, muscleGroup);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseDefinitionRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.muscleGroup == this.muscleGroup);
}

class ExerciseDefinitionsCompanion
    extends UpdateCompanion<ExerciseDefinitionRecord> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> muscleGroup;
  final Value<int> rowid;
  const ExerciseDefinitionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseDefinitionsCompanion.insert({
    required String id,
    required String name,
    required String muscleGroup,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       muscleGroup = Value(muscleGroup);
  static Insertable<ExerciseDefinitionRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? muscleGroup,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseDefinitionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? muscleGroup,
    Value<int>? rowid,
  }) {
    return ExerciseDefinitionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseDefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, goal, weightKg, heightCm, age];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String goal;
  final double? weightKg;
  final double? heightCm;
  final int? age;
  const UserProfile({
    required this.id,
    required this.goal,
    this.weightKg,
    this.heightCm,
    this.age,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal'] = Variable<String>(goal);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      goal: Value(goal),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      goal: serializer.fromJson<String>(json['goal']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      age: serializer.fromJson<int?>(json['age']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goal': serializer.toJson<String>(goal),
      'weightKg': serializer.toJson<double?>(weightKg),
      'heightCm': serializer.toJson<double?>(heightCm),
      'age': serializer.toJson<int?>(age),
    };
  }

  UserProfile copyWith({
    int? id,
    String? goal,
    Value<double?> weightKg = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<int?> age = const Value.absent(),
  }) => UserProfile(
    id: id ?? this.id,
    goal: goal ?? this.goal,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    age: age.present ? age.value : this.age,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      goal: data.goal.present ? data.goal.value : this.goal,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      age: data.age.present ? data.age.value : this.age,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('goal: $goal, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('age: $age')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goal, weightKg, heightCm, age);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.goal == this.goal &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.age == this.age);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> goal;
  final Value<double?> weightKg;
  final Value<double?> heightCm;
  final Value<int?> age;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.goal = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.age = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String goal,
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.age = const Value.absent(),
  }) : goal = Value(goal);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? goal,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<int>? age,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goal != null) 'goal': goal,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (age != null) 'age': age,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? goal,
    Value<double?>? weightKg,
    Value<double?>? heightCm,
    Value<int?>? age,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('goal: $goal, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('age: $age')
          ..write(')'))
        .toString();
  }
}

class $ExerciseProgressCachesTable extends ExerciseProgressCaches
    with TableInfo<$ExerciseProgressCachesTable, ExerciseProgressCacheRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseProgressCachesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recentProgressJsonMeta =
      const VerificationMeta('recentProgressJson');
  @override
  late final GeneratedColumn<String> recentProgressJson =
      GeneratedColumn<String>(
        'recent_progress_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _longTermProgressJsonMeta =
      const VerificationMeta('longTermProgressJson');
  @override
  late final GeneratedColumn<String> longTermProgressJson =
      GeneratedColumn<String>(
        'long_term_progress_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recentWindowJsonMeta = const VerificationMeta(
    'recentWindowJson',
  );
  @override
  late final GeneratedColumn<String> recentWindowJson = GeneratedColumn<String>(
    'recent_window_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longTermStateJsonMeta = const VerificationMeta(
    'longTermStateJson',
  );
  @override
  late final GeneratedColumn<String> longTermStateJson =
      GeneratedColumn<String>(
        'long_term_state_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastProcessedSessionIdMeta =
      const VerificationMeta('lastProcessedSessionId');
  @override
  late final GeneratedColumn<String> lastProcessedSessionId =
      GeneratedColumn<String>(
        'last_processed_session_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calculationVersionMeta =
      const VerificationMeta('calculationVersion');
  @override
  late final GeneratedColumn<int> calculationVersion = GeneratedColumn<int>(
    'calculation_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _needsRebuildMeta = const VerificationMeta(
    'needsRebuild',
  );
  @override
  late final GeneratedColumn<bool> needsRebuild = GeneratedColumn<bool>(
    'needs_rebuild',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_rebuild" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    exerciseId,
    recentProgressJson,
    longTermProgressJson,
    recentWindowJson,
    longTermStateJson,
    lastProcessedSessionId,
    calculationVersion,
    needsRebuild,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_progress_caches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseProgressCacheRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('recent_progress_json')) {
      context.handle(
        _recentProgressJsonMeta,
        recentProgressJson.isAcceptableOrUnknown(
          data['recent_progress_json']!,
          _recentProgressJsonMeta,
        ),
      );
    }
    if (data.containsKey('long_term_progress_json')) {
      context.handle(
        _longTermProgressJsonMeta,
        longTermProgressJson.isAcceptableOrUnknown(
          data['long_term_progress_json']!,
          _longTermProgressJsonMeta,
        ),
      );
    }
    if (data.containsKey('recent_window_json')) {
      context.handle(
        _recentWindowJsonMeta,
        recentWindowJson.isAcceptableOrUnknown(
          data['recent_window_json']!,
          _recentWindowJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recentWindowJsonMeta);
    }
    if (data.containsKey('long_term_state_json')) {
      context.handle(
        _longTermStateJsonMeta,
        longTermStateJson.isAcceptableOrUnknown(
          data['long_term_state_json']!,
          _longTermStateJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longTermStateJsonMeta);
    }
    if (data.containsKey('last_processed_session_id')) {
      context.handle(
        _lastProcessedSessionIdMeta,
        lastProcessedSessionId.isAcceptableOrUnknown(
          data['last_processed_session_id']!,
          _lastProcessedSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('calculation_version')) {
      context.handle(
        _calculationVersionMeta,
        calculationVersion.isAcceptableOrUnknown(
          data['calculation_version']!,
          _calculationVersionMeta,
        ),
      );
    }
    if (data.containsKey('needs_rebuild')) {
      context.handle(
        _needsRebuildMeta,
        needsRebuild.isAcceptableOrUnknown(
          data['needs_rebuild']!,
          _needsRebuildMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId};
  @override
  ExerciseProgressCacheRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseProgressCacheRecord(
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      recentProgressJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recent_progress_json'],
      ),
      longTermProgressJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}long_term_progress_json'],
      ),
      recentWindowJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recent_window_json'],
      )!,
      longTermStateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}long_term_state_json'],
      )!,
      lastProcessedSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_processed_session_id'],
      ),
      calculationVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calculation_version'],
      )!,
      needsRebuild: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_rebuild'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExerciseProgressCachesTable createAlias(String alias) {
    return $ExerciseProgressCachesTable(attachedDatabase, alias);
  }
}

class ExerciseProgressCacheRecord extends DataClass
    implements Insertable<ExerciseProgressCacheRecord> {
  final String exerciseId;
  final String? recentProgressJson;
  final String? longTermProgressJson;
  final String recentWindowJson;
  final String longTermStateJson;
  final String? lastProcessedSessionId;
  final int calculationVersion;
  final bool needsRebuild;
  final DateTime updatedAt;
  const ExerciseProgressCacheRecord({
    required this.exerciseId,
    this.recentProgressJson,
    this.longTermProgressJson,
    required this.recentWindowJson,
    required this.longTermStateJson,
    this.lastProcessedSessionId,
    required this.calculationVersion,
    required this.needsRebuild,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<String>(exerciseId);
    if (!nullToAbsent || recentProgressJson != null) {
      map['recent_progress_json'] = Variable<String>(recentProgressJson);
    }
    if (!nullToAbsent || longTermProgressJson != null) {
      map['long_term_progress_json'] = Variable<String>(longTermProgressJson);
    }
    map['recent_window_json'] = Variable<String>(recentWindowJson);
    map['long_term_state_json'] = Variable<String>(longTermStateJson);
    if (!nullToAbsent || lastProcessedSessionId != null) {
      map['last_processed_session_id'] = Variable<String>(
        lastProcessedSessionId,
      );
    }
    map['calculation_version'] = Variable<int>(calculationVersion);
    map['needs_rebuild'] = Variable<bool>(needsRebuild);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExerciseProgressCachesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseProgressCachesCompanion(
      exerciseId: Value(exerciseId),
      recentProgressJson: recentProgressJson == null && nullToAbsent
          ? const Value.absent()
          : Value(recentProgressJson),
      longTermProgressJson: longTermProgressJson == null && nullToAbsent
          ? const Value.absent()
          : Value(longTermProgressJson),
      recentWindowJson: Value(recentWindowJson),
      longTermStateJson: Value(longTermStateJson),
      lastProcessedSessionId: lastProcessedSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastProcessedSessionId),
      calculationVersion: Value(calculationVersion),
      needsRebuild: Value(needsRebuild),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExerciseProgressCacheRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseProgressCacheRecord(
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      recentProgressJson: serializer.fromJson<String?>(
        json['recentProgressJson'],
      ),
      longTermProgressJson: serializer.fromJson<String?>(
        json['longTermProgressJson'],
      ),
      recentWindowJson: serializer.fromJson<String>(json['recentWindowJson']),
      longTermStateJson: serializer.fromJson<String>(json['longTermStateJson']),
      lastProcessedSessionId: serializer.fromJson<String?>(
        json['lastProcessedSessionId'],
      ),
      calculationVersion: serializer.fromJson<int>(json['calculationVersion']),
      needsRebuild: serializer.fromJson<bool>(json['needsRebuild']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<String>(exerciseId),
      'recentProgressJson': serializer.toJson<String?>(recentProgressJson),
      'longTermProgressJson': serializer.toJson<String?>(longTermProgressJson),
      'recentWindowJson': serializer.toJson<String>(recentWindowJson),
      'longTermStateJson': serializer.toJson<String>(longTermStateJson),
      'lastProcessedSessionId': serializer.toJson<String?>(
        lastProcessedSessionId,
      ),
      'calculationVersion': serializer.toJson<int>(calculationVersion),
      'needsRebuild': serializer.toJson<bool>(needsRebuild),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExerciseProgressCacheRecord copyWith({
    String? exerciseId,
    Value<String?> recentProgressJson = const Value.absent(),
    Value<String?> longTermProgressJson = const Value.absent(),
    String? recentWindowJson,
    String? longTermStateJson,
    Value<String?> lastProcessedSessionId = const Value.absent(),
    int? calculationVersion,
    bool? needsRebuild,
    DateTime? updatedAt,
  }) => ExerciseProgressCacheRecord(
    exerciseId: exerciseId ?? this.exerciseId,
    recentProgressJson: recentProgressJson.present
        ? recentProgressJson.value
        : this.recentProgressJson,
    longTermProgressJson: longTermProgressJson.present
        ? longTermProgressJson.value
        : this.longTermProgressJson,
    recentWindowJson: recentWindowJson ?? this.recentWindowJson,
    longTermStateJson: longTermStateJson ?? this.longTermStateJson,
    lastProcessedSessionId: lastProcessedSessionId.present
        ? lastProcessedSessionId.value
        : this.lastProcessedSessionId,
    calculationVersion: calculationVersion ?? this.calculationVersion,
    needsRebuild: needsRebuild ?? this.needsRebuild,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExerciseProgressCacheRecord copyWithCompanion(
    ExerciseProgressCachesCompanion data,
  ) {
    return ExerciseProgressCacheRecord(
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      recentProgressJson: data.recentProgressJson.present
          ? data.recentProgressJson.value
          : this.recentProgressJson,
      longTermProgressJson: data.longTermProgressJson.present
          ? data.longTermProgressJson.value
          : this.longTermProgressJson,
      recentWindowJson: data.recentWindowJson.present
          ? data.recentWindowJson.value
          : this.recentWindowJson,
      longTermStateJson: data.longTermStateJson.present
          ? data.longTermStateJson.value
          : this.longTermStateJson,
      lastProcessedSessionId: data.lastProcessedSessionId.present
          ? data.lastProcessedSessionId.value
          : this.lastProcessedSessionId,
      calculationVersion: data.calculationVersion.present
          ? data.calculationVersion.value
          : this.calculationVersion,
      needsRebuild: data.needsRebuild.present
          ? data.needsRebuild.value
          : this.needsRebuild,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseProgressCacheRecord(')
          ..write('exerciseId: $exerciseId, ')
          ..write('recentProgressJson: $recentProgressJson, ')
          ..write('longTermProgressJson: $longTermProgressJson, ')
          ..write('recentWindowJson: $recentWindowJson, ')
          ..write('longTermStateJson: $longTermStateJson, ')
          ..write('lastProcessedSessionId: $lastProcessedSessionId, ')
          ..write('calculationVersion: $calculationVersion, ')
          ..write('needsRebuild: $needsRebuild, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    exerciseId,
    recentProgressJson,
    longTermProgressJson,
    recentWindowJson,
    longTermStateJson,
    lastProcessedSessionId,
    calculationVersion,
    needsRebuild,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseProgressCacheRecord &&
          other.exerciseId == this.exerciseId &&
          other.recentProgressJson == this.recentProgressJson &&
          other.longTermProgressJson == this.longTermProgressJson &&
          other.recentWindowJson == this.recentWindowJson &&
          other.longTermStateJson == this.longTermStateJson &&
          other.lastProcessedSessionId == this.lastProcessedSessionId &&
          other.calculationVersion == this.calculationVersion &&
          other.needsRebuild == this.needsRebuild &&
          other.updatedAt == this.updatedAt);
}

class ExerciseProgressCachesCompanion
    extends UpdateCompanion<ExerciseProgressCacheRecord> {
  final Value<String> exerciseId;
  final Value<String?> recentProgressJson;
  final Value<String?> longTermProgressJson;
  final Value<String> recentWindowJson;
  final Value<String> longTermStateJson;
  final Value<String?> lastProcessedSessionId;
  final Value<int> calculationVersion;
  final Value<bool> needsRebuild;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExerciseProgressCachesCompanion({
    this.exerciseId = const Value.absent(),
    this.recentProgressJson = const Value.absent(),
    this.longTermProgressJson = const Value.absent(),
    this.recentWindowJson = const Value.absent(),
    this.longTermStateJson = const Value.absent(),
    this.lastProcessedSessionId = const Value.absent(),
    this.calculationVersion = const Value.absent(),
    this.needsRebuild = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseProgressCachesCompanion.insert({
    required String exerciseId,
    this.recentProgressJson = const Value.absent(),
    this.longTermProgressJson = const Value.absent(),
    required String recentWindowJson,
    required String longTermStateJson,
    this.lastProcessedSessionId = const Value.absent(),
    this.calculationVersion = const Value.absent(),
    this.needsRebuild = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       recentWindowJson = Value(recentWindowJson),
       longTermStateJson = Value(longTermStateJson),
       updatedAt = Value(updatedAt);
  static Insertable<ExerciseProgressCacheRecord> custom({
    Expression<String>? exerciseId,
    Expression<String>? recentProgressJson,
    Expression<String>? longTermProgressJson,
    Expression<String>? recentWindowJson,
    Expression<String>? longTermStateJson,
    Expression<String>? lastProcessedSessionId,
    Expression<int>? calculationVersion,
    Expression<bool>? needsRebuild,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (recentProgressJson != null)
        'recent_progress_json': recentProgressJson,
      if (longTermProgressJson != null)
        'long_term_progress_json': longTermProgressJson,
      if (recentWindowJson != null) 'recent_window_json': recentWindowJson,
      if (longTermStateJson != null) 'long_term_state_json': longTermStateJson,
      if (lastProcessedSessionId != null)
        'last_processed_session_id': lastProcessedSessionId,
      if (calculationVersion != null) 'calculation_version': calculationVersion,
      if (needsRebuild != null) 'needs_rebuild': needsRebuild,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseProgressCachesCompanion copyWith({
    Value<String>? exerciseId,
    Value<String?>? recentProgressJson,
    Value<String?>? longTermProgressJson,
    Value<String>? recentWindowJson,
    Value<String>? longTermStateJson,
    Value<String?>? lastProcessedSessionId,
    Value<int>? calculationVersion,
    Value<bool>? needsRebuild,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExerciseProgressCachesCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      recentProgressJson: recentProgressJson ?? this.recentProgressJson,
      longTermProgressJson: longTermProgressJson ?? this.longTermProgressJson,
      recentWindowJson: recentWindowJson ?? this.recentWindowJson,
      longTermStateJson: longTermStateJson ?? this.longTermStateJson,
      lastProcessedSessionId:
          lastProcessedSessionId ?? this.lastProcessedSessionId,
      calculationVersion: calculationVersion ?? this.calculationVersion,
      needsRebuild: needsRebuild ?? this.needsRebuild,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (recentProgressJson.present) {
      map['recent_progress_json'] = Variable<String>(recentProgressJson.value);
    }
    if (longTermProgressJson.present) {
      map['long_term_progress_json'] = Variable<String>(
        longTermProgressJson.value,
      );
    }
    if (recentWindowJson.present) {
      map['recent_window_json'] = Variable<String>(recentWindowJson.value);
    }
    if (longTermStateJson.present) {
      map['long_term_state_json'] = Variable<String>(longTermStateJson.value);
    }
    if (lastProcessedSessionId.present) {
      map['last_processed_session_id'] = Variable<String>(
        lastProcessedSessionId.value,
      );
    }
    if (calculationVersion.present) {
      map['calculation_version'] = Variable<int>(calculationVersion.value);
    }
    if (needsRebuild.present) {
      map['needs_rebuild'] = Variable<bool>(needsRebuild.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseProgressCachesCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('recentProgressJson: $recentProgressJson, ')
          ..write('longTermProgressJson: $longTermProgressJson, ')
          ..write('recentWindowJson: $recentWindowJson, ')
          ..write('longTermStateJson: $longTermStateJson, ')
          ..write('lastProcessedSessionId: $lastProcessedSessionId, ')
          ..write('calculationVersion: $calculationVersion, ')
          ..write('needsRebuild: $needsRebuild, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingProgressUpdatesTable extends PendingProgressUpdates
    with TableInfo<$PendingProgressUpdatesTable, PendingProgressUpdate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingProgressUpdatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [workoutId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_progress_updates';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingProgressUpdate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workoutId};
  @override
  PendingProgressUpdate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingProgressUpdate(
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
    );
  }

  @override
  $PendingProgressUpdatesTable createAlias(String alias) {
    return $PendingProgressUpdatesTable(attachedDatabase, alias);
  }
}

class PendingProgressUpdate extends DataClass
    implements Insertable<PendingProgressUpdate> {
  final String workoutId;
  const PendingProgressUpdate({required this.workoutId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workout_id'] = Variable<String>(workoutId);
    return map;
  }

  PendingProgressUpdatesCompanion toCompanion(bool nullToAbsent) {
    return PendingProgressUpdatesCompanion(workoutId: Value(workoutId));
  }

  factory PendingProgressUpdate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingProgressUpdate(
      workoutId: serializer.fromJson<String>(json['workoutId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'workoutId': serializer.toJson<String>(workoutId)};
  }

  PendingProgressUpdate copyWith({String? workoutId}) =>
      PendingProgressUpdate(workoutId: workoutId ?? this.workoutId);
  PendingProgressUpdate copyWithCompanion(
    PendingProgressUpdatesCompanion data,
  ) {
    return PendingProgressUpdate(
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingProgressUpdate(')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => workoutId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingProgressUpdate && other.workoutId == this.workoutId);
}

class PendingProgressUpdatesCompanion
    extends UpdateCompanion<PendingProgressUpdate> {
  final Value<String> workoutId;
  final Value<int> rowid;
  const PendingProgressUpdatesCompanion({
    this.workoutId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingProgressUpdatesCompanion.insert({
    required String workoutId,
    this.rowid = const Value.absent(),
  }) : workoutId = Value(workoutId);
  static Insertable<PendingProgressUpdate> custom({
    Expression<String>? workoutId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workoutId != null) 'workout_id': workoutId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingProgressUpdatesCompanion copyWith({
    Value<String>? workoutId,
    Value<int>? rowid,
  }) {
    return PendingProgressUpdatesCompanion(
      workoutId: workoutId ?? this.workoutId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingProgressUpdatesCompanion(')
          ..write('workoutId: $workoutId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $ExerciseSetsTable exerciseSets = $ExerciseSetsTable(this);
  late final $ExerciseDefinitionsTable exerciseDefinitions =
      $ExerciseDefinitionsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $ExerciseProgressCachesTable exerciseProgressCaches =
      $ExerciseProgressCachesTable(this);
  late final $PendingProgressUpdatesTable pendingProgressUpdates =
      $PendingProgressUpdatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutSessions,
    workoutExercises,
    exerciseSets,
    exerciseDefinitions,
    userProfiles,
    exerciseProgressCaches,
    pendingProgressUpdates,
  ];
}

typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required String status,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<int> rowid,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSessionRecord
        > {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $WorkoutExercisesTable,
    List<WorkoutExerciseRecord>
  >
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'workout_sessions__id__workout_exercises__session_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSessionRecord,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSessionRecord, $$WorkoutSessionsTableReferences),
          WorkoutSessionRecord,
          PrefetchHooks Function({bool workoutExercisesRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSessionRecord>(
                    table,
                  ),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutExercisesRefs) db.workoutExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutExercisesRefs)
                    await $_getPrefetchedData<
                      WorkoutSessionRecord,
                      $WorkoutSessionsTable,
                      WorkoutExerciseRecord
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._workoutExercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSessionRecord,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSessionRecord, $$WorkoutSessionsTableReferences),
      WorkoutSessionRecord,
      PrefetchHooks Function({bool workoutExercisesRefs})
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      required String id,
      required String sessionId,
      required String exerciseId,
      required int order,
      Value<int> rowid,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> exerciseId,
      Value<int> order,
      Value<int> rowid,
    });

final class $$WorkoutExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExerciseRecord
        > {
  $$WorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('workout_exercises__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExerciseSetsTable, List<ExerciseSetRecord>>
  _exerciseSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exerciseSets,
    aliasName: 'workout_exercises__id__exercise_sets__workout_exercise_id',
  );

  $$ExerciseSetsTableProcessedTableManager get exerciseSetsRefs {
    final manager = $$ExerciseSetsTableTableManager($_db, $_db.exerciseSets)
        .filter(
          (f) => f.workoutExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_exerciseSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
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

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> exerciseSetsRefs(
    Expression<bool> Function($$ExerciseSetsTableFilterComposer f) f,
  ) {
    final $$ExerciseSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseSetsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> exerciseSetsRefs<T extends Object>(
    Expression<T> Function($$ExerciseSetsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.exerciseSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExerciseRecord,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (WorkoutExerciseRecord, $$WorkoutExercisesTableReferences),
          WorkoutExerciseRecord,
          PrefetchHooks Function({bool sessionId, bool exerciseSetsRefs})
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String exerciseId,
                required int order,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutExercisesTable, WorkoutExerciseRecord>(
                    table,
                  ),
                  $$WorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, exerciseSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exerciseSetsRefs) db.exerciseSets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$WorkoutExercisesTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$WorkoutExercisesTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exerciseSetsRefs)
                        await $_getPrefetchedData<
                          WorkoutExerciseRecord,
                          $WorkoutExercisesTable,
                          ExerciseSetRecord
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutExercisesTableReferences
                              ._exerciseSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).exerciseSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExerciseRecord,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (WorkoutExerciseRecord, $$WorkoutExercisesTableReferences),
      WorkoutExerciseRecord,
      PrefetchHooks Function({bool sessionId, bool exerciseSetsRefs})
    >;
typedef $$ExerciseSetsTableCreateCompanionBuilder =
    ExerciseSetsCompanion Function({
      required String id,
      required String workoutExerciseId,
      required int setNumber,
      Value<double?> suggestedWeight,
      Value<int?> suggestedReps,
      Value<double?> actualWeight,
      Value<int?> actualReps,
      required String status,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$ExerciseSetsTableUpdateCompanionBuilder =
    ExerciseSetsCompanion Function({
      Value<String> id,
      Value<String> workoutExerciseId,
      Value<int> setNumber,
      Value<double?> suggestedWeight,
      Value<int?> suggestedReps,
      Value<double?> actualWeight,
      Value<int?> actualReps,
      Value<String> status,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$ExerciseSetsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExerciseSetsTable, ExerciseSetRecord> {
  $$ExerciseSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutExercisesTable _workoutExerciseIdTable(_$AppDatabase db) => db
      .workoutExercises
      .createAlias('exercise_sets__workout_exercise_id__workout_exercises__id');

  $$WorkoutExercisesTableProcessedTableManager get workoutExerciseId {
    final $_column = $_itemColumn<String>('workout_exercise_id')!;

    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExerciseSetsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableFilterComposer({
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

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get suggestedWeight => $composableBuilder(
    column: $table.suggestedWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get suggestedReps => $composableBuilder(
    column: $table.suggestedReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualWeight => $composableBuilder(
    column: $table.actualWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutExercisesTableFilterComposer get workoutExerciseId {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableOrderingComposer({
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

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get suggestedWeight => $composableBuilder(
    column: $table.suggestedWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get suggestedReps => $composableBuilder(
    column: $table.suggestedReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualWeight => $composableBuilder(
    column: $table.actualWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutExercisesTableOrderingComposer get workoutExerciseId {
    final $$WorkoutExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get suggestedWeight => $composableBuilder(
    column: $table.suggestedWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get suggestedReps => $composableBuilder(
    column: $table.suggestedReps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get actualWeight => $composableBuilder(
    column: $table.actualWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$WorkoutExercisesTableAnnotationComposer get workoutExerciseId {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseSetsTable,
          ExerciseSetRecord,
          $$ExerciseSetsTableFilterComposer,
          $$ExerciseSetsTableOrderingComposer,
          $$ExerciseSetsTableAnnotationComposer,
          $$ExerciseSetsTableCreateCompanionBuilder,
          $$ExerciseSetsTableUpdateCompanionBuilder,
          (ExerciseSetRecord, $$ExerciseSetsTableReferences),
          ExerciseSetRecord,
          PrefetchHooks Function({bool workoutExerciseId})
        > {
  $$ExerciseSetsTableTableManager(_$AppDatabase db, $ExerciseSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutExerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double?> suggestedWeight = const Value.absent(),
                Value<int?> suggestedReps = const Value.absent(),
                Value<double?> actualWeight = const Value.absent(),
                Value<int?> actualReps = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseSetsCompanion(
                id: id,
                workoutExerciseId: workoutExerciseId,
                setNumber: setNumber,
                suggestedWeight: suggestedWeight,
                suggestedReps: suggestedReps,
                actualWeight: actualWeight,
                actualReps: actualReps,
                status: status,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutExerciseId,
                required int setNumber,
                Value<double?> suggestedWeight = const Value.absent(),
                Value<int?> suggestedReps = const Value.absent(),
                Value<double?> actualWeight = const Value.absent(),
                Value<int?> actualReps = const Value.absent(),
                required String status,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseSetsCompanion.insert(
                id: id,
                workoutExerciseId: workoutExerciseId,
                setNumber: setNumber,
                suggestedWeight: suggestedWeight,
                suggestedReps: suggestedReps,
                actualWeight: actualWeight,
                actualReps: actualReps,
                status: status,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExerciseSetsTable, ExerciseSetRecord>(table),
                  $$ExerciseSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutExerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutExerciseId,
                                referencedTable: $$ExerciseSetsTableReferences
                                    ._workoutExerciseIdTable(db),
                                referencedColumn: $$ExerciseSetsTableReferences
                                    ._workoutExerciseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExerciseSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseSetsTable,
      ExerciseSetRecord,
      $$ExerciseSetsTableFilterComposer,
      $$ExerciseSetsTableOrderingComposer,
      $$ExerciseSetsTableAnnotationComposer,
      $$ExerciseSetsTableCreateCompanionBuilder,
      $$ExerciseSetsTableUpdateCompanionBuilder,
      (ExerciseSetRecord, $$ExerciseSetsTableReferences),
      ExerciseSetRecord,
      PrefetchHooks Function({bool workoutExerciseId})
    >;
typedef $$ExerciseDefinitionsTableCreateCompanionBuilder =
    ExerciseDefinitionsCompanion Function({
      required String id,
      required String name,
      required String muscleGroup,
      Value<int> rowid,
    });
typedef $$ExerciseDefinitionsTableUpdateCompanionBuilder =
    ExerciseDefinitionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> muscleGroup,
      Value<int> rowid,
    });

class $$ExerciseDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseDefinitionsTable> {
  $$ExerciseDefinitionsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseDefinitionsTable> {
  $$ExerciseDefinitionsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseDefinitionsTable> {
  $$ExerciseDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => column,
  );
}

class $$ExerciseDefinitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseDefinitionsTable,
          ExerciseDefinitionRecord,
          $$ExerciseDefinitionsTableFilterComposer,
          $$ExerciseDefinitionsTableOrderingComposer,
          $$ExerciseDefinitionsTableAnnotationComposer,
          $$ExerciseDefinitionsTableCreateCompanionBuilder,
          $$ExerciseDefinitionsTableUpdateCompanionBuilder,
          (
            ExerciseDefinitionRecord,
            BaseReferences<
              _$AppDatabase,
              $ExerciseDefinitionsTable,
              ExerciseDefinitionRecord
            >,
          ),
          ExerciseDefinitionRecord,
          PrefetchHooks Function()
        > {
  $$ExerciseDefinitionsTableTableManager(
    _$AppDatabase db,
    $ExerciseDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseDefinitionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExerciseDefinitionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> muscleGroup = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseDefinitionsCompanion(
                id: id,
                name: name,
                muscleGroup: muscleGroup,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String muscleGroup,
                Value<int> rowid = const Value.absent(),
              }) => ExerciseDefinitionsCompanion.insert(
                id: id,
                name: name,
                muscleGroup: muscleGroup,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ExerciseDefinitionsTable,
                    ExerciseDefinitionRecord
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExerciseDefinitionsTable,
                    ExerciseDefinitionRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseDefinitionsTable,
      ExerciseDefinitionRecord,
      $$ExerciseDefinitionsTableFilterComposer,
      $$ExerciseDefinitionsTableOrderingComposer,
      $$ExerciseDefinitionsTableAnnotationComposer,
      $$ExerciseDefinitionsTableCreateCompanionBuilder,
      $$ExerciseDefinitionsTableUpdateCompanionBuilder,
      (
        ExerciseDefinitionRecord,
        BaseReferences<
          _$AppDatabase,
          $ExerciseDefinitionsTable,
          ExerciseDefinitionRecord
        >,
      ),
      ExerciseDefinitionRecord,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      required String goal,
      Value<double?> weightKg,
      Value<double?> heightCm,
      Value<int?> age,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> goal,
      Value<double?> weightKg,
      Value<double?> heightCm,
      Value<int?> age,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<int?> age = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                goal: goal,
                weightKg: weightKg,
                heightCm: heightCm,
                age: age,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String goal,
                Value<double?> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<int?> age = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                goal: goal,
                weightKg: weightKg,
                heightCm: heightCm,
                age: age,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$ExerciseProgressCachesTableCreateCompanionBuilder =
    ExerciseProgressCachesCompanion Function({
      required String exerciseId,
      Value<String?> recentProgressJson,
      Value<String?> longTermProgressJson,
      required String recentWindowJson,
      required String longTermStateJson,
      Value<String?> lastProcessedSessionId,
      Value<int> calculationVersion,
      Value<bool> needsRebuild,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ExerciseProgressCachesTableUpdateCompanionBuilder =
    ExerciseProgressCachesCompanion Function({
      Value<String> exerciseId,
      Value<String?> recentProgressJson,
      Value<String?> longTermProgressJson,
      Value<String> recentWindowJson,
      Value<String> longTermStateJson,
      Value<String?> lastProcessedSessionId,
      Value<int> calculationVersion,
      Value<bool> needsRebuild,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ExerciseProgressCachesTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseProgressCachesTable> {
  $$ExerciseProgressCachesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recentProgressJson => $composableBuilder(
    column: $table.recentProgressJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get longTermProgressJson => $composableBuilder(
    column: $table.longTermProgressJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recentWindowJson => $composableBuilder(
    column: $table.recentWindowJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get longTermStateJson => $composableBuilder(
    column: $table.longTermStateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastProcessedSessionId => $composableBuilder(
    column: $table.lastProcessedSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calculationVersion => $composableBuilder(
    column: $table.calculationVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsRebuild => $composableBuilder(
    column: $table.needsRebuild,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseProgressCachesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseProgressCachesTable> {
  $$ExerciseProgressCachesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recentProgressJson => $composableBuilder(
    column: $table.recentProgressJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get longTermProgressJson => $composableBuilder(
    column: $table.longTermProgressJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recentWindowJson => $composableBuilder(
    column: $table.recentWindowJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get longTermStateJson => $composableBuilder(
    column: $table.longTermStateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastProcessedSessionId => $composableBuilder(
    column: $table.lastProcessedSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calculationVersion => $composableBuilder(
    column: $table.calculationVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsRebuild => $composableBuilder(
    column: $table.needsRebuild,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseProgressCachesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseProgressCachesTable> {
  $$ExerciseProgressCachesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recentProgressJson => $composableBuilder(
    column: $table.recentProgressJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get longTermProgressJson => $composableBuilder(
    column: $table.longTermProgressJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recentWindowJson => $composableBuilder(
    column: $table.recentWindowJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get longTermStateJson => $composableBuilder(
    column: $table.longTermStateJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastProcessedSessionId => $composableBuilder(
    column: $table.lastProcessedSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calculationVersion => $composableBuilder(
    column: $table.calculationVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsRebuild => $composableBuilder(
    column: $table.needsRebuild,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExerciseProgressCachesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseProgressCachesTable,
          ExerciseProgressCacheRecord,
          $$ExerciseProgressCachesTableFilterComposer,
          $$ExerciseProgressCachesTableOrderingComposer,
          $$ExerciseProgressCachesTableAnnotationComposer,
          $$ExerciseProgressCachesTableCreateCompanionBuilder,
          $$ExerciseProgressCachesTableUpdateCompanionBuilder,
          (
            ExerciseProgressCacheRecord,
            BaseReferences<
              _$AppDatabase,
              $ExerciseProgressCachesTable,
              ExerciseProgressCacheRecord
            >,
          ),
          ExerciseProgressCacheRecord,
          PrefetchHooks Function()
        > {
  $$ExerciseProgressCachesTableTableManager(
    _$AppDatabase db,
    $ExerciseProgressCachesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseProgressCachesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ExerciseProgressCachesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExerciseProgressCachesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> exerciseId = const Value.absent(),
                Value<String?> recentProgressJson = const Value.absent(),
                Value<String?> longTermProgressJson = const Value.absent(),
                Value<String> recentWindowJson = const Value.absent(),
                Value<String> longTermStateJson = const Value.absent(),
                Value<String?> lastProcessedSessionId = const Value.absent(),
                Value<int> calculationVersion = const Value.absent(),
                Value<bool> needsRebuild = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseProgressCachesCompanion(
                exerciseId: exerciseId,
                recentProgressJson: recentProgressJson,
                longTermProgressJson: longTermProgressJson,
                recentWindowJson: recentWindowJson,
                longTermStateJson: longTermStateJson,
                lastProcessedSessionId: lastProcessedSessionId,
                calculationVersion: calculationVersion,
                needsRebuild: needsRebuild,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String exerciseId,
                Value<String?> recentProgressJson = const Value.absent(),
                Value<String?> longTermProgressJson = const Value.absent(),
                required String recentWindowJson,
                required String longTermStateJson,
                Value<String?> lastProcessedSessionId = const Value.absent(),
                Value<int> calculationVersion = const Value.absent(),
                Value<bool> needsRebuild = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExerciseProgressCachesCompanion.insert(
                exerciseId: exerciseId,
                recentProgressJson: recentProgressJson,
                longTermProgressJson: longTermProgressJson,
                recentWindowJson: recentWindowJson,
                longTermStateJson: longTermStateJson,
                lastProcessedSessionId: lastProcessedSessionId,
                calculationVersion: calculationVersion,
                needsRebuild: needsRebuild,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ExerciseProgressCachesTable,
                    ExerciseProgressCacheRecord
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExerciseProgressCachesTable,
                    ExerciseProgressCacheRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseProgressCachesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseProgressCachesTable,
      ExerciseProgressCacheRecord,
      $$ExerciseProgressCachesTableFilterComposer,
      $$ExerciseProgressCachesTableOrderingComposer,
      $$ExerciseProgressCachesTableAnnotationComposer,
      $$ExerciseProgressCachesTableCreateCompanionBuilder,
      $$ExerciseProgressCachesTableUpdateCompanionBuilder,
      (
        ExerciseProgressCacheRecord,
        BaseReferences<
          _$AppDatabase,
          $ExerciseProgressCachesTable,
          ExerciseProgressCacheRecord
        >,
      ),
      ExerciseProgressCacheRecord,
      PrefetchHooks Function()
    >;
typedef $$PendingProgressUpdatesTableCreateCompanionBuilder =
    PendingProgressUpdatesCompanion Function({
      required String workoutId,
      Value<int> rowid,
    });
typedef $$PendingProgressUpdatesTableUpdateCompanionBuilder =
    PendingProgressUpdatesCompanion Function({
      Value<String> workoutId,
      Value<int> rowid,
    });

class $$PendingProgressUpdatesTableFilterComposer
    extends Composer<_$AppDatabase, $PendingProgressUpdatesTable> {
  $$PendingProgressUpdatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingProgressUpdatesTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingProgressUpdatesTable> {
  $$PendingProgressUpdatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingProgressUpdatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingProgressUpdatesTable> {
  $$PendingProgressUpdatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workoutId =>
      $composableBuilder(column: $table.workoutId, builder: (column) => column);
}

class $$PendingProgressUpdatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingProgressUpdatesTable,
          PendingProgressUpdate,
          $$PendingProgressUpdatesTableFilterComposer,
          $$PendingProgressUpdatesTableOrderingComposer,
          $$PendingProgressUpdatesTableAnnotationComposer,
          $$PendingProgressUpdatesTableCreateCompanionBuilder,
          $$PendingProgressUpdatesTableUpdateCompanionBuilder,
          (
            PendingProgressUpdate,
            BaseReferences<
              _$AppDatabase,
              $PendingProgressUpdatesTable,
              PendingProgressUpdate
            >,
          ),
          PendingProgressUpdate,
          PrefetchHooks Function()
        > {
  $$PendingProgressUpdatesTableTableManager(
    _$AppDatabase db,
    $PendingProgressUpdatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingProgressUpdatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PendingProgressUpdatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingProgressUpdatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> workoutId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingProgressUpdatesCompanion(
                workoutId: workoutId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String workoutId,
                Value<int> rowid = const Value.absent(),
              }) => PendingProgressUpdatesCompanion.insert(
                workoutId: workoutId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $PendingProgressUpdatesTable,
                    PendingProgressUpdate
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PendingProgressUpdatesTable,
                    PendingProgressUpdate
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingProgressUpdatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingProgressUpdatesTable,
      PendingProgressUpdate,
      $$PendingProgressUpdatesTableFilterComposer,
      $$PendingProgressUpdatesTableOrderingComposer,
      $$PendingProgressUpdatesTableAnnotationComposer,
      $$PendingProgressUpdatesTableCreateCompanionBuilder,
      $$PendingProgressUpdatesTableUpdateCompanionBuilder,
      (
        PendingProgressUpdate,
        BaseReferences<
          _$AppDatabase,
          $PendingProgressUpdatesTable,
          PendingProgressUpdate
        >,
      ),
      PendingProgressUpdate,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$ExerciseSetsTableTableManager get exerciseSets =>
      $$ExerciseSetsTableTableManager(_db, _db.exerciseSets);
  $$ExerciseDefinitionsTableTableManager get exerciseDefinitions =>
      $$ExerciseDefinitionsTableTableManager(_db, _db.exerciseDefinitions);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$ExerciseProgressCachesTableTableManager get exerciseProgressCaches =>
      $$ExerciseProgressCachesTableTableManager(
        _db,
        _db.exerciseProgressCaches,
      );
  $$PendingProgressUpdatesTableTableManager get pendingProgressUpdates =>
      $$PendingProgressUpdatesTableTableManager(
        _db,
        _db.pendingProgressUpdates,
      );
}
