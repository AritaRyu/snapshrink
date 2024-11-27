import 'package:flutter_modular/flutter_modular.dart';
import 'camera_page.dart';

class CameraModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/', 
          child: (_, __) => CameraPage(
            onMediaCaptured: (List<String> mediaPaths) {
              // Handle the captured media, maybe update a parent widget or state
              print('Captured Media: $mediaPaths'); // Add your logic here
            },
          ),
        ),
      ];
}


