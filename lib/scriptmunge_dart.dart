import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

int calculate() => 42;

class ScriptMunger {
  /// Pack a single compiled Lua file (`.luac`) into a Battlefield2-style
  /// `.script` UCFB container and write it to [outScriptFile]. If [name]
  /// is omitted the base filename (without extension) is used.
  static Future<void> pack(File luacFile, File outScriptFile, {String? name}) async {
    final luac = await luacFile.readAsBytes();
    final baseName = luacFile.uri.pathSegments.last.replaceAll('.luac', '');
    final scriptName = (name ?? baseName).toLowerCase();
    final nameBytes = utf8.encode(scriptName);

    // Helper to build chunks with 4-byte alignment padding.
    final chunkBuilder = BytesBuilder();

    void writeChunk(String id, List<int> payload) {
      final idBytes = ascii.encode(id);
      final header = Uint8List(8);
      final headerView = ByteData.view(header.buffer);
      for (var i = 0; i < 4; i++) header[i] = idBytes[i];
      headerView.setUint32(4, payload.length, Endian.little);
      chunkBuilder.add(header);
      chunkBuilder.add(payload);
      final pad = (4 - (payload.length % 4)) % 4;
      if (pad > 0) chunkBuilder.add(Uint8List(pad));
    }

    // NAME chunk (null-terminated string)
    final namePayload = List<int>.from(nameBytes)..add(0);
    writeChunk('NAME', namePayload);

    // INFO chunk: Pandemic uses a single-byte INFO payload (value 0x01).
    final infoPayload = Uint8List.fromList([0x01]);
    writeChunk('INFO', infoPayload);

    // BODY chunk: include the raw .luac bytes and append a single zero byte
    // (Pandemic output shows BODY length = luac.length + 1).
    final bodyPayload = Uint8List(luac.length + 1)
      ..setRange(0, luac.length, luac)
      ..[luac.length] = 0x00;
    writeChunk('BODY', bodyPayload);

    // Assemble the scr_ chunk (contains NAME, INFO, BODY)
    final scrPayload = chunkBuilder.toBytes();
    final scrBuilder = BytesBuilder();
    final scrHeader = Uint8List(8);
    final scrHeaderView = ByteData.view(scrHeader.buffer);
    final scrId = ascii.encode('scr_');
    for (var i = 0; i < 4; i++) scrHeader[i] = scrId[i];
    scrHeaderView.setUint32(4, scrPayload.length, Endian.little);
    scrBuilder.add(scrHeader);
    scrBuilder.add(scrPayload);

    // Wrap in the top-level UCFB container
    final scrChunkBytes = scrBuilder.toBytes();
    final ucfbBuilder = BytesBuilder();
    final ucfbHeader = Uint8List(8);
    final ucfbHeaderView = ByteData.view(ucfbHeader.buffer);
    final ucfbId = ascii.encode('ucfb');
    for (var i = 0; i < 4; i++) ucfbHeader[i] = ucfbId[i];
    // UCFB size is the size of the following data (the scr_ chunk and its payload)
    ucfbHeaderView.setUint32(4, scrChunkBytes.length, Endian.little);
    ucfbBuilder.add(ucfbHeader);
    ucfbBuilder.add(scrChunkBytes);

    await outScriptFile.writeAsBytes(ucfbBuilder.toBytes());
  }
}
