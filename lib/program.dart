import 'dart:io';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as p;
import 'scriptmunge_dart.dart' as scriptmunge_dart;

class Program {

  static bool debug = false;
  
  Program._();

  /// Return the path to the `luac` executable. Uses the same lookup as the
  /// previous CLI wrapper: prefer known mod-tools locations on Windows,
  /// otherwise look in the working directory or `./bin`.
  static String getLuac() {
    if (Platform.isWindows) {
      String modToolsDir = "C:/BF2_ModTools";
        String loc1 = '$modToolsDir/ToolsFL/bin/luac.exe';
      String loc2 = './bin/luac.exe';
      String loc3 = './luac.exe';
      if (File(loc1).existsSync()) return loc1;
      if (File(loc2).existsSync()) return loc2;
      if (File(loc3).existsSync()) return loc3;
    } else {
      String loc1 = './luac';
      String loc2 = './bin/luac';
      if (File(loc1).existsSync()) return loc1;
      if (File(loc2).existsSync()) return loc2;
    }
    print('Warning: luac not found.');
    return '';
  }
  /*
    ScriptMunge  -inputfile $*.lua -sourcedir lua -outputdir pandemic_output 

    the 'inputFile' argument is complex. The following behavior is expected:
    -INPUTFILE      file    (multiple value to specify input files
                    wild cards "*" and "?" are allowed.  A wildcard
                    preceded by "!" or "$" is recursively applied to
                    all subdirectories - ex. !props\*.msh will search
                    for props\*.msh, props\*\*.msh, etc.)
  */
    static List<File> getFiles(String sourceDir, String inputFile) {
      final dir = Directory(sourceDir);
      if (!dir.existsSync()) {
        throw Exception('Source directory not found: $sourceDir');
      }

      // 1. Detect if the pattern is recursive (! or $)
      bool isRecursive = inputFile.startsWith('!') || inputFile.startsWith('\$');
      String rawPattern = isRecursive ? inputFile.substring(1) : inputFile;

      // 2. Build the standard Glob pattern
      String globPattern;
      if (isRecursive) {
        // Handling recursive search: include both the current dir (.) and subfolders (**)
        if (rawPattern.contains(RegExp(r'[\\/]'))) {
          // If path contains directories like "!scripts\*.lua"
          // Result: "{scripts/**, scripts}/*.lua"
          int lastSep = rawPattern.lastIndexOf(RegExp(r'[\\/]'));
          String pathPart = rawPattern.substring(0, lastSep).replaceAll('\\', '/');
          String filePart = rawPattern.substring(lastSep + 1);
          globPattern = '{$pathPart/**, $pathPart}/$filePart';
        } else {
          // If it's just a file pattern like "$*.lua"
          // Result: "{**, .}/*.lua"
          // "**/*.lua" ???
          //globPattern = '{**, .}/$rawPattern';
          globPattern = '*$rawPattern';
        }
      } else {
        // Non-recursive: just match files in the current directory
        globPattern = rawPattern.replaceAll('\\', '/');
      }
      //print('getFiles(); using glob pattern: `$globPattern` in sourceDir: `$sourceDir`');

      // 3. Join with the source directory and list files
      // We use p.join to ensure the path is correct for the OS
      final glob = Glob(p.join(sourceDir, globPattern).replaceAll('\\', '/'));
      
      return glob.listSync()
          .whereType<File>()
          .toList();
    }

  static Future<File> _compileLuaToLuac(File luaFile) async {
    final base = luaFile.uri.pathSegments.last.replaceAll('.lua', '');
    final tmpPath = '${Directory.systemTemp.path}${Platform.pathSeparator}${base}_${DateTime.now().millisecondsSinceEpoch}.luac';
    final luacPath = getLuac();
    print('Compiling ${luaFile.path} -> $tmpPath using $luacPath');
    List<String> args = ['-s', '-o', tmpPath, luaFile.path];
    if( debug ) {
      args = [ '-o', tmpPath, luaFile.path]; // -s strips debug info.
    }
    final result = await Process.run(luacPath, args);
    if (result.exitCode != 0) {
      throw Exception('luac failed: ${result.exitCode} ${result.stderr}');
    }
    final out = File(tmpPath);
    if (!out.existsSync()) throw Exception('Compiled file not found: $tmpPath');
    return out;
  }

/*
  print('\x1B[31mThis is Red\x1B[0m');
  print('\x1B[32mThis is Green\x1B[0m');
  print('\x1B[34mThis is Blue\x1B[0m');
  print('\x1B[33mThis is Yellow\x1B[0m');
  */

  static void _printHelp() {
    print('\x1B[33mReplacement for Pandemic Scriptmunge, targeted for linux/steamdeck use\x1B[0m');
    print('Packs lua source files (.lua) or pr-compiled lua files (.luac) into .script format for use in BF2 modding.');
    print('2 program usage styles are allowed, `simple` and `Pandemic` style');
    print('\x1B[32mSimple Style:\x1B[0m');
    print('If an input directory is provided, all `.luac` and `.lua` files inside will be packed.');
    print('   Usage (simple): scriptmunge <input-file|input-dir> [output-dir]');
    print('   Example (simple):   ScriptMunge  addme.lua MUNGED \x1B[33m  #process only addme.lua; wildcards not supported\x1B[0m');
    print('   Example (simple):   ScriptMunge  scripgs MUNGED \x1B[33m  #process all .lua or .luac files in folder `scripts`\x1B[0m');
    print('\x1B[32mPandemic Style:\x1B[0m');
    print('Pandemic command line syntax is supported');
    print('   Usage (pandemic style): scriptmunge -inputfile <file(s)> -sourcedir <dir> -outputdir <dir>');
    print('   Example (Pandemic style):   ScriptMunge  -inputfile \$*.lua -sourcedir scripts -outputdir MUNGED ');
  }
  /// Entrypoint for programmatic use. Accepts the same arguments as the
  /// command-line wrapper: `<input-file|input-dir> [output-dir]`.
  static Future<void> runMain(List<String> arguments) async {
    if (arguments.isEmpty) {
      _printHelp();
      return;
    }
    bool simpleStyle = false;

    try {
      // Support two styles:
      // 1) Positional: <input-file|input-dir> [output-dir]
      // 2) Pandemic-style flags: -inputfile <file> -sourcedir <dir> -outputdir <dir>
      String? inputPath;
      String? sourceDir;
      String outputDirPath = './';

      if (arguments.isNotEmpty && arguments.any((a) => a.startsWith('-'))) {
        for (var i = 0; i < arguments.length; i++) {
          final a = arguments[i];
          final al = a.toLowerCase();
          if (al == '-inputfile' || al == '-input') {
            if (i + 1 < arguments.length) inputPath = arguments[++i].replaceAll('\\', '/');
          } else if (al == '-sourcedir') {
            if (i + 1 < arguments.length) sourceDir = arguments[++i].replaceAll('\\', '/');
          } else if (al == '-outputdir') {
            if (i + 1 < arguments.length) outputDirPath = arguments[++i].replaceAll('\\', '/');
          } else if(al == '-debug') {
            debug = true;
          } 
        }
      } else {
        // positional fallback
        if (arguments.isNotEmpty) inputPath = arguments[0].replaceAll('\\', '/');
        if (arguments.length > 1) outputDirPath = arguments[1].replaceAll('\\', '/');
        simpleStyle = true;
      }

      final outputDir = Directory(outputDirPath);
      if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

      final inputFile = inputPath != null ? File(inputPath) : null;
      final inputDir = (sourceDir != null) ? Directory(sourceDir) : (inputPath != null ? Directory(inputPath) : null);

      String outNameFrom(File f) => f.uri.pathSegments.last.replaceAll(RegExp(r'\.(lua|luac)$', caseSensitive: false), '.script');
      String baseNameFrom(File f) => f.uri.pathSegments.last.replaceAll(RegExp(r'\.(lua|luac)$', caseSensitive: false), '');

      if (inputFile != null && inputFile.existsSync()) {
        // the 1-file case 
        final lower = inputFile!.path.toLowerCase();

        if (lower.endsWith('.lua')) {
          File? compiled;
          try {
            compiled = await _compileLuaToLuac(inputFile!);
            final out = File('${outputDir.path}${Platform.pathSeparator}${outNameFrom(inputFile!)}');
            final name = baseNameFrom(inputFile!);
            await scriptmunge_dart.ScriptMunger.pack(compiled, out, name: name);
            print('Wrote ${out.path}');
          } finally {
            if (compiled != null && compiled.existsSync()) compiled.deleteSync();
          }
          return;
        }

        if (lower.endsWith('.luac')) {
          final out = File('${outputDir.path}${Platform.pathSeparator}${outNameFrom(inputFile!)}');
          await scriptmunge_dart.ScriptMunger.pack(inputFile!, out);
          print('Wrote ${out.path}');
          return;
        }

        print('Input file is not a .lua or .luac: $inputPath');
        return;
      }

      List<File> files = [];

      if (simpleStyle) {
        if(Directory(inputPath!).existsSync()) {
          files = getFiles(inputPath, '*.{lua,luac}');
        } else {
          String sd = Directory(inputPath!).parent.path;
          String infile = inputPath.substring(inputPath.lastIndexOf('/')+1);
          //print("getFiles( '$sd' , '$infile' )");
          files = getFiles(sd, infile );
        }
        //print("Filecount: ${files.length}");
      }
      else if (inputDir != null && inputDir.existsSync()) {
        /*final files = inputDir!.listSync().whereType<File>().where((f) {
          final p = f.path.toLowerCase();
          return p.endsWith('.luac') || p.endsWith('.lua');
        });*/
        files = getFiles(inputDir.path, inputPath!);
      }
      if(files.isNotEmpty ) {
        for (final f in files) {
          final lower = f.path.toLowerCase();
          final out = File('${outputDir.path}${Platform.pathSeparator}${outNameFrom(f)}');
          if (lower.endsWith('.luac')) {
            await scriptmunge_dart.ScriptMunger.pack(f, out);
            print('Wrote ${out.path}');
          } else if (lower.endsWith('.lua')) {
            File? compiled;
            try {
              compiled = await _compileLuaToLuac(f);
              final name = baseNameFrom(f);
              await scriptmunge_dart.ScriptMunger.pack(compiled, out, name: name);
              print('Wrote ${out.path}');
            } finally {
              if (compiled != null && compiled.existsSync()) compiled.deleteSync();
            }
          }
        }
        return;
      }

      print('Input path not found: $inputPath');
    } catch (e) {
      print('Error: $e');
      _printHelp();
    }
  }
}
