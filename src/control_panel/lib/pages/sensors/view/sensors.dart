
// import 'package:flutter/material.dart';
// class SensorsPage extends StatefulWidget {
//   const SensorsPage({Key? key}) : super(key: key);

//   @override
//   State<SensorsPage> createState() => _SensorsPageState();
// }

// class _SensorsPageState extends State<SensorsPage> {
//   final WebSocket _videoSocket = WebSocket(Constants.videoWebsocketURL);
//   final WebSocket _chartWebsocketURL = WebSocket(Constants.chartWebsocketURL);

//   bool isVideoToggled = false;
//   bool isChartToggled = false;
//   bool isRecording = false;
//   bool isConnectedToController = false;
//   String? wifiName;

//   List<double> data = [1, 2, 3, 4, 5, 6, 4];

//   void getWifiName() async {
//     try {
//       wifiName = await WifiInfo().getWifiName();
//       if (kDebugMode) {
//         print('Connected to Wi-Fi network: $wifiName');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Failed to get Wi-Fi network name: $e');
//       }
//     }
//   }

//   void toggleStreaming({bool quit = false}) {
//     setState(() {
//       if (quit) {
//         isVideoToggled = false;
//       } else {
//         isVideoToggled = !isVideoToggled;
//       }
//     });
//     isVideoToggled ? _videoSocket.connect() : _videoSocket.disconnect();
//   }

//   void toggleRecording({bool quit = false}) {
//     setState(() {
//       if (quit) {
//         isRecording = false;
//       } else {
//         isRecording = !isRecording;
//       }
//     });
//   }

//   void toggleConnectionToController({bool quit = false}) {
//     setState(() {
//       if (quit) {
//         isConnectedToController = false;
//       } else {
//         isConnectedToController = !isConnectedToController;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Image.asset(
//           Constants.pathToHighCenteredLogo,
//           width: 200,
//           height: 100,
//         ),
//         backgroundColor: const Color(0xFF1331F5),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: const Text('admin'),
//               accountEmail: const Text('travelersesilv@gmail.com'),
//               currentAccountPicture: CircleAvatar(
//                 child: ClipOval(
//                   child: Image.asset(
//                     Constants.pathToProfilePicture,
//                     fit: BoxFit.cover,
//                     width: 90,
//                     height: 90,
//                   ),
//                 ),
//               ),
//               decoration: const BoxDecoration(color: Color(0xFF1331F5)),
//             ),
//             ListTile(
//               leading: const Icon(Icons.emergency_recording),
//               title: const Text('Acceuil'),
//               onTap: () => toggleStreaming(),
//               trailing: StateIcon(isOn: isVideoToggled),
//             ),
//             ListTile(
//               leading: const Icon(Icons.emergency_recording),
//               title: const Text('Données capteurs'),
//               onTap: () => toggleRecording(),
//               trailing: StateIcon(isOn: isRecording),
//             ),
//             ListTile(
//               leading: const Icon(Icons.control_camera),
//               title: const Text('Santé ordinateur de bord'),
//               onTap: () => toggleConnectionToController(),
//               trailing: StateIcon(isOn: isConnectedToController),
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Déconnexion'),
//               onTap: () {
//                 toggleStreaming(quit: true);
//                 toggleRecording(quit: true);
//                 toggleConnectionToController(quit: true);
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoginPage(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 25),
//               const Text(
//                 'Bienvenue dans votre panneau de contrôle',
//                 style: TextStyle(
//                   fontSize: 20,
//                 ),
//               ),
//               const Divider(),
//               const SizedBox(height: 30),
//               Row(children: [
//                 SizedBox(
//                   width: 640,
//                   height: 480,
//                   child: Image.asset(Constants.pathToNoImages),
//                 ),
//               ])
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
