import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_estate_app/core/config/app_config.dart';

void main() {
  test('compiled default is the production v1 base', () {
    final container = ProviderContainer.test();
    final url = container.read(appConfigProvider).apiBaseUrl;
    expect(url.toString(), 'https://real-estate-api-gray.vercel.app/api/v1/');
    expect(url.resolve('health').path, '/api/v1/health');
  });

  test('a custom mount point keeps its path and one trailing slash', () {
    final config = AppConfig.parse(
      'https://staging.example.test/custom/api/v1///',
    );
    final container = ProviderContainer.test(
      overrides: [appConfigProvider.overrideWithValue(config)],
    );
    expect(
      container.read(appConfigProvider).apiBaseUrl.toString(),
      'https://staging.example.test/custom/api/v1/',
    );
  });

  test('local cleartext is opt-in and unavailable for external hosts', () {
    for (final url in [
      'http://localhost:3000/api/v1',
      'http://10.0.2.2:3000/api/v1',
      'http://192.168.1.8:3000/api/v1',
      'http://[::1]:3000/api/v1',
    ]) {
      expect(() => AppConfig.parse(url), throwsFormatException);
      expect(
        AppConfig.parse(url, allowInsecureLocal: true).apiBaseUrl.path,
        '/api/v1/',
      );
    }
    expect(
      () => AppConfig.parse(
        'http://remote.example/api/v1',
        allowInsecureLocal: true,
      ),
      throwsFormatException,
    );
    expect(
      () =>
          AppConfig.parse('http://0127.0.0.1/api/v1', allowInsecureLocal: true),
      throwsFormatException,
    );
  });

  test('malformed URLs, credentials, queries and fragments are rejected', () {
    for (final url in [
      '',
      '/api/v1',
      'ftp://host.test/api/v1',
      'https:///api/v1',
      'https://invalid host/api/v1',
      'https://host.test:99999/api/v1',
      'https://user:secret@host.test/api/v1',
      'https://host.test/api/v1?key=secret',
      'https://host.test/api/v1#fragment',
      'https://host.test/api/%invalid',
    ]) {
      expect(
        () => AppConfig.parse(url),
        throwsFormatException,
        reason: url.split(':').first,
      );
    }
  });
}
