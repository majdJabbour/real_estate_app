const splashPath = '/splash';
const signInPath = '/auth';

String signInLocation(Uri destination) => Uri(
  path: signInPath,
  queryParameters: {'returnTo': destination.toString()},
).toString();

String? publicDestination(String? value) {
  if (value == null) return null;
  final uri = Uri.tryParse(value);
  if (uri == null || uri.hasAuthority || uri.hasScheme || uri.hasFragment) {
    return null;
  }
  if (const {
    '/home',
    '/explore',
    '/profile',
    '/favorites',
  }.contains(uri.path)) {
    return uri.toString();
  }
  final segments = uri.pathSegments;
  if (uri.path.startsWith('/properties/') &&
      segments.length == 2 &&
      RegExp(r'^[A-Za-z0-9_~-][A-Za-z0-9._~-]{0,127}$').hasMatch(segments[1])) {
    return uri.toString();
  }
  return null;
}
