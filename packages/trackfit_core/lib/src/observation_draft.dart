/// One reading as printed in a source, before it is standardized.
///
/// Every text field holds exactly what the source shows: not translated, not
/// converted, not corrected. Empty strings mean "not printed". Deriving
/// numbers, units and codes from these fields is the job of standardization.
final class ObservationDraft {
  const ObservationDraft({
    required this.name,
    this.value = '',
    this.unit = '',
    this.reference = '',
    this.flag = '',
    this.specimen = '',
    this.method = '',
    this.panel = '',
    this.page,
  });

  /// Reads a draft from its JSON form, see [toJson].
  ///
  /// Missing optional fields become empty strings. Throws a [FormatException]
  /// when `name` is missing or blank, or a field has the wrong type.
  factory ObservationDraft.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value == null) return '';
      if (value is String) return value;
      if (value is num) return value.toString();
      throw FormatException('"$key" must be a string', json);
    }

    final name = text('name').trim();
    if (name.isEmpty) {
      throw FormatException('"name" is required', json);
    }
    final page = json['page'];
    if (page != null && page is! int) {
      throw FormatException('"page" must be an integer', json);
    }
    return ObservationDraft(
      name: name,
      value: text('value'),
      unit: text('unit'),
      reference: text('reference'),
      flag: text('flag'),
      specimen: text('specimen'),
      method: text('method'),
      panel: text('panel'),
      page: page as int?,
    );
  }

  /// Name of the test as printed, e.g. `Ferritin` or `25-OH-Vitamin D`.
  final String name;

  /// Value as printed, e.g. `52`, `<0.5`, `negativ` or `12,9`.
  final String value;

  /// Unit as printed, e.g. `µg/dl`.
  final String unit;

  /// Reference range as printed, e.g. `60 - 170` or `< 5,0`.
  final String reference;

  /// Abnormal flag as printed, e.g. `H`, `L`, `+` or `↓`.
  final String flag;

  /// Specimen as printed, e.g. `Serum`.
  final String specimen;

  /// Method as printed.
  final String method;

  /// Heading of the panel the reading is listed under, e.g. `Blutbild`.
  final String panel;

  /// Page of the report the reading was found on, starting at 1.
  final int? page;

  Map<String, Object?> toJson() => {
    'name': name,
    if (value.isNotEmpty) 'value': value,
    if (unit.isNotEmpty) 'unit': unit,
    if (reference.isNotEmpty) 'reference': reference,
    if (flag.isNotEmpty) 'flag': flag,
    if (specimen.isNotEmpty) 'specimen': specimen,
    if (method.isNotEmpty) 'method': method,
    if (panel.isNotEmpty) 'panel': panel,
    if (page != null) 'page': page,
  };

  @override
  bool operator ==(Object other) =>
      other is ObservationDraft &&
      other.name == name &&
      other.value == value &&
      other.unit == unit &&
      other.reference == reference &&
      other.flag == flag &&
      other.specimen == specimen &&
      other.method == method &&
      other.panel == panel &&
      other.page == page;

  @override
  int get hashCode => Object.hash(
    name,
    value,
    unit,
    reference,
    flag,
    specimen,
    method,
    panel,
    page,
  );

  @override
  String toString() => 'ObservationDraft(${toJson()})';
}
