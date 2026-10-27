import 'action.dart';
import 'card_mgmt.dart';
import 'input.dart';

/// Represents a player in the card game.
class Player {
  Player(this.name, int deckSize, int handSize, [Input? input])
    : deck = Deck('Standard Deck', deckSize),
      hand = Hand(handSize),
      _input = input ?? NoOpInput();

  final String name;
  final Deck deck;
  final Hand hand;
  final Input _input;

  PlayerAction? _nextAction;

  void setUpHand() {
    drawCard();
  }

  void drawCard() {
    final card = deck.drawCard();
    if (card != null) hand.addCard(card);
  }

  /// Queues a [PlayerAction] directly (useful for UI/web frontends and tests).
  void queueAction(PlayerAction action) {
    _nextAction = action;
  }

  /// Returns the next action the player has chosen to take.
  PlayerAction consumeAction() {
    final action = _nextAction;
    _nextAction = null;
    return action ?? const NoAction();
  }

  void pollAction() {
    _nextAction = _input.getPlayerAction();
  }

  bool hasAction() {
    return _nextAction != null;
  }
}
