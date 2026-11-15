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

class Report extends Table with TableInfo<Report, ReportRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Report(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES person(id)',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _reportDateMeta = const VerificationMeta(
    'reportDate',
  );
  late final GeneratedColumn<String> reportDate = GeneratedColumn<String>(
    'report_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (report_date IS NULL OR report_date GLOB \'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\')',
  );
  late final GeneratedColumnWithTypeConverter<DateSource, String>
  dateSource = GeneratedColumn<String>(
    'date_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'\' CHECK (date_source IN (\'\', \'extracted\', \'file-date\', \'manual\'))',
    defaultValue: const CustomExpression('\'\''),
  ).withConverter<DateSource>(Report.$converterdateSource);
  static const VerificationMeta _labNameMeta = const VerificationMeta(
    'labName',
  );
  late final GeneratedColumn<String> labName = GeneratedColumn<String>(
    'lab_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumnWithTypeConverter<ReportStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'pending\' CHECK (status IN (\'pending\', \'ocr\', \'extracting\', \'review\', \'done\', \'failed\'))',
    defaultValue: const CustomExpression('\'pending\''),
  ).withConverter<ReportStatus>(Report.$converterstatus);
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      ).withConverter<DateTime>(Report.$convertercreatedAt);
  late final GeneratedColumnWithTypeConverter<DateTime?, int> deletedAt =
      GeneratedColumn<int>(
        'deleted_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        $customConstraints: '',
      ).withConverter<DateTime?>(Report.$converterdeletedAtn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personId,
    title,
    reportDate,
    dateSource,
    labName,
    status,
    error,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('report_date')) {
      context.handle(
        _reportDateMeta,
        reportDate.isAcceptableOrUnknown(data['report_date']!, _reportDateMeta),
      );
    }
    if (data.containsKey('lab_name')) {
      context.handle(
        _labNameMeta,
        labName.isAcceptableOrUnknown(data['lab_name']!, _labNameMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      reportDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_date'],
      ),
      dateSource: Report.$converterdateSource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date_source'],
        )!,
      ),
      labName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lab_name'],
      )!,
      status: Report.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      )!,
      createdAt: Report.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      deletedAt: Report.$converterdeletedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}deleted_at'],
        ),
      ),
    );
  }

  @override
  Report createAlias(String alias) {
    return Report(attachedDatabase, alias);
  }

  static TypeConverter<DateSource, String> $converterdateSource =
      dateSourceConverter;
  static TypeConverter<ReportStatus, String> $converterstatus =
      reportStatusConverter;
  static TypeConverter<DateTime, int> $convertercreatedAt = utcMillisConverter;
  static TypeConverter<DateTime, int> $converterdeletedAt = utcMillisConverter;
  static TypeConverter<DateTime?, int?> $converterdeletedAtn =
      NullAwareTypeConverter.wrap($converterdeletedAt);
  @override
  List<String> get customConstraints => const [
    'CHECK(status <> \'failed\' OR error <> \'\')',
    'CHECK((report_date IS NULL)=(date_source = \'\'))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class ReportRow extends DataClass implements Insertable<ReportRow> {
  final int id;
  final int personId;
  final String title;

  /// Date printed on the report. NULL until known; never defaults to today.
  final String? reportDate;
  final DateSource dateSource;
  final String labName;
  final ReportStatus status;
  final String error;
  final DateTime createdAt;
  final DateTime? deletedAt;
  const ReportRow({
    required this.id,
    required this.personId,
    required this.title,
    this.reportDate,
    required this.dateSource,
    required this.labName,
    required this.status,
    required this.error,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || reportDate != null) {
      map['report_date'] = Variable<String>(reportDate);
    }
    {
      map['date_source'] = Variable<String>(
        Report.$converterdateSource.toSql(dateSource),
      );
    }
    map['lab_name'] = Variable<String>(labName);
    {
      map['status'] = Variable<String>(Report.$converterstatus.toSql(status));
    }
    map['error'] = Variable<String>(error);
    {
      map['created_at'] = Variable<int>(
        Report.$convertercreatedAt.toSql(createdAt),
      );
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(
        Report.$converterdeletedAtn.toSql(deletedAt),
      );
    }
    return map;
  }

  ReportCompanion toCompanion(bool nullToAbsent) {
    return ReportCompanion(
      id: Value(id),
      personId: Value(personId),
      title: Value(title),
      reportDate: reportDate == null && nullToAbsent
          ? const Value.absent()
          : Value(reportDate),
      dateSource: Value(dateSource),
      labName: Value(labName),
      status: Value(status),
      error: Value(error),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ReportRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportRow(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['person_id']),
      title: serializer.fromJson<String>(json['title']),
      reportDate: serializer.fromJson<String?>(json['report_date']),
      dateSource: serializer.fromJson<DateSource>(json['date_source']),
      labName: serializer.fromJson<String>(json['lab_name']),
      status: serializer.fromJson<ReportStatus>(json['status']),
      error: serializer.fromJson<String>(json['error']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'person_id': serializer.toJson<int>(personId),
      'title': serializer.toJson<String>(title),
      'report_date': serializer.toJson<String?>(reportDate),
      'date_source': serializer.toJson<DateSource>(dateSource),
      'lab_name': serializer.toJson<String>(labName),
      'status': serializer.toJson<ReportStatus>(status),
      'error': serializer.toJson<String>(error),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ReportRow copyWith({
    int? id,
    int? personId,
    String? title,
    Value<String?> reportDate = const Value.absent(),
    DateSource? dateSource,
    String? labName,
    ReportStatus? status,
    String? error,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ReportRow(
    id: id ?? this.id,
    personId: personId ?? this.personId,
    title: title ?? this.title,
    reportDate: reportDate.present ? reportDate.value : this.reportDate,
    dateSource: dateSource ?? this.dateSource,
    labName: labName ?? this.labName,
    status: status ?? this.status,
    error: error ?? this.error,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ReportRow copyWithCompanion(ReportCompanion data) {
    return ReportRow(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      title: data.title.present ? data.title.value : this.title,
      reportDate: data.reportDate.present
          ? data.reportDate.value
          : this.reportDate,
      dateSource: data.dateSource.present
          ? data.dateSource.value
          : this.dateSource,
      labName: data.labName.present ? data.labName.value : this.labName,
      status: data.status.present ? data.status.value : this.status,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportRow(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('title: $title, ')
          ..write('reportDate: $reportDate, ')
          ..write('dateSource: $dateSource, ')
          ..write('labName: $labName, ')
          ..write('status: $status, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personId,
    title,
    reportDate,
    dateSource,
    labName,
    status,
    error,
    createdAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportRow &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.title == this.title &&
          other.reportDate == this.reportDate &&
          other.dateSource == this.dateSource &&
          other.labName == this.labName &&
          other.status == this.status &&
          other.error == this.error &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class ReportCompanion extends UpdateCompanion<ReportRow> {
  final Value<int> id;
  final Value<int> personId;
  final Value<String> title;
  final Value<String?> reportDate;
  final Value<DateSource> dateSource;
  final Value<String> labName;
  final Value<ReportStatus> status;
  final Value<String> error;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  const ReportCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.title = const Value.absent(),
    this.reportDate = const Value.absent(),
    this.dateSource = const Value.absent(),
    this.labName = const Value.absent(),
    this.status = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  ReportCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    this.title = const Value.absent(),
    this.reportDate = const Value.absent(),
    this.dateSource = const Value.absent(),
    this.labName = const Value.absent(),
    this.status = const Value.absent(),
    this.error = const Value.absent(),
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
  }) : personId = Value(personId),
       createdAt = Value(createdAt);
  static Insertable<ReportRow> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<String>? title,
    Expression<String>? reportDate,
    Expression<String>? dateSource,
    Expression<String>? labName,
    Expression<String>? status,
    Expression<String>? error,
    Expression<int>? createdAt,
    Expression<int>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (title != null) 'title': title,
      if (reportDate != null) 'report_date': reportDate,
      if (dateSource != null) 'date_source': dateSource,
      if (labName != null) 'lab_name': labName,
      if (status != null) 'status': status,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  ReportCompanion copyWith({
    Value<int>? id,
    Value<int>? personId,
    Value<String>? title,
    Value<String?>? reportDate,
    Value<DateSource>? dateSource,
    Value<String>? labName,
    Value<ReportStatus>? status,
    Value<String>? error,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
  }) {
    return ReportCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      title: title ?? this.title,
      reportDate: reportDate ?? this.reportDate,
      dateSource: dateSource ?? this.dateSource,
      labName: labName ?? this.labName,
      status: status ?? this.status,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (reportDate.present) {
      map['report_date'] = Variable<String>(reportDate.value);
    }
    if (dateSource.present) {
      map['date_source'] = Variable<String>(
        Report.$converterdateSource.toSql(dateSource.value),
      );
    }
    if (labName.present) {
      map['lab_name'] = Variable<String>(labName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        Report.$converterstatus.toSql(status.value),
      );
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        Report.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(
        Report.$converterdeletedAtn.toSql(deletedAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('title: $title, ')
          ..write('reportDate: $reportDate, ')
          ..write('dateSource: $dateSource, ')
          ..write('labName: $labName, ')
          ..write('status: $status, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class Extraction extends Table with TableInfo<Extraction, ExtractionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Extraction(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES person(id)',
  );
  late final GeneratedColumnWithTypeConverter<SourceKind, String>
  sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (source_kind IN (\'file\', \'manual\', \'health-connect\', \'healthkit\', \'device-file\'))',
  ).withConverter<SourceKind>(Extraction.$convertersourceKind);
  static const VerificationMeta _sourceRefMeta = const VerificationMeta(
    'sourceRef',
  );
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  late final GeneratedColumn<int> reportId = GeneratedColumn<int>(
    'report_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES report(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _extractorMeta = const VerificationMeta(
    'extractor',
  );
  late final GeneratedColumn<String> extractor = GeneratedColumn<String>(
    'extractor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumnWithTypeConverter<ExtractionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        $customConstraints:
            'NOT NULL CHECK (status IN (\'ok\', \'failed\', \'unverified\'))',
      ).withConverter<ExtractionStatus>(Extraction.$converterstatus);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _digestMeta = const VerificationMeta('digest');
  late final GeneratedColumn<String> digest = GeneratedColumn<String>(
    'digest',
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
      ).withConverter<DateTime>(Extraction.$convertercreatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personId,
    sourceKind,
    sourceRef,
    reportId,
    extractor,
    status,
    reason,
    payload,
    digest,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extraction';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExtractionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('source_ref')) {
      context.handle(
        _sourceRefMeta,
        sourceRef.isAcceptableOrUnknown(data['source_ref']!, _sourceRefMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceRefMeta);
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    }
    if (data.containsKey('extractor')) {
      context.handle(
        _extractorMeta,
        extractor.isAcceptableOrUnknown(data['extractor']!, _extractorMeta),
      );
    } else if (isInserting) {
      context.missing(_extractorMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('digest')) {
      context.handle(
        _digestMeta,
        digest.isAcceptableOrUnknown(data['digest']!, _digestMeta),
      );
    } else if (isInserting) {
      context.missing(_digestMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sourceRef, digest},
  ];
  @override
  ExtractionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtractionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      )!,
      sourceKind: Extraction.$convertersourceKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source_kind'],
        )!,
      ),
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      )!,
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}report_id'],
      ),
      extractor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extractor'],
      )!,
      status: Extraction.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      digest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}digest'],
      )!,
      createdAt: Extraction.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
    );
  }

  @override
  Extraction createAlias(String alias) {
    return Extraction(attachedDatabase, alias);
  }

  static TypeConverter<SourceKind, String> $convertersourceKind =
      sourceKindConverter;
  static TypeConverter<ExtractionStatus, String> $converterstatus =
      extractionStatusConverter;
  static TypeConverter<DateTime, int> $convertercreatedAt = utcMillisConverter;
  @override
  List<String> get customConstraints => const [
    'UNIQUE(source_ref, digest)',
    'CHECK(status = \'ok\' OR reason <> \'\')',
    'CHECK(status = \'failed\' OR payload IS NOT NULL)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class ExtractionRow extends DataClass implements Insertable<ExtractionRow> {
  final int id;
  final int personId;
  final SourceKind sourceKind;

  /// e.g. 'report:<id>'.
  final String sourceRef;
  final int? reportId;

  /// e.g. 'llm:mistral/<model>@prompt-v1', 'manual'.
  final String extractor;
  final ExtractionStatus status;
  final String reason;

  /// The drafts as JSON; NULL when reading failed.
  final String? payload;

  /// SHA-256 over source_ref, extractor and payload.
  final String digest;
  final DateTime createdAt;
  const ExtractionRow({
    required this.id,
    required this.personId,
    required this.sourceKind,
    required this.sourceRef,
    this.reportId,
    required this.extractor,
    required this.status,
    required this.reason,
    this.payload,
    required this.digest,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    {
      map['source_kind'] = Variable<String>(
        Extraction.$convertersourceKind.toSql(sourceKind),
      );
    }
    map['source_ref'] = Variable<String>(sourceRef);
    if (!nullToAbsent || reportId != null) {
      map['report_id'] = Variable<int>(reportId);
    }
    map['extractor'] = Variable<String>(extractor);
    {
      map['status'] = Variable<String>(
        Extraction.$converterstatus.toSql(status),
      );
    }
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['digest'] = Variable<String>(digest);
    {
      map['created_at'] = Variable<int>(
        Extraction.$convertercreatedAt.toSql(createdAt),
      );
    }
    return map;
  }

  ExtractionCompanion toCompanion(bool nullToAbsent) {
    return ExtractionCompanion(
      id: Value(id),
      personId: Value(personId),
      sourceKind: Value(sourceKind),
      sourceRef: Value(sourceRef),
      reportId: reportId == null && nullToAbsent
          ? const Value.absent()
          : Value(reportId),
      extractor: Value(extractor),
      status: Value(status),
      reason: Value(reason),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      digest: Value(digest),
      createdAt: Value(createdAt),
    );
  }

  factory ExtractionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtractionRow(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['person_id']),
      sourceKind: serializer.fromJson<SourceKind>(json['source_kind']),
      sourceRef: serializer.fromJson<String>(json['source_ref']),
      reportId: serializer.fromJson<int?>(json['report_id']),
      extractor: serializer.fromJson<String>(json['extractor']),
      status: serializer.fromJson<ExtractionStatus>(json['status']),
      reason: serializer.fromJson<String>(json['reason']),
      payload: serializer.fromJson<String?>(json['payload']),
      digest: serializer.fromJson<String>(json['digest']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'person_id': serializer.toJson<int>(personId),
      'source_kind': serializer.toJson<SourceKind>(sourceKind),
      'source_ref': serializer.toJson<String>(sourceRef),
      'report_id': serializer.toJson<int?>(reportId),
      'extractor': serializer.toJson<String>(extractor),
      'status': serializer.toJson<ExtractionStatus>(status),
      'reason': serializer.toJson<String>(reason),
      'payload': serializer.toJson<String?>(payload),
      'digest': serializer.toJson<String>(digest),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExtractionRow copyWith({
    int? id,
    int? personId,
    SourceKind? sourceKind,
    String? sourceRef,
    Value<int?> reportId = const Value.absent(),
    String? extractor,
    ExtractionStatus? status,
    String? reason,
    Value<String?> payload = const Value.absent(),
    String? digest,
    DateTime? createdAt,
  }) => ExtractionRow(
    id: id ?? this.id,
    personId: personId ?? this.personId,
    sourceKind: sourceKind ?? this.sourceKind,
    sourceRef: sourceRef ?? this.sourceRef,
    reportId: reportId.present ? reportId.value : this.reportId,
    extractor: extractor ?? this.extractor,
    status: status ?? this.status,
    reason: reason ?? this.reason,
    payload: payload.present ? payload.value : this.payload,
    digest: digest ?? this.digest,
    createdAt: createdAt ?? this.createdAt,
  );
  ExtractionRow copyWithCompanion(ExtractionCompanion data) {
    return ExtractionRow(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      extractor: data.extractor.present ? data.extractor.value : this.extractor,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
      payload: data.payload.present ? data.payload.value : this.payload,
      digest: data.digest.present ? data.digest.value : this.digest,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionRow(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('reportId: $reportId, ')
          ..write('extractor: $extractor, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('payload: $payload, ')
          ..write('digest: $digest, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personId,
    sourceKind,
    sourceRef,
    reportId,
    extractor,
    status,
    reason,
    payload,
    digest,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtractionRow &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.sourceKind == this.sourceKind &&
          other.sourceRef == this.sourceRef &&
          other.reportId == this.reportId &&
          other.extractor == this.extractor &&
          other.status == this.status &&
          other.reason == this.reason &&
          other.payload == this.payload &&
          other.digest == this.digest &&
          other.createdAt == this.createdAt);
}

class ExtractionCompanion extends UpdateCompanion<ExtractionRow> {
  final Value<int> id;
  final Value<int> personId;
  final Value<SourceKind> sourceKind;
  final Value<String> sourceRef;
  final Value<int?> reportId;
  final Value<String> extractor;
  final Value<ExtractionStatus> status;
  final Value<String> reason;
  final Value<String?> payload;
  final Value<String> digest;
  final Value<DateTime> createdAt;
  const ExtractionCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.reportId = const Value.absent(),
    this.extractor = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.payload = const Value.absent(),
    this.digest = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExtractionCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required SourceKind sourceKind,
    required String sourceRef,
    this.reportId = const Value.absent(),
    required String extractor,
    required ExtractionStatus status,
    this.reason = const Value.absent(),
    this.payload = const Value.absent(),
    required String digest,
    required DateTime createdAt,
  }) : personId = Value(personId),
       sourceKind = Value(sourceKind),
       sourceRef = Value(sourceRef),
       extractor = Value(extractor),
       status = Value(status),
       digest = Value(digest),
       createdAt = Value(createdAt);
  static Insertable<ExtractionRow> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<String>? sourceKind,
    Expression<String>? sourceRef,
    Expression<int>? reportId,
    Expression<String>? extractor,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<String>? payload,
    Expression<String>? digest,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (reportId != null) 'report_id': reportId,
      if (extractor != null) 'extractor': extractor,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (payload != null) 'payload': payload,
      if (digest != null) 'digest': digest,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExtractionCompanion copyWith({
    Value<int>? id,
    Value<int>? personId,
    Value<SourceKind>? sourceKind,
    Value<String>? sourceRef,
    Value<int?>? reportId,
    Value<String>? extractor,
    Value<ExtractionStatus>? status,
    Value<String>? reason,
    Value<String?>? payload,
    Value<String>? digest,
    Value<DateTime>? createdAt,
  }) {
    return ExtractionCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      sourceKind: sourceKind ?? this.sourceKind,
      sourceRef: sourceRef ?? this.sourceRef,
      reportId: reportId ?? this.reportId,
      extractor: extractor ?? this.extractor,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      payload: payload ?? this.payload,
      digest: digest ?? this.digest,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(
        Extraction.$convertersourceKind.toSql(sourceKind.value),
      );
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<int>(reportId.value);
    }
    if (extractor.present) {
      map['extractor'] = Variable<String>(extractor.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        Extraction.$converterstatus.toSql(status.value),
      );
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (digest.present) {
      map['digest'] = Variable<String>(digest.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        Extraction.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('reportId: $reportId, ')
          ..write('extractor: $extractor, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('payload: $payload, ')
          ..write('digest: $digest, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class Observation extends Table with TableInfo<Observation, ObservationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Observation(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES person(id)',
  );
  late final GeneratedColumnWithTypeConverter<ObservationKind, String>
  kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (kind IN (\'measurement\', \'symptom\', \'condition\', \'note\', \'finding\', \'organizer\'))',
  ).withConverter<ObservationKind>(Observation.$converterkind);
  late final GeneratedColumnWithTypeConverter<Modality, String>
  modality = GeneratedColumn<String>(
    'modality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (modality IN (\'lab-report\', \'device-sensed\', \'self-reported\', \'manual\', \'derived\', \'llm-unverified\'))',
  ).withConverter<Modality>(Observation.$convertermodality);
  late final GeneratedColumnWithTypeConverter<SourceKind, String>
  sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (source_kind IN (\'file\', \'manual\', \'health-connect\', \'healthkit\', \'device-file\'))',
  ).withConverter<SourceKind>(Observation.$convertersourceKind);
  static const VerificationMeta _sourceRefMeta = const VerificationMeta(
    'sourceRef',
  );
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sourceRecordIdMeta = const VerificationMeta(
    'sourceRecordId',
  );
  late final GeneratedColumn<String> sourceRecordId = GeneratedColumn<String>(
    'source_record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _extractionIdMeta = const VerificationMeta(
    'extractionId',
  );
  late final GeneratedColumn<int> extractionId = GeneratedColumn<int>(
    'extraction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES extraction(id)',
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  late final GeneratedColumn<int> reportId = GeneratedColumn<int>(
    'report_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES report(id)',
  );
  static const VerificationMeta _pageIxMeta = const VerificationMeta('pageIx');
  late final GeneratedColumn<int> pageIx = GeneratedColumn<int>(
    'page_ix',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (page_ix IS NULL OR page_ix >= 0)',
  );
  static const VerificationMeta _rowIxMeta = const VerificationMeta('rowIx');
  late final GeneratedColumn<int> rowIx = GeneratedColumn<int>(
    'row_ix',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (row_ix IS NULL OR row_ix >= 0)',
  );
  static const VerificationMeta _vendorMeta = const VerificationMeta('vendor');
  late final GeneratedColumn<String> vendor = GeneratedColumn<String>(
    'vendor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _vendorFieldMeta = const VerificationMeta(
    'vendorField',
  );
  late final GeneratedColumn<String> vendorField = GeneratedColumn<String>(
    'vendor_field',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumnWithTypeConverter<SourceClass, String>
  sourceClass = GeneratedColumn<String>(
    'source_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (source_class IN (\'measurer\', \'profile-echo\', \'aggregator\', \'manual\'))',
  ).withConverter<SourceClass>(Observation.$convertersourceClass);
  static const VerificationMeta _derivedFromMeta = const VerificationMeta(
    'derivedFrom',
  );
  late final GeneratedColumn<String> derivedFrom = GeneratedColumn<String>(
    'derived_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _memberOfMeta = const VerificationMeta(
    'memberOf',
  );
  late final GeneratedColumn<int> memberOf = GeneratedColumn<int>(
    'member_of',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES observation(id)',
  );
  static const VerificationMeta _panelTextMeta = const VerificationMeta(
    'panelText',
  );
  late final GeneratedColumn<String> panelText = GeneratedColumn<String>(
    'panel_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumnWithTypeConverter<DateTime, int> observedStart =
      GeneratedColumn<int>(
        'observed_start',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      ).withConverter<DateTime>(Observation.$converterobservedStart);
  late final GeneratedColumnWithTypeConverter<DateTime, int> observedEnd =
      GeneratedColumn<int>(
        'observed_end',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      ).withConverter<DateTime>(Observation.$converterobservedEnd);
  static const VerificationMeta _tzMeta = const VerificationMeta('tz');
  late final GeneratedColumn<String> tz = GeneratedColumn<String>(
    'tz',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumnWithTypeConverter<TzSource, String>
  tzSource = GeneratedColumn<String>(
    'tz_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (tz_source IN (\'iana\', \'offset-only\', \'floating\', \'user-default\'))',
  ).withConverter<TzSource>(Observation.$convertertzSource);
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (local_date GLOB \'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\')',
  );
  late final GeneratedColumnWithTypeConverter<Grain, String> grain =
      GeneratedColumn<String>(
        'grain',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        $customConstraints:
            'NOT NULL CHECK (grain IN (\'instant\', \'window\', \'day\'))',
      ).withConverter<Grain>(Observation.$convertergrain);
  late final GeneratedColumnWithTypeConverter<Stat, String>
  stat = GeneratedColumn<String>(
    'stat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'\' CHECK (stat IN (\'\', \'average\', \'minimum\', \'maximum\', \'sum\', \'count\', \'last\'))',
    defaultValue: const CustomExpression('\'\''),
  ).withConverter<Stat>(Observation.$converterstat);
  static const VerificationMeta _nameTextMeta = const VerificationMeta(
    'nameText',
  );
  late final GeneratedColumn<String> nameText = GeneratedColumn<String>(
    'name_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _valueTextMeta = const VerificationMeta(
    'valueText',
  );
  late final GeneratedColumn<String> valueText = GeneratedColumn<String>(
    'value_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _unitTextMeta = const VerificationMeta(
    'unitText',
  );
  late final GeneratedColumn<String> unitText = GeneratedColumn<String>(
    'unit_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _refTextMeta = const VerificationMeta(
    'refText',
  );
  late final GeneratedColumn<String> refText = GeneratedColumn<String>(
    'ref_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _flagTextMeta = const VerificationMeta(
    'flagText',
  );
  late final GeneratedColumn<String> flagText = GeneratedColumn<String>(
    'flag_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _methodTextMeta = const VerificationMeta(
    'methodText',
  );
  late final GeneratedColumn<String> methodText = GeneratedColumn<String>(
    'method_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _specimenTextMeta = const VerificationMeta(
    'specimenText',
  );
  late final GeneratedColumn<String> specimenText = GeneratedColumn<String>(
    'specimen_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _noteTextMeta = const VerificationMeta(
    'noteText',
  );
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
    'note_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumnWithTypeConverter<ValueKind, String>
  valueKind = GeneratedColumn<String>(
    'value_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (value_kind IN (\'quantity\', \'ordinal\', \'nominal\', \'narrative\', \'absent\'))',
  ).withConverter<ValueKind>(Observation.$convertervalueKind);
  static const VerificationMeta _valueNumMeta = const VerificationMeta(
    'valueNum',
  );
  late final GeneratedColumn<double> valueNum = GeneratedColumn<double>(
    'value_num',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _valueDecimalsMeta = const VerificationMeta(
    'valueDecimals',
  );
  late final GeneratedColumn<int> valueDecimals = GeneratedColumn<int>(
    'value_decimals',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (value_decimals IS NULL OR value_decimals >= 0)',
  );
  late final GeneratedColumnWithTypeConverter<Comparator, String>
  comparator = GeneratedColumn<String>(
    'comparator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'\' CHECK (comparator IN (\'\', \'<\', \'<=\', \'>\', \'>=\'))',
    defaultValue: const CustomExpression('\'\''),
  ).withConverter<Comparator>(Observation.$convertercomparator);
  static const VerificationMeta _valueCodeMeta = const VerificationMeta(
    'valueCode',
  );
  late final GeneratedColumn<String> valueCode = GeneratedColumn<String>(
    'value_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _dataAbsentReasonMeta = const VerificationMeta(
    'dataAbsentReason',
  );
  late final GeneratedColumn<String> dataAbsentReason = GeneratedColumn<String>(
    'data_absent_reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _unitUcumMeta = const VerificationMeta(
    'unitUcum',
  );
  late final GeneratedColumn<String> unitUcum = GeneratedColumn<String>(
    'unit_ucum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _refLowMeta = const VerificationMeta('refLow');
  late final GeneratedColumn<double> refLow = GeneratedColumn<double>(
    'ref_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _refHighMeta = const VerificationMeta(
    'refHigh',
  );
  late final GeneratedColumn<double> refHigh = GeneratedColumn<double>(
    'ref_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  late final GeneratedColumnWithTypeConverter<Comparator, String>
  refComparator = GeneratedColumn<String>(
    'ref_comparator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'\' CHECK (ref_comparator IN (\'\', \'<\', \'<=\', \'>\', \'>=\'))',
    defaultValue: const CustomExpression('\'\''),
  ).withConverter<Comparator>(Observation.$converterrefComparator);
  late final GeneratedColumnWithTypeConverter<Flag, String>
  flag = GeneratedColumn<String>(
    'flag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'\' CHECK (flag IN (\'\', \'low\', \'high\', \'critical-low\', \'critical-high\', \'abnormal\'))',
    defaultValue: const CustomExpression('\'\''),
  ).withConverter<Flag>(Observation.$converterflag);
  static const VerificationMeta _localKeyMeta = const VerificationMeta(
    'localKey',
  );
  late final GeneratedColumn<String> localKey = GeneratedColumn<String>(
    'local_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _streamKeyMeta = const VerificationMeta(
    'streamKey',
  );
  late final GeneratedColumn<String> streamKey = GeneratedColumn<String>(
    'stream_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumnWithTypeConverter<ObservationStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'final\' CHECK (status IN (\'final\', \'entered-in-error\'))',
    defaultValue: const CustomExpression('\'final\''),
  ).withConverter<ObservationStatus>(Observation.$converterstatus);
  static const VerificationMeta _amendsMeta = const VerificationMeta('amends');
  late final GeneratedColumn<int> amends = GeneratedColumn<int>(
    'amends',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES observation(id)',
  );
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      ).withConverter<DateTime>(Observation.$convertercreatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personId,
    kind,
    modality,
    sourceKind,
    sourceRef,
    sourceRecordId,
    extractionId,
    reportId,
    pageIx,
    rowIx,
    vendor,
    vendorField,
    sourceClass,
    derivedFrom,
    memberOf,
    panelText,
    observedStart,
    observedEnd,
    tz,
    tzSource,
    localDate,
    grain,
    stat,
    nameText,
    valueText,
    unitText,
    refText,
    flagText,
    methodText,
    specimenText,
    noteText,
    nameKey,
    valueKind,
    valueNum,
    valueDecimals,
    comparator,
    valueCode,
    dataAbsentReason,
    unitUcum,
    refLow,
    refHigh,
    refComparator,
    flag,
    localKey,
    streamKey,
    fingerprint,
    status,
    amends,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'observation';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObservationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('source_ref')) {
      context.handle(
        _sourceRefMeta,
        sourceRef.isAcceptableOrUnknown(data['source_ref']!, _sourceRefMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceRefMeta);
    }
    if (data.containsKey('source_record_id')) {
      context.handle(
        _sourceRecordIdMeta,
        sourceRecordId.isAcceptableOrUnknown(
          data['source_record_id']!,
          _sourceRecordIdMeta,
        ),
      );
    }
    if (data.containsKey('extraction_id')) {
      context.handle(
        _extractionIdMeta,
        extractionId.isAcceptableOrUnknown(
          data['extraction_id']!,
          _extractionIdMeta,
        ),
      );
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    }
    if (data.containsKey('page_ix')) {
      context.handle(
        _pageIxMeta,
        pageIx.isAcceptableOrUnknown(data['page_ix']!, _pageIxMeta),
      );
    }
    if (data.containsKey('row_ix')) {
      context.handle(
        _rowIxMeta,
        rowIx.isAcceptableOrUnknown(data['row_ix']!, _rowIxMeta),
      );
    }
    if (data.containsKey('vendor')) {
      context.handle(
        _vendorMeta,
        vendor.isAcceptableOrUnknown(data['vendor']!, _vendorMeta),
      );
    }
    if (data.containsKey('vendor_field')) {
      context.handle(
        _vendorFieldMeta,
        vendorField.isAcceptableOrUnknown(
          data['vendor_field']!,
          _vendorFieldMeta,
        ),
      );
    }
    if (data.containsKey('derived_from')) {
      context.handle(
        _derivedFromMeta,
        derivedFrom.isAcceptableOrUnknown(
          data['derived_from']!,
          _derivedFromMeta,
        ),
      );
    }
    if (data.containsKey('member_of')) {
      context.handle(
        _memberOfMeta,
        memberOf.isAcceptableOrUnknown(data['member_of']!, _memberOfMeta),
      );
    }
    if (data.containsKey('panel_text')) {
      context.handle(
        _panelTextMeta,
        panelText.isAcceptableOrUnknown(data['panel_text']!, _panelTextMeta),
      );
    }
    if (data.containsKey('tz')) {
      context.handle(_tzMeta, tz.isAcceptableOrUnknown(data['tz']!, _tzMeta));
    } else if (isInserting) {
      context.missing(_tzMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('name_text')) {
      context.handle(
        _nameTextMeta,
        nameText.isAcceptableOrUnknown(data['name_text']!, _nameTextMeta),
      );
    } else if (isInserting) {
      context.missing(_nameTextMeta);
    }
    if (data.containsKey('value_text')) {
      context.handle(
        _valueTextMeta,
        valueText.isAcceptableOrUnknown(data['value_text']!, _valueTextMeta),
      );
    }
    if (data.containsKey('unit_text')) {
      context.handle(
        _unitTextMeta,
        unitText.isAcceptableOrUnknown(data['unit_text']!, _unitTextMeta),
      );
    }
    if (data.containsKey('ref_text')) {
      context.handle(
        _refTextMeta,
        refText.isAcceptableOrUnknown(data['ref_text']!, _refTextMeta),
      );
    }
    if (data.containsKey('flag_text')) {
      context.handle(
        _flagTextMeta,
        flagText.isAcceptableOrUnknown(data['flag_text']!, _flagTextMeta),
      );
    }
    if (data.containsKey('method_text')) {
      context.handle(
        _methodTextMeta,
        methodText.isAcceptableOrUnknown(data['method_text']!, _methodTextMeta),
      );
    }
    if (data.containsKey('specimen_text')) {
      context.handle(
        _specimenTextMeta,
        specimenText.isAcceptableOrUnknown(
          data['specimen_text']!,
          _specimenTextMeta,
        ),
      );
    }
    if (data.containsKey('note_text')) {
      context.handle(
        _noteTextMeta,
        noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta),
      );
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('value_num')) {
      context.handle(
        _valueNumMeta,
        valueNum.isAcceptableOrUnknown(data['value_num']!, _valueNumMeta),
      );
    }
    if (data.containsKey('value_decimals')) {
      context.handle(
        _valueDecimalsMeta,
        valueDecimals.isAcceptableOrUnknown(
          data['value_decimals']!,
          _valueDecimalsMeta,
        ),
      );
    }
    if (data.containsKey('value_code')) {
      context.handle(
        _valueCodeMeta,
        valueCode.isAcceptableOrUnknown(data['value_code']!, _valueCodeMeta),
      );
    }
    if (data.containsKey('data_absent_reason')) {
      context.handle(
        _dataAbsentReasonMeta,
        dataAbsentReason.isAcceptableOrUnknown(
          data['data_absent_reason']!,
          _dataAbsentReasonMeta,
        ),
      );
    }
    if (data.containsKey('unit_ucum')) {
      context.handle(
        _unitUcumMeta,
        unitUcum.isAcceptableOrUnknown(data['unit_ucum']!, _unitUcumMeta),
      );
    }
    if (data.containsKey('ref_low')) {
      context.handle(
        _refLowMeta,
        refLow.isAcceptableOrUnknown(data['ref_low']!, _refLowMeta),
      );
    }
    if (data.containsKey('ref_high')) {
      context.handle(
        _refHighMeta,
        refHigh.isAcceptableOrUnknown(data['ref_high']!, _refHighMeta),
      );
    }
    if (data.containsKey('local_key')) {
      context.handle(
        _localKeyMeta,
        localKey.isAcceptableOrUnknown(data['local_key']!, _localKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_localKeyMeta);
    }
    if (data.containsKey('stream_key')) {
      context.handle(
        _streamKeyMeta,
        streamKey.isAcceptableOrUnknown(data['stream_key']!, _streamKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_streamKeyMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('amends')) {
      context.handle(
        _amendsMeta,
        amends.isAcceptableOrUnknown(data['amends']!, _amendsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ObservationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObservationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      )!,
      kind: Observation.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      modality: Observation.$convertermodality.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}modality'],
        )!,
      ),
      sourceKind: Observation.$convertersourceKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source_kind'],
        )!,
      ),
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      )!,
      sourceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_record_id'],
      )!,
      extractionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}extraction_id'],
      ),
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}report_id'],
      ),
      pageIx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_ix'],
      ),
      rowIx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_ix'],
      ),
      vendor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor'],
      )!,
      vendorField: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_field'],
      )!,
      sourceClass: Observation.$convertersourceClass.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source_class'],
        )!,
      ),
      derivedFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}derived_from'],
      ),
      memberOf: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_of'],
      ),
      panelText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}panel_text'],
      )!,
      observedStart: Observation.$converterobservedStart.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}observed_start'],
        )!,
      ),
      observedEnd: Observation.$converterobservedEnd.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}observed_end'],
        )!,
      ),
      tz: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tz'],
      )!,
      tzSource: Observation.$convertertzSource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tz_source'],
        )!,
      ),
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      grain: Observation.$convertergrain.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}grain'],
        )!,
      ),
      stat: Observation.$converterstat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}stat'],
        )!,
      ),
      nameText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_text'],
      )!,
      valueText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_text'],
      )!,
      unitText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_text'],
      )!,
      refText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_text'],
      )!,
      flagText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag_text'],
      )!,
      methodText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method_text'],
      )!,
      specimenText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specimen_text'],
      )!,
      noteText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_text'],
      ),
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      valueKind: Observation.$convertervalueKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}value_kind'],
        )!,
      ),
      valueNum: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_num'],
      ),
      valueDecimals: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_decimals'],
      ),
      comparator: Observation.$convertercomparator.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}comparator'],
        )!,
      ),
      valueCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_code'],
      )!,
      dataAbsentReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_absent_reason'],
      )!,
      unitUcum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_ucum'],
      )!,
      refLow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ref_low'],
      ),
      refHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ref_high'],
      ),
      refComparator: Observation.$converterrefComparator.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}ref_comparator'],
        )!,
      ),
      flag: Observation.$converterflag.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}flag'],
        )!,
      ),
      localKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_key'],
      )!,
      streamKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stream_key'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      status: Observation.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      amends: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amends'],
      ),
      createdAt: Observation.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
    );
  }

  @override
  Observation createAlias(String alias) {
    return Observation(attachedDatabase, alias);
  }

  static TypeConverter<ObservationKind, String> $converterkind =
      observationKindConverter;
  static TypeConverter<Modality, String> $convertermodality = modalityConverter;
  static TypeConverter<SourceKind, String> $convertersourceKind =
      sourceKindConverter;
  static TypeConverter<SourceClass, String> $convertersourceClass =
      sourceClassConverter;
  static TypeConverter<DateTime, int> $converterobservedStart =
      utcMillisConverter;
  static TypeConverter<DateTime, int> $converterobservedEnd =
      utcMillisConverter;
  static TypeConverter<TzSource, String> $convertertzSource = tzSourceConverter;
  static TypeConverter<Grain, String> $convertergrain = grainConverter;
  static TypeConverter<Stat, String> $converterstat = statConverter;
  static TypeConverter<ValueKind, String> $convertervalueKind =
      valueKindConverter;
  static TypeConverter<Comparator, String> $convertercomparator =
      comparatorConverter;
  static TypeConverter<Comparator, String> $converterrefComparator =
      comparatorConverter;
  static TypeConverter<Flag, String> $converterflag = flagConverter;
  static TypeConverter<ObservationStatus, String> $converterstatus =
      observationStatusConverter;
  static TypeConverter<DateTime, int> $convertercreatedAt = utcMillisConverter;
  @override
  List<String> get customConstraints => const [
    'CHECK(observed_end >= observed_start)',
    'CHECK(grain <> \'instant\' OR observed_start = observed_end)',
    'CHECK(grain = \'instant\' OR stat <> \'\')',
    'CHECK(value_kind <> \'absent\' OR data_absent_reason <> \'\')',
    'CHECK(value_kind <> \'quantity\' OR value_num IS NOT NULL)',
    'CHECK(modality <> \'derived\' OR derived_from IS NOT NULL)',
    'CHECK(status = \'final\' OR amends IS NOT NULL)',
    'CHECK(ref_low IS NULL OR ref_high IS NULL OR ref_low <= ref_high)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class ObservationRow extends DataClass implements Insertable<ObservationRow> {
  final int id;
  final int personId;

  /// Provenance
  final ObservationKind kind;
  final Modality modality;
  final SourceKind sourceKind;
  final String sourceRef;

  /// Id of the record in its source, '' when it has none.
  final String sourceRecordId;
  final int? extractionId;
  final int? reportId;

  /// Page of the report, counted across its files, starting at 0.
  final int? pageIx;
  final int? rowIx;
  final String vendor;
  final String vendorField;
  final SourceClass sourceClass;

  /// JSON array of observation ids a derived value was computed from.
  final String? derivedFrom;
  final int? memberOf;
  final String panelText;

  /// Time
  final DateTime observedStart;
  final DateTime observedEnd;
  final String tz;
  final TzSource tzSource;

  /// Local day of the reading, derived once when written.
  final String localDate;
  final Grain grain;
  final Stat stat;

  /// As printed, never translated
  final String nameText;
  final String valueText;
  final String unitText;
  final String refText;
  final String flagText;
  final String methodText;
  final String specimenText;
  final String? noteText;

  /// Typed, derived when written
  final String nameKey;
  final ValueKind valueKind;
  final double? valueNum;

  /// Decimal places as printed, to show the value as it was reported.
  final int? valueDecimals;
  final Comparator comparator;
  final String valueCode;
  final String dataAbsentReason;

  /// '' when there is no unit or it did not normalize.
  final String unitUcum;
  final double? refLow;
  final double? refHigh;
  final Comparator refComparator;
  final Flag flag;

  /// Keys and status
  /// name_key|unit_ucum: the series of a reading without a code.
  final String localKey;

  /// local_key|source_kind:vendor: one physical stream, never averaged with others.
  final String streamKey;

  /// Hash over the printed fields and the time; an unchanged re-import writes nothing.
  final String fingerprint;
  final ObservationStatus status;
  final int? amends;
  final DateTime createdAt;
  const ObservationRow({
    required this.id,
    required this.personId,
    required this.kind,
    required this.modality,
    required this.sourceKind,
    required this.sourceRef,
    required this.sourceRecordId,
    this.extractionId,
    this.reportId,
    this.pageIx,
    this.rowIx,
    required this.vendor,
    required this.vendorField,
    required this.sourceClass,
    this.derivedFrom,
    this.memberOf,
    required this.panelText,
    required this.observedStart,
    required this.observedEnd,
    required this.tz,
    required this.tzSource,
    required this.localDate,
    required this.grain,
    required this.stat,
    required this.nameText,
    required this.valueText,
    required this.unitText,
    required this.refText,
    required this.flagText,
    required this.methodText,
    required this.specimenText,
    this.noteText,
    required this.nameKey,
    required this.valueKind,
    this.valueNum,
    this.valueDecimals,
    required this.comparator,
    required this.valueCode,
    required this.dataAbsentReason,
    required this.unitUcum,
    this.refLow,
    this.refHigh,
    required this.refComparator,
    required this.flag,
    required this.localKey,
    required this.streamKey,
    required this.fingerprint,
    required this.status,
    this.amends,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    {
      map['kind'] = Variable<String>(Observation.$converterkind.toSql(kind));
    }
    {
      map['modality'] = Variable<String>(
        Observation.$convertermodality.toSql(modality),
      );
    }
    {
      map['source_kind'] = Variable<String>(
        Observation.$convertersourceKind.toSql(sourceKind),
      );
    }
    map['source_ref'] = Variable<String>(sourceRef);
    map['source_record_id'] = Variable<String>(sourceRecordId);
    if (!nullToAbsent || extractionId != null) {
      map['extraction_id'] = Variable<int>(extractionId);
    }
    if (!nullToAbsent || reportId != null) {
      map['report_id'] = Variable<int>(reportId);
    }
    if (!nullToAbsent || pageIx != null) {
      map['page_ix'] = Variable<int>(pageIx);
    }
    if (!nullToAbsent || rowIx != null) {
      map['row_ix'] = Variable<int>(rowIx);
    }
    map['vendor'] = Variable<String>(vendor);
    map['vendor_field'] = Variable<String>(vendorField);
    {
      map['source_class'] = Variable<String>(
        Observation.$convertersourceClass.toSql(sourceClass),
      );
    }
    if (!nullToAbsent || derivedFrom != null) {
      map['derived_from'] = Variable<String>(derivedFrom);
    }
    if (!nullToAbsent || memberOf != null) {
      map['member_of'] = Variable<int>(memberOf);
    }
    map['panel_text'] = Variable<String>(panelText);
    {
      map['observed_start'] = Variable<int>(
        Observation.$converterobservedStart.toSql(observedStart),
      );
    }
    {
      map['observed_end'] = Variable<int>(
        Observation.$converterobservedEnd.toSql(observedEnd),
      );
    }
    map['tz'] = Variable<String>(tz);
    {
      map['tz_source'] = Variable<String>(
        Observation.$convertertzSource.toSql(tzSource),
      );
    }
    map['local_date'] = Variable<String>(localDate);
    {
      map['grain'] = Variable<String>(Observation.$convertergrain.toSql(grain));
    }
    {
      map['stat'] = Variable<String>(Observation.$converterstat.toSql(stat));
    }
    map['name_text'] = Variable<String>(nameText);
    map['value_text'] = Variable<String>(valueText);
    map['unit_text'] = Variable<String>(unitText);
    map['ref_text'] = Variable<String>(refText);
    map['flag_text'] = Variable<String>(flagText);
    map['method_text'] = Variable<String>(methodText);
    map['specimen_text'] = Variable<String>(specimenText);
    if (!nullToAbsent || noteText != null) {
      map['note_text'] = Variable<String>(noteText);
    }
    map['name_key'] = Variable<String>(nameKey);
    {
      map['value_kind'] = Variable<String>(
        Observation.$convertervalueKind.toSql(valueKind),
      );
    }
    if (!nullToAbsent || valueNum != null) {
      map['value_num'] = Variable<double>(valueNum);
    }
    if (!nullToAbsent || valueDecimals != null) {
      map['value_decimals'] = Variable<int>(valueDecimals);
    }
    {
      map['comparator'] = Variable<String>(
        Observation.$convertercomparator.toSql(comparator),
      );
    }
    map['value_code'] = Variable<String>(valueCode);
    map['data_absent_reason'] = Variable<String>(dataAbsentReason);
    map['unit_ucum'] = Variable<String>(unitUcum);
    if (!nullToAbsent || refLow != null) {
      map['ref_low'] = Variable<double>(refLow);
    }
    if (!nullToAbsent || refHigh != null) {
      map['ref_high'] = Variable<double>(refHigh);
    }
    {
      map['ref_comparator'] = Variable<String>(
        Observation.$converterrefComparator.toSql(refComparator),
      );
    }
    {
      map['flag'] = Variable<String>(Observation.$converterflag.toSql(flag));
    }
    map['local_key'] = Variable<String>(localKey);
    map['stream_key'] = Variable<String>(streamKey);
    map['fingerprint'] = Variable<String>(fingerprint);
    {
      map['status'] = Variable<String>(
        Observation.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || amends != null) {
      map['amends'] = Variable<int>(amends);
    }
    {
      map['created_at'] = Variable<int>(
        Observation.$convertercreatedAt.toSql(createdAt),
      );
    }
    return map;
  }

  ObservationCompanion toCompanion(bool nullToAbsent) {
    return ObservationCompanion(
      id: Value(id),
      personId: Value(personId),
      kind: Value(kind),
      modality: Value(modality),
      sourceKind: Value(sourceKind),
      sourceRef: Value(sourceRef),
      sourceRecordId: Value(sourceRecordId),
      extractionId: extractionId == null && nullToAbsent
          ? const Value.absent()
          : Value(extractionId),
      reportId: reportId == null && nullToAbsent
          ? const Value.absent()
          : Value(reportId),
      pageIx: pageIx == null && nullToAbsent
          ? const Value.absent()
          : Value(pageIx),
      rowIx: rowIx == null && nullToAbsent
          ? const Value.absent()
          : Value(rowIx),
      vendor: Value(vendor),
      vendorField: Value(vendorField),
      sourceClass: Value(sourceClass),
      derivedFrom: derivedFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(derivedFrom),
      memberOf: memberOf == null && nullToAbsent
          ? const Value.absent()
          : Value(memberOf),
      panelText: Value(panelText),
      observedStart: Value(observedStart),
      observedEnd: Value(observedEnd),
      tz: Value(tz),
      tzSource: Value(tzSource),
      localDate: Value(localDate),
      grain: Value(grain),
      stat: Value(stat),
      nameText: Value(nameText),
      valueText: Value(valueText),
      unitText: Value(unitText),
      refText: Value(refText),
      flagText: Value(flagText),
      methodText: Value(methodText),
      specimenText: Value(specimenText),
      noteText: noteText == null && nullToAbsent
          ? const Value.absent()
          : Value(noteText),
      nameKey: Value(nameKey),
      valueKind: Value(valueKind),
      valueNum: valueNum == null && nullToAbsent
          ? const Value.absent()
          : Value(valueNum),
      valueDecimals: valueDecimals == null && nullToAbsent
          ? const Value.absent()
          : Value(valueDecimals),
      comparator: Value(comparator),
      valueCode: Value(valueCode),
      dataAbsentReason: Value(dataAbsentReason),
      unitUcum: Value(unitUcum),
      refLow: refLow == null && nullToAbsent
          ? const Value.absent()
          : Value(refLow),
      refHigh: refHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(refHigh),
      refComparator: Value(refComparator),
      flag: Value(flag),
      localKey: Value(localKey),
      streamKey: Value(streamKey),
      fingerprint: Value(fingerprint),
      status: Value(status),
      amends: amends == null && nullToAbsent
          ? const Value.absent()
          : Value(amends),
      createdAt: Value(createdAt),
    );
  }

  factory ObservationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObservationRow(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['person_id']),
      kind: serializer.fromJson<ObservationKind>(json['kind']),
      modality: serializer.fromJson<Modality>(json['modality']),
      sourceKind: serializer.fromJson<SourceKind>(json['source_kind']),
      sourceRef: serializer.fromJson<String>(json['source_ref']),
      sourceRecordId: serializer.fromJson<String>(json['source_record_id']),
      extractionId: serializer.fromJson<int?>(json['extraction_id']),
      reportId: serializer.fromJson<int?>(json['report_id']),
      pageIx: serializer.fromJson<int?>(json['page_ix']),
      rowIx: serializer.fromJson<int?>(json['row_ix']),
      vendor: serializer.fromJson<String>(json['vendor']),
      vendorField: serializer.fromJson<String>(json['vendor_field']),
      sourceClass: serializer.fromJson<SourceClass>(json['source_class']),
      derivedFrom: serializer.fromJson<String?>(json['derived_from']),
      memberOf: serializer.fromJson<int?>(json['member_of']),
      panelText: serializer.fromJson<String>(json['panel_text']),
      observedStart: serializer.fromJson<DateTime>(json['observed_start']),
      observedEnd: serializer.fromJson<DateTime>(json['observed_end']),
      tz: serializer.fromJson<String>(json['tz']),
      tzSource: serializer.fromJson<TzSource>(json['tz_source']),
      localDate: serializer.fromJson<String>(json['local_date']),
      grain: serializer.fromJson<Grain>(json['grain']),
      stat: serializer.fromJson<Stat>(json['stat']),
      nameText: serializer.fromJson<String>(json['name_text']),
      valueText: serializer.fromJson<String>(json['value_text']),
      unitText: serializer.fromJson<String>(json['unit_text']),
      refText: serializer.fromJson<String>(json['ref_text']),
      flagText: serializer.fromJson<String>(json['flag_text']),
      methodText: serializer.fromJson<String>(json['method_text']),
      specimenText: serializer.fromJson<String>(json['specimen_text']),
      noteText: serializer.fromJson<String?>(json['note_text']),
      nameKey: serializer.fromJson<String>(json['name_key']),
      valueKind: serializer.fromJson<ValueKind>(json['value_kind']),
      valueNum: serializer.fromJson<double?>(json['value_num']),
      valueDecimals: serializer.fromJson<int?>(json['value_decimals']),
      comparator: serializer.fromJson<Comparator>(json['comparator']),
      valueCode: serializer.fromJson<String>(json['value_code']),
      dataAbsentReason: serializer.fromJson<String>(json['data_absent_reason']),
      unitUcum: serializer.fromJson<String>(json['unit_ucum']),
      refLow: serializer.fromJson<double?>(json['ref_low']),
      refHigh: serializer.fromJson<double?>(json['ref_high']),
      refComparator: serializer.fromJson<Comparator>(json['ref_comparator']),
      flag: serializer.fromJson<Flag>(json['flag']),
      localKey: serializer.fromJson<String>(json['local_key']),
      streamKey: serializer.fromJson<String>(json['stream_key']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      status: serializer.fromJson<ObservationStatus>(json['status']),
      amends: serializer.fromJson<int?>(json['amends']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'person_id': serializer.toJson<int>(personId),
      'kind': serializer.toJson<ObservationKind>(kind),
      'modality': serializer.toJson<Modality>(modality),
      'source_kind': serializer.toJson<SourceKind>(sourceKind),
      'source_ref': serializer.toJson<String>(sourceRef),
      'source_record_id': serializer.toJson<String>(sourceRecordId),
      'extraction_id': serializer.toJson<int?>(extractionId),
      'report_id': serializer.toJson<int?>(reportId),
      'page_ix': serializer.toJson<int?>(pageIx),
      'row_ix': serializer.toJson<int?>(rowIx),
      'vendor': serializer.toJson<String>(vendor),
      'vendor_field': serializer.toJson<String>(vendorField),
      'source_class': serializer.toJson<SourceClass>(sourceClass),
      'derived_from': serializer.toJson<String?>(derivedFrom),
      'member_of': serializer.toJson<int?>(memberOf),
      'panel_text': serializer.toJson<String>(panelText),
      'observed_start': serializer.toJson<DateTime>(observedStart),
      'observed_end': serializer.toJson<DateTime>(observedEnd),
      'tz': serializer.toJson<String>(tz),
      'tz_source': serializer.toJson<TzSource>(tzSource),
      'local_date': serializer.toJson<String>(localDate),
      'grain': serializer.toJson<Grain>(grain),
      'stat': serializer.toJson<Stat>(stat),
      'name_text': serializer.toJson<String>(nameText),
      'value_text': serializer.toJson<String>(valueText),
      'unit_text': serializer.toJson<String>(unitText),
      'ref_text': serializer.toJson<String>(refText),
      'flag_text': serializer.toJson<String>(flagText),
      'method_text': serializer.toJson<String>(methodText),
      'specimen_text': serializer.toJson<String>(specimenText),
      'note_text': serializer.toJson<String?>(noteText),
      'name_key': serializer.toJson<String>(nameKey),
      'value_kind': serializer.toJson<ValueKind>(valueKind),
      'value_num': serializer.toJson<double?>(valueNum),
      'value_decimals': serializer.toJson<int?>(valueDecimals),
      'comparator': serializer.toJson<Comparator>(comparator),
      'value_code': serializer.toJson<String>(valueCode),
      'data_absent_reason': serializer.toJson<String>(dataAbsentReason),
      'unit_ucum': serializer.toJson<String>(unitUcum),
      'ref_low': serializer.toJson<double?>(refLow),
      'ref_high': serializer.toJson<double?>(refHigh),
      'ref_comparator': serializer.toJson<Comparator>(refComparator),
      'flag': serializer.toJson<Flag>(flag),
      'local_key': serializer.toJson<String>(localKey),
      'stream_key': serializer.toJson<String>(streamKey),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'status': serializer.toJson<ObservationStatus>(status),
      'amends': serializer.toJson<int?>(amends),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  ObservationRow copyWith({
    int? id,
    int? personId,
    ObservationKind? kind,
    Modality? modality,
    SourceKind? sourceKind,
    String? sourceRef,
    String? sourceRecordId,
    Value<int?> extractionId = const Value.absent(),
    Value<int?> reportId = const Value.absent(),
    Value<int?> pageIx = const Value.absent(),
    Value<int?> rowIx = const Value.absent(),
    String? vendor,
    String? vendorField,
    SourceClass? sourceClass,
    Value<String?> derivedFrom = const Value.absent(),
    Value<int?> memberOf = const Value.absent(),
    String? panelText,
    DateTime? observedStart,
    DateTime? observedEnd,
    String? tz,
    TzSource? tzSource,
    String? localDate,
    Grain? grain,
    Stat? stat,
    String? nameText,
    String? valueText,
    String? unitText,
    String? refText,
    String? flagText,
    String? methodText,
    String? specimenText,
    Value<String?> noteText = const Value.absent(),
    String? nameKey,
    ValueKind? valueKind,
    Value<double?> valueNum = const Value.absent(),
    Value<int?> valueDecimals = const Value.absent(),
    Comparator? comparator,
    String? valueCode,
    String? dataAbsentReason,
    String? unitUcum,
    Value<double?> refLow = const Value.absent(),
    Value<double?> refHigh = const Value.absent(),
    Comparator? refComparator,
    Flag? flag,
    String? localKey,
    String? streamKey,
    String? fingerprint,
    ObservationStatus? status,
    Value<int?> amends = const Value.absent(),
    DateTime? createdAt,
  }) => ObservationRow(
    id: id ?? this.id,
    personId: personId ?? this.personId,
    kind: kind ?? this.kind,
    modality: modality ?? this.modality,
    sourceKind: sourceKind ?? this.sourceKind,
    sourceRef: sourceRef ?? this.sourceRef,
    sourceRecordId: sourceRecordId ?? this.sourceRecordId,
    extractionId: extractionId.present ? extractionId.value : this.extractionId,
    reportId: reportId.present ? reportId.value : this.reportId,
    pageIx: pageIx.present ? pageIx.value : this.pageIx,
    rowIx: rowIx.present ? rowIx.value : this.rowIx,
    vendor: vendor ?? this.vendor,
    vendorField: vendorField ?? this.vendorField,
    sourceClass: sourceClass ?? this.sourceClass,
    derivedFrom: derivedFrom.present ? derivedFrom.value : this.derivedFrom,
    memberOf: memberOf.present ? memberOf.value : this.memberOf,
    panelText: panelText ?? this.panelText,
    observedStart: observedStart ?? this.observedStart,
    observedEnd: observedEnd ?? this.observedEnd,
    tz: tz ?? this.tz,
    tzSource: tzSource ?? this.tzSource,
    localDate: localDate ?? this.localDate,
    grain: grain ?? this.grain,
    stat: stat ?? this.stat,
    nameText: nameText ?? this.nameText,
    valueText: valueText ?? this.valueText,
    unitText: unitText ?? this.unitText,
    refText: refText ?? this.refText,
    flagText: flagText ?? this.flagText,
    methodText: methodText ?? this.methodText,
    specimenText: specimenText ?? this.specimenText,
    noteText: noteText.present ? noteText.value : this.noteText,
    nameKey: nameKey ?? this.nameKey,
    valueKind: valueKind ?? this.valueKind,
    valueNum: valueNum.present ? valueNum.value : this.valueNum,
    valueDecimals: valueDecimals.present
        ? valueDecimals.value
        : this.valueDecimals,
    comparator: comparator ?? this.comparator,
    valueCode: valueCode ?? this.valueCode,
    dataAbsentReason: dataAbsentReason ?? this.dataAbsentReason,
    unitUcum: unitUcum ?? this.unitUcum,
    refLow: refLow.present ? refLow.value : this.refLow,
    refHigh: refHigh.present ? refHigh.value : this.refHigh,
    refComparator: refComparator ?? this.refComparator,
    flag: flag ?? this.flag,
    localKey: localKey ?? this.localKey,
    streamKey: streamKey ?? this.streamKey,
    fingerprint: fingerprint ?? this.fingerprint,
    status: status ?? this.status,
    amends: amends.present ? amends.value : this.amends,
    createdAt: createdAt ?? this.createdAt,
  );
  ObservationRow copyWithCompanion(ObservationCompanion data) {
    return ObservationRow(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      kind: data.kind.present ? data.kind.value : this.kind,
      modality: data.modality.present ? data.modality.value : this.modality,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      sourceRecordId: data.sourceRecordId.present
          ? data.sourceRecordId.value
          : this.sourceRecordId,
      extractionId: data.extractionId.present
          ? data.extractionId.value
          : this.extractionId,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      pageIx: data.pageIx.present ? data.pageIx.value : this.pageIx,
      rowIx: data.rowIx.present ? data.rowIx.value : this.rowIx,
      vendor: data.vendor.present ? data.vendor.value : this.vendor,
      vendorField: data.vendorField.present
          ? data.vendorField.value
          : this.vendorField,
      sourceClass: data.sourceClass.present
          ? data.sourceClass.value
          : this.sourceClass,
      derivedFrom: data.derivedFrom.present
          ? data.derivedFrom.value
          : this.derivedFrom,
      memberOf: data.memberOf.present ? data.memberOf.value : this.memberOf,
      panelText: data.panelText.present ? data.panelText.value : this.panelText,
      observedStart: data.observedStart.present
          ? data.observedStart.value
          : this.observedStart,
      observedEnd: data.observedEnd.present
          ? data.observedEnd.value
          : this.observedEnd,
      tz: data.tz.present ? data.tz.value : this.tz,
      tzSource: data.tzSource.present ? data.tzSource.value : this.tzSource,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      grain: data.grain.present ? data.grain.value : this.grain,
      stat: data.stat.present ? data.stat.value : this.stat,
      nameText: data.nameText.present ? data.nameText.value : this.nameText,
      valueText: data.valueText.present ? data.valueText.value : this.valueText,
      unitText: data.unitText.present ? data.unitText.value : this.unitText,
      refText: data.refText.present ? data.refText.value : this.refText,
      flagText: data.flagText.present ? data.flagText.value : this.flagText,
      methodText: data.methodText.present
          ? data.methodText.value
          : this.methodText,
      specimenText: data.specimenText.present
          ? data.specimenText.value
          : this.specimenText,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      valueKind: data.valueKind.present ? data.valueKind.value : this.valueKind,
      valueNum: data.valueNum.present ? data.valueNum.value : this.valueNum,
      valueDecimals: data.valueDecimals.present
          ? data.valueDecimals.value
          : this.valueDecimals,
      comparator: data.comparator.present
          ? data.comparator.value
          : this.comparator,
      valueCode: data.valueCode.present ? data.valueCode.value : this.valueCode,
      dataAbsentReason: data.dataAbsentReason.present
          ? data.dataAbsentReason.value
          : this.dataAbsentReason,
      unitUcum: data.unitUcum.present ? data.unitUcum.value : this.unitUcum,
      refLow: data.refLow.present ? data.refLow.value : this.refLow,
      refHigh: data.refHigh.present ? data.refHigh.value : this.refHigh,
      refComparator: data.refComparator.present
          ? data.refComparator.value
          : this.refComparator,
      flag: data.flag.present ? data.flag.value : this.flag,
      localKey: data.localKey.present ? data.localKey.value : this.localKey,
      streamKey: data.streamKey.present ? data.streamKey.value : this.streamKey,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      status: data.status.present ? data.status.value : this.status,
      amends: data.amends.present ? data.amends.value : this.amends,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObservationRow(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('kind: $kind, ')
          ..write('modality: $modality, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('extractionId: $extractionId, ')
          ..write('reportId: $reportId, ')
          ..write('pageIx: $pageIx, ')
          ..write('rowIx: $rowIx, ')
          ..write('vendor: $vendor, ')
          ..write('vendorField: $vendorField, ')
          ..write('sourceClass: $sourceClass, ')
          ..write('derivedFrom: $derivedFrom, ')
          ..write('memberOf: $memberOf, ')
          ..write('panelText: $panelText, ')
          ..write('observedStart: $observedStart, ')
          ..write('observedEnd: $observedEnd, ')
          ..write('tz: $tz, ')
          ..write('tzSource: $tzSource, ')
          ..write('localDate: $localDate, ')
          ..write('grain: $grain, ')
          ..write('stat: $stat, ')
          ..write('nameText: $nameText, ')
          ..write('valueText: $valueText, ')
          ..write('unitText: $unitText, ')
          ..write('refText: $refText, ')
          ..write('flagText: $flagText, ')
          ..write('methodText: $methodText, ')
          ..write('specimenText: $specimenText, ')
          ..write('noteText: $noteText, ')
          ..write('nameKey: $nameKey, ')
          ..write('valueKind: $valueKind, ')
          ..write('valueNum: $valueNum, ')
          ..write('valueDecimals: $valueDecimals, ')
          ..write('comparator: $comparator, ')
          ..write('valueCode: $valueCode, ')
          ..write('dataAbsentReason: $dataAbsentReason, ')
          ..write('unitUcum: $unitUcum, ')
          ..write('refLow: $refLow, ')
          ..write('refHigh: $refHigh, ')
          ..write('refComparator: $refComparator, ')
          ..write('flag: $flag, ')
          ..write('localKey: $localKey, ')
          ..write('streamKey: $streamKey, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('status: $status, ')
          ..write('amends: $amends, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    personId,
    kind,
    modality,
    sourceKind,
    sourceRef,
    sourceRecordId,
    extractionId,
    reportId,
    pageIx,
    rowIx,
    vendor,
    vendorField,
    sourceClass,
    derivedFrom,
    memberOf,
    panelText,
    observedStart,
    observedEnd,
    tz,
    tzSource,
    localDate,
    grain,
    stat,
    nameText,
    valueText,
    unitText,
    refText,
    flagText,
    methodText,
    specimenText,
    noteText,
    nameKey,
    valueKind,
    valueNum,
    valueDecimals,
    comparator,
    valueCode,
    dataAbsentReason,
    unitUcum,
    refLow,
    refHigh,
    refComparator,
    flag,
    localKey,
    streamKey,
    fingerprint,
    status,
    amends,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObservationRow &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.kind == this.kind &&
          other.modality == this.modality &&
          other.sourceKind == this.sourceKind &&
          other.sourceRef == this.sourceRef &&
          other.sourceRecordId == this.sourceRecordId &&
          other.extractionId == this.extractionId &&
          other.reportId == this.reportId &&
          other.pageIx == this.pageIx &&
          other.rowIx == this.rowIx &&
          other.vendor == this.vendor &&
          other.vendorField == this.vendorField &&
          other.sourceClass == this.sourceClass &&
          other.derivedFrom == this.derivedFrom &&
          other.memberOf == this.memberOf &&
          other.panelText == this.panelText &&
          other.observedStart == this.observedStart &&
          other.observedEnd == this.observedEnd &&
          other.tz == this.tz &&
          other.tzSource == this.tzSource &&
          other.localDate == this.localDate &&
          other.grain == this.grain &&
          other.stat == this.stat &&
          other.nameText == this.nameText &&
          other.valueText == this.valueText &&
          other.unitText == this.unitText &&
          other.refText == this.refText &&
          other.flagText == this.flagText &&
          other.methodText == this.methodText &&
          other.specimenText == this.specimenText &&
          other.noteText == this.noteText &&
          other.nameKey == this.nameKey &&
          other.valueKind == this.valueKind &&
          other.valueNum == this.valueNum &&
          other.valueDecimals == this.valueDecimals &&
          other.comparator == this.comparator &&
          other.valueCode == this.valueCode &&
          other.dataAbsentReason == this.dataAbsentReason &&
          other.unitUcum == this.unitUcum &&
          other.refLow == this.refLow &&
          other.refHigh == this.refHigh &&
          other.refComparator == this.refComparator &&
          other.flag == this.flag &&
          other.localKey == this.localKey &&
          other.streamKey == this.streamKey &&
          other.fingerprint == this.fingerprint &&
          other.status == this.status &&
          other.amends == this.amends &&
          other.createdAt == this.createdAt);
}

class ObservationCompanion extends UpdateCompanion<ObservationRow> {
  final Value<int> id;
  final Value<int> personId;
  final Value<ObservationKind> kind;
  final Value<Modality> modality;
  final Value<SourceKind> sourceKind;
  final Value<String> sourceRef;
  final Value<String> sourceRecordId;
  final Value<int?> extractionId;
  final Value<int?> reportId;
  final Value<int?> pageIx;
  final Value<int?> rowIx;
  final Value<String> vendor;
  final Value<String> vendorField;
  final Value<SourceClass> sourceClass;
  final Value<String?> derivedFrom;
  final Value<int?> memberOf;
  final Value<String> panelText;
  final Value<DateTime> observedStart;
  final Value<DateTime> observedEnd;
  final Value<String> tz;
  final Value<TzSource> tzSource;
  final Value<String> localDate;
  final Value<Grain> grain;
  final Value<Stat> stat;
  final Value<String> nameText;
  final Value<String> valueText;
  final Value<String> unitText;
  final Value<String> refText;
  final Value<String> flagText;
  final Value<String> methodText;
  final Value<String> specimenText;
  final Value<String?> noteText;
  final Value<String> nameKey;
  final Value<ValueKind> valueKind;
  final Value<double?> valueNum;
  final Value<int?> valueDecimals;
  final Value<Comparator> comparator;
  final Value<String> valueCode;
  final Value<String> dataAbsentReason;
  final Value<String> unitUcum;
  final Value<double?> refLow;
  final Value<double?> refHigh;
  final Value<Comparator> refComparator;
  final Value<Flag> flag;
  final Value<String> localKey;
  final Value<String> streamKey;
  final Value<String> fingerprint;
  final Value<ObservationStatus> status;
  final Value<int?> amends;
  final Value<DateTime> createdAt;
  const ObservationCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.kind = const Value.absent(),
    this.modality = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.sourceRecordId = const Value.absent(),
    this.extractionId = const Value.absent(),
    this.reportId = const Value.absent(),
    this.pageIx = const Value.absent(),
    this.rowIx = const Value.absent(),
    this.vendor = const Value.absent(),
    this.vendorField = const Value.absent(),
    this.sourceClass = const Value.absent(),
    this.derivedFrom = const Value.absent(),
    this.memberOf = const Value.absent(),
    this.panelText = const Value.absent(),
    this.observedStart = const Value.absent(),
    this.observedEnd = const Value.absent(),
    this.tz = const Value.absent(),
    this.tzSource = const Value.absent(),
    this.localDate = const Value.absent(),
    this.grain = const Value.absent(),
    this.stat = const Value.absent(),
    this.nameText = const Value.absent(),
    this.valueText = const Value.absent(),
    this.unitText = const Value.absent(),
    this.refText = const Value.absent(),
    this.flagText = const Value.absent(),
    this.methodText = const Value.absent(),
    this.specimenText = const Value.absent(),
    this.noteText = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.valueKind = const Value.absent(),
    this.valueNum = const Value.absent(),
    this.valueDecimals = const Value.absent(),
    this.comparator = const Value.absent(),
    this.valueCode = const Value.absent(),
    this.dataAbsentReason = const Value.absent(),
    this.unitUcum = const Value.absent(),
    this.refLow = const Value.absent(),
    this.refHigh = const Value.absent(),
    this.refComparator = const Value.absent(),
    this.flag = const Value.absent(),
    this.localKey = const Value.absent(),
    this.streamKey = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.status = const Value.absent(),
    this.amends = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ObservationCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required ObservationKind kind,
    required Modality modality,
    required SourceKind sourceKind,
    required String sourceRef,
    this.sourceRecordId = const Value.absent(),
    this.extractionId = const Value.absent(),
    this.reportId = const Value.absent(),
    this.pageIx = const Value.absent(),
    this.rowIx = const Value.absent(),
    this.vendor = const Value.absent(),
    this.vendorField = const Value.absent(),
    required SourceClass sourceClass,
    this.derivedFrom = const Value.absent(),
    this.memberOf = const Value.absent(),
    this.panelText = const Value.absent(),
    required DateTime observedStart,
    required DateTime observedEnd,
    required String tz,
    required TzSource tzSource,
    required String localDate,
    required Grain grain,
    this.stat = const Value.absent(),
    required String nameText,
    this.valueText = const Value.absent(),
    this.unitText = const Value.absent(),
    this.refText = const Value.absent(),
    this.flagText = const Value.absent(),
    this.methodText = const Value.absent(),
    this.specimenText = const Value.absent(),
    this.noteText = const Value.absent(),
    required String nameKey,
    required ValueKind valueKind,
    this.valueNum = const Value.absent(),
    this.valueDecimals = const Value.absent(),
    this.comparator = const Value.absent(),
    this.valueCode = const Value.absent(),
    this.dataAbsentReason = const Value.absent(),
    this.unitUcum = const Value.absent(),
    this.refLow = const Value.absent(),
    this.refHigh = const Value.absent(),
    this.refComparator = const Value.absent(),
    this.flag = const Value.absent(),
    required String localKey,
    required String streamKey,
    required String fingerprint,
    this.status = const Value.absent(),
    this.amends = const Value.absent(),
    required DateTime createdAt,
  }) : personId = Value(personId),
       kind = Value(kind),
       modality = Value(modality),
       sourceKind = Value(sourceKind),
       sourceRef = Value(sourceRef),
       sourceClass = Value(sourceClass),
       observedStart = Value(observedStart),
       observedEnd = Value(observedEnd),
       tz = Value(tz),
       tzSource = Value(tzSource),
       localDate = Value(localDate),
       grain = Value(grain),
       nameText = Value(nameText),
       nameKey = Value(nameKey),
       valueKind = Value(valueKind),
       localKey = Value(localKey),
       streamKey = Value(streamKey),
       fingerprint = Value(fingerprint),
       createdAt = Value(createdAt);
  static Insertable<ObservationRow> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<String>? kind,
    Expression<String>? modality,
    Expression<String>? sourceKind,
    Expression<String>? sourceRef,
    Expression<String>? sourceRecordId,
    Expression<int>? extractionId,
    Expression<int>? reportId,
    Expression<int>? pageIx,
    Expression<int>? rowIx,
    Expression<String>? vendor,
    Expression<String>? vendorField,
    Expression<String>? sourceClass,
    Expression<String>? derivedFrom,
    Expression<int>? memberOf,
    Expression<String>? panelText,
    Expression<int>? observedStart,
    Expression<int>? observedEnd,
    Expression<String>? tz,
    Expression<String>? tzSource,
    Expression<String>? localDate,
    Expression<String>? grain,
    Expression<String>? stat,
    Expression<String>? nameText,
    Expression<String>? valueText,
    Expression<String>? unitText,
    Expression<String>? refText,
    Expression<String>? flagText,
    Expression<String>? methodText,
    Expression<String>? specimenText,
    Expression<String>? noteText,
    Expression<String>? nameKey,
    Expression<String>? valueKind,
    Expression<double>? valueNum,
    Expression<int>? valueDecimals,
    Expression<String>? comparator,
    Expression<String>? valueCode,
    Expression<String>? dataAbsentReason,
    Expression<String>? unitUcum,
    Expression<double>? refLow,
    Expression<double>? refHigh,
    Expression<String>? refComparator,
    Expression<String>? flag,
    Expression<String>? localKey,
    Expression<String>? streamKey,
    Expression<String>? fingerprint,
    Expression<String>? status,
    Expression<int>? amends,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (kind != null) 'kind': kind,
      if (modality != null) 'modality': modality,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (sourceRecordId != null) 'source_record_id': sourceRecordId,
      if (extractionId != null) 'extraction_id': extractionId,
      if (reportId != null) 'report_id': reportId,
      if (pageIx != null) 'page_ix': pageIx,
      if (rowIx != null) 'row_ix': rowIx,
      if (vendor != null) 'vendor': vendor,
      if (vendorField != null) 'vendor_field': vendorField,
      if (sourceClass != null) 'source_class': sourceClass,
      if (derivedFrom != null) 'derived_from': derivedFrom,
      if (memberOf != null) 'member_of': memberOf,
      if (panelText != null) 'panel_text': panelText,
      if (observedStart != null) 'observed_start': observedStart,
      if (observedEnd != null) 'observed_end': observedEnd,
      if (tz != null) 'tz': tz,
      if (tzSource != null) 'tz_source': tzSource,
      if (localDate != null) 'local_date': localDate,
      if (grain != null) 'grain': grain,
      if (stat != null) 'stat': stat,
      if (nameText != null) 'name_text': nameText,
      if (valueText != null) 'value_text': valueText,
      if (unitText != null) 'unit_text': unitText,
      if (refText != null) 'ref_text': refText,
      if (flagText != null) 'flag_text': flagText,
      if (methodText != null) 'method_text': methodText,
      if (specimenText != null) 'specimen_text': specimenText,
      if (noteText != null) 'note_text': noteText,
      if (nameKey != null) 'name_key': nameKey,
      if (valueKind != null) 'value_kind': valueKind,
      if (valueNum != null) 'value_num': valueNum,
      if (valueDecimals != null) 'value_decimals': valueDecimals,
      if (comparator != null) 'comparator': comparator,
      if (valueCode != null) 'value_code': valueCode,
      if (dataAbsentReason != null) 'data_absent_reason': dataAbsentReason,
      if (unitUcum != null) 'unit_ucum': unitUcum,
      if (refLow != null) 'ref_low': refLow,
      if (refHigh != null) 'ref_high': refHigh,
      if (refComparator != null) 'ref_comparator': refComparator,
      if (flag != null) 'flag': flag,
      if (localKey != null) 'local_key': localKey,
      if (streamKey != null) 'stream_key': streamKey,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (status != null) 'status': status,
      if (amends != null) 'amends': amends,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ObservationCompanion copyWith({
    Value<int>? id,
    Value<int>? personId,
    Value<ObservationKind>? kind,
    Value<Modality>? modality,
    Value<SourceKind>? sourceKind,
    Value<String>? sourceRef,
    Value<String>? sourceRecordId,
    Value<int?>? extractionId,
    Value<int?>? reportId,
    Value<int?>? pageIx,
    Value<int?>? rowIx,
    Value<String>? vendor,
    Value<String>? vendorField,
    Value<SourceClass>? sourceClass,
    Value<String?>? derivedFrom,
    Value<int?>? memberOf,
    Value<String>? panelText,
    Value<DateTime>? observedStart,
    Value<DateTime>? observedEnd,
    Value<String>? tz,
    Value<TzSource>? tzSource,
    Value<String>? localDate,
    Value<Grain>? grain,
    Value<Stat>? stat,
    Value<String>? nameText,
    Value<String>? valueText,
    Value<String>? unitText,
    Value<String>? refText,
    Value<String>? flagText,
    Value<String>? methodText,
    Value<String>? specimenText,
    Value<String?>? noteText,
    Value<String>? nameKey,
    Value<ValueKind>? valueKind,
    Value<double?>? valueNum,
    Value<int?>? valueDecimals,
    Value<Comparator>? comparator,
    Value<String>? valueCode,
    Value<String>? dataAbsentReason,
    Value<String>? unitUcum,
    Value<double?>? refLow,
    Value<double?>? refHigh,
    Value<Comparator>? refComparator,
    Value<Flag>? flag,
    Value<String>? localKey,
    Value<String>? streamKey,
    Value<String>? fingerprint,
    Value<ObservationStatus>? status,
    Value<int?>? amends,
    Value<DateTime>? createdAt,
  }) {
    return ObservationCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      kind: kind ?? this.kind,
      modality: modality ?? this.modality,
      sourceKind: sourceKind ?? this.sourceKind,
      sourceRef: sourceRef ?? this.sourceRef,
      sourceRecordId: sourceRecordId ?? this.sourceRecordId,
      extractionId: extractionId ?? this.extractionId,
      reportId: reportId ?? this.reportId,
      pageIx: pageIx ?? this.pageIx,
      rowIx: rowIx ?? this.rowIx,
      vendor: vendor ?? this.vendor,
      vendorField: vendorField ?? this.vendorField,
      sourceClass: sourceClass ?? this.sourceClass,
      derivedFrom: derivedFrom ?? this.derivedFrom,
      memberOf: memberOf ?? this.memberOf,
      panelText: panelText ?? this.panelText,
      observedStart: observedStart ?? this.observedStart,
      observedEnd: observedEnd ?? this.observedEnd,
      tz: tz ?? this.tz,
      tzSource: tzSource ?? this.tzSource,
      localDate: localDate ?? this.localDate,
      grain: grain ?? this.grain,
      stat: stat ?? this.stat,
      nameText: nameText ?? this.nameText,
      valueText: valueText ?? this.valueText,
      unitText: unitText ?? this.unitText,
      refText: refText ?? this.refText,
      flagText: flagText ?? this.flagText,
      methodText: methodText ?? this.methodText,
      specimenText: specimenText ?? this.specimenText,
      noteText: noteText ?? this.noteText,
      nameKey: nameKey ?? this.nameKey,
      valueKind: valueKind ?? this.valueKind,
      valueNum: valueNum ?? this.valueNum,
      valueDecimals: valueDecimals ?? this.valueDecimals,
      comparator: comparator ?? this.comparator,
      valueCode: valueCode ?? this.valueCode,
      dataAbsentReason: dataAbsentReason ?? this.dataAbsentReason,
      unitUcum: unitUcum ?? this.unitUcum,
      refLow: refLow ?? this.refLow,
      refHigh: refHigh ?? this.refHigh,
      refComparator: refComparator ?? this.refComparator,
      flag: flag ?? this.flag,
      localKey: localKey ?? this.localKey,
      streamKey: streamKey ?? this.streamKey,
      fingerprint: fingerprint ?? this.fingerprint,
      status: status ?? this.status,
      amends: amends ?? this.amends,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        Observation.$converterkind.toSql(kind.value),
      );
    }
    if (modality.present) {
      map['modality'] = Variable<String>(
        Observation.$convertermodality.toSql(modality.value),
      );
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(
        Observation.$convertersourceKind.toSql(sourceKind.value),
      );
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (sourceRecordId.present) {
      map['source_record_id'] = Variable<String>(sourceRecordId.value);
    }
    if (extractionId.present) {
      map['extraction_id'] = Variable<int>(extractionId.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<int>(reportId.value);
    }
    if (pageIx.present) {
      map['page_ix'] = Variable<int>(pageIx.value);
    }
    if (rowIx.present) {
      map['row_ix'] = Variable<int>(rowIx.value);
    }
    if (vendor.present) {
      map['vendor'] = Variable<String>(vendor.value);
    }
    if (vendorField.present) {
      map['vendor_field'] = Variable<String>(vendorField.value);
    }
    if (sourceClass.present) {
      map['source_class'] = Variable<String>(
        Observation.$convertersourceClass.toSql(sourceClass.value),
      );
    }
    if (derivedFrom.present) {
      map['derived_from'] = Variable<String>(derivedFrom.value);
    }
    if (memberOf.present) {
      map['member_of'] = Variable<int>(memberOf.value);
    }
    if (panelText.present) {
      map['panel_text'] = Variable<String>(panelText.value);
    }
    if (observedStart.present) {
      map['observed_start'] = Variable<int>(
        Observation.$converterobservedStart.toSql(observedStart.value),
      );
    }
    if (observedEnd.present) {
      map['observed_end'] = Variable<int>(
        Observation.$converterobservedEnd.toSql(observedEnd.value),
      );
    }
    if (tz.present) {
      map['tz'] = Variable<String>(tz.value);
    }
    if (tzSource.present) {
      map['tz_source'] = Variable<String>(
        Observation.$convertertzSource.toSql(tzSource.value),
      );
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (grain.present) {
      map['grain'] = Variable<String>(
        Observation.$convertergrain.toSql(grain.value),
      );
    }
    if (stat.present) {
      map['stat'] = Variable<String>(
        Observation.$converterstat.toSql(stat.value),
      );
    }
    if (nameText.present) {
      map['name_text'] = Variable<String>(nameText.value);
    }
    if (valueText.present) {
      map['value_text'] = Variable<String>(valueText.value);
    }
    if (unitText.present) {
      map['unit_text'] = Variable<String>(unitText.value);
    }
    if (refText.present) {
      map['ref_text'] = Variable<String>(refText.value);
    }
    if (flagText.present) {
      map['flag_text'] = Variable<String>(flagText.value);
    }
    if (methodText.present) {
      map['method_text'] = Variable<String>(methodText.value);
    }
    if (specimenText.present) {
      map['specimen_text'] = Variable<String>(specimenText.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (valueKind.present) {
      map['value_kind'] = Variable<String>(
        Observation.$convertervalueKind.toSql(valueKind.value),
      );
    }
    if (valueNum.present) {
      map['value_num'] = Variable<double>(valueNum.value);
    }
    if (valueDecimals.present) {
      map['value_decimals'] = Variable<int>(valueDecimals.value);
    }
    if (comparator.present) {
      map['comparator'] = Variable<String>(
        Observation.$convertercomparator.toSql(comparator.value),
      );
    }
    if (valueCode.present) {
      map['value_code'] = Variable<String>(valueCode.value);
    }
    if (dataAbsentReason.present) {
      map['data_absent_reason'] = Variable<String>(dataAbsentReason.value);
    }
    if (unitUcum.present) {
      map['unit_ucum'] = Variable<String>(unitUcum.value);
    }
    if (refLow.present) {
      map['ref_low'] = Variable<double>(refLow.value);
    }
    if (refHigh.present) {
      map['ref_high'] = Variable<double>(refHigh.value);
    }
    if (refComparator.present) {
      map['ref_comparator'] = Variable<String>(
        Observation.$converterrefComparator.toSql(refComparator.value),
      );
    }
    if (flag.present) {
      map['flag'] = Variable<String>(
        Observation.$converterflag.toSql(flag.value),
      );
    }
    if (localKey.present) {
      map['local_key'] = Variable<String>(localKey.value);
    }
    if (streamKey.present) {
      map['stream_key'] = Variable<String>(streamKey.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        Observation.$converterstatus.toSql(status.value),
      );
    }
    if (amends.present) {
      map['amends'] = Variable<int>(amends.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        Observation.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObservationCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('kind: $kind, ')
          ..write('modality: $modality, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('extractionId: $extractionId, ')
          ..write('reportId: $reportId, ')
          ..write('pageIx: $pageIx, ')
          ..write('rowIx: $rowIx, ')
          ..write('vendor: $vendor, ')
          ..write('vendorField: $vendorField, ')
          ..write('sourceClass: $sourceClass, ')
          ..write('derivedFrom: $derivedFrom, ')
          ..write('memberOf: $memberOf, ')
          ..write('panelText: $panelText, ')
          ..write('observedStart: $observedStart, ')
          ..write('observedEnd: $observedEnd, ')
          ..write('tz: $tz, ')
          ..write('tzSource: $tzSource, ')
          ..write('localDate: $localDate, ')
          ..write('grain: $grain, ')
          ..write('stat: $stat, ')
          ..write('nameText: $nameText, ')
          ..write('valueText: $valueText, ')
          ..write('unitText: $unitText, ')
          ..write('refText: $refText, ')
          ..write('flagText: $flagText, ')
          ..write('methodText: $methodText, ')
          ..write('specimenText: $specimenText, ')
          ..write('noteText: $noteText, ')
          ..write('nameKey: $nameKey, ')
          ..write('valueKind: $valueKind, ')
          ..write('valueNum: $valueNum, ')
          ..write('valueDecimals: $valueDecimals, ')
          ..write('comparator: $comparator, ')
          ..write('valueCode: $valueCode, ')
          ..write('dataAbsentReason: $dataAbsentReason, ')
          ..write('unitUcum: $unitUcum, ')
          ..write('refLow: $refLow, ')
          ..write('refHigh: $refHigh, ')
          ..write('refComparator: $refComparator, ')
          ..write('flag: $flag, ')
          ..write('localKey: $localKey, ')
          ..write('streamKey: $streamKey, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('status: $status, ')
          ..write('amends: $amends, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class SourceFile extends Table with TableInfo<SourceFile, SourceFileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SourceFile(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES person(id)',
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  late final GeneratedColumn<int> reportId = GeneratedColumn<int>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES report(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (position >= 0)',
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(content_hash) = 64)',
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (byte_size >= 0)',
  );
  static const VerificationMeta _storedPathMeta = const VerificationMeta(
    'storedPath',
  );
  late final GeneratedColumn<String> storedPath = GeneratedColumn<String>(
    'stored_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumnWithTypeConverter<FileKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        $customConstraints:
            'NOT NULL CHECK (kind IN (\'pdf\', \'image\', \'other\'))',
      ).withConverter<FileKind>(SourceFile.$converterkind);
  late final GeneratedColumnWithTypeConverter<ImportChannel, String>
  importChannel = GeneratedColumn<String>(
    'import_channel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (import_channel IN (\'file-picker\', \'drag-drop\', \'camera\', \'gallery\', \'share\'))',
  ).withConverter<ImportChannel>(SourceFile.$converterimportChannel);
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (page_count IS NULL OR page_count > 0)',
  );
  late final GeneratedColumnWithTypeConverter<DateTime, int> importedAt =
      GeneratedColumn<int>(
        'imported_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      ).withConverter<DateTime>(SourceFile.$converterimportedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personId,
    reportId,
    position,
    contentHash,
    fileName,
    mimeType,
    byteSize,
    storedPath,
    kind,
    importChannel,
    pageCount,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_file';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceFileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('stored_path')) {
      context.handle(
        _storedPathMeta,
        storedPath.isAcceptableOrUnknown(data['stored_path']!, _storedPathMeta),
      );
    } else if (isInserting) {
      context.missing(_storedPathMeta);
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {personId, contentHash},
    {reportId, position},
  ];
  @override
  SourceFileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceFileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      )!,
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}report_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      storedPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stored_path'],
      )!,
      kind: SourceFile.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      importChannel: SourceFile.$converterimportChannel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}import_channel'],
        )!,
      ),
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      importedAt: SourceFile.$converterimportedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}imported_at'],
        )!,
      ),
    );
  }

  @override
  SourceFile createAlias(String alias) {
    return SourceFile(attachedDatabase, alias);
  }

  static TypeConverter<FileKind, String> $converterkind = fileKindConverter;
  static TypeConverter<ImportChannel, String> $converterimportChannel =
      importChannelConverter;
  static TypeConverter<DateTime, int> $converterimportedAt = utcMillisConverter;
  @override
  List<String> get customConstraints => const [
    'UNIQUE(person_id, content_hash)',
    'UNIQUE(report_id, position)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class SourceFileRow extends DataClass implements Insertable<SourceFileRow> {
  final int id;
  final int personId;
  final int reportId;

  /// Order of the file within its report, starting at 0.
  final int position;
  final String contentHash;
  final String fileName;
  final String mimeType;
  final int byteSize;

  /// Path relative to the app data directory.
  final String storedPath;
  final FileKind kind;
  final ImportChannel importChannel;
  final int? pageCount;
  final DateTime importedAt;
  const SourceFileRow({
    required this.id,
    required this.personId,
    required this.reportId,
    required this.position,
    required this.contentHash,
    required this.fileName,
    required this.mimeType,
    required this.byteSize,
    required this.storedPath,
    required this.kind,
    required this.importChannel,
    this.pageCount,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    map['report_id'] = Variable<int>(reportId);
    map['position'] = Variable<int>(position);
    map['content_hash'] = Variable<String>(contentHash);
    map['file_name'] = Variable<String>(fileName);
    map['mime_type'] = Variable<String>(mimeType);
    map['byte_size'] = Variable<int>(byteSize);
    map['stored_path'] = Variable<String>(storedPath);
    {
      map['kind'] = Variable<String>(SourceFile.$converterkind.toSql(kind));
    }
    {
      map['import_channel'] = Variable<String>(
        SourceFile.$converterimportChannel.toSql(importChannel),
      );
    }
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    {
      map['imported_at'] = Variable<int>(
        SourceFile.$converterimportedAt.toSql(importedAt),
      );
    }
    return map;
  }

  SourceFileCompanion toCompanion(bool nullToAbsent) {
    return SourceFileCompanion(
      id: Value(id),
      personId: Value(personId),
      reportId: Value(reportId),
      position: Value(position),
      contentHash: Value(contentHash),
      fileName: Value(fileName),
      mimeType: Value(mimeType),
      byteSize: Value(byteSize),
      storedPath: Value(storedPath),
      kind: Value(kind),
      importChannel: Value(importChannel),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      importedAt: Value(importedAt),
    );
  }

  factory SourceFileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceFileRow(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['person_id']),
      reportId: serializer.fromJson<int>(json['report_id']),
      position: serializer.fromJson<int>(json['position']),
      contentHash: serializer.fromJson<String>(json['content_hash']),
      fileName: serializer.fromJson<String>(json['file_name']),
      mimeType: serializer.fromJson<String>(json['mime_type']),
      byteSize: serializer.fromJson<int>(json['byte_size']),
      storedPath: serializer.fromJson<String>(json['stored_path']),
      kind: serializer.fromJson<FileKind>(json['kind']),
      importChannel: serializer.fromJson<ImportChannel>(json['import_channel']),
      pageCount: serializer.fromJson<int?>(json['page_count']),
      importedAt: serializer.fromJson<DateTime>(json['imported_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'person_id': serializer.toJson<int>(personId),
      'report_id': serializer.toJson<int>(reportId),
      'position': serializer.toJson<int>(position),
      'content_hash': serializer.toJson<String>(contentHash),
      'file_name': serializer.toJson<String>(fileName),
      'mime_type': serializer.toJson<String>(mimeType),
      'byte_size': serializer.toJson<int>(byteSize),
      'stored_path': serializer.toJson<String>(storedPath),
      'kind': serializer.toJson<FileKind>(kind),
      'import_channel': serializer.toJson<ImportChannel>(importChannel),
      'page_count': serializer.toJson<int?>(pageCount),
      'imported_at': serializer.toJson<DateTime>(importedAt),
    };
  }

  SourceFileRow copyWith({
    int? id,
    int? personId,
    int? reportId,
    int? position,
    String? contentHash,
    String? fileName,
    String? mimeType,
    int? byteSize,
    String? storedPath,
    FileKind? kind,
    ImportChannel? importChannel,
    Value<int?> pageCount = const Value.absent(),
    DateTime? importedAt,
  }) => SourceFileRow(
    id: id ?? this.id,
    personId: personId ?? this.personId,
    reportId: reportId ?? this.reportId,
    position: position ?? this.position,
    contentHash: contentHash ?? this.contentHash,
    fileName: fileName ?? this.fileName,
    mimeType: mimeType ?? this.mimeType,
    byteSize: byteSize ?? this.byteSize,
    storedPath: storedPath ?? this.storedPath,
    kind: kind ?? this.kind,
    importChannel: importChannel ?? this.importChannel,
    pageCount: pageCount.present ? pageCount.value : this.pageCount,
    importedAt: importedAt ?? this.importedAt,
  );
  SourceFileRow copyWithCompanion(SourceFileCompanion data) {
    return SourceFileRow(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      position: data.position.present ? data.position.value : this.position,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      storedPath: data.storedPath.present
          ? data.storedPath.value
          : this.storedPath,
      kind: data.kind.present ? data.kind.value : this.kind,
      importChannel: data.importChannel.present
          ? data.importChannel.value
          : this.importChannel,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceFileRow(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('reportId: $reportId, ')
          ..write('position: $position, ')
          ..write('contentHash: $contentHash, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('storedPath: $storedPath, ')
          ..write('kind: $kind, ')
          ..write('importChannel: $importChannel, ')
          ..write('pageCount: $pageCount, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personId,
    reportId,
    position,
    contentHash,
    fileName,
    mimeType,
    byteSize,
    storedPath,
    kind,
    importChannel,
    pageCount,
    importedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceFileRow &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.reportId == this.reportId &&
          other.position == this.position &&
          other.contentHash == this.contentHash &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.byteSize == this.byteSize &&
          other.storedPath == this.storedPath &&
          other.kind == this.kind &&
          other.importChannel == this.importChannel &&
          other.pageCount == this.pageCount &&
          other.importedAt == this.importedAt);
}

class SourceFileCompanion extends UpdateCompanion<SourceFileRow> {
  final Value<int> id;
  final Value<int> personId;
  final Value<int> reportId;
  final Value<int> position;
  final Value<String> contentHash;
  final Value<String> fileName;
  final Value<String> mimeType;
  final Value<int> byteSize;
  final Value<String> storedPath;
  final Value<FileKind> kind;
  final Value<ImportChannel> importChannel;
  final Value<int?> pageCount;
  final Value<DateTime> importedAt;
  const SourceFileCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.reportId = const Value.absent(),
    this.position = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.storedPath = const Value.absent(),
    this.kind = const Value.absent(),
    this.importChannel = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.importedAt = const Value.absent(),
  });
  SourceFileCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required int reportId,
    required int position,
    required String contentHash,
    required String fileName,
    required String mimeType,
    required int byteSize,
    required String storedPath,
    required FileKind kind,
    required ImportChannel importChannel,
    this.pageCount = const Value.absent(),
    required DateTime importedAt,
  }) : personId = Value(personId),
       reportId = Value(reportId),
       position = Value(position),
       contentHash = Value(contentHash),
       fileName = Value(fileName),
       mimeType = Value(mimeType),
       byteSize = Value(byteSize),
       storedPath = Value(storedPath),
       kind = Value(kind),
       importChannel = Value(importChannel),
       importedAt = Value(importedAt);
  static Insertable<SourceFileRow> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<int>? reportId,
    Expression<int>? position,
    Expression<String>? contentHash,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<int>? byteSize,
    Expression<String>? storedPath,
    Expression<String>? kind,
    Expression<String>? importChannel,
    Expression<int>? pageCount,
    Expression<int>? importedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (reportId != null) 'report_id': reportId,
      if (position != null) 'position': position,
      if (contentHash != null) 'content_hash': contentHash,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (byteSize != null) 'byte_size': byteSize,
      if (storedPath != null) 'stored_path': storedPath,
      if (kind != null) 'kind': kind,
      if (importChannel != null) 'import_channel': importChannel,
      if (pageCount != null) 'page_count': pageCount,
      if (importedAt != null) 'imported_at': importedAt,
    });
  }

  SourceFileCompanion copyWith({
    Value<int>? id,
    Value<int>? personId,
    Value<int>? reportId,
    Value<int>? position,
    Value<String>? contentHash,
    Value<String>? fileName,
    Value<String>? mimeType,
    Value<int>? byteSize,
    Value<String>? storedPath,
    Value<FileKind>? kind,
    Value<ImportChannel>? importChannel,
    Value<int?>? pageCount,
    Value<DateTime>? importedAt,
  }) {
    return SourceFileCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      reportId: reportId ?? this.reportId,
      position: position ?? this.position,
      contentHash: contentHash ?? this.contentHash,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      storedPath: storedPath ?? this.storedPath,
      kind: kind ?? this.kind,
      importChannel: importChannel ?? this.importChannel,
      pageCount: pageCount ?? this.pageCount,
      importedAt: importedAt ?? this.importedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<int>(reportId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (storedPath.present) {
      map['stored_path'] = Variable<String>(storedPath.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        SourceFile.$converterkind.toSql(kind.value),
      );
    }
    if (importChannel.present) {
      map['import_channel'] = Variable<String>(
        SourceFile.$converterimportChannel.toSql(importChannel.value),
      );
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<int>(
        SourceFile.$converterimportedAt.toSql(importedAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceFileCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('reportId: $reportId, ')
          ..write('position: $position, ')
          ..write('contentHash: $contentHash, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('storedPath: $storedPath, ')
          ..write('kind: $kind, ')
          ..write('importChannel: $importChannel, ')
          ..write('pageCount: $pageCount, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }
}

class SourcePage extends Table with TableInfo<SourcePage, SourcePageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SourcePage(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourceFileIdMeta = const VerificationMeta(
    'sourceFileId',
  );
  late final GeneratedColumn<int> sourceFileId = GeneratedColumn<int>(
    'source_file_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES source_file(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _pageIxMeta = const VerificationMeta('pageIx');
  late final GeneratedColumn<int> pageIx = GeneratedColumn<int>(
    'page_ix',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (page_ix >= 0)',
  );
  static const VerificationMeta _textOriginMeta = const VerificationMeta(
    'textOrigin',
  );
  late final GeneratedColumn<String> textOrigin = GeneratedColumn<String>(
    'text_origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (text_origin <> \'\')',
  );
  static const VerificationMeta _markdownMeta = const VerificationMeta(
    'markdown',
  );
  late final GeneratedColumn<String> markdown = GeneratedColumn<String>(
    'markdown',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _tablesHtmlMeta = const VerificationMeta(
    'tablesHtml',
  );
  late final GeneratedColumn<String> tablesHtml = GeneratedColumn<String>(
    'tables_html',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      ).withConverter<DateTime>(SourcePage.$convertercreatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    sourceFileId,
    pageIx,
    textOrigin,
    markdown,
    tablesHtml,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_page';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourcePageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source_file_id')) {
      context.handle(
        _sourceFileIdMeta,
        sourceFileId.isAcceptableOrUnknown(
          data['source_file_id']!,
          _sourceFileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceFileIdMeta);
    }
    if (data.containsKey('page_ix')) {
      context.handle(
        _pageIxMeta,
        pageIx.isAcceptableOrUnknown(data['page_ix']!, _pageIxMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIxMeta);
    }
    if (data.containsKey('text_origin')) {
      context.handle(
        _textOriginMeta,
        textOrigin.isAcceptableOrUnknown(data['text_origin']!, _textOriginMeta),
      );
    } else if (isInserting) {
      context.missing(_textOriginMeta);
    }
    if (data.containsKey('markdown')) {
      context.handle(
        _markdownMeta,
        markdown.isAcceptableOrUnknown(data['markdown']!, _markdownMeta),
      );
    } else if (isInserting) {
      context.missing(_markdownMeta);
    }
    if (data.containsKey('tables_html')) {
      context.handle(
        _tablesHtmlMeta,
        tablesHtml.isAcceptableOrUnknown(data['tables_html']!, _tablesHtmlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sourceFileId, pageIx, textOrigin};
  @override
  SourcePageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourcePageRow(
      sourceFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_file_id'],
      )!,
      pageIx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_ix'],
      )!,
      textOrigin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_origin'],
      )!,
      markdown: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}markdown'],
      )!,
      tablesHtml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tables_html'],
      )!,
      createdAt: SourcePage.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
    );
  }

  @override
  SourcePage createAlias(String alias) {
    return SourcePage(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt = utcMillisConverter;
  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(source_file_id, page_ix, text_origin)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class SourcePageRow extends DataClass implements Insertable<SourcePageRow> {
  final int sourceFileId;

  /// Page within the file, starting at 0.
  final int pageIx;

  /// e.g. 'text-layer', 'ocr:mistral:<model>'.
  final String textOrigin;

  /// Recognized text as Markdown.
  final String markdown;
  final String tablesHtml;
  final DateTime createdAt;
  const SourcePageRow({
    required this.sourceFileId,
    required this.pageIx,
    required this.textOrigin,
    required this.markdown,
    required this.tablesHtml,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source_file_id'] = Variable<int>(sourceFileId);
    map['page_ix'] = Variable<int>(pageIx);
    map['text_origin'] = Variable<String>(textOrigin);
    map['markdown'] = Variable<String>(markdown);
    map['tables_html'] = Variable<String>(tablesHtml);
    {
      map['created_at'] = Variable<int>(
        SourcePage.$convertercreatedAt.toSql(createdAt),
      );
    }
    return map;
  }

  SourcePageCompanion toCompanion(bool nullToAbsent) {
    return SourcePageCompanion(
      sourceFileId: Value(sourceFileId),
      pageIx: Value(pageIx),
      textOrigin: Value(textOrigin),
      markdown: Value(markdown),
      tablesHtml: Value(tablesHtml),
      createdAt: Value(createdAt),
    );
  }

  factory SourcePageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourcePageRow(
      sourceFileId: serializer.fromJson<int>(json['source_file_id']),
      pageIx: serializer.fromJson<int>(json['page_ix']),
      textOrigin: serializer.fromJson<String>(json['text_origin']),
      markdown: serializer.fromJson<String>(json['markdown']),
      tablesHtml: serializer.fromJson<String>(json['tables_html']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'source_file_id': serializer.toJson<int>(sourceFileId),
      'page_ix': serializer.toJson<int>(pageIx),
      'text_origin': serializer.toJson<String>(textOrigin),
      'markdown': serializer.toJson<String>(markdown),
      'tables_html': serializer.toJson<String>(tablesHtml),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  SourcePageRow copyWith({
    int? sourceFileId,
    int? pageIx,
    String? textOrigin,
    String? markdown,
    String? tablesHtml,
    DateTime? createdAt,
  }) => SourcePageRow(
    sourceFileId: sourceFileId ?? this.sourceFileId,
    pageIx: pageIx ?? this.pageIx,
    textOrigin: textOrigin ?? this.textOrigin,
    markdown: markdown ?? this.markdown,
    tablesHtml: tablesHtml ?? this.tablesHtml,
    createdAt: createdAt ?? this.createdAt,
  );
  SourcePageRow copyWithCompanion(SourcePageCompanion data) {
    return SourcePageRow(
      sourceFileId: data.sourceFileId.present
          ? data.sourceFileId.value
          : this.sourceFileId,
      pageIx: data.pageIx.present ? data.pageIx.value : this.pageIx,
      textOrigin: data.textOrigin.present
          ? data.textOrigin.value
          : this.textOrigin,
      markdown: data.markdown.present ? data.markdown.value : this.markdown,
      tablesHtml: data.tablesHtml.present
          ? data.tablesHtml.value
          : this.tablesHtml,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourcePageRow(')
          ..write('sourceFileId: $sourceFileId, ')
          ..write('pageIx: $pageIx, ')
          ..write('textOrigin: $textOrigin, ')
          ..write('markdown: $markdown, ')
          ..write('tablesHtml: $tablesHtml, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sourceFileId,
    pageIx,
    textOrigin,
    markdown,
    tablesHtml,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourcePageRow &&
          other.sourceFileId == this.sourceFileId &&
          other.pageIx == this.pageIx &&
          other.textOrigin == this.textOrigin &&
          other.markdown == this.markdown &&
          other.tablesHtml == this.tablesHtml &&
          other.createdAt == this.createdAt);
}

class SourcePageCompanion extends UpdateCompanion<SourcePageRow> {
  final Value<int> sourceFileId;
  final Value<int> pageIx;
  final Value<String> textOrigin;
  final Value<String> markdown;
  final Value<String> tablesHtml;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SourcePageCompanion({
    this.sourceFileId = const Value.absent(),
    this.pageIx = const Value.absent(),
    this.textOrigin = const Value.absent(),
    this.markdown = const Value.absent(),
    this.tablesHtml = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourcePageCompanion.insert({
    required int sourceFileId,
    required int pageIx,
    required String textOrigin,
    required String markdown,
    this.tablesHtml = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : sourceFileId = Value(sourceFileId),
       pageIx = Value(pageIx),
       textOrigin = Value(textOrigin),
       markdown = Value(markdown),
       createdAt = Value(createdAt);
  static Insertable<SourcePageRow> custom({
    Expression<int>? sourceFileId,
    Expression<int>? pageIx,
    Expression<String>? textOrigin,
    Expression<String>? markdown,
    Expression<String>? tablesHtml,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sourceFileId != null) 'source_file_id': sourceFileId,
      if (pageIx != null) 'page_ix': pageIx,
      if (textOrigin != null) 'text_origin': textOrigin,
      if (markdown != null) 'markdown': markdown,
      if (tablesHtml != null) 'tables_html': tablesHtml,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourcePageCompanion copyWith({
    Value<int>? sourceFileId,
    Value<int>? pageIx,
    Value<String>? textOrigin,
    Value<String>? markdown,
    Value<String>? tablesHtml,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SourcePageCompanion(
      sourceFileId: sourceFileId ?? this.sourceFileId,
      pageIx: pageIx ?? this.pageIx,
      textOrigin: textOrigin ?? this.textOrigin,
      markdown: markdown ?? this.markdown,
      tablesHtml: tablesHtml ?? this.tablesHtml,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sourceFileId.present) {
      map['source_file_id'] = Variable<int>(sourceFileId.value);
    }
    if (pageIx.present) {
      map['page_ix'] = Variable<int>(pageIx.value);
    }
    if (textOrigin.present) {
      map['text_origin'] = Variable<String>(textOrigin.value);
    }
    if (markdown.present) {
      map['markdown'] = Variable<String>(markdown.value);
    }
    if (tablesHtml.present) {
      map['tables_html'] = Variable<String>(tablesHtml.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        SourcePage.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcePageCompanion(')
          ..write('sourceFileId: $sourceFileId, ')
          ..write('pageIx: $pageIx, ')
          ..write('textOrigin: $textOrigin, ')
          ..write('markdown: $markdown, ')
          ..write('tablesHtml: $tablesHtml, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TrackfitDatabase extends GeneratedDatabase {
  _$TrackfitDatabase(QueryExecutor e) : super(e);
  late final Person person = Person(this);
  late final Report report = Report(this);
  late final Extraction extraction = Extraction(this);
  late final Observation observation = Observation(this);
  late final Index uqObservationIdentity = Index(
    'uq_observation_identity',
    'CREATE UNIQUE INDEX uq_observation_identity ON observation (person_id, name_key, observed_start, observed_end, source_ref, source_record_id, COALESCE(member_of, 0), COALESCE(amends, 0))',
  );
  late final Index idxObservationDay = Index(
    'idx_observation_day',
    'CREATE INDEX idx_observation_day ON observation (person_id, local_date)',
  );
  late final Index idxObservationStream = Index(
    'idx_observation_stream',
    'CREATE INDEX idx_observation_stream ON observation (person_id, stream_key, observed_start)',
  );
  late final Index idxObservationSource = Index(
    'idx_observation_source',
    'CREATE INDEX idx_observation_source ON observation (source_ref)',
  );
  late final Index idxObservationReport = Index(
    'idx_observation_report',
    'CREATE INDEX idx_observation_report ON observation (report_id) WHERE report_id IS NOT NULL',
  );
  late final Index idxObservationAmends = Index(
    'idx_observation_amends',
    'CREATE INDEX idx_observation_amends ON observation (amends) WHERE amends IS NOT NULL',
  );
  late final Index idxObservationCreated = Index(
    'idx_observation_created',
    'CREATE INDEX idx_observation_created ON observation (person_id, created_at)',
  );
  late final SourceFile sourceFile = SourceFile(this);
  late final SourcePage sourcePage = SourcePage(this);
  late final Index idxExtractionReport = Index(
    'idx_extraction_report',
    'CREATE INDEX idx_extraction_report ON extraction (report_id)',
  );
  late final Index idxReportPersonDate = Index(
    'idx_report_person_date',
    'CREATE INDEX idx_report_person_date ON report (person_id, report_date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    person,
    report,
    extraction,
    observation,
    uqObservationIdentity,
    idxObservationDay,
    idxObservationStream,
    idxObservationSource,
    idxObservationReport,
    idxObservationAmends,
    idxObservationCreated,
    sourceFile,
    sourcePage,
    idxExtractionReport,
    idxReportPersonDate,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'report',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('extraction', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'report',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('source_file', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'source_file',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('source_page', kind: UpdateKind.delete)],
    ),
  ]);
}
