import 'package:cards_with_dart/action.dart';
import 'package:cards_with_dart/card_mgmt.dart';
import 'package:cards_with_dart/input.dart';

/// Represents a player.
/// Later this can be initialized from a savegame or network account.
class Player {
  final String name;
  final Deck deck;
  final Hand hand;
  final Input _input;

  PlayerAction? _nextAction;

  Player(this.name, int deckSize, int handSize, Input input)
    : deck = Deck('Standard Deck', deckSize),
      hand = Hand(handSize),
      _input = input;

  void setUpHand() {
    drawCard();
  }

  void drawCard() {
    final card1 = deck.drawCard();
    if (card1 != null) hand.addCard(card1);
  }

  /// Returns the next action the player has chosen to take.
  PlayerAction consumeAction() {
    final action = _nextAction;
    _nextAction = null;
    return action!;
  }

  void pollAction() {
    _nextAction = _input.getPlayerAction();
  }

  bool hasAction() {
    return _nextAction != null;
  }
}
