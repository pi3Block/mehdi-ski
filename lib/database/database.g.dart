// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LevelTable extends Level with TableInfo<$LevelTable, LevelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<String> seed = GeneratedColumn<String>(
      'seed', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _highscoreMeta =
      const VerificationMeta('highscore');
  @override
  late final GeneratedColumn<int> highscore = GeneratedColumn<int>(
      'highscore', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, seed, highscore];
  @override
  String get aliasedName => _alias ?? 'level';
  @override
  String get actualTableName => 'level';
  @override
  VerificationContext validateIntegrity(Insertable<LevelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('seed')) {
      context.handle(
          _seedMeta, seed.isAcceptableOrUnknown(data['seed']!, _seedMeta));
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('highscore')) {
      context.handle(_highscoreMeta,
          highscore.isAcceptableOrUnknown(data['highscore']!, _highscoreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LevelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      seed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}seed'])!,
      highscore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}highscore']),
    );
  }

  @override
  $LevelTable createAlias(String alias) {
    return $LevelTable(attachedDatabase, alias);
  }
}

class LevelData extends DataClass implements Insertable<LevelData> {
  ///PK of the table
  final int id;

  ///Seed of the level
  final String seed;

  ///Highscore of the player if level was solved
  final int? highscore;
  const LevelData({required this.id, required this.seed, this.highscore});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['seed'] = Variable<String>(seed);
    if (!nullToAbsent || highscore != null) {
      map['highscore'] = Variable<int>(highscore);
    }
    return map;
  }

  LevelCompanion toCompanion(bool nullToAbsent) {
    return LevelCompanion(
      id: Value(id),
      seed: Value(seed),
      highscore: highscore == null && nullToAbsent
          ? const Value.absent()
          : Value(highscore),
    );
  }

  factory LevelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelData(
      id: serializer.fromJson<int>(json['id']),
      seed: serializer.fromJson<String>(json['seed']),
      highscore: serializer.fromJson<int?>(json['highscore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seed': serializer.toJson<String>(seed),
      'highscore': serializer.toJson<int?>(highscore),
    };
  }

  LevelData copyWith(
          {int? id,
          String? seed,
          Value<int?> highscore = const Value.absent()}) =>
      LevelData(
        id: id ?? this.id,
        seed: seed ?? this.seed,
        highscore: highscore.present ? highscore.value : this.highscore,
      );
  @override
  String toString() {
    return (StringBuffer('LevelData(')
          ..write('id: $id, ')
          ..write('seed: $seed, ')
          ..write('highscore: $highscore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, seed, highscore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelData &&
          other.id == this.id &&
          other.seed == this.seed &&
          other.highscore == this.highscore);
}

class LevelCompanion extends UpdateCompanion<LevelData> {
  final Value<int> id;
  final Value<String> seed;
  final Value<int?> highscore;
  const LevelCompanion({
    this.id = const Value.absent(),
    this.seed = const Value.absent(),
    this.highscore = const Value.absent(),
  });
  LevelCompanion.insert({
    this.id = const Value.absent(),
    required String seed,
    this.highscore = const Value.absent(),
  }) : seed = Value(seed);
  static Insertable<LevelData> custom({
    Expression<int>? id,
    Expression<String>? seed,
    Expression<int>? highscore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seed != null) 'seed': seed,
      if (highscore != null) 'highscore': highscore,
    });
  }

  LevelCompanion copyWith(
      {Value<int>? id, Value<String>? seed, Value<int?>? highscore}) {
    return LevelCompanion(
      id: id ?? this.id,
      seed: seed ?? this.seed,
      highscore: highscore ?? this.highscore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seed.present) {
      map['seed'] = Variable<String>(seed.value);
    }
    if (highscore.present) {
      map['highscore'] = Variable<int>(highscore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelCompanion(')
          ..write('id: $id, ')
          ..write('seed: $seed, ')
          ..write('highscore: $highscore')
          ..write(')'))
        .toString();
  }
}

class $HighscoreTable extends Highscore
    with TableInfo<$HighscoreTable, HighscoreData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighscoreTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<String> seed = GeneratedColumn<String>(
      'seed', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _creationDateMeta =
      const VerificationMeta('creationDate');
  @override
  late final GeneratedColumn<DateTime> creationDate = GeneratedColumn<DateTime>(
      'creation_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, seed, score, creationDate];
  @override
  String get aliasedName => _alias ?? 'highscore';
  @override
  String get actualTableName => 'highscore';
  @override
  VerificationContext validateIntegrity(Insertable<HighscoreData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('seed')) {
      context.handle(
          _seedMeta, seed.isAcceptableOrUnknown(data['seed']!, _seedMeta));
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('creation_date')) {
      context.handle(
          _creationDateMeta,
          creationDate.isAcceptableOrUnknown(
              data['creation_date']!, _creationDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HighscoreData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighscoreData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      seed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}seed'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score']),
      creationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_date'])!,
    );
  }

  @override
  $HighscoreTable createAlias(String alias) {
    return $HighscoreTable(attachedDatabase, alias);
  }
}

class HighscoreData extends DataClass implements Insertable<HighscoreData> {
  ///PK of the table
  final int id;

  ///Seed of the level
  final String seed;

  ///Highscore of the player if level was solved
  final int? score;

  ///Datetime the high score with entered
  final DateTime creationDate;
  const HighscoreData(
      {required this.id,
      required this.seed,
      this.score,
      required this.creationDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['seed'] = Variable<String>(seed);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['creation_date'] = Variable<DateTime>(creationDate);
    return map;
  }

  HighscoreCompanion toCompanion(bool nullToAbsent) {
    return HighscoreCompanion(
      id: Value(id),
      seed: Value(seed),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      creationDate: Value(creationDate),
    );
  }

  factory HighscoreData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighscoreData(
      id: serializer.fromJson<int>(json['id']),
      seed: serializer.fromJson<String>(json['seed']),
      score: serializer.fromJson<int?>(json['score']),
      creationDate: serializer.fromJson<DateTime>(json['creationDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seed': serializer.toJson<String>(seed),
      'score': serializer.toJson<int?>(score),
      'creationDate': serializer.toJson<DateTime>(creationDate),
    };
  }

  HighscoreData copyWith(
          {int? id,
          String? seed,
          Value<int?> score = const Value.absent(),
          DateTime? creationDate}) =>
      HighscoreData(
        id: id ?? this.id,
        seed: seed ?? this.seed,
        score: score.present ? score.value : this.score,
        creationDate: creationDate ?? this.creationDate,
      );
  @override
  String toString() {
    return (StringBuffer('HighscoreData(')
          ..write('id: $id, ')
          ..write('seed: $seed, ')
          ..write('score: $score, ')
          ..write('creationDate: $creationDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, seed, score, creationDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighscoreData &&
          other.id == this.id &&
          other.seed == this.seed &&
          other.score == this.score &&
          other.creationDate == this.creationDate);
}

class HighscoreCompanion extends UpdateCompanion<HighscoreData> {
  final Value<int> id;
  final Value<String> seed;
  final Value<int?> score;
  final Value<DateTime> creationDate;
  const HighscoreCompanion({
    this.id = const Value.absent(),
    this.seed = const Value.absent(),
    this.score = const Value.absent(),
    this.creationDate = const Value.absent(),
  });
  HighscoreCompanion.insert({
    this.id = const Value.absent(),
    required String seed,
    this.score = const Value.absent(),
    this.creationDate = const Value.absent(),
  }) : seed = Value(seed);
  static Insertable<HighscoreData> custom({
    Expression<int>? id,
    Expression<String>? seed,
    Expression<int>? score,
    Expression<DateTime>? creationDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seed != null) 'seed': seed,
      if (score != null) 'score': score,
      if (creationDate != null) 'creation_date': creationDate,
    });
  }

  HighscoreCompanion copyWith(
      {Value<int>? id,
      Value<String>? seed,
      Value<int?>? score,
      Value<DateTime>? creationDate}) {
    return HighscoreCompanion(
      id: id ?? this.id,
      seed: seed ?? this.seed,
      score: score ?? this.score,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seed.present) {
      map['seed'] = Variable<String>(seed.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (creationDate.present) {
      map['creation_date'] = Variable<DateTime>(creationDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighscoreCompanion(')
          ..write('id: $id, ')
          ..write('seed: $seed, ')
          ..write('score: $score, ')
          ..write('creationDate: $creationDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$MehdiSkiGameDatabase extends GeneratedDatabase {
  _$MehdiSkiGameDatabase(QueryExecutor e) : super(e);
  late final $LevelTable level = $LevelTable(this);
  late final $HighscoreTable highscore = $HighscoreTable(this);
  Selectable<LevelData> getTopTenScore() {
    return customSelect(
        'SELECT * FROM level WHERE level.highscore <> NULL ORDER BY level.highscore DESC LIMIT 10',
        variables: [],
        readsFrom: {
          level,
        }).asyncMap(level.mapFromRow);
  }

  Future<int> updateScoreForLevel(int? newHighscore, int levelId) {
    return customUpdate(
      'UPDATE level SET highscore = ?1 WHERE id = ?2 AND highscore < ?1',
      variables: [Variable<int>(newHighscore), Variable<int>(levelId)],
      updates: {level},
      updateKind: UpdateKind.update,
    );
  }

  Future<int> createANewLevel(String newLevelSeed) {
    return customInsert(
      'INSERT INTO level (seed) VALUES (?1)',
      variables: [Variable<String>(newLevelSeed)],
      updates: {level},
    );
  }

  Future<int> createNewHighScoreEntry(String seed, int? newHighscore) {
    return customInsert(
      'INSERT INTO highscore (seed, score) VALUES (?1, ?2)',
      variables: [Variable<String>(seed), Variable<int>(newHighscore)],
      updates: {highscore},
    );
  }

  Selectable<GetTopTenForSeedResult> getTopTenForSeed(String seed) {
    return customSelect(
        'SELECT score, creation_date FROM highscore WHERE seed = ?1 ORDER BY score DESC LIMIT 10',
        variables: [
          Variable<String>(seed)
        ],
        readsFrom: {
          highscore,
        }).map((QueryRow row) {
      return GetTopTenForSeedResult(
        score: row.readNullable<int>('score'),
        creationDate: row.read<DateTime>('creation_date'),
      );
    });
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [level, highscore];
}

class GetTopTenForSeedResult {
  final int? score;
  final DateTime creationDate;
  GetTopTenForSeedResult({
    this.score,
    required this.creationDate,
  });
}
