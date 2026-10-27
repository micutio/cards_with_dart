library;

import 'dart:collection';

import 'package:cards_with_dart_core/cards_with_dart_core.dart';

/// Captures messages and state events from [Game] for the web UI.
class WebGameRenderer implements Renderer {
  final List<String> _messages = [];
  bool? _gameOverWon;

  UnmodifiableListView<String> get messages => UnmodifiableListView(_messages);
  bool? get gameOverWon => _gameOverWon;

  void clear() {
    _messages.clear();
    _gameOverWon = null;
  }

  @override
  void renderCard(Card card) {
    _messages.add('$card');
  }

  @override
  void renderHand(Hand hand) {
    _messages.add('Your Hand (${hand.size}/${hand.maxSize}):');
    for (var i = 0; i < hand.size; i++) {
      _messages.add('  ${i + 1}: ${hand.cards[i]}');
    }
  }

  @override
  void renderDeck(Deck deck) {
    _messages.add('Deck "${deck.title}" (${deck.cards.length} cards)');
  }

  @override
  void renderMessage(String msg) {
    _messages.add(msg);
  }

  @override
  void renderGameOver(bool won) {
    _gameOverWon = won;
    final verb = won ? 'won' : 'lost';
    _messages.add('You $verb !');
  }
}

/// High-level controller driving [Game] for the browser UI.
class WebGameController {
  WebGameController({this.shuffleDeck = true}) : renderer = WebGameRenderer() {
    _game = Game(renderer);
    reset();
  }

  final bool shuffleDeck;
  final WebGameRenderer renderer;
  late Game _game;

  Game get game => _game;
  UnmodifiableListView<Card> get handCards => _game.player.hand.cards;
  int get handSize => _game.player.hand.size;
  int get maxHandSize => _game.player.hand.maxSize;
  int get deckRemaining => _game.player.deck.cards.length;
  bool get isGameRunning => _game.isGameRunning;
  bool get isGameWon => _game.isGameWon;
  UnmodifiableListView<String> get logMessages => renderer.messages;

  /// Resets the game to a fresh deck and initial hand.
  void reset() {
    renderer.clear();
    _game = Game(renderer)
      ..setUp(shuffleDeck: shuffleDeck)
      ..startInteractive();
  }

  /// Plays the card at [index] in the player's hand.
  ActionResult playCard(int index) {
    return _game.handleAction(PlayCardAction(index));
  }

  /// Passes the current turn and draws a card if possible.
  ActionResult passTurn() {
    return _game.handleAction(const PassAction());
  }

  /// Logs the current hand to the message log.
  ActionResult viewHand() {
    return _game.handleAction(const ViewHandAction());
  }
}
