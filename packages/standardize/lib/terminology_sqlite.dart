/// Reading and writing the terminology database.
///
/// Kept apart from `standardize.dart`, so the resolver itself needs no
/// SQLite.
library;

import 'package:sqlite3/sqlite3.dart';

import 'standardize.dart';

/// Version of the table layout of the terminology database.
const terminologySchemaVersion = 1;

/// Writes [terminology] into the empty database [db].
void writeTerminology(Database db, Terminology terminology) {
  db
    ..execute('''
      CREATE TABLE meta (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL);
      CREATE TABLE loinc (
        code           TEXT NOT NULL PRIMARY KEY,
        group_id       TEXT NOT NULL,
        property       TEXT NOT NULL,
        scale          TEXT NOT NULL,
        units          TEXT NOT NULL,
        canonical_unit TEXT,
        molar_mass     REAL,
        category       TEXT NOT NULL,
        short_name     TEXT NOT NULL,
        display_de     TEXT NOT NULL,
        display        TEXT NOT NULL,
        component      TEXT NOT NULL,
        system         TEXT NOT NULL
      );
      CREATE TABLE alias (name_key TEXT NOT NULL PRIMARY KEY, group_id TEXT NOT NULL);
      CREATE TABLE category (name_key TEXT NOT NULL PRIMARY KEY);
    ''')
    ..execute('BEGIN');
  final meta = db.prepare('INSERT INTO meta VALUES (?, ?)');
  meta
    ..execute(['release', terminology.release])
    ..execute(['schema_version', '$terminologySchemaVersion'])
    ..close();
  final loinc = db.prepare(
    'INSERT INTO loinc VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
  );
  for (final entry in terminology.entries) {
    final concept = entry.concept;
    loinc.execute([
      entry.code,
      entry.groupId,
      entry.property,
      entry.scale,
      (entry.units.toList()..sort()).join(','),
      entry.canonicalUnit,
      entry.molarMass,
      concept.category,
      concept.shortName,
      concept.displayDe,
      concept.display,
      concept.component,
      concept.system,
    ]);
  }
  loinc.close();
  final alias = db.prepare('INSERT INTO alias VALUES (?, ?)');
  terminology.aliases.forEach((key, group) => alias.execute([key, group]));
  alias.close();
  final category = db.prepare('INSERT INTO category VALUES (?)');
  for (final key in terminology.categories) {
    category.execute([key]);
  }
  category.close();
  db.execute('COMMIT');
}

/// Reads a terminology database written by [writeTerminology].
Terminology readTerminology(Database db) {
  final release =
      db.select("SELECT value FROM meta WHERE key = 'release'").single['value']
          as String;
  return Terminology(
    release: release,
    entries: [
      for (final row in db.select('SELECT * FROM loinc'))
        TerminologyEntry(
          code: row['code'] as String,
          groupId: row['group_id'] as String,
          property: row['property'] as String,
          scale: row['scale'] as String,
          units: {
            for (final unit in (row['units'] as String).split(','))
              if (unit.isNotEmpty) unit,
          },
          canonicalUnit: row['canonical_unit'] as String?,
          molarMass: (row['molar_mass'] as num?)?.toDouble(),
          concept: ConceptInfo(
            display: row['display'] as String,
            displayDe: row['display_de'] as String,
            shortName: row['short_name'] as String,
            category: row['category'] as String,
            component: row['component'] as String,
            property: row['property'] as String,
            system: row['system'] as String,
            scale: row['scale'] as String,
          ),
        ),
    ],
    aliases: {
      for (final row in db.select('SELECT * FROM alias'))
        row['name_key'] as String: row['group_id'] as String,
    },
    categories: {
      for (final row in db.select('SELECT * FROM category'))
        row['name_key'] as String,
    },
  );
}
