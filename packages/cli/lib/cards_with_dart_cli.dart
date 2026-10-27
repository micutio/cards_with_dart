import 'dart:io';

import 'package:args/args.dart';
import 'package:cards_with_dart_core/cards_with_dart_core.dart';

import 'src/input/stdin_input.dart';
import 'src/renderer/stdout_renderer.dart';

export 'src/input/stdin_input.dart';
export 'src/renderer/stdout_renderer.dart';

const String cliVersion = '0.1.0';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print usage information.',
    )
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print application version.',
    );
}

int runCli(
  List<String> args, {
  StringSink? out,
  StringSink? err,
  Input? input,
}) {
  final stdoutSink = out ?? stdout;
  final stderrSink = err ?? stderr;
  final parser = buildParser();

  try {
    final results = parser.parse(args);

    if (results.flag('help')) {
      stdoutSink
        ..writeln('Cards with Dart CLI - Interactive terminal card game')
        ..writeln()
        ..writeln('Usage: cards_with_dart [options]')
        ..writeln()
        ..writeln(parser.usage);
      return 0;
    }

    if (results.flag('version')) {
      stdoutSink.writeln('cards_with_dart version $cliVersion');
      return 0;
    }

    Game(StdoutRenderer(out: stdoutSink), input: input ?? StdinInput())
      ..setUp()
      ..loop();

    return 0;
  } on FormatException catch (e) {
    stderrSink
      ..writeln(e.message)
      ..writeln()
      ..writeln(parser.usage);
    return 64;
  }
}
