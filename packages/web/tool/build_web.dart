import 'dart:io';

import 'package:path/path.dart' as p;

/// Builds the static web bundle into `build/web`.
Future<void> main() async {
  exitCode = await _buildWeb();
}

Future<int> _buildWeb() async {
  final outDir = Directory(p.join('build', 'web'));
  if (outDir.existsSync()) {
    outDir.deleteSync(recursive: true);
  }
  outDir.createSync(recursive: true);

  for (final asset in ['index.html', 'styles.css']) {
    final source = File(p.join('web', asset));
    if (!source.existsSync()) {
      stderr.writeln('Missing web asset: ${source.path}');
      return 1;
    }
    source.copySync(p.join(outDir.path, asset));
  }

  final jsOut = p.join(outDir.path, 'main.dart.js');
  final entry = p.join('web', 'main.dart');
  stdout.writeln('Compiling $entry -> $jsOut');

  final result = await Process.run('dart', [
    'compile',
    'js',
    '-O2',
    '-o',
    jsOut,
    entry,
  ], runInShell: true);

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode != 0) {
    stderr.writeln('dart compile js failed with exit code ${result.exitCode}');
    return result.exitCode;
  }

  final bundleFile = File(jsOut);
  if (!bundleFile.existsSync() || bundleFile.lengthSync() == 0) {
    stderr.writeln('Expected non-empty compiled JS bundle at $jsOut');
    return 1;
  }

  stdout.writeln('Web bundle built successfully in ${outDir.path}.');
  return 0;
}
