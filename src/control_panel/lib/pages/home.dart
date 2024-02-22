import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

import 'package:control_panel/pages/auth.dart';
import 'package:control_panel/components/custom_stateicon.dart';
import 'package:control_panel/components/websocket.dart';
import 'package:control_panel/constants/constants.dart';

/// Defines the home page of the application with the video flux and the controls
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WebSocket _socket = WebSocket(Constants.videoWebsocketURL);
  bool isStreaming = false;
  bool isRecording = false;
  bool isConnectedToController = false;
  String? wifiName;

  void getWifiName() async {
    try {
      wifiName = await WifiInfo().getWifiName();
      //print('Connected to Wi-Fi network: $wifiName');
    } catch (e) {
      //print('Failed to get Wi-Fi network name: $e');
    }
  }

  void toggleStreaming({bool quit = false}) {
    setState(() {
      if (quit) {
        isStreaming = false;
      } else {
        isStreaming = !isStreaming;
      }
    });
    isStreaming ? _socket.connect() : _socket.disconnect();
  }

  void toggleRecording({bool quit = false}) {
    setState(() {
      if (quit) {
        isRecording = false;
      } else {
        isRecording = !isRecording;
      }
    });
  }

  void toggleConnectionToController({bool quit = false}) {
    setState(() {
      if (quit) {
        isConnectedToController = false;
      } else {
        isConnectedToController = !isConnectedToController;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.pathToHighCenteredLogo,
          width: 200,
          height: 100,
        ),
        backgroundColor: const Color(0xFF1331F5),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('admin'),
              accountEmail: const Text('travelersesilv@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    Constants.pathToProfilePicture,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: const BoxDecoration(color: Color(0xFF1331F5)),
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Retour vidéo'),
              onTap: () => toggleStreaming(),
              trailing: StateIcon(isOn: isStreaming),
            ),
            ListTile(
              leading: const Icon(Icons.emergency_recording),
              title: const Text('Enregistrement'),
              onTap: () => toggleRecording(),
              trailing: StateIcon(isOn: isRecording),
            ),
            ListTile(
              leading: const Icon(Icons.control_camera),
              title: const Text('Contrôleur moteur'),
              onTap: () => toggleConnectionToController(),
              trailing: StateIcon(isOn: isConnectedToController),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                toggleStreaming(quit: true);
                toggleRecording(quit: true);
                toggleConnectionToController(quit: true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Text(
                'Bienvenue dans votre panneau de contrôle',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Divider(),
              const SizedBox(height: 30),
              isStreaming
                  ? StreamBuilder(
                      //créer un stream d'images depuis la pi caméra
                      stream: _socket.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          // si pas de données en lecture, affiche un cercle de chargement
                          return const SizedBox(
                            width: 640,
                            height: 480,
                            child: Center(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1331F5),
                                ),
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          return const Center(
                            child: Text("Connection Closed !"),
                          );
                        }
                        return Image.memory(
                          // décode les images contenues dans les websockets vers des images lisibles
                          Uint8List.fromList(
                            base64Decode(
                              (snapshot.data.toString()),
                            ),
                          ),
                          width: 640,
                          height: 480,
                          //gaplessPlayback: true,
                          excludeFromSemantics: true,
                        );
                      },
                    )
                  : SizedBox(
                      width: 640,
                      height: 480,
                      child: Image.asset(Constants.pathToNoImages),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
