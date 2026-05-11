import 'effect.dart';

class Card {
  final String name;
  final Effect effect;

  /// Generative constructor to initialise name and effect.
  Card(this.name, this.effect);

  @override
  String toString() => 'Card (name: $name, effect: $effect)';
}
