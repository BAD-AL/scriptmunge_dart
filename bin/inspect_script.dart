import 'dart:io';
import 'dart:typed_data';

void main(List<String> args) {
  if (args.isEmpty) {
    print('usage: inspect_script.dart <file>');
    exit(1);
  }
  final f = File(args[0]);
  final bytes = f.readAsBytesSync();
  final data = ByteData.sublistView(bytes);
  int off = 0;
  String readId(int o) {
    return String.fromCharCodes(bytes.sublist(o, o + 4));
  }

  void dumpHeader(int o) {
    final id = readId(o);
    final size = data.getUint32(o + 4, Endian.little);
    print('offset $o: $id size=$size');
  }

  dumpHeader(off);
  final topSize = data.getUint32(4, Endian.little);
  off += 8;
  final end = 8 + topSize;
  while (off + 8 <= bytes.length && off < end) {
    final id = readId(off);
    final size = data.getUint32(off + 4, Endian.little);
    print('  sub offset $off: $id size=$size');
    final payloadStart = off + 8;
    final payloadEnd = payloadStart + size;
    final first = bytes.sublist(payloadStart, payloadStart + (size < 32 ? size : 32));
    print('    first ${first.length} bytes: ${first.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');

    // If this is the scr_ chunk, parse its internal child chunks
    if (id == 'scr_') {
      var innerOff = payloadStart;
      final innerEnd = payloadEnd;
      while (innerOff + 8 <= innerEnd) {
        final iid = readId(innerOff);
        final isize = data.getUint32(innerOff + 4, Endian.little);
        final ipayloadStart = innerOff + 8;
        print('    child offset $innerOff: $iid size=$isize');
        final ifirst = bytes.sublist(ipayloadStart, ipayloadStart + (isize < 32 ? isize : 32));
        print('      first ${ifirst.length} bytes: ${ifirst.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
        innerOff = ipayloadStart + isize;
        final ipad = (4 - (isize % 4)) % 4;
        innerOff += ipad;
      }
    }

    off = payloadEnd;
    final pad = (4 - (size % 4)) % 4;
    off += pad;
  }
}
