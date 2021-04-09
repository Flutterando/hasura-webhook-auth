import 'dart:convert';

class Config {
  final String jwkUrl;
  final List<String> audience;
  final List<FunctionsConfig> functions;

  Config({required this.jwkUrl, this.audience = const [], this.functions = const []});

  Map<String, dynamic> toMap() {
    return {
      'jwk_url': jwkUrl,
      'audience': audience,
      'functions': functions.map((x) => x.toMap()).toList(),
    };
  }

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      jwkUrl: map['jwk_url'],
      audience: List<String>.from(map['audience']),
      functions: List<FunctionsConfig>.from(map['functions']?.map((x) => FunctionsConfig.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Config.fromJson(String source) => Config.fromMap(json.decode(source));
}

class FunctionsConfig {
  final String secret;
  final String hasuraRole;
  final String? hasuraId;

  FunctionsConfig(this.secret, this.hasuraRole, this.hasuraId);

  Map<String, dynamic> toMap() {
    return {
      'secret': secret,
      'hasura_role': hasuraRole,
      'hasura_id': hasuraId,
    };
  }

  factory FunctionsConfig.fromMap(Map<String, dynamic> map) {
    return FunctionsConfig(
      map['secret'],
      map['hasura_role'] ?? 'function',
      map['hasura_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FunctionsConfig.fromJson(String source) => FunctionsConfig.fromMap(json.decode(source));
}
