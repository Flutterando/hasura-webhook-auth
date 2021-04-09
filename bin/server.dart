import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jwk_verify/jwk_verify.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:hasura_connect/hasura_connect.dart';

Future main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 4000;
  final config = await generateConfig(File(Platform.environment['CONFIG_FILE'] ?? '/app/ConfigFile.json'));
  final keyStore = await generateKeyStore(Dio(), config.jwkUrl);
  final router = Router();
  router.get('/', (shelf.Request request) async {
    return await handle(request: request, keyStore: keyStore, config: config);
  });

  router.post('/ping', (shelf.Request request) async {
    final connect = HasuraConnect('http://localhost:8080/v1/graphql', headers: {'secret': request.headers['secret'] ?? ''});
    final result = await connect.query('''
    query MyQuery {
      user {
        name
      }
    } 
''');
    return shelf.Response.ok(jsonEncode({'result': 'ok'}));
  });

  final server = await io.serve(router, '0.0.0.0', port);
  print('Start :${server.port}');
}
