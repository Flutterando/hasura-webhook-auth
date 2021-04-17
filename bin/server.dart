import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jose/jose.dart';
import 'package:jwk_verify/jwk_verify.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

late JsonWebKeyStore keyStore;

Future main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 4000;
  final refreshJwkTime = int.tryParse(Platform.environment['REFRESH_JWK_TIME'] ?? '') ?? 10;
  final config = await generateConfig(File(Platform.environment['CONFIG_FILE'] ?? '/app/ConfigFile.json'));
  keyStore = await generateKeyStore(Dio(), config.jwkUrl);
  final router = Router();
  Timer.periodic(Duration(minutes: refreshJwkTime), (_) async {
    keyStore = await generateKeyStore(Dio(), config.jwkUrl);
  });
  router.get('/', (shelf.Request request) async {
    return await handle(request: request, keyStore: keyStore, config: config);
  });

  final server = await io.serve(router, '0.0.0.0', port);
  print('Start :${server.port}');
}
