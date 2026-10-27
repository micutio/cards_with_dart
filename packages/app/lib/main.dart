import 'package:cards_with_dart_core/cards_with_dart_core.dart' as core;
import 'package:flutter/material.dart';

void main() {
  runApp(const CardsWithDartApp());
}

class FlutterGameRenderer implements core.Renderer {
  final List<String> messages = [];
  bool? gameOverWon;

  @override
  void renderCard(core.Card card) {
    messages.add('Card: $card');
  }

  @override
  void renderHand(core.Hand hand) {
    messages.add('Hand size: ${hand.size}/${hand.maxSize}');
  }

  @override
  void renderDeck(core.Deck deck) {
    messages.add('Deck "${deck.title}": ${deck.cards.length} remaining');
  }

  @override
  void renderMessage(String msg) {
    messages.add(msg);
  }

  @override
  void renderGameOver(bool won) {
    gameOverWon = won;
    messages.add(won ? 'You won !' : 'You lost !');
  }
}

class CardsWithDartApp extends StatelessWidget {
  const CardsWithDartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cards with Dart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CardsGamePage(title: 'Cards with Dart'),
    );
  }
}

class CardsGamePage extends StatefulWidget {
  const CardsGamePage({required this.title, super.key});

  final String title;

  @override
  State<CardsGamePage> createState() => _CardsGamePageState();
}

class _CardsGamePageState extends State<CardsGamePage> {
  late FlutterGameRenderer _renderer;
  late core.Game _game;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _renderer = FlutterGameRenderer();
    _game = core.Game(_renderer)
      ..setUp()
      ..startInteractive();
  }

  void _resetGame() {
    setState(_startNewGame);
  }

  void _playCard(int index) {
    setState(() {
      _game.handleAction(core.PlayCardAction(index));
    });
  }

  void _passTurn() {
    setState(() {
      _game.handleAction(const core.PassAction());
    });
  }

  Color _effectColor(core.Effect effect) {
    switch (effect) {
      case core.Effect.winGame:
        return Colors.green.shade700;
      case core.Effect.loseGame:
        return Colors.red.shade700;
      case core.Effect.none:
        return Colors.blueGrey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final handCards = _game.player.hand.cards;
    final deckRemaining = _game.player.deck.cards.length;
    final isRunning = _game.isGameRunning;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _resetGame,
            tooltip: 'New Game',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deck: $deckRemaining cards',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Hand: ${handCards.length}/${_game.player.hand.maxSize}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!isRunning)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _game.isGameWon
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _game.isGameWon ? 'Victory! You won!' : 'Defeat! You lost!',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 12),
            Text('Your Hand', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: handCards.length,
                itemBuilder: (context, index) {
                  final card = handCards[index];
                  return Card(
                    child: ListTile(
                      title: Text(card.name),
                      subtitle: Text('Effect: ${card.effect.name}'),
                      trailing: FilledButton(
                        onPressed: isRunning ? () => _playCard(index) : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: _effectColor(card.effect),
                        ),
                        child: const Text('Play'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last event: ${_renderer.messages.isNotEmpty ? _renderer.messages.last : ""}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isRunning ? _passTurn : _resetGame,
        tooltip: isRunning ? 'Pass Turn' : 'New Game',
        icon: Icon(isRunning ? Icons.skip_next : Icons.replay),
        label: Text(isRunning ? 'Pass Turn' : 'New Game'),
      ),
    );
  }
}
