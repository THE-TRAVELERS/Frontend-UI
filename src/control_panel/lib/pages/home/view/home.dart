import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:control_panel/components/custom_linechart.dart';
import 'package:control_panel/components/custom_stateicon.dart';
import 'package:control_panel/components/websocket.dart';
import 'package:control_panel/constants/constants.dart';
import 'package:control_panel/pages/auth/view/auth.dart';
import 'package:control_panel/pages/health/view/health.dart';
import 'package:control_panel/pages/home/logic/controller.dart';
import 'package:control_panel/pages/sensors/view/sensors.dart';
import 'package:flutter/material.dart';

/// Defines the home page of the application with the video flux and the controls
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CustomWebSocket _videoSocket =
      CustomWebSocket(Constants.videoWebsocketURL);
  final CustomWebSocket _pressionWebsocketURL =
      CustomWebSocket(Constants.websocketURL_1);
  final CustomWebSocket _temperatureWebsocketURL =
      CustomWebSocket(Constants.websocketURL_2);

  bool isVideoToggled = false;
  bool isChartToggled = false;
  bool isRecording = false;
  bool isConnectedToController = false;
  String? wifiName;

  List<double> data = [];

  void toggleStreaming({bool quit = false}) {
    if (!NetworkStatus.online) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Veuillez connecter votre client au réseau de l\'ordinateur de bord.',
        ),
        duration: Duration(seconds: 5),
      ));
      return;
    }
    setState(() {
      if (quit) {
        isVideoToggled = false;
      } else {
        isVideoToggled = !isVideoToggled;
      }
    });
    isVideoToggled ? _videoSocket.connect() : _videoSocket.disconnect();
  }

  void tryToConnectWebsocket() async {
    // Try to connect immediately
    bool test = await _pressionWebsocketURL.connect();
    if (!test) {
      // Start the timer if the connection failed
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        test = await _pressionWebsocketURL.connect();
        if (test) {
          timer.cancel();
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Veuillez déployer le serveur websocket de l\'ordinateur de bord.',
            ),
            duration: Duration(seconds: 4),
          ));
        }
      });
    }
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
    tryToConnectWebsocket();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1331F5),
        title: Image.asset(
          Constants.pathToHighCenteredLogo,
          width: 220,
          height: 100,
        ),
        actions: [
          Center(
            child: Row(children: [
              const Text(
                'WiFi : ',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                NetworkStatus.online ? "connecté  " : "aucun  ",
                style: TextStyle(
                  color: NetworkStatus.online
                      ? const Color.fromARGB(255, 105, 203, 109)
                      : const Color.fromARGB(255, 255, 101, 90),
                  fontSize: 20,
                ),
              ),
            ]),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('session admin'),
              accountEmail: const Text('the-travelers@outlook.com'),
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
              leading: const Icon(Icons.emergency_recording),
              title: const Text('Acceuil'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text('Données capteurs'),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SensorsPage(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety_outlined),
              title: const Text('Santé ordinateur de bord'),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HealthPage(),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                toggleStreaming(quit: true);
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(height: height * 0.03),
                  StreamBuilder(
                      stream: _pressionWebsocketURL.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox(
                              width: width * 0.2,
                              height: height * 0.25,
                              child: CustomLineChart(getValues(data)));
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          tryToConnectWebsocket();
                          return SizedBox(
                              width: width * 0.2,
                              height: height * 0.25,
                              child: CustomLineChart(getValues(data)));
                        }
                        return SizedBox(
                            width: width * 0.2,
                            height: height * 0.25,
                            child: CustomLineChart(getValues(
                                update(convert(snapshot.data), data))));
                      }),
                  SizedBox(height: height * 0.008),
                  Container(
                    width: width * 0.2,
                    height: height * 0.25,
                    color: Colors.orange,
                  ),
                  SizedBox(height: height * 0.008),
                  Container(
                    width: width * 0.2,
                    height: height * 0.25,
                    color: Colors.green,
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.08),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 640,
                            height: 480,
                            child: Image.asset(Constants.pathToNoImages),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    IntrinsicWidth(
                      child: ElevatedButton(
                        onPressed: () => toggleStreaming(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isVideoToggled
                                  ? 'Arrêter le flux vidéo'
                                  : 'Démarrer le flux vidéo',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 10),
                            StateIcon(isOn: isVideoToggled),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.2,
                    height: height * 0.25,
                    color: Colors.blue,
                  ),
                  SizedBox(height: height * 0.008),
                  Container(
                    width: width * 0.2,
                    height: height * 0.25,
                    color: Colors.orange,
                  ),
                  SizedBox(height: height * 0.008),
                  Container(
                    width: width * 0.2,
                    height: height * 0.25,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
