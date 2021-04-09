import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:jose/jose.dart';
import 'package:shelf/shelf.dart' as shelf;

import 'config.dart';

export 'config.dart';

Future<Config> generateConfig(File file) async {
  try {
    final json = await file.readAsString();
    return Config.fromJson(json);
  } catch (e) {
    throw Exception('Parse Error to ConfigFile.json');
  }
}

Future<JsonWebKeyStore> generateKeyStore(dio.Dio client, String jwk_url) async {
  var keyStore = JsonWebKeyStore();

  final result = await client.get(jwk_url);
  for (var key in result.data['keys']) {
    keyStore.addKey(JsonWebKey.fromJson(key));
  }

  return keyStore;
}

FutureOr<shelf.Response> execJwtVerify({required String token, required JsonWebKeyStore keyStore, required Config config}) async {
  var jwt = JsonWebToken.unverified(token);
  var verified = await jwt.verify(keyStore);
  if (verified) {
    var custom = Map.of(jwt.claims['https://hasura.io/jwt/claims']);
    custom.removeWhere((key, value) => (key as String).toLowerCase() == 'x-hasura-allowed-roles');
    custom.remove('x-hasura-role');
    if (!custom.containsKey('x-hasura-role')) {
      custom['x-hasura-role'] = custom['x-hasura-default-role'];
    }

    return shelf.Response.ok(jsonEncode(custom));
  } else {
    return shelf.Response(401);
  }
}

FutureOr<shelf.Response> handle({required shelf.Request request, required JsonWebKeyStore keyStore, required Config config}) async {
  try {
    if (request.headers.containsKey('authorization')) {
      final token = request.headers['authorization']!.split(' ').last;
      return await execJwtVerify(token: token, config: config, keyStore: keyStore);
    } else if (request.headers.containsKey('secret')) {
      final secret = request.headers['secret'];
      final result = config.functions.firstWhere((element) => element.secret == secret);
      final custom = {};
      custom['x-hasura-role'] = result.hasuraRole;
      custom['x-hasura-default-role'] = result.hasuraRole;
      if (result.hasuraId != null) {
        custom['x-hasura-user-id'] = result.hasuraId;
      }
      return shelf.Response.ok(jsonEncode(custom));
    } else {
      return shelf.Response(401);
    }
  } catch (e) {
    return shelf.Response(401);
  }
}
