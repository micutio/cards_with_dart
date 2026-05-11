import 'dart:io';

import 'package:cards_with_dart/card.dart';
import 'package:cards_with_dart/effect.dart';

void main(List<String> arguments) {
  final hand = [
    Card("Overpowered!", Effect.winGame),
    Card("Sleep", Effect.none),
    Card("Skip", Effect.none),
    Card("Eternal Fail", Effect.loseGame),
  ];

  var isGameLost = false;
  var isGameWon = false;

  print('Cards with Dart');

  // Run the loop until the player has either won or lost.
  while (!(isGameLost || isGameWon)) {
    // Show the player's hand.
    print('Your hand:');
    for (var i = 0; i < hand.length; i++) {
      final idx = i + 1;
      final card = hand[i];
      print('  $idx: $card');
    }

    print('Choose a card or `pass`: ');

    final choice = stdin.readLineSync();
    if (choice == null) {
      print('input error');
      exit(1);
    }

    if (choice == 'pass') continue;

    // Parse the card number.
    var cardNumber = int.tryParse(choice);
    if (cardNumber == null) {
      print('This is not a valid number!');
      exit(1);
    }

    // Convert card number from 1-indexed to 0-indexed.
    cardNumber -= 1;

    if (cardNumber < 0) {
      print('The chosen card number is too small!');
      continue;
    }

    if (cardNumber >= hand.length) {
      print('The chosen card number is too high!');
      continue;
    }

    final card = hand.removeAt(cardNumber);
    print('You play $card');
    switch (card.effect) {
      case Effect.none:
        print('You passed the turn');
        break;
      case Effect.winGame:
        isGameWon = true;
        break;
      case Effect.loseGame:
        isGameLost = true;
        break;
    }
  }

  if (isGameLost) print('You lost!');

  if (isGameWon) print('You won!');
}
