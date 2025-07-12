import 'package:flutter_driver/driver_extension.dart';
import 'package:chakame/main.dart' as app;

void main() {
  // Enable integration testing with the Flutter Driver extension
  enableFlutterDriverExtension();
  
  // Call the main function of your app
  app.main();
}