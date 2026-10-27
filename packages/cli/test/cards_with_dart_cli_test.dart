import 'package:cards_with_dart_cli/cards_with_dart_cli.dart';
import 'package:cards_with_dart_core/cards_with_dart_core.dart';
import 'package:test/test.dart';

void main() {
  group('Cards with Dart CLI', () {
    test('buildParser creates parser with flags', () {
      final parser = buildParser();
      expect(parser.options.containsKey('help'), isTrue);
      expect(parser.options.containsKey('version'), isTrue);
    });

    test('runCli handles --help flag', () {
      final out = StringBuffer();
      final code = runCli(['--help'], out: out);
      expect(code, equals(0));
      expect(out.toString(), contains('Cards with Dart CLI'));
    });

    test('runCli handles --version flag', () {
      final out = StringBuffer();
      final code = runCli(['--version'], out: out);
      expect(code, equals(0));
      expect(out.toString(), contains('cards_with_dart version'));
    });

    test('runCli handles invalid options', () {
      final err = StringBuffer();
      final code = runCli(['--unknown-option-xyz'], err: err);
      expect(code, equals(64));
      expect(err.toString(), contains('Could not find an option'));
    });

    test('runCli executes full game loop with scripted input', () {
      final out = StringBuffer();
      final inputs = ['hand', 'pass', 'invalid', '0', '1', '1', '1', '1'];
      var index = 0;
      final input = StdinInput(
        readLine: () => index < inputs.length ? inputs[index++] : '1',
      );

      final code = runCli([], out: out, input: input);
      expect(code, equals(0));
      expect(out.toString(), contains('Cards with Dart'));
      expect(out.toString(), contains('Your Hand:'));
      expect(out.toString(), anyOf(contains('You won'), contains('You lost')));
    });

    test('StdoutRenderer renders card and deck', () {
      final out = StringBuffer();
      final renderer = StdoutRenderer(out: out);
      const card = Card('Sleep', Effect.none);
      final deck = Deck('Main', 10)..addCard(card);

      renderer
        ..renderCard(card)
        ..renderDeck(deck);

      expect(out.toString(), contains('Sleep'));
      expect(out.toString(), contains('Deck "Main":'));
    });
  });
}
