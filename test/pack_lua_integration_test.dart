import 'dart:io';
import 'package:test/test.dart';
import 'package:scriptmunge_dart/program.dart';

void testCleanup(Directory outDir) {
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  for (final entry in outDir.listSync()) {
    if (entry is File) entry.deleteSync();
    if (entry is Directory) entry.deleteSync(recursive: true);
  }
}

void main() {
  final luaDir = Directory('test/lua');
  final pandemicDir = Directory('test/pandemic_output');
  final outDir = Directory('test/scriptmunge_dart_output');

  test('getFiles() test', () async {
    final files = Program.getFiles(luaDir.path,'*.lua');
    final files2 = Program.getFiles(luaDir.path,'\$*.lua');

    expect(files, isNotEmpty, reason: 'No .lua files found in test/lua');
    expect(files2.length > files.length, isTrue, reason: 'Expected more files with pattern \$*.lua than *.lua');
    
  }, timeout: Timeout.factor(4));

  test('getFiles() test 2', () async {
    Program.runMain(  ['./test/lua/*.lua', 'test/scriptmunge_dart_output'] ); 
    final files = Program.getFiles(luaDir.path,'*.lua');
    final files2 = Program.getFiles(luaDir.path,'\$*.lua');

    expect(files, isNotEmpty, reason: 'No .lua files found in test/lua');
    expect(files2.length > files.length, isTrue, reason: 'Expected more files with pattern \$*.lua than *.lua');
    
  }, timeout: Timeout.factor(4));

  test('invoke CLI to compile .lua and pack to match pandemic outputs', () async {
    testCleanup(outDir);

    final luaFiles = luaDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.lua'))
        .toList();

    expect(luaFiles, isNotEmpty, reason: 'No .lua files found in test/lua');

    for (final lua in luaFiles) {
      final base = lua.uri.pathSegments.last.replaceAll(RegExp(r'\.(lua|luac)$', caseSensitive: false), '');

      // Call the programmatic entrypoint directly so the library locates `luac`.
      await Program.runMain([lua.path, outDir.path]);

      final outFile = File('${outDir.path}${Platform.pathSeparator}${base}.script');
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
  }, timeout: Timeout.factor(8));
}
