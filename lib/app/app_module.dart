import 'package:flutter_modular/flutter_modular.dart';
import 'modules/home/home_module.dart';
import 'modules/camera/camera_module.dart';
import 'modules/settings/settings_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: HomeModule()),
        ModuleRoute('/camera', module: CameraModule()),
        ModuleRoute('/settings', module: SettingsModule()),
      ];
}
