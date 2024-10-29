// Check the `avoid_hardcoded_japanese` rule.

// expect_lint: avoid_hardcoded_japanese
const hiragana = 'あいうえお';

// expect_lint: avoid_hardcoded_japanese
const katakana = 'アイウエオ';

// expect_lint: avoid_hardcoded_japanese
const kanji = '漢字';

const notJapanese = 'abc';
