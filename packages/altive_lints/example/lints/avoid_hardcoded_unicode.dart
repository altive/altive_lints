// Check the `avoid_hardcoded_unicode` rule.

// expect_lint: avoid_hardcoded_unicode
const japanese = 'こんにちは';
// expect_lint: avoid_hardcoded_unicode
const russian = 'Ошибка';
// expect_lint: avoid_hardcoded_unicode
const spanish = '¡Hola!';

const ascii = 'Hello!';
const numbers = '12345';
const symbols = '!@#%&*()';
