import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Runs smoke tests against the compiled CLI binary.
Future<void> main() async {
  exitCode = await _smoke();
}

Future<int> _smoke() async {
  final binary = _findBinary();
  stdout.writeln('Smoke testing CLI at $binary');

  // 1. Test --help
  final help = Process.runSync(binary, ['--help']);
  stdout.write(help.stdout);
  stderr.write(help.stderr);
  if (help.exitCode != 0) {
    stderr.writeln('--help failed with exit code ${help.exitCode}');
    return help.exitCode;
  }
  if (!help.stdout.toString().contains('Cards with Dart CLI')) {
    stderr.writeln('Expected --help output to contain "Cards with Dart CLI"');
    return 1;
  }

  // 2. Test --version
  final version = Process.runSync(binary, ['--version']);
  stdout.write(version.stdout);
  stderr.write(version.stderr);
  if (version.exitCode != 0) {
    stderr.writeln('--version failed with exit code ${version.exitCode}');
    return version.exitCode;
  }
  if (!version.stdout.toString().contains('cards_with_dart version')) {
    stderr.writeln(
      'Expected --version output to contain "cards_with_dart version"',
    );
    return 1;
  }

  // 3. Test scripted interactive game loop
  final process = await Process.start(binary, []);
  final out = StringBuffer();
  final gameOver = Completer<void>();

  final stderrSub = process.stderr.transform(utf8.decoder).listen((chunk) {
    stderr.write(chunk);
  });

  final stdoutSub = process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
        out.writeln(line);
        stdout.writeln(line);
        if (line.contains('Choose a card')) {
          process.stdin.writeln('1');
        }
        if (line.contains('You won') || line.contains('You lost')) {
          if (!gameOver.isCompleted) {
            gameOver.complete();
          }
        }
      });

  try {
    await gameOver.future.timeout(const Duration(seconds: 20));
  } on TimeoutException {
    process.kill();
    await stdoutSub.cancel();
    await stderrSub.cancel();
    stderr.writeln('Smoke test timed out waiting for game over.');
    return 1;
  }

  late final int code;
  try {
    code = await process.exitCode.timeout(const Duration(seconds: 5));
  } on TimeoutException {
    process.kill();
    await stdoutSub.cancel();
    await stderrSub.cancel();
    stderr.writeln('Smoke test timed out waiting for the CLI to exit.');
    return 1;
  }

  await process.stdin.close();
  await stdoutSub.cancel();
  await stderrSub.cancel();

  if (code != 0) {
    stderr.writeln('CLI exited with $code');
    return code;
  }
  if (!out.toString().contains('Cards with Dart')) {
    stderr.writeln('Expected CLI output to include the game title.');
    return 1;
  }

  stdout.writeln('CLI smoke test passed successfully.');
  return 0;
}

String _findBinary() {
  final candidates = [
    Directory('build/cli'),
    Directory('packages/cli/build/cli'),
  ];

  for (final dir in candidates) {
    if (dir.existsSync()) {
      final matches = dir.listSync(recursive: true).whereType<File>().where((
        file,
      ) {
        final name = p.basename(file.path);
        return name == 'cards_with_dart' || name == 'cards_with_dart.exe';
      }).toList();

      if (matches.isNotEmpty) {
        return matches.first.absolute.path;
      }
    }
  }

  stderr.writeln(
    'No cards_with_dart binary found under build/cli or packages/cli/build/cli. Run dart build cli first.',
  );
  exit(1);
}
