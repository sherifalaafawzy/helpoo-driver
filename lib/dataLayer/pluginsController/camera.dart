import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class Camera {
  List<CameraDescription> cameras = [];
  Future<void> init() async {
    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
    if (!await Permission.photos.isGranted) {
      await Permission.photos.request();
    }
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }
  }
}
