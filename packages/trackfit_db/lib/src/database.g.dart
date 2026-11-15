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

abstract class _$TrackfitDatabase extends GeneratedDatabase {
  _$TrackfitDatabase(QueryExecutor e) : super(e);
  late final Person person = Person(this);
  late final Report report = Report(this);
  late final SourceFile sourceFile = SourceFile(this);
  late final SourcePage sourcePage = SourcePage(this);
  late final Extraction extraction = Extraction(this);
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
    sourceFile,
    sourcePage,
    extraction,
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
      result: [TableUpdate('source_file', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'source_file',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('source_page', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'report',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('extraction', kind: UpdateKind.delete)],
    ),
  ]);
}
