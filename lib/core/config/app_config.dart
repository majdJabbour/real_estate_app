import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

final class AppConfig {
  AppConfig.fromEnvironment()
    : this.parse(
        const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: productionBaseUrl,
        ),
        allowInsecureLocal: !const bool.fromEnvironment('dart.vm.product'),
      );

  AppConfig.parse(String value, {bool allowInsecureLocal = false})
    : apiBaseUrl = _parseBaseUrl(value, allowInsecureLocal);

  static const productionBaseUrl =
      'https://real-estate-api-gray.vercel.app/api/v1/';
  final Uri apiBaseUrl;

  static Uri _parseBaseUrl(String value, bool allowInsecureLocal) {
    final input = value.trim();
    final uri = Uri.tryParse(input);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        uri.authority.contains('@') ||
        uri.hasQuery ||
        uri.hasFragment ||
        RegExp(r'[\s\\]|%(?![0-9a-fA-F]{2})').hasMatch(input) ||
        (uri.hasPort && (uri.port < 1 || uri.port > 65535))) {
      throw const FormatException('Invalid API base URL.');
    }
    if (uri.scheme != 'https' &&
        !(allowInsecureLocal && uri.scheme == 'http' && _isLocal(uri.host))) {
      throw const FormatException('API base URL must use HTTPS.');
    }
    final path = uri.path.replaceFirst(RegExp(r'/+$'), '');
    return uri.replace(path: '$path/');
  }

  static bool _isLocal(String host) {
    if (host == 'localhost' || host == '::1') return true;
    if (!RegExp(r'^(0|[1-9][0-9]{0,2})(\.(0|[1-9][0-9]{0,2})){3}$')
        .hasMatch(host)) {
      return false;
    }
    final octets = host.split('.').map(int.tryParse).toList();
    if (octets case [int a, int b, int c, int d]
        when [a, b, c, d].every((part) => part >= 0 && part <= 255)) {
      return a == 127 ||
          a == 10 ||
          (a == 192 && b == 168) ||
          (a == 172 && b >= 16 && b <= 31);
    }
    return false;
  }
}

@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => AppConfig.fromEnvironment();
