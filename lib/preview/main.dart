import 'package:material_ui/material_ui.dart';

import '../core/storage/locale_preferences.dart';
import 'preview_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(createPreviewApp(await SharedLocalePreferences.load()));
}
