import 'dart:collection';

import 'card.dart';

/// Holds all the player's cards during a game which are not in their hand.
/// Cards are drawn from the back of the deck to avoid to much re-allocation
/// of the backing list.
class Deck {
  final String title;
  final int maxSize;
  final List<Card> _cards = [];

  Deck(this.title, this.maxSize);

  /// Draws a card and removes it from the deck.
  Card? drawCard() {
    if (_cards.isEmpty) return null;

    return _cards.removeLast();
  }

  /// Add a card to the bottom of the deck.
  void addCard(Card card) {
    _cards.insert(0, card);
  }

  /// Add all cards to the bottom of the deck.
  void addCards(Iterable<Card> cards) {
    _cards.insertAll(0, cards);
  }

  /// Shuffles all cards into random order.
  /// TODO: Specify RNG for reproducibility.
  void shuffle() {
    _cards.shuffle();
  }

  /// Returns all cards of the hand without removing them.
  /// Intended for debugging.
  UnmodifiableListView<Card> get cards => UnmodifiableListView(_cards);
}
