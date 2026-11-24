import 'package:material_ui/material_ui.dart';

import 'app/app.dart';
import 'core/storage/locale_preferences.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedLocalePreferences.load();
  runApp(createApp(preferences));
}
