import '../../card_mgmt.dart';
import '../../renderer.dart';

class StdoutRenderer implements Renderer {
  @override
  void renderCard(Card card) {
    print('$card');
  }

  @override
  void renderHand(Hand hand) {
    for (var i = 0; i < hand.size; i++) {
      final idx = i + 1;
      final card = hand.cards[i];
      print('  $idx: $card');
    }
  }

  @override
  void renderDeck(Deck deck) {
    final deckTitle = deck.title;
    print('Deck "$deckTitle":');
    for (final card in deck.cards) {
      print('  $card');
    }
  }

  @override
  void renderMessage(String message) {
    print(message);
  }

  @override
  void renderGameOver(bool won) {
    final verb = won ? "won" : "lost";
    print('You $verb !');
  }
}
