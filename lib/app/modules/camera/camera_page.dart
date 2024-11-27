import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:video_compress/video_compress.dart';

class CameraPage extends StatefulWidget {
  final Function(List<String>) onMediaCaptured;

  CameraPage({required this.onMediaCaptured});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool isInitialized = false;
  bool isRecording = false;
  bool isProcessing = false; // New state for "Please Wait"
  List<String> capturedMediaPaths = [];

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
      );
      await _cameraController.initialize();
      setState(() {
        isInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> capturePhoto() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      final image = await _cameraController.takePicture();
      final fileBytes = await image.readAsBytes();
      final savedPath = await saveFileToGallery(
        fileBytes,
        'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      if (savedPath != null) {
        capturedMediaPaths.add(savedPath);
        widget.onMediaCaptured(capturedMediaPaths); // Notify parent
      }
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  Future<void> startRecording() async {
    if (!_cameraController.value.isInitialized || isRecording) return;

    try {
      await _cameraController.startVideoRecording();
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    setState(() {
      isProcessing = true; // Show "Please Wait" message
    });

    try {
      final video = await _cameraController.stopVideoRecording();
      final compressedVideo = await compressVideo(File(video.path));
      final videoBytes = await compressedVideo.readAsBytes();
      final savedPath = await saveFileToGallery(
        videoBytes,
        'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      if (savedPath != null) {
        capturedMediaPaths.add(savedPath);
        widget.onMediaCaptured(capturedMediaPaths); // Notify parent
      }
    } catch (e) {
      print('Error stopping video recording: $e');
    } finally {
      setState(() {
        isRecording = false;
        isProcessing = false; // Hide "Please Wait" message
      });
    }
  }

  Future<File> compressVideo(File videoFile) async {
    try {
      final info = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );

      if (info == null || info.file == null) {
        throw Exception('Video compression failed.');
      }

      return info.file!;
    } catch (e) {
      print('Error compressing video: $e');
      return videoFile;
    }
  }

  Future<String?> saveFileToGallery(Uint8List fileBytes, String fileName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/$fileName';

      final file = File(tempFilePath);
      await file.writeAsBytes(fileBytes);

      final result = await ImageGallerySaverPlus.saveFile(
        tempFilePath,
        name: fileName,
      );

      if (result["isSuccess"]) {
        return tempFilePath;
      }
    } catch (e) {
      print('Error saving to gallery: $e');
    }
    return null;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    VideoCompress.cancelCompression();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isInitialized)
            Positioned.fill(
              child: CameraPreview(_cameraController),
            )
          else
            Center(child: CircularProgressIndicator()),
          
          // "Please Wait" overlay
          if (isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        'Please Wait...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: !_cameraController.value.isInitialized || isRecording
                      ? null
                      : capturePhoto,
                  child: Text('Capture Photo'),
                ),
                ElevatedButton(
                  onPressed: !_cameraController.value.isInitialized || isProcessing
                      ? null
                      : isRecording
                          ? stopRecording
                          : startRecording,
                  child: Text(isRecording ? 'Stop Recording' : 'Record Video'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}