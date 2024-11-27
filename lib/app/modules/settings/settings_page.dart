import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _imageQuality = 'High';
  String _videoQuality = 'High';
  String _imageFormat = 'JPEG';
  String _videoFormat = 'MP4';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _imageQuality,
              items: ['High', 'Medium', 'Low']
                  .map((quality) => DropdownMenuItem(
                        value: quality,
                        child: Text(quality),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _imageQuality = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Image Quality'),
            ),
            DropdownButtonFormField<String>(
              value: _imageFormat,
              items: ['JPEG', 'PNG', 'WEBP']
                  .map((format) => DropdownMenuItem(
                        value: format,
                        child: Text(format),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _imageFormat = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Image Format'),
            ),
            DropdownButtonFormField<String>(
              value: _videoQuality,
              items: ['High', 'Medium', 'Low']
                  .map((quality) => DropdownMenuItem(
                        value: quality,
                        child: Text(quality),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _videoQuality = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Video Quality'),
            ),
            DropdownButtonFormField<String>(
              value: _videoFormat,
              items: ['MP4', 'AVI', 'MKV']
                  .map((format) => DropdownMenuItem(
                        value: format,
                        child: Text(format),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _videoFormat = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Video Format'),
            ),
          ],
        ),
      ),
    );
  }
}
