import 'package:flutter_modular/flutter_modular.dart';
import 'settings_page.dart';

class SettingsModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => SettingsPage()),
      ];
}
