import 'dart:io';
import 'package:flutter/material.dart';
import '../camera/camera_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // This will hold the paths of captured media
  List<String> _mediaPaths = [];

  // Define the content for each tab
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      _buildHomeContent(),
      CameraPage(
        onMediaCaptured: (mediaPaths) {
          setState(() {
            _mediaPaths = mediaPaths;
          });
        },
      ),
      _buildSettingsContent(),
    ];
  }

  // Home tab content
  Widget _buildHomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(image: AssetImage('assets/LOGO.png'), height: 100), // Your logo
        SizedBox(height: 20),
        Text(
          'Seize The Moment',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Expanded(
          child: _mediaPaths.isEmpty
              ? Center(
                  child: Text(
                    'No media found.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _mediaPaths.length,
                  itemBuilder: (context, index) {
                    final path = _mediaPaths[index];
                    final isVideo = path.endsWith('.mp4');
                    return GestureDetector(
                      onTap: () {
                        // Open full view for the media
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenMediaView(path: path),
                          ),
                        );
                      },
                      child: isVideo
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.file(File(path), fit: BoxFit.cover),
                                Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
                              ],
                            )
                          : Image.file(File(path), fit: BoxFit.cover),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Settings tab content
  Widget _buildSettingsContent() {
    return Center(
      child: Text(
        'Settings Page Content',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Navigation logic
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SnapShrink',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class FullScreenMediaView extends StatelessWidget {
  final String path;

  FullScreenMediaView({required this.path});

  @override
  Widget build(BuildContext context) {
    final isVideo = path.endsWith('.mp4');
    return Scaffold(
      appBar: AppBar(title: Text('Media View')),
      body: Center(
        child: isVideo
            ? Text('Video playback UI here (e.g., VideoPlayer)')
            : Image.file(File(path)),
      ),
    );
  }
}

