import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ket_studio/v03/core/native/native_host_protocol.dart';

void main() {
  test('native host frames round-trip and support fragmented input', () {
    const codec = NativeHostFrameCodec();
    final message = NativeHostMessage(
      type: NativeHostMessageType.terminalInput,
      requestId: 'request-1',
      sessionId: 'session-1',
      payload: const <String, Object?>{'data': 'aGVsbG8='},
    );
    final encoded = codec.encode(message);
    final decoder = NativeHostFrameDecoder(codec);

    expect(decoder.add(Uint8List.fromList(encoded.sublist(0, 2))), isEmpty);
    expect(decoder.add(Uint8List.fromList(encoded.sublist(2))), hasLength(1));

    final decoded = decoder.add(Uint8List(0));
    expect(decoded, isEmpty);
  });

  test('native host rejects frames larger than the configured limit', () {
    const codec = NativeHostFrameCodec(maxFrameBytes: 8);
    final message = NativeHostMessage(
      type: NativeHostMessageType.hello,
      requestId: 'large',
      payload: const <String, Object?>{'protocolVersion': 1},
    );

    expect(() => codec.encode(message), throwsStateError);
  });
}
