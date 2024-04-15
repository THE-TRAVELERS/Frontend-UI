import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:control_panel/components/custom_linechart.dart';
import 'package:control_panel/components/custom_stateicon.dart';
import 'package:control_panel/models/charpoint.dart';
import 'package:control_panel/models/websocket.dart';
import 'package:control_panel/constants/paths.dart';
import 'package:control_panel/constants/urls.dart';
import 'package:control_panel/pages/auth/view/auth.dart';
import 'package:control_panel/pages/health/view/health.dart';
import 'package:control_panel/pages/home/logic/controller.dart';
import 'package:control_panel/pages/sensors/view/sensors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // VIDEO
  final CustomWebSocket _videoSocket = CustomWebSocket(URLS.videoWebsocket);
  bool isVideoToggled = false;
  Timer? videoTimer;

  // PRESSURE
  final CustomWebSocket _pressureWebsocketURL =
      CustomWebSocket(URLS.pressure);
  bool isPressureServerConnected = false;
  List<double> pressureData = [];
  Timer? pressureTimer;

  // TEMPERATURE
  final CustomWebSocket _temperatureWebsocketURL =
      CustomWebSocket(URLS.temperature);
  bool isTemperatureServerConnected = false;
  List<double> temperatureData = [];
  Timer? temperatureTimer;

  // HUMIDITY
  final CustomWebSocket _humidityWebsocketURL =
      CustomWebSocket(URLS.humidity);
  bool isHumidityServerConnected = false;
  List<double> humidityData = [];
  Timer? humidityTimer;

  @override
  void initState() {
    super.initState();

    pressureRoutine();
    temperatureRoutine();
    humidityRoutine();
  }

  void toggleStreaming({bool quit = false}) {
    setState(() {
      if (quit) {
        isVideoToggled = false;
      } else {
        isVideoToggled = !isVideoToggled;
      }
    });
    if (isVideoToggled) {
      videoRoutine();
    } else {
      videoTimer?.cancel();
      _videoSocket.disconnect();
    }
  }

  void videoRoutine() async {
    videoTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_videoSocket.getChannel == null ||
          _videoSocket.getChannel!.closeCode != null) {
        bool isConnected = await _videoSocket.connect();
        if (isConnected != isVideoToggled) {
          setState(() {
            isVideoToggled = isConnected;
          });
        }
        if (!isVideoToggled) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Veuillez déployer le'
              ' serveur websocket de l\'ordinateur de bord.',
            ),
            duration: Duration(seconds: 3),
          ));
        }
      }
    });
  }

  void pressureRoutine() async {
    pressureTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_pressureWebsocketURL.getChannel == null ||
          _pressureWebsocketURL.getChannel!.closeCode != null) {
        bool isConnected = await _pressureWebsocketURL.connect();
        if (isConnected != isPressureServerConnected) {
          setState(() {
            isPressureServerConnected = isConnected;
          });
        }
        if (!isConnected) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Veuillez déployer le'
              ' serveur websocket de l\'ordinateur de bord.',
            ),
            duration: Duration(seconds: 3),
          ));
        }
      }
    });
  }

  void temperatureRoutine() async {
    temperatureTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_temperatureWebsocketURL.getChannel == null ||
          _temperatureWebsocketURL.getChannel!.closeCode != null) {
        bool isConnected = await _temperatureWebsocketURL.connect();
        if (isConnected != isTemperatureServerConnected) {
          setState(() {
            isTemperatureServerConnected = isConnected;
          });
        }
        if (!isTemperatureServerConnected) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Veuillez déployer le'
              ' serveur websocket de l\'ordinateur de bord.',
            ),
            duration: Duration(seconds: 3),
          ));
        }
      }
    });
  }

  void humidityRoutine() async {
    humidityTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_humidityWebsocketURL.getChannel == null ||
          _humidityWebsocketURL.getChannel!.closeCode != null) {
        bool isConnected = await _humidityWebsocketURL.connect();
        if (isConnected != isHumidityServerConnected) {
          setState(() {
            isHumidityServerConnected = isConnected;
          });
        }
        if (!isHumidityServerConnected) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Veuillez déployer le'
              ' serveur websocket de l\'ordinateur de bord.',
            ),
            duration: Duration(seconds: 3),
          ));
        }
      }
    });
  }

  void toggleConnectionToController({bool quit = false}) {
    setState(() {
      if (quit) {
        isPressureServerConnected = false;
      } else {
        isPressureServerConnected = !isPressureServerConnected;
      }
    });
  }

  void closeAllWebsockets() {
    videoTimer?.cancel();
    pressureTimer?.cancel();
    temperatureTimer?.cancel();
    humidityTimer?.cancel();

    _videoSocket.disconnect();
    _pressureWebsocketURL.disconnect();
    _temperatureWebsocketURL.disconnect();
    _humidityWebsocketURL.disconnect();
  }

  @override
  void dispose() {
    videoTimer?.cancel();
    pressureTimer?.cancel();
    temperatureTimer?.cancel();
    humidityTimer?.cancel();

    _videoSocket.disconnect();
    _pressureWebsocketURL.disconnect();
    _temperatureWebsocketURL.disconnect();
    _humidityWebsocketURL.disconnect();

    if (mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1331F5),
        title: Image.asset(
          Paths.highCenteredLogo,
          width: 220,
          height: 100,
        ),
        actions: [
          Center(
            child: Row(
              children: [
                const Text(
                  'WiFi : ',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  NetworkStatus.online ? 'connecté' : 'aucun',
                  style: TextStyle(
                    color: NetworkStatus.online
                        ? const Color.fromARGB(255, 105, 203, 109)
                        : const Color.fromARGB(255, 255, 101, 90),
                    fontSize: 20,
                  ),
                ),
                const Text('  ')
              ],
            ),
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
                    Paths.profilePicture,
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
              leading: const Icon(Icons.close),
              title: const Text('Close all WebSockets'),
              onTap: () => closeAllWebsockets(),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                toggleStreaming(quit: true);
                toggleConnectionToController(quit: true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthPage(),
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
              Center(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                            child: StreamBuilder(
                          stream: _videoSocket.stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                !snapshot.hasData) {
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
                            if (snapshot.connectionState ==
                                    ConnectionState.active &&
                                snapshot.hasData) {
                              return Image.memory(
                                Uint8List.fromList(
                                  base64Decode(
                                    (snapshot.data.toString()),
                                  ),
                                ),
                                width: 640,
                                height: 480,
                                gaplessPlayback: true,
                                excludeFromSemantics: true,
                              );
                            }
                            return SizedBox(
                              width: 640,
                              height: 480,
                              child: Image.asset(Paths.noImages),
                            );
                          },
                        ))
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
                  StreamBuilder(
                    stream: _temperatureWebsocketURL.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.active &&
                          snapshot.hasData) {
                        return SizedBox(
                          width: width * 0.2,
                          height: height * 0.25,
                          child: CustomLineChart(
                            getValues(update(
                                convert(snapshot.data), temperatureData)),
                            title: 'Température (°C)',
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          width: width * 0.2,
                          height: height * 0.25,
                          child: CustomLineChart(
                            getValues(temperatureData),
                            title: 'Température (°C)',
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(temperatureData),
                          title: 'Température (°C)',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.008),
                  StreamBuilder(
                    stream: _pressureWebsocketURL.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.active &&
                          snapshot.hasData) {
                        return SizedBox(
                          width: width * 0.2,
                          height: height * 0.25,
                          child: CustomLineChart(
                            getValues(
                                update(convert(snapshot.data), pressureData)),
                            title: 'Pression (P)',
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          width: width * 0.2,
                          height: height * 0.25,
                          child: CustomLineChart(
                            getValues(pressureData),
                            title: 'Pression (P)',
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(pressureData),
                          title: 'Pression (P)',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.008),
                  StreamBuilder(
                    stream: _humidityWebsocketURL.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.active &&
                          snapshot.hasData) {
                        return SizedBox(
                          width: width * 0.2,
                          height: height * 0.25,
                          child: CustomLineChart(
                            getValues(
                                update(convert(snapshot.data), humidityData)),
                            title: 'Humidité (%)',
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          width: width * 0.2,
                          height: height * 0.25,
                          child: CustomLineChart(
                            getValues(humidityData),
                            title: 'Humidité (%)',
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(humidityData),
                          title: 'Humidité (%)',
                        ),
                      );
                    },
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
