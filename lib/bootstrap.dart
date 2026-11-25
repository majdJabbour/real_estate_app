import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';
import 'core/storage/locale_preferences.dart';
import 'features/authentication/data/firebase_authentication_repository.dart';
import 'features/authentication/domain/authentication_repository.dart';
import 'firebase_options.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedLocalePreferences.load();
  AuthenticationRepository? repository;
  runApp(
    createApp(
      preferences,
      initializeAuthentication: () async => repository ??= await _initialize(),
    ),
  );
}

Future<AuthenticationRepository> _initialize() async {
  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return FirebaseAuthenticationRepository(
    FirebaseAuth.instanceFor(app: firebase),
    GoogleSignIn.instance,
  );
}
