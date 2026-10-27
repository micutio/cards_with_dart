import 'dart:collection';

import 'action.dart';
import 'card_mgmt.dart';
import 'input.dart';
import 'player.dart';
import 'renderer.dart';

class Game {
  /// Constructor. Takes a generic [Renderer] and optional [Input] or [Player].
  Game(this._renderer, {Input? input, Player? player})
    : _player = player ?? Player('Player', deckSize, handSize, input);

  static const int deckSize = 10;
  static const int handSize = 4;

  final Renderer _renderer;
  final Player _player;
  final Queue<String> _log = Queue<String>();

  String? choice;
  bool _isGameWon = false;
  bool _isGameRunning = true;
  bool _isNewTurn = true;

  Player get player => _player;
  bool get isGameWon => _isGameWon;
  bool get isGameRunning => _isGameRunning;
  bool get isNewTurn => _isNewTurn;

  /// Initialize necessary fields and get the [Game] ready to play.
  void setUp({bool shuffleDeck = true}) {
    _log.clear();
    _isGameWon = false;
    _isGameRunning = true;
    _isNewTurn = true;

    // Clear any existing cards on reset.
    while (_player.deck.drawCard() != null) {}
    while (_player.hand.size > 0) {
      _player.hand.playCardAt(0);
    }

    // Create a library with a set of unique cards.
    final library = Library();
    library.cards.addAll({
      const Card('Overpowered!', Effect.winGame),
      const Card('Sleep', Effect.none),
      const Card('Skip', Effect.none),
      const Card('Eternal Fail', Effect.loseGame),
    });

    // Create a deck with max size 10 and add each card twice.
    _player.deck.addCards([
      for (final card in library.cards) ...[card, card],
    ]);
    if (shuffleDeck) {
      _player.deck.shuffle();
    }
    _player.setUpHand();
  }

  /// Starts an event-driven game session (used by Flutter/Web frontends).
  void startInteractive() {
    _renderer.renderMessage('Cards with Dart');
    _render(ActionResult.drewCard);
    _isNewTurn = false;
    _render(ActionResult.newTurn);
  }

  /// Applies a single [PlayerAction] in an event-driven game session.
  ActionResult handleAction(PlayerAction action) {
    if (!_isGameRunning) {
      return ActionResult.gameOver;
    }

    _player.queueAction(action);
    final result = _advanceGame(ActionResult.newTurn);
    _render(result);

    if (_isGameRunning && _isNewTurn) {
      if (!_player.hand.isFull && _player.deck.cards.isNotEmpty) {
        _player.drawCard();
        _render(ActionResult.drewCard);
      }
      _isNewTurn = false;
      _render(ActionResult.newTurn);
    }

    return result;
  }

  /// Runs the synchronous game loop until the [Game] ends (used by CLI).
  void loop() {
    _renderer.renderMessage('Cards with Dart');
    var actionResult = ActionResult.drewCard;

    // Run the loop until the player has either won or lost.
    while (_isGameRunning) {
      // Step 1: Render the state of the game including the results
      //         of last turn's actions.
      _render(actionResult);

      // Step 2: Check whether the player has made any new input.
      _processInput();

      // Step 3: Advance the game and keep track of important actions.
      actionResult = _advanceGame(actionResult);
    }

    // Render the terminal game-over state after the loop exits.
    _render(actionResult);
  }

  /// Render the board and player state according to the given [ActionResult]
  /// from the last turn.
  void _render(ActionResult actionResult) {
    while (_log.isNotEmpty) {
      _renderer.renderMessage(_log.removeFirst());
    }

    switch (actionResult) {
      case ActionResult.viewHand:
        _renderer.renderHand(_player.hand);
        return;
      case ActionResult.newTurn:
        _renderer.renderMessage(
          'Choose a card `#`, view your `hand` or `pass` the turn: ',
        );
        return;
      case ActionResult.drewCard:
        if (_player.hand.size > 0) {
          final lastCardIdx = _player.hand.size - 1;
          _renderer.renderMessage(
            'You draw ${_player.hand.cards[lastCardIdx]}',
          );
        }
        return;
      case ActionResult.gameOver:
        _renderer.renderGameOver(_isGameWon);
        return;
      case _:
        return;
    }
  }

  /// Check the [Player] for input and turn it into executable actions.
  void _processInput() {
    if (_isNewTurn || _player.hasAction()) return;

    _player.pollAction();
  }

  /// Advance the [Game] by starting/ending turns and resolving effects.
  ActionResult _advanceGame(ActionResult actionResult) {
    // Check for new turn.
    if (_isNewTurn) {
      // If we can draw a card, do that first,
      // otherwise prompt for user input.
      if (actionResult != ActionResult.drewCard &&
          !_player.hand.isFull &&
          _player.deck.cards.isNotEmpty) {
        _player.drawCard();
        return ActionResult.drewCard;
      }
      _isNewTurn = false;
      return ActionResult.newTurn;
    }

    // Process the player's choice.
    switch (_player.consumeAction()) {
      case NoAction():
        return ActionResult.invalid;
      case PassAction():
        _isNewTurn = true;
        return ActionResult.passTurn;
      case ViewHandAction():
        return ActionResult.viewHand;
      case PlayCardAction(:final cardNumber):
        if (cardNumber < 0 || cardNumber >= _player.hand.size) {
          _log.add('Invalid card index!');
          return ActionResult.invalid;
        }
        final card = _player.hand.playCardAt(cardNumber);
        _log.add('You play $card');
        switch (card.effect) {
          case Effect.none:
            _log.add('The card has no effect!');
            _isNewTurn = true;
            return ActionResult.passTurn;
          case Effect.winGame:
            _isGameRunning = false;
            _isGameWon = true;
            return ActionResult.gameOver;
          case Effect.loseGame:
            _isGameRunning = false;
            _isGameWon = false;
            return ActionResult.gameOver;
        }
    }
  }
}
