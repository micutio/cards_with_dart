import 'dart:io';

import 'package:cards_with_dart_core/cards_with_dart_core.dart';

class StdoutRenderer implements Renderer {
  StdoutRenderer({StringSink? out}) : _out = out ?? stdout;

  final StringSink _out;

  @override
  void renderCard(Card card) {
    _out.writeln('$card');
  }

  @override
  void renderHand(Hand hand) {
    _out.writeln('Your Hand:');
    for (var i = 0; i < hand.size; i++) {
      final idx = i + 1;
      final card = hand.cards[i];
      _out.writeln('  $idx: $card');
    }
  }

  @override
  void renderDeck(Deck deck) {
    final deckTitle = deck.title;
    _out.writeln('Deck "$deckTitle":');
    for (final card in deck.cards) {
      _out.writeln('  $card');
    }
  }

  @override
  void renderMessage(String message) {
    _out.writeln(message);
  }

  @override
  void renderGameOver(bool won) {
    final verb = won ? 'won' : 'lost';
    _out.writeln('You $verb !');
  }
}
