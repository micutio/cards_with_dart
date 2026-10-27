import 'package:cards_with_dart_core/cards_with_dart_core.dart';
import 'package:test/test.dart';

class _RecordingRenderer implements Renderer {
  final List<String> messages = [];
  final List<Card> renderedCards = [];
  int handRenderCount = 0;
  int deckRenderCount = 0;
  bool? gameOverWon;

  @override
  void renderCard(Card card) {
    renderedCards.add(card);
  }

  @override
  void renderHand(Hand hand) {
    handRenderCount++;
  }

  @override
  void renderDeck(Deck deck) {
    deckRenderCount++;
  }

  @override
  void renderMessage(String msg) {
    messages.add(msg);
  }

  @override
  void renderGameOver(bool won) {
    gameOverWon = won;
  }
}

class _ScriptedInput extends Input {
  _ScriptedInput(this._actions);

  final List<PlayerAction> _actions;
  int _index = 0;

  @override
  PlayerAction getPlayerAction() {
    if (_index >= _actions.length) {
      return const PlayCardAction(0);
    }
    return _actions[_index++];
  }
}

void main() {
  group('Card & Collections', () {
    test('Card equality, hashCode, and toString', () {
      const c1 = Card('Overpowered!', Effect.winGame);
      const c2 = Card('Overpowered!', Effect.winGame);
      const c3 = Card('Sleep', Effect.none);

      expect(c1, equals(c2));
      expect(c1.hashCode, equals(c2.hashCode));
      expect(c1, isNot(equals(c3)));
      expect(c1.toString(), contains('Overpowered!'));
      expect(c1.toString(), contains('winGame'));
    });

    test('Deck addCard, addCards, drawCard, and shuffle', () {
      final deck = Deck('Test Deck', 10);
      expect(deck.drawCard(), isNull);

      const c1 = Card('Card 1', Effect.none);
      const c2 = Card('Card 2', Effect.winGame);
      deck
        ..addCard(c1)
        ..addCards([c2]);

      expect(deck.cards.length, equals(2));
      deck.shuffle();
      expect(deck.drawCard(), isNotNull);
      expect(deck.cards.length, equals(1));
    });

    test('Hand addCard, playCard, playCardAt, shuffle, and isFull', () {
      final hand = Hand(2);
      const c1 = Card('Card 1', Effect.none);
      const c2 = Card('Card 2', Effect.winGame);

      expect(hand.isFull, isFalse);
      hand
        ..addCard(c1)
        ..addCard(c2);
      expect(hand.isFull, isTrue);
      expect(hand.size, equals(2));

      hand.shuffle();
      final played = hand.playCardAt(0);
      expect(played, anyOf(equals(c1), equals(c2)));
      expect(hand.size, equals(1));

      hand.playCard(hand.cards.first);
      expect(hand.size, equals(0));
    });

    test('Library stores unique cards and decks', () {
      final library = Library();
      library.cards
        ..add(const Card('Sleep', Effect.none))
        ..add(const Card('Sleep', Effect.none));
      expect(library.cards.length, equals(1));
      expect(library.decks, isEmpty);
    });
  });

  group('Game engine', () {
    test(
      'interactive session handles view hand, pass turn, and playing cards',
      () {
        final renderer = _RecordingRenderer();
        final game = Game(renderer)
          ..setUp(shuffleDeck: false)
          ..startInteractive();
        expect(renderer.messages.first, equals('Cards with Dart'));
        expect(game.player.hand.size, equals(1));

        final viewResult = game.handleAction(const ViewHandAction());
        expect(viewResult, equals(ActionResult.viewHand));
        expect(renderer.handRenderCount, equals(1));

        final passResult = game.handleAction(const PassAction());
        expect(passResult, equals(ActionResult.passTurn));
        expect(game.player.hand.size, equals(2));

        final invalidResult = game.handleAction(const PlayCardAction(99));
        expect(invalidResult, equals(ActionResult.invalid));

        // Play cards until game ends.
        while (game.isGameRunning) {
          if (game.player.hand.size == 0) {
            game.handleAction(const PassAction());
          } else {
            game.handleAction(const PlayCardAction(0));
          }
        }

        expect(game.isGameRunning, isFalse);
        expect(renderer.gameOverWon, isNotNull);
      },
    );

    test('synchronous loop runs until game over', () {
      final renderer = _RecordingRenderer();
      final input = _ScriptedInput([
        const ViewHandAction(),
        const PassAction(),
        const NoAction(),
        const PlayCardAction(0),
        const PlayCardAction(0),
        const PlayCardAction(0),
        const PlayCardAction(0),
      ]);
      final game = Game(renderer, input: input)
        ..setUp(shuffleDeck: false)
        ..loop();

      expect(game.isGameRunning, isFalse);
      expect(renderer.gameOverWon, isNotNull);
    });
  });
}
