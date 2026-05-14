import 'dart:collection';

import 'card.dart';

/// The cards a player is holding in their hand.
class Hand {
  final int maxSize;
  final List<Card> _cards = [];

  Hand(this.maxSize);

  /// Adds a card to the hand.
  /// TODO: Specify what should happen if the hand is already full!
  void addCard(Card card) {
    _cards.add(card);
  }

  /// Removes a given card from the hand to play it.
  void playCard(Card card) {
    _cards.remove(card);
  }

  /// Removes a card at the given index from the hand to play it.
  Card playCardAt(int idx) {
    return _cards.removeAt(idx);
  }

  /// Randomly re-orders all cards in hand.
  void shuffle() {
    _cards.shuffle();
  }

  /// Returns the current hand size, i.e.: cards in hand.
  int get size => _cards.length;

  /// Returns [true] if the hand is full, [false] otherwise.
  bool get isFull => size == maxSize;

  /// Returns all cards of the hand without removing them.
  /// Intended for debugging.
  UnmodifiableListView<Card> get cards => UnmodifiableListView(_cards);
}
