import 'package:drift/drift.dart';
import 'package:trackfit_core/trackfit_core.dart';

/// Stores a [WireEnum] as its stable string value.
class WireEnumConverter<T extends WireEnum> extends TypeConverter<T, String> {
  const WireEnumConverter(this.values);

  final List<T> values;

  @override
  T fromSql(String fromDb) => enumFromWire(values, fromDb);

  @override
  String toSql(T value) => value.wire;
}

/// Stores a point in time as milliseconds since the epoch, always in UTC.
class UtcMillisConverter extends TypeConverter<DateTime, int> {
  const UtcMillisConverter();

  @override
  DateTime fromSql(int fromDb) =>
      DateTime.fromMillisecondsSinceEpoch(fromDb, isUtc: true);

  @override
  int toSql(DateTime value) => value.toUtc().millisecondsSinceEpoch;
}

/// Converters for every enum stored in the database, usable in `.drift` files.
const observationKindConverter = WireEnumConverter(ObservationKind.values);
const modalityConverter = WireEnumConverter(Modality.values);
const sourceKindConverter = WireEnumConverter(SourceKind.values);
const sourceClassConverter = WireEnumConverter(SourceClass.values);
const grainConverter = WireEnumConverter(Grain.values);
const valueKindConverter = WireEnumConverter(ValueKind.values);
const comparatorConverter = WireEnumConverter(Comparator.values);
const observationStatusConverter = WireEnumConverter(ObservationStatus.values);
const codingOutcomeConverter = WireEnumConverter(CodingOutcome.values);
const reportStatusConverter = WireEnumConverter(ReportStatus.values);
const dateSourceConverter = WireEnumConverter(DateSource.values);
const fileKindConverter = WireEnumConverter(FileKind.values);
const importChannelConverter = WireEnumConverter(ImportChannel.values);
const utcMillisConverter = UtcMillisConverter();
const extractionStatusConverter = WireEnumConverter(ExtractionStatus.values);
const tzSourceConverter = WireEnumConverter(TzSource.values);
const statConverter = WireEnumConverter(Stat.values);
const flagConverter = WireEnumConverter(Flag.values);
const codingCauseConverter = WireEnumConverter(CodingCause.values);
const sexConverter = WireEnumConverter(Sex.values);
