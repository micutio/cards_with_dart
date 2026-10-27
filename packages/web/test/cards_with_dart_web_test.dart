import 'package:cards_with_dart_core/cards_with_dart_core.dart';
import 'package:cards_with_dart_web/cards_with_dart_web.dart';
import 'package:test/test.dart';

void main() {
  group('WebGameController', () {
    test('initializes with 1 card in hand and 7 cards remaining in deck', () {
      final controller = WebGameController(shuffleDeck: false);

      expect(controller.isGameRunning, isTrue);
      expect(controller.handSize, equals(1));
      expect(controller.maxHandSize, equals(4));
      expect(controller.deckRemaining, equals(7));
      expect(controller.logMessages.first, equals('Cards with Dart'));
    });

    test('passTurn draws a card and viewHand logs current hand', () {
      final controller = WebGameController(shuffleDeck: false);

      final passRes = controller.passTurn();
      expect(passRes, equals(ActionResult.passTurn));
      expect(controller.handSize, equals(2));
      expect(controller.deckRemaining, equals(6));

      final viewRes = controller.viewHand();
      expect(viewRes, equals(ActionResult.viewHand));
      expect(
        controller.logMessages.any((m) => m.contains('Your Hand (2/4):')),
        isTrue,
      );
    });

    test('playing cards resolves game over and reset starts a new session', () {
      final controller = WebGameController(shuffleDeck: false);

      while (controller.isGameRunning) {
        if (controller.handSize == 0) {
          controller.passTurn();
        } else {
          controller.playCard(0);
        }
      }

      expect(controller.isGameRunning, isFalse);
      expect(controller.renderer.gameOverWon, isNotNull);

      controller.reset();
      expect(controller.isGameRunning, isTrue);
      expect(controller.handSize, equals(1));
      expect(controller.renderer.gameOverWon, isNull);
    });

    test('WebGameRenderer renders individual card and deck summaries', () {
      final renderer = WebGameRenderer();
      const card = Card('Overpowered!', Effect.winGame);
      final deck = Deck('Web Deck', 10)..addCard(card);

      renderer
        ..renderCard(card)
        ..renderDeck(deck);

      expect(renderer.messages.length, equals(2));
      expect(renderer.messages.first, contains('Overpowered!'));
      expect(renderer.messages.last, contains('Deck "Web Deck" (1 cards)'));
    });
  });
}
