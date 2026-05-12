import '../card.dart';
import '../deck.dart';

/// Holds all the cards that exist in the game.
/// Maybe it should also hold all the player's decks?
class Library {
  final Set<Card> cards = <Card>{};
  final List<Deck> decks = [];
}
