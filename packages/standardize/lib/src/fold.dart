import 'package:unorm_dart/unorm_dart.dart' as unorm;

final _whitespace = RegExp(r'\s+');
final _trailing = RegExp(r'[\s.,;:]+$');
final _cjk = RegExp(r'[぀-ヿ㐀-鿿豈-﫿]');

/// The lookup key of a printed test name.
///
/// Unicode NFKC (full-width letters become plain ones), lower case, one
/// space between words, no space next to a CJK character, no trailing
/// punctuation. It does not translate, expand abbreviations or drop
/// specimen words: those are coding decisions, not folding.
///
/// Every writer and reader uses this one function, so one test never ends
/// up in two series because of a spelling detail.
String nameKey(String printed) {
  final folded = unorm
      .nfkc(printed)
      .toLowerCase()
      .replaceAll(_whitespace, ' ')
      .trim()
      .replaceAll(_trailing, '');
  if (!_cjk.hasMatch(folded)) return folded;
  final buffer = StringBuffer();
  for (var i = 0; i < folded.length; i++) {
    final char = folded[i];
    if (char == ' ') {
      final before = i > 0 ? folded[i - 1] : '';
      final after = i + 1 < folded.length ? folded[i + 1] : '';
      if (_cjk.hasMatch(before) || _cjk.hasMatch(after)) continue;
    }
    buffer.write(char);
  }
  return buffer.toString();
}
