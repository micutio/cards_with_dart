import 'dart:io';

import 'package:cards_with_dart/card_mgmt.dart';
import 'package:cards_with_dart/src/renderer/stdout_renderer.dart';

void main(List<String> arguments) {
  const int deckSize = 10;
  const int handSize = 4;

  final renderer = StdoutRenderer();

  // Create a library with a set of unique cards
  final library = Library();
  library.cards.addAll({
    Card("Overpowered!", Effect.winGame),
    Card("Sleep", Effect.none),
    Card("Skip", Effect.none),
    Card("Eternal Fail", Effect.loseGame),
  });

  // Create a deck with max size 10 and add each card twice.
  final deck = Deck('Default deck', deckSize);
  // `...` is the spread operator, which unpacks the little 2-card list into the bigger list.
  deck.addCards([
    for (var card in library.cards) ...[card, card],
  ]);
  deck.shuffle();

  // Then create a hand and give it a card.
  final hand = Hand(handSize);
  final card1 = deck.drawCard();
  if (card1 != null) hand.addCard(card1);

  var isGameWon = false;

  renderer.renderMessage('Cards with Dart');

  // Run the loop until the player has either won or lost.
  while (!isGameWon) {
    // Add a card from the deck, if possible
    if (!hand.isFull) {
      final drawnCard = deck.drawCard();
      if (drawnCard != null) hand.addCard(drawnCard);
    }

    // Show the player's hand.
    renderer.renderMessage('Your hand:');
    renderer.renderHand(hand);

    renderer.renderMessage('Choose a card or `pass`: ');

    final choice = stdin.readLineSync();
    if (choice == null) {
      print('input error');
      exit(1);
    }

    if (choice == 'pass') continue;

    // Parse the card number.
    var cardNumber = int.tryParse(choice);
    if (cardNumber == null) {
      renderer.renderMessage('This is not a valid number!');
      continue;
    }

    // Convert card number from 1-indexed to 0-indexed.
    cardNumber -= 1;

    if (cardNumber < 0) {
      renderer.renderMessage('The chosen card number is too small!');
      continue;
    }

    if (cardNumber >= hand.size) {
      renderer.renderMessage('The chosen card number is too high!');
      continue;
    }

    final card = hand.playCardAt(cardNumber);
    renderer.renderMessage('You play $card');
    switch (card.effect) {
      case Effect.none:
        renderer.renderMessage('You passed the turn');
        break;
      case Effect.winGame:
        isGameWon = true;
        break;
      case Effect.loseGame:
        isGameWon = false;
        break;
    }
  }

  renderer.renderGameOver(isGameWon);
}
