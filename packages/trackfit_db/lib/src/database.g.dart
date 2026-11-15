// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Person extends Table with TableInfo<Person, PersonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Person(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (birth_date IS NULL OR birth_date GLOB \'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\')',
  );
  late final GeneratedColumnWithTypeConverter<Sex, String>
  sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'unknown\' CHECK (sex IN (\'unknown\', \'female\', \'male\', \'other\'))',
    defaultValue: const CustomExpression('\'unknown\''),
  ).withConverter<Sex>(Person.$convertersex);
  static const VerificationMeta _defaultTzMeta = const VerificationMeta(
    'defaultTz',
  );
  late final GeneratedColumn<String> defaultTz = GeneratedColumn<String>(
    'default_tz',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      ).withConverter<DateTime>(Person.$convertercreatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    birthDate,
    sex,
    defaultTz,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'person';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('default_tz')) {
      context.handle(
        _defaultTzMeta,
        defaultTz.isAcceptableOrUnknown(data['default_tz']!, _defaultTzMeta),
      );
    } else if (isInserting) {
      context.missing(_defaultTzMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      ),
      sex: Person.$convertersex.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sex'],
        )!,
      ),
      defaultTz: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_tz'],
      )!,
      createdAt: Person.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
    );
  }

  @override
  Person createAlias(String alias) {
    return Person(attachedDatabase, alias);
  }

  static TypeConverter<Sex, String> $convertersex = sexConverter;
  static TypeConverter<DateTime, int> $convertercreatedAt = utcMillisConverter;
  @override
  bool get dontWriteConstraints => true;
}

class PersonRow extends DataClass implements Insertable<PersonRow> {
  final int id;
  final String displayName;
  final String? birthDate;
  final Sex sex;

  /// IANA zone used for readings without a zone of their own.
  final String defaultTz;
  final DateTime createdAt;
  const PersonRow({
    required this.id,
    required this.displayName,
    this.birthDate,
    required this.sex,
    required this.defaultTz,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(birthDate);
    }
    {
      map['sex'] = Variable<String>(Person.$convertersex.toSql(sex));
    }
    map['default_tz'] = Variable<String>(defaultTz);
    {
      map['created_at'] = Variable<int>(
        Person.$convertercreatedAt.toSql(createdAt),
      );
    }
    return map;
  }

  PersonCompanion toCompanion(bool nullToAbsent) {
    return PersonCompanion(
      id: Value(id),
      displayName: Value(displayName),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      sex: Value(sex),
      defaultTz: Value(defaultTz),
      createdAt: Value(createdAt),
    );
  }

  factory PersonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonRow(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['display_name']),
      birthDate: serializer.fromJson<String?>(json['birth_date']),
      sex: serializer.fromJson<Sex>(json['sex']),
      defaultTz: serializer.fromJson<String>(json['default_tz']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'display_name': serializer.toJson<String>(displayName),
      'birth_date': serializer.toJson<String?>(birthDate),
      'sex': serializer.toJson<Sex>(sex),
      'default_tz': serializer.toJson<String>(defaultTz),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  PersonRow copyWith({
    int? id,
    String? displayName,
    Value<String?> birthDate = const Value.absent(),
    Sex? sex,
    String? defaultTz,
    DateTime? createdAt,
  }) => PersonRow(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    sex: sex ?? this.sex,
    defaultTz: defaultTz ?? this.defaultTz,
    createdAt: createdAt ?? this.createdAt,
  );
  PersonRow copyWithCompanion(PersonCompanion data) {
    return PersonRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      sex: data.sex.present ? data.sex.value : this.sex,
      defaultTz: data.defaultTz.present ? data.defaultTz.value : this.defaultTz,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('defaultTz: $defaultTz, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, displayName, birthDate, sex, defaultTz, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.birthDate == this.birthDate &&
          other.sex == this.sex &&
          other.defaultTz == this.defaultTz &&
          other.createdAt == this.createdAt);
}

class PersonCompanion extends UpdateCompanion<PersonRow> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String?> birthDate;
  final Value<Sex> sex;
  final Value<String> defaultTz;
  final Value<DateTime> createdAt;
  const PersonCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.sex = const Value.absent(),
    this.defaultTz = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PersonCompanion.insert({
    this.id = const Value.absent(),
    required String displayName,
    this.birthDate = const Value.absent(),
    this.sex = const Value.absent(),
    required String defaultTz,
    required DateTime createdAt,
  }) : displayName = Value(displayName),
       defaultTz = Value(defaultTz),
       createdAt = Value(createdAt);
  static Insertable<PersonRow> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? birthDate,
    Expression<String>? sex,
    Expression<String>? defaultTz,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (birthDate != null) 'birth_date': birthDate,
      if (sex != null) 'sex': sex,
      if (defaultTz != null) 'default_tz': defaultTz,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PersonCompanion copyWith({
    Value<int>? id,
    Value<String>? displayName,
    Value<String?>? birthDate,
    Value<Sex>? sex,
    Value<String>? defaultTz,
    Value<DateTime>? createdAt,
  }) {
    return PersonCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      defaultTz: defaultTz ?? this.defaultTz,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(Person.$convertersex.toSql(sex.value));
    }
    if (defaultTz.present) {
      map['default_tz'] = Variable<String>(defaultTz.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        Person.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('defaultTz: $defaultTz, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$TrackfitDatabase extends GeneratedDatabase {
  _$TrackfitDatabase(QueryExecutor e) : super(e);
  late final Person person = Person(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [person];
}
