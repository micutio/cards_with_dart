import 'card.dart';
import 'deck.dart';

/// Holds all the cards that exist in the game.
class Library {
  final Set<Card> cards = <Card>{};
  final List<Deck> decks = [];
}
