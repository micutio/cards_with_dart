import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Runs the compiled CLI through a short scripted game until it exits.
Future<void> main() async {
  exitCode = await _smoke();
}

Future<int> _smoke() async {
  final binary = _findBinary();
  print('Smoke testing $binary');

  final process = await Process.start(binary, []);
  final out = StringBuffer();
  final gameOver = Completer<void>();

  process.stderr.transform(utf8.decoder).listen((chunk) {
    stderr.write(chunk);
  });

  process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(
    (line) {
      out.writeln(line);
      print(line);
      if (line.contains('Choose a card')) {
        process.stdin.writeln('1');
      }
      if (line.contains('You won') || line.contains('You lost')) {
        if (!gameOver.isCompleted) {
          gameOver.complete();
        }
      }
    },
  );

  try {
    await gameOver.future.timeout(const Duration(seconds: 20));
  } on TimeoutException {
    process.kill();
    stderr.writeln('Smoke test timed out waiting for game over.');
    return 1;
  }

  late final int code;
  try {
    code = await process.exitCode.timeout(const Duration(seconds: 5));
  } on TimeoutException {
    process.kill();
    stderr.writeln('Smoke test timed out waiting for the CLI to exit.');
    return 1;
  }

  await process.stdin.close();

  if (code != 0) {
    stderr.writeln('CLI exited with $code');
    return code;
  }
  if (!out.toString().contains('Cards with Dart')) {
    stderr.writeln('Expected CLI output to include the game title.');
    return 1;
  }

  print('Smoke test finished successfully.');
  return 0;
}

String _findBinary() {
  final root = Directory('build/cli');
  if (!root.existsSync()) {
    stderr.writeln('No build/cli directory. Run dart build cli first.');
    exit(1);
  }

  final matches = root.listSync(recursive: true).whereType<File>().where((
    file,
  ) {
    final name = p.basename(file.path);
    return name == 'cards_with_dart' || name == 'cards_with_dart.exe';
  }).toList();
  if (matches.isEmpty) {
    stderr.writeln('No cards_with_dart binary under build/cli.');
    exit(1);
  }
  return matches.first.absolute.path;
}
