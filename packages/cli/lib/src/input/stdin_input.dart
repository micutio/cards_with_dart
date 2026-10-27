import 'dart:io';

import 'package:cards_with_dart_core/cards_with_dart_core.dart';

class StdinInput extends Input {
  StdinInput({String? Function()? readLine})
    : _readLine = readLine ?? stdin.readLineSync;

  final String? Function() _readLine;

  @override
  PlayerAction getPlayerAction() {
    return determineAction(_readLine());
  }

  PlayerAction determineAction(String? userInput) {
    if (userInput == null) {
      return const NoAction();
    }

    final trimmed = userInput.trim();
    if (trimmed == 'pass') {
      return const PassAction();
    }

    if (trimmed == 'hand') {
      return const ViewHandAction();
    }

    // Try to parse user input into a number.
    var cardNumber = int.tryParse(trimmed);
    if (cardNumber == null) {
      return const NoAction();
    }

    // Convert card number from 1-indexed to 0-indexed.
    cardNumber -= 1;

    if (cardNumber < 0) {
      return const NoAction();
    }

    return PlayCardAction(cardNumber);
  }
}
