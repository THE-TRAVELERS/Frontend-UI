// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// This class returns the current network status (online/offline) as a boolean value.
class NetworkStatus {
  static bool get online => html.window.navigator.onLine ?? false;
}
