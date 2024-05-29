import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:control_panel/components/custom_elevatedbutton.dart';
import 'package:control_panel/components/custom_linechart.dart';
import 'package:control_panel/constants/colors.dart';
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
  final CustomWebSocket _videoWebsocket = CustomWebSocket(URLS.video);
  bool isVideoToggled = false;
  Timer? videoTimer;

  // ---------- ---------- External Sensors ---------- ---------- //
  bool isExternalSensorsToggled = false;

  // PRESSURE
  final String pressureTitle = 'Pression extérieure (Pa)';
  final CustomWebSocket _pressureWebsocket = CustomWebSocket(URLS.pressure);
  bool isPressureServerConnected = false;
  List<double> pressureData = [];
  Timer? pressureTimer;

  // TEMPERATURE
  final String temperatureTitle = 'Température extérieure (°C)';
  final CustomWebSocket _temperatureWebsocket =
      CustomWebSocket(URLS.temperature);
  bool isTemperatureServerConnected = false;
  List<double> temperatureData = [];
  Timer? temperatureTimer;

  // HUMIDITY
  final String humidityTitle = 'Humidité extérieure (%)';
  final CustomWebSocket _humidityWebsocket = CustomWebSocket(URLS.humidity);
  bool isHumidityServerConnected = false;
  List<double> humidityData = [];
  Timer? humidityTimer;
  // ---------- ---------- External Sensors ---------- ---------- //

  // ---------- ---------- Internal Sensors ---------- ---------- //
  bool isInternalSensorsConnected = false;

  // TEMPERATURE
  final String raspTempTitle = 'Température interne (°C)';
  final CustomWebSocket _raspTempWebsocket = CustomWebSocket(URLS.raspTemp);
  bool isRaspTempServerConnected = false;
  List<double> raspTempData = [];
  Timer? raspTempTimer;

  // CPU
  final String raspCPUTitle = 'Charge CPU (%)';
  final CustomWebSocket _raspCPUWebsocket = CustomWebSocket(URLS.raspCPU);
  bool isRaspCPUServerConnected = false;
  List<double> raspCPUData = [];
  Timer? raspCPUTimer;

  // RAM
  final String raspRAMTitle = 'Charge RAM (%)';
  final CustomWebSocket _raspRAMWebsocket = CustomWebSocket(URLS.raspRAM);
  bool isRaspRAMServerConnected = false;
  List<double> raspRAMData = [];
  Timer? raspRAMTimer;
  // ---------- ---------- Internal Sensors ---------- ---------- //

  @override
  void initState() {
    super.initState();
  }

  void startInternalSensors() {
    raspTempRoutine();
    raspCPURoutine();
    raspRAMRoutine();
  }

  void startExternalSensors() {
    pressureRoutine();
    temperatureRoutine();
    humidityRoutine();
  }

  void stopInternalSensorsTimers() {
    raspTempTimer?.cancel();
    raspCPUTimer?.cancel();
    raspRAMTimer?.cancel();
  }

  void stopExternalSensorsTimers() {
    pressureTimer?.cancel();
    temperatureTimer?.cancel();
    humidityTimer?.cancel();
  }

  void closeInternalSensorsConnection() {
    stopInternalSensorsTimers();

    _raspTempWebsocket.disconnect();
    _raspCPUWebsocket.disconnect();
    _raspRAMWebsocket.disconnect();
  }

  void closeExternalSensorsConnection() {
    stopExternalSensorsTimers();

    _pressureWebsocket.disconnect();
    _temperatureWebsocket.disconnect();
    _humidityWebsocket.disconnect();
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
      _videoWebsocket.disconnect();
    }
  }

  void toggleInternal({bool quit = false}) {}

  void toggleExternal({bool quit = false}) {
    setState(() {
      if (quit) {
        isExternalSensorsToggled = false;
      } else {
        isExternalSensorsToggled = !isExternalSensorsToggled;
      }
    });
    if (isExternalSensorsToggled) {
      startExternalSensors();
    } else {
      closeExternalSensorsConnection();
    }
  }

  void routine(Timer timer, CustomWebSocket websocketURL, bool isConnected,
      Function setIsConnected) async {
    if (websocketURL.getChannel == null ||
        websocketURL.getChannel!.closeCode != null) {
      bool connectionStatus = await websocketURL.connect();
      if (connectionStatus != isConnected) {
        setState(() {
          setIsConnected(connectionStatus);
        });
      }
      if (!connectionStatus) {
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
    setState(() {});
  }

  void videoRoutine() async {
    videoTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => routine(timer, _videoWebsocket, isVideoToggled,
          (value) => isVideoToggled = value),
    );
  }

  void pressureRoutine() async {
    pressureTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => routine(timer, _pressureWebsocket, isPressureServerConnected,
          (value) => isPressureServerConnected = value),
    );
  }

  void temperatureRoutine() async {
    temperatureTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => routine(
          timer,
          _temperatureWebsocket,
          isTemperatureServerConnected,
          (value) => isTemperatureServerConnected = value),
    );
  }

  void humidityRoutine() async {
    humidityTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => routine(timer, _humidityWebsocket, isHumidityServerConnected,
          (value) => isHumidityServerConnected = value),
    );
  }

  void raspTempRoutine() async {
    raspTempTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => routine(timer, _raspTempWebsocket, isRaspTempServerConnected,
          (value) => isRaspTempServerConnected = value),
    );
  }

  void raspCPURoutine() async {
    raspCPUTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => routine(timer, _raspCPUWebsocket, isRaspCPUServerConnected,
          (value) => isRaspCPUServerConnected = value),
    );
  }

  void raspRAMRoutine() async {
    raspRAMTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => routine(timer, _raspRAMWebsocket, isRaspRAMServerConnected,
          (value) => isRaspRAMServerConnected = value),
    );
  }

  void closeAllWebsockets() {
    videoTimer?.cancel();
    _videoWebsocket.disconnect();

    closeExternalSensorsConnection();
    closeInternalSensorsConnection();
  }

  @override
  void dispose() {
    closeAllWebsockets();

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
        iconTheme: IconThemeData(color: ProjectColors.white),
        backgroundColor: ProjectColors.primary,
        title: Image.asset(
          Paths.highCenteredLogo,
          width: 220,
          height: 100,
        ),
        actions: [
          Center(
            child: Row(
              children: [
                Text(
                  'WiFi : ',
                  style: TextStyle(color: ProjectColors.white, fontSize: 20),
                ),
                Text(
                  NetworkStatus.online ? 'connecté' : 'aucun',
                  style: TextStyle(
                    color: NetworkStatus.online
                        ? ProjectColors.greenValidate
                        : ProjectColors.redError,
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
              decoration: BoxDecoration(color: ProjectColors.primary),
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
                  StreamBuilder(
                    stream: _raspTempWebsocket.stream,
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
                                update(convert(snapshot.data), raspTempData)),
                            title: raspTempTitle,
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(raspTempData),
                          title: raspTempTitle,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.008),
                  StreamBuilder(
                    stream: _raspCPUWebsocket.stream,
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
                                update(convert(snapshot.data), raspCPUData)),
                            title: raspCPUTitle,
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(raspCPUData),
                          title: raspCPUTitle,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.008),
                  StreamBuilder(
                    stream: _raspRAMWebsocket.stream,
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
                                update(convert(snapshot.data), raspRAMData)),
                            title: raspRAMTitle,
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(raspRAMData),
                          title: raspRAMTitle,
                        ),
                      );
                    },
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
                          stream: _videoWebsocket.stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                !snapshot.hasData) {
                              return SizedBox(
                                width: 640,
                                height: 480,
                                child: Center(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(
                                      color: ProjectColors.primary,
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
                      child: CustomElevatedButton(
                        onPressed: toggleStreaming,
                        isToggled: isVideoToggled,
                        startText: 'Démarrer le flux vidéo',
                        stopText: 'Arrêter le flux vidéo',
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomElevatedButton(
                          onPressed: toggleInternal,
                          isToggled: isInternalSensorsConnected,
                          startText: 'Démarrer les capteurs internes',
                          stopText: 'Arrêter les capteurs internes',
                        ),
                        SizedBox(width: width * 0.01),
                        CustomElevatedButton(
                          onPressed: toggleExternal,
                          isToggled: isExternalSensorsToggled,
                          startText: 'Démarrer les capteurs externes',
                          stopText: 'Arrêter les capteurs externes',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: height * 0.03),
                  StreamBuilder(
                    stream: _temperatureWebsocket.stream,
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
                            title: temperatureTitle,
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(temperatureData),
                          title: temperatureTitle,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.008),
                  StreamBuilder(
                    stream: _pressureWebsocket.stream,
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
                            title: pressureTitle,
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(pressureData),
                          title: pressureTitle,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.008),
                  StreamBuilder(
                    stream: _humidityWebsocket.stream,
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
                            title: humidityTitle,
                          ),
                        );
                      }
                      return SizedBox(
                        width: width * 0.2,
                        height: height * 0.25,
                        child: CustomLineChart(
                          getValues(humidityData),
                          title: humidityTitle,
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
