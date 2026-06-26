import 'dart:io';

import 'package:cards_with_dart/action.dart';
import 'package:cards_with_dart/input.dart';

class StdinInput extends Input {
  @override
  PlayerAction getPlayerAction() {
    return _determineAction(_getRawUserInput());
  }

  PlayerAction _determineAction(String? userInput) {
    if (userInput == null) {
      // TODO: Give feedback to user about invalid input
      return NoAction();
    }

    if (userInput == 'pass') {
      return PassAction();
    }

    if (userInput == 'hand') {
      return ViewHandAction();
    }

    // Try to parse user input into a number

    var cardNumber = int.tryParse(userInput);
    if (cardNumber == null) {
      // TODO: _log.add('This is not a valid number!');
      return NoAction();
    }

    // Convert card number from 1-indexed to 0-indexed.
    cardNumber -= 1;

    if (cardNumber < 0) {
      // TODO: _log.add('The chosen card number is too small!');
      return NoAction();
    }

    // TODO: Check hand size
    //    if (cardNumber >= _player.hand.size) {

    // TODO:   _log.add('The chosen card number is too high!');
    return PlayCardAction(cardNumber);
  }

  String? _getRawUserInput() {
    return stdin.readLineSync();
  }
}
