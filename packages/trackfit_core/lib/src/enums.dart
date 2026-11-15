import 'wire_enum.dart';

/// What an observation is.
enum ObservationKind implements WireEnum {
  measurement('measurement'),
  symptom('symptom'),
  condition('condition'),
  note('note'),
  finding('finding'),

  /// Head of a panel, e.g. "complete blood count". Other rows point to it.
  organizer('organizer');

  const ObservationKind(this.wire);

  @override
  final String wire;
}

/// How a reading came about.
enum Modality implements WireEnum {
  labReport('lab-report'),
  deviceSensed('device-sensed'),
  selfReported('self-reported'),
  manual('manual'),
  derived('derived'),

  /// Read by a language model and not yet confirmed by a person.
  llmUnverified('llm-unverified');

  const Modality(this.wire);

  @override
  final String wire;
}

/// Where a reading entered the app.
enum SourceKind implements WireEnum {
  file('file'),
  manual('manual'),
  healthConnect('health-connect'),
  healthKit('healthkit'),
  deviceFile('device-file');

  const SourceKind(this.wire);

  @override
  final String wire;
}

/// Role of a source when several report the same day.
enum SourceClass implements WireEnum {
  /// The source measured the value itself.
  measurer('measurer'),

  /// The source repeats a value from the user profile, e.g. a height.
  profileEcho('profile-echo'),
  aggregator('aggregator'),
  manual('manual');

  const SourceClass(this.wire);

  @override
  final String wire;
}

/// Time resolution of an observation.
enum Grain implements WireEnum {
  instant('instant'),
  window('window'),
  day('day');

  const Grain(this.wire);

  @override
  final String wire;
}

/// Type of a value.
enum ValueKind implements WireEnum {
  /// A number, always with a numeric value.
  quantity('quantity'),

  /// An ordered category such as `++`.
  ordinal('ordinal'),

  /// An unordered category such as "negative".
  nominal('nominal'),

  /// Free text.
  narrative('narrative'),

  /// No value, with a reason why.
  absent('absent');

  const ValueKind(this.wire);

  @override
  final String wire;
}

/// Comparator printed in front of a number, e.g. `<0.5`.
enum Comparator implements WireEnum {
  none(''),
  lessThan('<'),
  lessOrEqual('<='),
  greaterThan('>'),
  greaterOrEqual('>=');

  const Comparator(this.wire);

  @override
  final String wire;
}

/// Lifecycle of an observation row. Rows are never updated in place.
enum ObservationStatus implements WireEnum {
  finalStatus('final'),
  enteredInError('entered-in-error');

  const ObservationStatus(this.wire);

  @override
  final String wire;
}

/// Result of coding an observation.
enum CodingOutcome implements WireEnum {
  coded('coded'),

  /// No safe code yet; a person has to answer a question.
  needsInput('needs-input'),

  /// Deliberately not coded, e.g. a category term or a note.
  refused('refused');

  const CodingOutcome(this.wire);

  @override
  final String wire;
}

/// Processing state of a report.
enum ReportStatus implements WireEnum {
  pending('pending'),
  ocr('ocr'),
  extracting('extracting'),

  /// Values were extracted and wait to be looked at or have open questions.
  review('review'),
  done('done'),
  failed('failed');

  const ReportStatus(this.wire);

  @override
  final String wire;
}

/// Where the date of a report came from.
enum DateSource implements WireEnum {
  unknown(''),
  extracted('extracted'),
  fileDate('file-date'),
  manual('manual');

  const DateSource(this.wire);

  @override
  final String wire;
}

/// Kind of an imported file.
enum FileKind implements WireEnum {
  pdf('pdf'),
  image('image'),
  other('other');

  const FileKind(this.wire);

  @override
  final String wire;
}

/// How a file was brought into the app.
enum ImportChannel implements WireEnum {
  filePicker('file-picker'),
  dragDrop('drag-drop'),
  camera('camera'),
  gallery('gallery'),
  share('share');

  const ImportChannel(this.wire);

  @override
  final String wire;
}
