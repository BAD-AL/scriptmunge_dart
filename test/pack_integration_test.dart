import 'dart:io';
import 'package:test/test.dart';
import 'package:scriptmunge_dart/scriptmunge_dart.dart';

void testCleanup(Directory outDir) {
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  for (final entry in outDir.listSync()) {
    if (entry is File) entry.deleteSync();
    if (entry is Directory) entry.deleteSync(recursive: true);
  }
}

void main() {
  final luacDir = Directory('test/luac');
  final pandemicDir = Directory('test/pandemic_output');
  final outDir = Directory('test/scriptmunge_dart_output');

  test('pack luac files and match pandemic outputs', () async {
    testCleanup(outDir);

    final luacFiles = luacDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.luac'))
        .toList();

    expect(luacFiles, isNotEmpty, reason: 'No .luac files found in test/luac');

    for (final luac in luacFiles) {
      final outFile = File('${outDir.path}${Platform.pathSeparator}${luac.uri.pathSegments.last.replaceAll('.luac', '.script')}');
      await ScriptMunger.pack(luac, outFile);
      expect(outFile.existsSync(), isTrue, reason: 'Output file not created: ${outFile.path}');

      final expected = File('${pandemicDir.path}${Platform.pathSeparator}${outFile.uri.pathSegments.last}');
      expect(expected.existsSync(), isTrue, reason: 'Missing expected file: ${expected.path}');

      final actualBytes = outFile.readAsBytesSync();
      final expectedBytes = expected.readAsBytesSync();
      expect(actualBytes.length, expectedBytes.length, reason: 'Length mismatch: ${outFile.path}');
      expect(actualBytes, expectedBytes, reason: 'Byte mismatch: ${outFile.path}');
    }

    // Clean up generated files after successful comparison
    testCleanup(outDir);
  }, timeout: Timeout.factor(10));
}
