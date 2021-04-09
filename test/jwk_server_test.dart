import 'dart:io';

import 'package:dio/native_imp.dart';
import 'package:dio/dio.dart' as dio;
import 'package:jose/jose.dart';
import 'package:jwk_verify/jwk_verify.dart' as service;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FileMock extends Mock implements File {}

class DioMock extends Mock implements DioForNative {}

void main() {
  test('exec functions auth with 200', () async {
    final config = service.Config(jwkUrl: 'jwkUrl', audience: ['prod-tutores-pupz']);
    final keyStore = JsonWebKeyStore();
    keyStore.addKey(JsonWebKey.fromJson({
      'e': 'AQAB',
      'n':
          'pCkrjCbf5Uv73PVX8iLopxh9aem7NdEzfJnv-TijGsSEonDoi8U_YR-Ov6p5Pb6xrEPXpflM0yEa-ahtXXxAOa0U2BcB1j-alGnIakikFX3B3RRMol0LuFau3bu2H6VXyK5KIkoCb2vMA-LXdjExQQX3k10FFVVqXrT2SxMAlJBtuOMEkBilVBh8161Hxj2jpMH4g-dDTe7skq5cR1rWe-lholUqRZ2egufSUNvSocBvvPII0qM_t_29FZYQSjNga6IupvbGRcoHGOrpZkIkzt7sHS074x3m03MUySlb1YPjfUqbZFB_US00qD6TJ36XQV3LynTYMZ0wiuUQc5GkTQ',
      'kid': '8d8c797e049aadeeb9c93dbde7d0032f697660bd',
      'kty': 'RSA',
      'use': 'sig',
      'alg': 'RS256'
    }));
    keyStore.addKey(JsonWebKey.fromJson({
      'n':
          'yhFNV1hdfqRbygSmWa_DkrYuc3dNLF1TYTivcsrBjnBYQ4gQmSBermaP7UP8ARIlETx695UAqVHn-8EhM-4lP31qCMb_i-v0I10RmM9z9OaoWZfCV15f-gTz0sihK4EpH-DcJEjXtn_RX9lp4vA2VbP8D8vr4wR8RuAAiJLFcWRy1ctMhZ_ci2Hbg5M3yFUKAJpRZUu5j4UamtSepA6qfWWlu1vV-BNIj8kAZe7rCwRLJzfGyUPZ7hXIFDWL4mhbf9UrJ2U4N3dMfJ0VEEcY90lCQsfhxwOHaRDixZDi-O6lKyQEowC8up-2m9VSjouiARc1GaYjqyOW5GUS9iTXiQ',
      'kty': 'RSA',
      'kid': '1de8067a8298a4e3344b4dbded25f2fb4f40f3ce',
      'use': 'sig',
      'alg': 'RS256',
      'e': 'AQAB'
    }));

    final response = await service.execJwtVerify(
      token:
          'eyJhbGciOiJSUzI1NiIsImtpZCI6IjhkOGM3OTdlMDQ5YWFkZWViOWM5M2RiZGU3ZDAwMzJmNjk3NjYwYmQiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiSmFjb2IgTW91cmEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2g0SEJCY2lWcEVvc0VoMFJLSmRqa2hNay03NVd2dUk1SDU5UFNVSVZBPXM5Ni1jIiwiaHR0cHM6Ly9oYXN1cmEuaW8vand0L2NsYWltcyI6eyJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIiwiYWRtaW4iLCJtYW5hZ2VyIiwiYW5vbnltb3VzIl0sIngtaGFzdXJhLXVzZXItaWQiOiIxOSJ9LCJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vcHJvZC10dXRvcmVzLXB1cHoiLCJhdWQiOiJwcm9kLXR1dG9yZXMtcHVweiIsImF1dGhfdGltZSI6MTYxNzg5ODE2MSwidXNlcl9pZCI6IkRSdmdLaHpVZHVjSm9DUHNDT0RuanRIejlkQzMiLCJzdWIiOiJEUnZnS2h6VWR1Y0pvQ1BzQ09Ebmp0SHo5ZEMzIiwiaWF0IjoxNjE3ODk4NDMwLCJleHAiOjE2MTc5MDIwMzAsImVtYWlsIjoiamFjb2JhcmF1am83QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTA2NDY3MzA5NDczMTE1ODM4NDA3Il0sImVtYWlsIjpbImphY29iYXJhdWpvN0BnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJnb29nbGUuY29tIn19.c-uyDOzKyhJQk6tLpdlqoYjHy75pZVw-LeyhLKsz4eGJwuvG23keDIU3eYgQBiPF8jLl7ovQEeTZl-wH1Hm19gUjxrRkz0ks-Nxe03GT2tJBj5Owj0Dt0Eb_gFp_AdjLD13Jh_kAd62tLuc64Vf54EUhKabtmkohoZoQN4u191ZO1TQITyBDLwaGrZ4an5nGHZmhc-JYCzDCd-P9X0I8sPKDGjsTYZTbrdVdz6Us2F3L188qTjphvqS2zXj7RupTov22_AtLtFdDsyebW6KpLo1hI4RNi16ThrGPYCu45YcjRhOfyBx7avz9SLLhwTal2o0M3ytlG7lBotHbBCaTJQ',
      keyStore: keyStore,
      config: config,
    );
    expect(response.statusCode, 200);
  });

  test('exec functions auth with 401', () async {
    final config = service.Config(jwkUrl: 'jwkUrl');
    final keyStore = JsonWebKeyStore();

    final response = await service.execJwtVerify(
      token:
          'eyJhbGciOiJSUzI1NiIsImtpZCI6IjhkOGM3OTdlMDQ5YWFkZWViOWM5M2RiZGU3ZDAwMzJmNjk3NjYwYmQiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiSmFjb2IgTW91cmEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2g0SEJCY2lWcEVvc0VoMFJLSmRqa2hNay03NVd2dUk1SDU5UFNVSVZBPXM5Ni1jIiwiaHR0cHM6Ly9oYXN1cmEuaW8vand0L2NsYWltcyI6eyJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIiwiYWRtaW4iLCJtYW5hZ2VyIiwiYW5vbnltb3VzIl0sIngtaGFzdXJhLXVzZXItaWQiOiIxOSJ9LCJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vcHJvZC10dXRvcmVzLXB1cHoiLCJhdWQiOiJwcm9kLXR1dG9yZXMtcHVweiIsImF1dGhfdGltZSI6MTYxNzg5ODE2MSwidXNlcl9pZCI6IkRSdmdLaHpVZHVjSm9DUHNDT0RuanRIejlkQzMiLCJzdWIiOiJEUnZnS2h6VWR1Y0pvQ1BzQ09Ebmp0SHo5ZEMzIiwiaWF0IjoxNjE3ODk4NDMwLCJleHAiOjE2MTc5MDIwMzAsImVtYWlsIjoiamFjb2JhcmF1am83QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTA2NDY3MzA5NDczMTE1ODM4NDA3Il0sImVtYWlsIjpbImphY29iYXJhdWpvN0BnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJnb29nbGUuY29tIn19.c-uyDOzKyhJQk6tLpdlqoYjHy75pZVw-LeyhLKsz4eGJwuvG23keDIU3eYgQBiPF8jLl7ovQEeTZl-wH1Hm19gUjxrRkz0ks-Nxe03GT2tJBj5Owj0Dt0Eb_gFp_AdjLD13Jh_kAd62tLuc64Vf54EUhKabtmkohoZoQN4u191ZO1TQITyBDLwaGrZ4an5nGHZmhc-JYCzDCd-P9X0I8sPKDGjsTYZTbrdVdz6Us2F3L188qTjphvqS2zXj7RupTov22_AtLtFdDsyebW6KpLo1hI4RNi16ThrGPYCu45YcjRhOfyBx7avz9SLLhwTal2o0M3ytlG7lBotHbBCaTJQ',
      keyStore: keyStore,
      config: config,
    );
    expect(response.statusCode, 401);
  });

  test('parse config', () async {
    final file = FileMock();
    when(() => file.readAsString()).thenAnswer((invocation) async => '''
    {
    "jwk_url": "url",
    "audience": ["aud1", "aud2"],
    "unauthorized_role": "anonymous",
    "functions": [
        {
            "secret": "domain",
            "hasura_role": "role"
        }
    ]
}
    ''');

    final config = await service.generateConfig(file);

    expect(config.jwkUrl, 'url');
    expect(config.unauthorizedRole, 'anonymous');
    expect(config.audience, ['aud1', 'aud2']);
    expect(config.functions[0].secret, 'domain');
    expect(config.functions[0].hasuraRole, 'role');
    //   expect(config.functions[0].hasuraId, '1');
  });
  test('get keystore', () async {
    final config = service.Config(jwkUrl: 'jwkUrl');
    final client = DioMock();
    when(() => client.get(config.jwkUrl)).thenAnswer((_) async => dio.Response(requestOptions: dio.RequestOptions(path: ''), statusCode: 200, data: {
          'keys': [
            {
              'e': 'AQAB',
              'n':
                  'pCkrjCbf5Uv73PVX8iLopxh9aem7NdEzfJnv-TijGsSEonDoi8U_YR-Ov6p5Pb6xrEPXpflM0yEa-ahtXXxAOa0U2BcB1j-alGnIakikFX3B3RRMol0LuFau3bu2H6VXyK5KIkoCb2vMA-LXdjExQQX3k10FFVVqXrT2SxMAlJBtuOMEkBilVBh8161Hxj2jpMH4g-dDTe7skq5cR1rWe-lholUqRZ2egufSUNvSocBvvPII0qM_t_29FZYQSjNga6IupvbGRcoHGOrpZkIkzt7sHS074x3m03MUySlb1YPjfUqbZFB_US00qD6TJ36XQV3LynTYMZ0wiuUQc5GkTQ',
              'kid': '8d8c797e049aadeeb9c93dbde7d0032f697660bd',
              'kty': 'RSA',
              'use': 'sig',
              'alg': 'RS256'
            },
          ]
        }));

    final keyStore = await service.generateKeyStore(client, 'jwkUrl');

    expect(keyStore, isA<JsonWebKeyStore>());
  });
}
