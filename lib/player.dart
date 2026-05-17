import 'dart:io';

import 'package:cards_with_dart/card_mgmt.dart';

/// Represents a player.
/// Later this can be initialized from a savegame or network account.
class Player {
  final String name;
  final Deck deck;
  final Hand hand;

  Player(this.name, int deckSize, int handSize)
    : deck = Deck('Standard Deck', deckSize),
      hand = Hand(handSize);

  void setUpHand() {
    drawCard();
  }

  void drawCard() {
    final card1 = deck.drawCard();
    if (card1 != null) hand.addCard(card1);
  }

  /// For now we use the string typed in by the user as their action
  /// and continue to process it further.
  String? getAction() {
    return stdin.readLineSync();
  }
}
