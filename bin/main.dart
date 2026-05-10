import 'dart:io';

void main(List<String> arguments) {
  var isGameLost = false;
  var isGameWon = false;

  print('Cards with Dart');
  print('Choose a card ([1], [2]): ');

  var choice = stdin.readLineSync();
  if (choice == null) {
    print('input error');
    exit(1);
  }

  var cardNumber = int.tryParse(choice);

  if (cardNumber == null) {
    print('this is not a valid number between 1 and 2');
    exit(1);
  }

  isGameLost = cardNumber == 1;
  isGameWon = cardNumber == 2;

  if (isGameLost) print('You lost!');

  if (isGameWon) {
    print('You won!');
  }
}
