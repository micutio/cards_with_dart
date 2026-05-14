import 'effect.dart';

/// Represents a single card.
class Card {
  final String name;
  final Effect effect;

  /// Generative constructor to initialise name and effect.
  Card(this.name, this.effect);

  @override
  String toString() => 'Card (name: $name, effect: $effect)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Card &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          effect == other.effect;

  @override
  int get hashCode => name.hashCode ^ effect.hashCode;
}
