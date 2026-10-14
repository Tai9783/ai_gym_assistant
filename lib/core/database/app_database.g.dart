// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
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
    Insertable<WorkoutSession> instance, {
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
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
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

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  const WorkoutSession({
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

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
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

  WorkoutSession copyWith({
    String? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
  }) => WorkoutSession(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
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
      (other is WorkoutSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
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
  static Insertable<WorkoutSession> custom({
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
    with TableInfo<$WorkoutExercisesTable, WorkoutExercise> {
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
    Insertable<WorkoutExercise> instance, {
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
  WorkoutExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercise(
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

class WorkoutExercise extends DataClass implements Insertable<WorkoutExercise> {
  final String id;
  final String sessionId;
  final String exerciseId;
  final int order;
  const WorkoutExercise({
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

  factory WorkoutExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercise(
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

  WorkoutExercise copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    int? order,
  }) => WorkoutExercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    order: order ?? this.order,
  );
  WorkoutExercise copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercise(
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
    return (StringBuffer('WorkoutExercise(')
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
      (other is WorkoutExercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.order == this.order);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercise> {
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
  static Insertable<WorkoutExercise> custom({
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
    with TableInfo<$ExerciseSetsTable, ExerciseSet> {
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
    Insertable<ExerciseSet> instance, {
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
  ExerciseSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseSet(
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

class ExerciseSet extends DataClass implements Insertable<ExerciseSet> {
  final String id;
  final String workoutExerciseId;
  final int setNumber;
  final double? suggestedWeight;
  final int? suggestedReps;
  final double? actualWeight;
  final int? actualReps;
  final String status;
  final String? note;
  const ExerciseSet({
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

  factory ExerciseSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseSet(
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

  ExerciseSet copyWith({
    String? id,
    String? workoutExerciseId,
    int? setNumber,
    Value<double?> suggestedWeight = const Value.absent(),
    Value<int?> suggestedReps = const Value.absent(),
    Value<double?> actualWeight = const Value.absent(),
    Value<int?> actualReps = const Value.absent(),
    String? status,
    Value<String?> note = const Value.absent(),
  }) => ExerciseSet(
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
  ExerciseSet copyWithCompanion(ExerciseSetsCompanion data) {
    return ExerciseSet(
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
    return (StringBuffer('ExerciseSet(')
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
      (other is ExerciseSet &&
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

class ExerciseSetsCompanion extends UpdateCompanion<ExerciseSet> {
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
  static Insertable<ExerciseSet> custom({
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutSessions,
    workoutExercises,
    exerciseSets,
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
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
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
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
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
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
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
                      WorkoutSession,
                      $WorkoutSessionsTable,
                      WorkoutExercise
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
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
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
        BaseReferences<_$AppDatabase, $WorkoutExercisesTable, WorkoutExercise> {
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

  static MultiTypedResultKey<$ExerciseSetsTable, List<ExerciseSet>>
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
          WorkoutExercise,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (WorkoutExercise, $$WorkoutExercisesTableReferences),
          WorkoutExercise,
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
                  e.readTable<$WorkoutExercisesTable, WorkoutExercise>(table),
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
                          WorkoutExercise,
                          $WorkoutExercisesTable,
                          ExerciseSet
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
      WorkoutExercise,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (WorkoutExercise, $$WorkoutExercisesTableReferences),
      WorkoutExercise,
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
    extends BaseReferences<_$AppDatabase, $ExerciseSetsTable, ExerciseSet> {
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
          ExerciseSet,
          $$ExerciseSetsTableFilterComposer,
          $$ExerciseSetsTableOrderingComposer,
          $$ExerciseSetsTableAnnotationComposer,
          $$ExerciseSetsTableCreateCompanionBuilder,
          $$ExerciseSetsTableUpdateCompanionBuilder,
          (ExerciseSet, $$ExerciseSetsTableReferences),
          ExerciseSet,
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
                  e.readTable<$ExerciseSetsTable, ExerciseSet>(table),
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
      ExerciseSet,
      $$ExerciseSetsTableFilterComposer,
      $$ExerciseSetsTableOrderingComposer,
      $$ExerciseSetsTableAnnotationComposer,
      $$ExerciseSetsTableCreateCompanionBuilder,
      $$ExerciseSetsTableUpdateCompanionBuilder,
      (ExerciseSet, $$ExerciseSetsTableReferences),
      ExerciseSet,
      PrefetchHooks Function({bool workoutExerciseId})
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
}
